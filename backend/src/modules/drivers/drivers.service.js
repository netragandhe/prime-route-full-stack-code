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

async function getDriverById(id) {
  let searchCondition = {};
  if (String(id).startsWith('DRV-')) {
    const rawId = parseInt(String(id).replace('DRV-', ''), 10) - 100;
    searchCondition = { id: BigInt(rawId) };
  } else if (!isNaN(Number(id))) {
    searchCondition = { id: BigInt(id) };
  }

  const d = await prisma.drivers.findFirst({
    where: searchCondition,
    include: {
      rentals: {
        where: { status: 'active' },
        include: {
          vehicles: true
        }
      }
    }
  });

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

  const created = await prisma.drivers.create({
    data: {
      first_name: firstName,
      last_name: lastName,
      phone: data.phone || '+1 (555) 000-0000',
      email: data.email || `driver${Date.now()}@primeroute.io`,
      license_number: data.license || `DL-NY-${Date.now().toString().slice(-7)}`,
      license_state: data.state || 'NY',
      license_expiry: data.licenseExpiry ? new Date(data.licenseExpiry) : new Date('2026-12-31'),
      status: (data.status || 'active').toLowerCase(),
      balance: data.balance ? parseFloat(data.balance) : 0.00,
      deposit_held: data.depositHeld ? parseFloat(data.depositHeld) : 500.00,
      notes: data.notes || 'Commercial Fleet Driver'
    }
  });

  return getDriverById(Number(created.id));
}

async function updateDriver(id, updates) {
  let rawId = id;
  if (String(id).startsWith('DRV-')) {
    rawId = parseInt(String(id).replace('DRV-', ''), 10) - 100;
  }

  const dataToUpdate = {};
  if (updates.name) {
    const names = updates.name.trim().split(' ');
    dataToUpdate.first_name = names[0];
    dataToUpdate.last_name = names.slice(1).join(' ') || '';
  }
  if (updates.phone) dataToUpdate.phone = updates.phone;
  if (updates.email) dataToUpdate.email = updates.email;
  if (updates.status) dataToUpdate.status = updates.status.toLowerCase();
  if (updates.balance !== undefined) dataToUpdate.balance = parseFloat(updates.balance);

  await prisma.drivers.update({
    where: { id: BigInt(rawId) },
    data: dataToUpdate
  });

  return getDriverById(rawId);
}

async function deleteDriver(id) {
  let rawId = id;
  if (String(id).startsWith('DRV-')) {
    rawId = parseInt(String(id).replace('DRV-', ''), 10) - 100;
  }

  await prisma.drivers.update({
    where: { id: BigInt(rawId) },
    data: { archived_at: new Date() }
  });

  return { success: true };
}

module.exports = {
  getAllDrivers,
  getDriverById,
  createDriver,
  updateDriver,
  deleteDriver
};
