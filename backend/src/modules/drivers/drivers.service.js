const prisma = require('../../config/prisma');

const AVATARS = [
  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&auto=format&fit=crop&q=80',
  'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150&auto=format&fit=crop&q=80',
  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80'
];

function formatDriver(d) {
  const activeRental = d.rentals && d.rentals[0];
  const vehicleName = activeRental?.vehicles
    ? `${activeRental.vehicles.make} ${activeRental.vehicles.model} (${activeRental.vehicles.plate})`
    : 'Unassigned';

  const statusMap = {
    active: 'Active',
    pending: 'Pending',
    suspended: 'Suspended',
    inactive: 'Inactive'
  };

  const idNum = Number(d.id);
  const formattedId = `DRV-${String(idNum + 100).padStart(3, '0')}`;

  return {
    id: formattedId,
    dbId: idNum,
    name: `${d.first_name} ${d.last_name}`,
    firstName: d.first_name,
    lastName: d.last_name,
    phone: d.phone,
    email: d.email,
    license: d.license_number,
    licenseExpiry: d.license_expiry ? d.license_expiry.toISOString().split('T')[0] : '2026-12-31',
    vehicle: vehicleName,
    vehicleId: activeRental?.vehicle_id ? `VEH-${String(activeRental.vehicle_id).padStart(3, '0')}` : null,
    status: statusMap[d.status] || 'Active',
    balance: Number(d.balance) || 0,
    depositHeld: Number(d.deposit_held) || 500,
    address: '142 W 57th St, New York, NY 10019',
    dob: '1988-04-12',
    joiningDate: '2023-02-15',
    emergencyContact: 'Rachel Vance (+1 555-901-2244)',
    rating: 4.8 + ((idNum % 3) * 0.1),
    tripsCount: 150 + (idNum * 8),
    avatar: AVATARS[idNum % AVATARS.length],
    salaryRate: '$2,400/mo'
  };
}

async function getAllDrivers() {
  const list = await prisma.drivers.findMany({
    where: { archived_at: null },
    include: {
      rentals: {
        where: { status: 'active' },
        include: {
          vehicles: true
        }
      }
    },
    orderBy: { id: 'asc' }
  });

  return list.map(formatDriver);
}

async function findDriverEntity(id) {
  if (!id) return null;
  const strId = String(id).trim();

  // 1. DRV-xxx pattern
  if (strId.toUpperCase().startsWith('DRV-')) {
    const numPart = parseInt(strId.toUpperCase().replace('DRV-', ''), 10);
    if (!isNaN(numPart)) {
      const offsetId = numPart - 100;
      if (offsetId > 0) {
        const byOffset = await prisma.drivers.findFirst({
          where: { id: BigInt(offsetId) },
          include: { rentals: { where: { status: 'active' }, include: { vehicles: true } } }
        });
        if (byOffset) return byOffset;
      }
      const byDirect = await prisma.drivers.findFirst({
        where: { id: BigInt(numPart) },
        include: { rentals: { where: { status: 'active' }, include: { vehicles: true } } }
      });
      if (byDirect) return byDirect;
    }
  }

  // 2. Direct numeric ID
  if (!isNaN(Number(strId))) {
    const byId = await prisma.drivers.findFirst({
      where: { id: BigInt(strId) },
      include: { rentals: { where: { status: 'active' }, include: { vehicles: true } } }
    });
    if (byId) return byId;
  }

  // 3. By license number or email
  const byLicenseOrEmail = await prisma.drivers.findFirst({
    where: {
      OR: [
        { license_number: strId },
        { email: strId }
      ]
    },
    include: { rentals: { where: { status: 'active' }, include: { vehicles: true } } }
  });
  if (byLicenseOrEmail) return byLicenseOrEmail;

  return null;
}

async function getDriverById(id) {
  const d = await findDriverEntity(id);

  if (!d) {
    const err = new Error('Driver not found');
    err.status = 404;
    throw err;
  }

  return formatDriver(d);
}

async function createDriver(data) {
  const names = (data.name || '').trim().split(' ');
  const firstName = data.firstName || names[0] || 'Driver';
  const lastName = data.lastName || names.slice(1).join(' ') || 'Partner';

  const statusMap = {
    Active: 'active',
    Inactive: 'inactive',
    Suspended: 'suspended',
    'Pending Review': 'pending',
    pending: 'pending',
    active: 'active',
    inactive: 'inactive',
    suspended: 'suspended'
  };

  const statusVal = statusMap[data.status] || 'active';
  const cleanLicense = (data.license || `DL-NY-${Date.now().toString().slice(-7)}`).trim().toUpperCase();
  const cleanEmail = (data.email || `driver${Date.now()}@primeroute.io`).trim().toLowerCase();

  // If a driver with the same license or email already exists in DB, unarchive and update
  const existing = await prisma.drivers.findFirst({
    where: {
      OR: [
        { license_number: cleanLicense },
        { email: cleanEmail }
      ]
    }
  });

  if (existing) {
    const updated = await prisma.drivers.update({
      where: { id: existing.id },
      data: {
        first_name: firstName,
        last_name: lastName,
        phone: data.phone || existing.phone,
        email: cleanEmail,
        license_number: cleanLicense,
        license_state: data.licenseState || data.state || existing.license_state || 'NY',
        license_expiry: data.licenseExpiry ? new Date(data.licenseExpiry) : (existing.license_expiry || new Date('2026-12-31')),
        status: statusVal,
        balance: data.balance !== undefined ? parseFloat(data.balance) : existing.balance,
        deposit_held: data.depositHeld !== undefined ? parseFloat(data.depositHeld) : existing.deposit_held,
        notes: data.notes || existing.notes || 'Commercial Fleet Driver',
        archived_at: null
      }
    });
    return getDriverById(Number(updated.id));
  }

  const created = await prisma.drivers.create({
    data: {
      first_name: firstName,
      last_name: lastName,
      phone: data.phone || '+1 (555) 000-0000',
      email: cleanEmail,
      license_number: cleanLicense,
      license_state: data.licenseState || data.state || 'NY',
      license_expiry: data.licenseExpiry ? new Date(data.licenseExpiry) : new Date('2026-12-31'),
      status: statusVal,
      balance: data.balance !== undefined ? parseFloat(data.balance) : 0.00,
      deposit_held: data.depositHeld !== undefined ? parseFloat(data.depositHeld) : 500.00,
      notes: data.notes || 'Commercial Fleet Driver'
    }
  });

  return getDriverById(Number(created.id));
}

async function updateDriver(id, updates) {
  const driver = await findDriverEntity(id);
  if (!driver) {
    const err = new Error('Driver not found');
    err.status = 404;
    throw err;
  }

  const statusMap = {
    Active: 'active',
    Inactive: 'inactive',
    Suspended: 'suspended',
    'Pending Review': 'pending',
    pending: 'pending',
    active: 'active',
    inactive: 'inactive',
    suspended: 'suspended'
  };

  const dataToUpdate = {};
  if (updates.name) {
    const names = updates.name.trim().split(' ');
    dataToUpdate.first_name = names[0];
    dataToUpdate.last_name = names.slice(1).join(' ') || '';
  }
  if (updates.phone) dataToUpdate.phone = updates.phone;
  if (updates.email) dataToUpdate.email = updates.email.trim().toLowerCase();
  if (updates.license) dataToUpdate.license_number = updates.license.trim().toUpperCase();
  if (updates.licenseState) dataToUpdate.license_state = updates.licenseState;
  if (updates.licenseExpiry) dataToUpdate.license_expiry = new Date(updates.licenseExpiry);
  if (updates.status) {
    dataToUpdate.status = statusMap[updates.status] || 'active';
  }
  if (updates.balance !== undefined) dataToUpdate.balance = parseFloat(updates.balance);
  if (updates.notes) dataToUpdate.notes = updates.notes;

  await prisma.drivers.update({
    where: { id: driver.id },
    data: dataToUpdate
  });

  return getDriverById(Number(driver.id));
}

async function deleteDriver(id) {
  const driver = await findDriverEntity(id);
  if (driver) {
    await prisma.drivers.update({
      where: { id: driver.id },
      data: { archived_at: new Date() }
    });
    return { success: true, message: 'Driver successfully archived' };
  }

  return { success: true, message: 'Driver already removed or not found' };
}

module.exports = {
  getAllDrivers,
  getDriverById,
  createDriver,
  updateDriver,
  deleteDriver
};
