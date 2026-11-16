const prisma = require('../../config/prisma');

function formatRental(r) {
  const v = r.vehicles;
  const d = r.drivers;

  const vehicleName = v ? `${v.make} ${v.model} (${v.plate})` : 'Vehicle N/A';
  const driverName = d ? `${d.first_name} ${d.last_name}` : 'Driver N/A';

  const weeklyRent = Number(r.weekly_rate) || 487.50;
  const deposit = Number(r.deposit_amount) || 500.00;
  const amount = Math.round(weeklyRent * 4);
  const tax = Math.round(amount * 0.08);
  const total = amount + tax;

  return {
    id: r.contract_no,
    dbId: Number(r.id),
    customer: 'Apex Logistics LLC',
    customerPhone: d?.phone || '+1 (555) 883-1920',
    customerEmail: d?.email || 'fleet@apexlogistics.com',
    vehicle: vehicleName,
    vehicleId: v ? `VEH-${String(v.id).padStart(3, '0')}` : null,
    driver: driverName,
    driverId: d ? `DRV-${String(Number(d.id) + 100).padStart(3, '0')}` : null,
    startDate: r.start_date ? r.start_date.toISOString().split('T')[0] : '2025-07-01',
    endDate: r.end_date ? r.end_date.toISOString().split('T')[0] : '2025-07-31',
    rentalType: 'Monthly Lease',
    pickupLocation: 'JFK Airport Fleet Hub',
    dropoffLocation: 'Manhattan Financial Center',
    amount,
    deposit,
    tax,
    discount: 0,
    total,
    paymentStatus: 'Paid',
    status: r.status === 'active' ? 'Active' : r.status === 'completed' ? 'Completed' : 'Draft',
    paymentMethod: 'Corporate ACH',
    notes: r.terms || 'Premium commercial fleet lease agreement.',
    pickupDateTime: `${r.start_date ? r.start_date.toISOString().split('T')[0] : '2025-07-01'}T09:00:00`,
    pickupOdometer: r.mileage_at_pickup || 24500,
    pickupFuelLevel: 'Full (100%)',
    pickupCondition: 'Pristine / No visible damage',
    pickupRemarks: `Handover inspection verified with ${driverName}.`,
    weeklyRent,
    paymentDueDay: 'Every Monday',
    securityDeposit: deposit,
    agreementStatus: 'Signed',
    agreementData: {
      owner: 'PrimeRoute',
      renter: driverName,
      license: d?.license_number || 'DL-NY-9028148',
      vehicle: vehicleName,
      vin: v?.vin || '4T1B11HK5JU192831',
      plate: v?.plate || 'PR-2024-TC',
      weeklyRent,
      securityDeposit: deposit,
      paymentDueDay: 'Every Monday'
    },
    driverSignature: driverName,
    representativeSignature: 'Marcus Brody (Owner)',
    signedAt: `${r.start_date ? r.start_date.toISOString().split('T')[0] : '2025-07-01'}T09:15:00`,
    agreementId: `AGR-${r.contract_no.replace('RNT-', '')}`,
    returnDateTime: null,
    returnOdometer: null,
    returnFuelLevel: null,
    returnCondition: null,
    returnRemarks: null,
    returnStatus: 'Pending Return'
  };
}

async function getAllRentals() {
  const list = await prisma.rentals.findMany({
    include: {
      vehicles: true,
      drivers: true
    },
    orderBy: { id: 'asc' }
  });

  return list.map(formatRental);
}

async function getRentalById(id) {
  let searchCondition = {};
  if (String(id).startsWith('RNT-')) {
    searchCondition = { contract_no: String(id) };
  } else if (!isNaN(Number(id))) {
    searchCondition = { id: BigInt(id) };
  }

  const r = await prisma.rentals.findFirst({
    where: searchCondition,
    include: {
      vehicles: true,
      drivers: true
    }
  });

  if (!r) {
    const err = new Error('Rental contract not found');
    err.status = 404;
    throw err;
  }

  return formatRental(r);
}

async function createRental(data) {
  let vehicleId = 1;
  if (data.vehicleId) {
    vehicleId = parseInt(String(data.vehicleId).replace('VEH-', ''), 10) || 1;
  }

  let driverId = 1;
  if (data.driverId) {
    driverId = (parseInt(String(data.driverId).replace('DRV-', ''), 10) - 100) || 1;
  }

  const contractNo = data.id || `RNT-2024-${Math.floor(100 + Math.random() * 900)}`;

  const created = await prisma.rentals.create({
    data: {
      contract_no: contractNo,
      vehicle_id: BigInt(vehicleId),
      driver_id: BigInt(driverId),
      created_by: BigInt(1),
      status: 'active',
      start_date: data.startDate ? new Date(data.startDate) : new Date(),
      end_date: data.endDate ? new Date(data.endDate) : new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
      weekly_rate: data.weeklyRent ? parseFloat(data.weeklyRent) : 350.00,
      deposit_amount: data.deposit ? parseFloat(data.deposit) : 500.00,
      mileage_at_pickup: data.pickupOdometer ? parseInt(data.pickupOdometer, 10) : 25000,
      terms: data.notes || 'Commercial Fleet Lease Agreement'
    }
  });

  // Also update vehicle status to rented
  await prisma.vehicles.update({
    where: { id: BigInt(vehicleId) },
    data: { status: 'rented' }
  });

  return getRentalById(Number(created.id));
}

async function updateRental(id, updates) {
  let searchCondition = {};
  if (String(id).startsWith('RNT-')) {
    searchCondition = { contract_no: String(id) };
  } else if (!isNaN(Number(id))) {
    searchCondition = { id: BigInt(id) };
  }

  const existing = await prisma.rentals.findFirst({ where: searchCondition });
  if (!existing) {
    const err = new Error('Rental contract not found');
    err.status = 404;
    throw err;
  }

  const dataToUpdate = {};
  if (updates.status) {
    dataToUpdate.status = updates.status.toLowerCase() === 'completed' ? 'completed' : 'active';
  }
  if (updates.endDate) dataToUpdate.end_date = new Date(updates.endDate);
  if (updates.weeklyRent) dataToUpdate.weekly_rate = parseFloat(updates.weeklyRent);

  await prisma.rentals.update({
    where: { id: existing.id },
    data: dataToUpdate
  });

  return getRentalById(Number(existing.id));
}

async function terminateRental(id) {
  let searchCondition = {};
  if (String(id).startsWith('RNT-')) {
    searchCondition = { contract_no: String(id) };
  } else if (!isNaN(Number(id))) {
    searchCondition = { id: BigInt(id) };
  }

  const existing = await prisma.rentals.findFirst({ where: searchCondition });
  if (existing) {
    await prisma.rentals.update({
      where: { id: existing.id },
      data: { status: 'completed' }
    });
    // Set vehicle back to available
    await prisma.vehicles.update({
      where: { id: existing.vehicle_id },
      data: { status: 'available' }
    });
  }

  return { success: true };
}

module.exports = {
  getAllRentals,
  getRentalById,
  createRental,
  updateRental,
  terminateRental
};
