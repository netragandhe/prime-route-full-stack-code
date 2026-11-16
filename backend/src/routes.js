const express = require('express');
const router = express.Router();
const db = require('./config/db');
const authRoutes = require('./modules/auth/auth.routes');
const usersRoutes = require('./modules/users/users.routes');
const dashboardRoutes = require('./modules/dashboard/dashboard.routes');
const vehiclesRoutes = require('./modules/vehicles/vehicles.routes');
const driversRoutes = require('./modules/drivers/drivers.routes');
const rentalsRoutes = require('./modules/rentals/rentals.routes');

router.get('/health', async (req, res, next) => {
  try {
    await db.raw('SELECT 1');
    return res.status(200).json({
      success: true,
      data: {
        status: 'ok',
        db: 'connected'
      }
    });
  } catch (error) {
    return next({
      status: 503,
      message: 'Database connection failed: ' + error.message,
      code: 'DB_UNAVAILABLE'
    });
  }
});

// Mount domain routes
router.use('/auth', authRoutes);
router.use('/users', usersRoutes);
router.use('/dashboard', dashboardRoutes);
router.use('/vehicles', vehiclesRoutes);
router.use('/drivers', driversRoutes);
router.use('/rentals', rentalsRoutes);

module.exports = router;
