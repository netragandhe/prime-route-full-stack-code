const prisma = require('../../config/prisma');

const CAR_IMAGES = {
  Toyota: 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=400&auto=format&fit=crop&q=80',
  Honda: 'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=400&auto=format&fit=crop&q=80',
  Hyundai: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=400&auto=format&fit=crop&q=80',
  Chevrolet: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=400&auto=format&fit=crop&q=80',
  Tesla: 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?w=400&auto=format&fit=crop&q=80',
  Ford: 'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=400&auto=format&fit=crop&q=80',
  BMW: 'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=400&auto=format&fit=crop&q=80'
};

function formatVehicle(v) {
  const activeRental = v.rentals && v.rentals[0];
  const driverName = activeRental?.drivers
    ? `${activeRental.drivers.first_name} ${activeRental.drivers.last_name}`
    : 'Unassigned';

  const statusMap = {
    available: 'Available',
    reserved: 'Reserved',
    rented: 'Rented',
    maintenance: 'Maintenance',
    unavailable: 'Unavailable',
    sold_retired: 'Sold/Retired'
  };

  const idNum = Number(v.id);
  const formattedId = `VEH-${String(idNum).padStart(3, '0')}`;

  let vehicleType = 'Sedan';
  if (['Tahoe'].includes(v.model)) vehicleType = 'SUV';
  else if (['F-150'].includes(v.model)) vehicleType = 'Truck';
  else if (['Model 3'].includes(v.model)) vehicleType = 'Electric';
  else if (['5 Series'].includes(v.model)) vehicleType = 'Luxury';

  return {
    id: formattedId,
    dbId: idNum,
    name: `${v.make} ${v.model}`,
    plate: v.plate,
    make: v.make,
    model: v.model,
    year: v.year,
    type: vehicleType,
    fuel: v.make === 'Tesla' ? 'Electric' : 'Gasoline',
    transmission: 'Automatic',
    status: statusMap[v.status] || 'Available',
    driver: driverName,
    color: v.color || 'Black',
    mileage: `${v.mileage.toLocaleString()} mi`,
    rawMileage: v.mileage,
    vin: v.vin,
    purchasePrice: Number(v.purchase_price) || 28500,
    insuranceExpiry: '2026-11-15',
    registrationExpiry: '2026-10-30',
    image: CAR_IMAGES[v.make] || CAR_IMAGES.Toyota,
    dailyRate: activeRental ? Math.round(Number(activeRental.weekly_rate) / 7) : 65
  };
}

async function getAllVehicles() {
  const list = await prisma.vehicles.findMany({
    where: { archived_at: null },
    include: {
      rentals: {
        where: { status: 'active' },
        include: {
          drivers: true
        }
      }
    },
    orderBy: { id: 'asc' }
  });

  return list.map(formatVehicle);
}

async function getVehicleById(id) {
  let searchCondition = {};
  if (String(id).startsWith('VEH-')) {
    const rawId = parseInt(String(id).replace('VEH-', ''), 10);
    searchCondition = { id: BigInt(rawId) };
  } else if (!isNaN(Number(id))) {
    searchCondition = { id: BigInt(id) };
  } else {
    searchCondition = { plate: String(id) };
  }

  const v = await prisma.vehicles.findFirst({
    where: searchCondition,
    include: {
      rentals: {
        where: { status: 'active' },
        include: {
          drivers: true
        }
      }
    }
  });

  if (!v) {
    const err = new Error(`Vehicle not found`);
    err.status = 404;
    throw err;
  }

  return formatVehicle(v);
}

async function createVehicle(data) {
  const statusMap = {
    Available: 'available',
    Reserved: 'reserved',
    Rented: 'rented',
    Maintenance: 'maintenance',
    Unavailable: 'unavailable',
    'Sold/Retired': 'sold_retired'
  };

  const mileageNum = parseInt(String(data.mileage || '0').replace(/[^0-9]/g, ''), 10) || 0;

  const created = await prisma.vehicles.create({
    data: {
      vin: data.vin || `1PRIME${Date.now()}`,
      plate: data.plate || `PR-${Math.floor(1000 + Math.random() * 9000)}`,
      make: data.make || 'Toyota',
      model: data.model || 'Camry',
      year: parseInt(data.year, 10) || 2024,
      color: data.color || 'White',
      mileage: mileageNum,
      status: statusMap[data.status] || 'available',
      purchase_date: data.purchaseDate ? new Date(data.purchaseDate) : new Date(),
      purchase_price: data.purchasePrice ? parseFloat(data.purchasePrice) : 28000.00
    }
  });

  return getVehicleById(Number(created.id));
}

async function updateVehicle(id, updates) {
  let rawId = id;
  if (String(id).startsWith('VEH-')) {
    rawId = parseInt(String(id).replace('VEH-', ''), 10);
  }

  const statusMap = {
    Available: 'available',
    Reserved: 'reserved',
    Rented: 'rented',
    Maintenance: 'maintenance',
    Unavailable: 'unavailable',
    'Sold/Retired': 'sold_retired'
  };

  const dataToUpdate = {};
  if (updates.status) {
    dataToUpdate.status = statusMap[updates.status] || updates.status.toLowerCase();
  }
  if (updates.mileage !== undefined) {
    dataToUpdate.mileage = parseInt(String(updates.mileage).replace(/[^0-9]/g, ''), 10);
  }
  if (updates.plate) dataToUpdate.plate = updates.plate;
  if (updates.color) dataToUpdate.color = updates.color;

  await prisma.vehicles.update({
    where: { id: BigInt(rawId) },
    data: dataToUpdate
  });

  return getVehicleById(rawId);
}

async function deleteVehicle(id) {
  let rawId = id;
  if (String(id).startsWith('VEH-')) {
    rawId = parseInt(String(id).replace('VEH-', ''), 10);
  }

  await prisma.vehicles.update({
    where: { id: BigInt(rawId) },
    data: { archived_at: new Date() }
  });

  return { success: true };
}

module.exports = {
  getAllVehicles,
  getVehicleById,
  createVehicle,
  updateVehicle,
  deleteVehicle
};
