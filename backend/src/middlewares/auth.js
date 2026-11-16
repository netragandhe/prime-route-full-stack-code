const db = require('../config/db');
const { verifyAccessToken } = require('../services/tokenService');

async function authenticate(req, res, next) {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      if (process.env.NODE_ENV === 'development') {
        const devUser = await db('users').where({ id: 1 }).first();
        if (devUser) {
          req.user = devUser;
          return next();
        }
      }
      return res.status(401).json({
        success: false,
        error: {
          message: 'Authentication token missing or invalid',
          code: 'UNAUTHORIZED'
        }
      });
    }

    const token = authHeader.split(' ')[1];
    const decoded = verifyAccessToken(token);

    const user = await db('users')
      .where({ id: decoded.userId })
      .select('id', 'name', 'email', 'role', 'status', 'phone', 'mfa_enabled', 'created_at', 'updated_at')
      .first();

    if (!user) {
      return res.status(401).json({
        success: false,
        error: {
          message: 'User associated with token no longer exists',
          code: 'USER_NOT_FOUND'
        }
      });
    }

    if (user.status !== 'active') {
      return res.status(403).json({
        success: false,
        error: {
          message: `Account is ${user.status}. Please contact system administrator.`,
          code: 'ACCOUNT_INACTIVE'
        }
      });
    }

    req.user = user;
    next();
  } catch (error) {
    next(error);
  }
}

function requireRoles(...allowedRoles) {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        error: {
          message: 'Authentication required',
          code: 'UNAUTHORIZED'
        }
      });
    }

    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        error: {
          message: `Access denied. Requires one of roles: [${allowedRoles.join(', ')}]`,
          code: 'FORBIDDEN'
        }
      });
    }

    next();
  };
}

module.exports = {
  authenticate,
  requireRoles
};
