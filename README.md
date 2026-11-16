# PrimeRoute - Full-Stack Fleet & Vehicle Rental Management System

Enterprise vehicle leasing, rental lifecycle tracking, preventative maintenance scheduling, citation matching, driver accounting, and role-based operational workflows.

---

## 🏗️ Architecture & Project Structure

This repository contains both the **React Frontend** and the **Node.js + Express Backend**:

```
prime-route-full-stack-code/
├── backend/                  # Node.js + Express.js + Knex.js + MySQL Backend API
│   ├── db/
│   │   ├── migrations/       # 12 Knex migration files (30 normalized tables)
│   │   ├── seeds/            # Initial system seeds (users, settings, rules)
│   │   └── primeroute.sql    # Complete MySQL relational database dump
│   ├── docs/                 # 15 Complete technical handbooks & architectural specifications
│   ├── src/                  # Express app, routes, controllers, middlewares, config
│   ├── tests/                # Automated integration & unit test suite (Jest + Supertest)
│   ├── uploads/              # Document and condition photo storage
│   ├── knexfile.js           # Knex database configuration
│   ├── package.json          # Backend dependencies and scripts
│   ├── .env.example          # Backend environment template
│   └── README.md             # Backend detailed quickstart guide
│
├── frontend/                 # React 18 + Vite + Tailwind CSS Frontend Application
│   ├── public/               # Static assets, icons, and logos
│   ├── src/                  # React UI components, pages, context, and client APIs
│   │   ├── api/              # API clients & adapters
│   │   ├── auth/             # Role-based access control (RBAC) matrix & permissions
│   │   ├── components/       # Reusable layout and data table components
│   │   ├── pages/            # Feature pages (Vehicles, Drivers, Rentals, Accounting, etc.)
│   │   └── utils/            # Formatters, CSV exporter, and PII masking
│   ├── package.json          # Frontend dependencies and scripts
│   ├── vite.config.js        # Vite build configuration
│   ├── .env.example          # Frontend environment template
│   └── README.md             # Frontend documentation
│
├── PrimeRoute_Backend_Plan.md# Complete backend architecture plan & specifications
├── .gitignore                # Global git ignore configuration
└── README.md                 # Project root overview
```

---

## 🚀 Quickstart Guide

### 1. Prerequisites
- **Node.js** (v20 LTS recommended, v18+ supported)
- **npm** (v9+ or v10+)
- **MySQL Server** (v8.0+ or MariaDB 10.4+)

---

### 2. Backend Setup
```bash
# 1. Navigate to backend directory
cd backend

# 2. Install dependencies
npm install

# 3. Create database in MySQL
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS primeroute CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 4. Copy environment configuration
cp .env.example .env

# 5. Run migrations (creates all 30 tables)
npm run migrate

# 6. Seed default users and system settings
npm run seed

# 7. Start backend development server (Port 5001)
npm run dev
```

Verify backend health at: `http://localhost:5001/api/v1/health`

---

### 3. Frontend Setup
```bash
# 1. In a new terminal, navigate to frontend directory
cd frontend

# 2. Install dependencies
npm install

# 3. Copy environment configuration
cp .env.example .env

# 4. Start frontend development server (Port 5173 / 3000)
npm run dev
```

Open your browser at `http://localhost:5173` (or the URL shown by Vite).

---

## 📚 Technical Documentation Index

Detailed architectural specifications, database catalogs, and workflows are in `backend/docs/`:

- [01_ARCHITECTURE.md](backend/docs/01_ARCHITECTURE.md) - System architecture, request pipeline, and service design.
- [02_DATABASE_SCHEMA.md](backend/docs/02_DATABASE_SCHEMA.md) - 30-table database catalog, foreign keys, and ER diagrams.
- [03_API_MAP.md](backend/docs/03_API_MAP.md) - REST API routes, payloads, and query conventions.
- [04_RBAC_PERMISSIONS.md](backend/docs/04_RBAC_PERMISSIONS.md) - The 6 system roles, permissions matrix, and PII masking.
- [05_AUTH_AND_SECURITY.md](backend/docs/05_AUTH_AND_SECURITY.md) - JWT token lifecycle, TOTP MFA, and security policies.
- [06_DATA_FLOW.md](backend/docs/06_DATA_FLOW.md) - Step-by-step Mermaid sequence diagrams for business flows.
- [07_FRONTEND_INTEGRATION.md](backend/docs/07_FRONTEND_INTEGRATION.md) - Frontend-to-backend API connection guide.
- [08_IMPLEMENTATION_MAP.md](backend/docs/08_IMPLEMENTATION_MAP.md) - Implementation status matrix across all modules.
- [09_ALERTS_AND_NOTIFICATIONS.md](backend/docs/09_ALERTS_AND_NOTIFICATIONS.md) - Expiration warnings and background cron jobs.
- [10_ENVIRONMENT_SETUP.md](backend/docs/10_ENVIRONMENT_SETUP.md) - Environment setup and troubleshooting solutions.
- [11_DEPLOYMENT.md](backend/docs/11_DEPLOYMENT.md) - Production server deployment with PM2 and Nginx.
- [12_BACKUP_AND_RESTORE.md](backend/docs/12_BACKUP_AND_RESTORE.md) - Daily mysqldump backup and recovery procedures.
- [13_TESTING_AND_ACCEPTANCE.md](backend/docs/13_TESTING_AND_ACCEPTANCE.md) - Automated tests and 13-point client acceptance matrix.
- [14_CLIENT_HANDOVER.md](backend/docs/14_CLIENT_HANDOVER.md) - Deliverable inventory and credentials transfer guide.
- [CHANGELOG.md](backend/docs/CHANGELOG.md) - Phase-by-phase development history.
