-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 16, 2026 at 02:15 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `prime_route`
--

-- --------------------------------------------------------

--
-- Table structure for table `accidents`
--

CREATE TABLE `accidents` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `driver_id` bigint(20) UNSIGNED DEFAULT NULL,
  `rental_id` bigint(20) UNSIGNED DEFAULT NULL,
  `accident_date` datetime NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `police_report_no` varchar(100) DEFAULT NULL,
  `estimated_damage` decimal(12,2) DEFAULT NULL,
  `status` enum('reported','under_investigation','repair_pending','resolved') NOT NULL DEFAULT 'reported',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `alert_history`
--

CREATE TABLE `alert_history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `rule_id` bigint(20) UNSIGNED DEFAULT NULL,
  `event_type` varchar(100) NOT NULL,
  `title` varchar(200) NOT NULL,
  `severity` enum('info','warning','danger') NOT NULL DEFAULT 'info',
  `message` text DEFAULT NULL,
  `related_entity_type` varchar(100) DEFAULT NULL,
  `related_entity_id` bigint(20) UNSIGNED DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `resolved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `alert_history`
--

INSERT INTO `alert_history` (`id`, `rule_id`, `event_type`, `title`, `severity`, `message`, `related_entity_type`, `related_entity_id`, `resolved_at`, `resolved_by`, `created_at`, `updated_at`) VALUES
(1, NULL, 'contract_expiry', '1 Lease Contract Expires in 7 Days', 'warning', 'Rental contract RNT-2024-001 expiring soon.', 'rentals', 1, NULL, NULL, '2026-11-16 07:13:21', '2026-11-16 07:13:21');

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `module` varchar(100) NOT NULL,
  `action` varchar(100) NOT NULL,
  `entity_type` varchar(100) DEFAULT NULL,
  `entity_id` bigint(20) UNSIGNED DEFAULT NULL,
  `old_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_values`)),
  `new_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_values`)),
  `ip_address` varchar(50) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `documents`
--

CREATE TABLE `documents` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `document_type` varchar(100) NOT NULL,
  `file_url` varchar(500) NOT NULL,
  `file_size` int(10) UNSIGNED DEFAULT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `vehicle_id` bigint(20) UNSIGNED DEFAULT NULL,
  `driver_id` bigint(20) UNSIGNED DEFAULT NULL,
  `rental_id` bigint(20) UNSIGNED DEFAULT NULL,
  `uploaded_by` bigint(20) UNSIGNED DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `document_versions`
--

CREATE TABLE `document_versions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `document_id` bigint(20) UNSIGNED NOT NULL,
  `version_number` int(11) NOT NULL DEFAULT 1,
  `file_url` varchar(500) NOT NULL,
  `file_size` int(10) UNSIGNED DEFAULT NULL,
  `uploaded_by` bigint(20) UNSIGNED DEFAULT NULL,
  `change_summary` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `drivers`
--

CREATE TABLE `drivers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `license_number` varchar(100) DEFAULT NULL,
  `license_state` varchar(10) DEFAULT NULL,
  `license_expiry` date DEFAULT NULL,
  `status` enum('active','inactive','suspended','pending') NOT NULL DEFAULT 'pending',
  `balance` decimal(12,2) NOT NULL DEFAULT 0.00,
  `deposit_held` decimal(12,2) NOT NULL DEFAULT 0.00,
  `notes` text DEFAULT NULL,
  `archived_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `drivers`
--

INSERT INTO `drivers` (`id`, `first_name`, `last_name`, `email`, `phone`, `license_number`, `license_state`, `license_expiry`, `status`, `balance`, `deposit_held`, `notes`, `archived_at`, `created_at`, `updated_at`) VALUES
(1, 'Marcus', 'Vance', 'marcus.vance@primeroute.io', '+1 (555) 234-8901', 'DL-NY-9028148', 'NY', '2026-12-31', 'active', 350.00, 500.00, 'Test Driver #1', NULL, '2026-11-16 07:13:21', '2026-11-16 07:13:21');

-- --------------------------------------------------------

--
-- Table structure for table `employee_paperwork`
--

CREATE TABLE `employee_paperwork` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `driver_id` bigint(20) UNSIGNED DEFAULT NULL,
  `full_name` varchar(200) NOT NULL,
  `ssn_last4` varchar(4) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `address` text DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `emergency_contact` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`emergency_contact`)),
  `direct_deposit_details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`direct_deposit_details`)),
  `status` enum('draft','submitted','under_review','approved','rejected') NOT NULL DEFAULT 'draft',
  `submitted_at` datetime DEFAULT NULL,
  `reviewed_by` bigint(20) UNSIGNED DEFAULT NULL,
  `review_notes` text DEFAULT NULL,
  `signature_url` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

CREATE TABLE `expenses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `vehicle_id` bigint(20) UNSIGNED DEFAULT NULL,
  `vendor_id` bigint(20) UNSIGNED DEFAULT NULL,
  `rental_id` bigint(20) UNSIGNED DEFAULT NULL,
  `recorded_by` bigint(20) UNSIGNED DEFAULT NULL,
  `approver_id` bigint(20) UNSIGNED DEFAULT NULL,
  `category` enum('insurance','registration','oil_change','repairs','tires','towing','cleaning','tolls','parking','tickets','marketing','software','bank_fees','office','legal_accounting','other') NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `expense_date` date NOT NULL,
  `payment_method` varchar(100) DEFAULT NULL,
  `invoice_receipt_url` varchar(500) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` enum('pending','approved','rejected','paid') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `expenses`
--

INSERT INTO `expenses` (`id`, `vehicle_id`, `vendor_id`, `rental_id`, `recorded_by`, `approver_id`, `category`, `amount`, `expense_date`, `payment_method`, `invoice_receipt_url`, `description`, `status`, `created_at`, `updated_at`) VALUES
(1, NULL, NULL, NULL, NULL, NULL, 'oil_change', 120.00, '2025-07-10', NULL, NULL, 'Synthetic oil & filter service', 'paid', '2026-11-16 07:13:21', '2026-11-16 07:13:21');

-- --------------------------------------------------------

--
-- Table structure for table `inspections`
--

CREATE TABLE `inspections` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `rental_id` bigint(20) UNSIGNED DEFAULT NULL,
  `vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `inspector_id` bigint(20) UNSIGNED DEFAULT NULL,
  `inspection_type` enum('pickup','return','routine') NOT NULL,
  `inspection_date` datetime NOT NULL,
  `odometer` int(11) NOT NULL,
  `fuel_level` varchar(50) DEFAULT NULL,
  `condition_checklist` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`condition_checklist`)),
  `notes` text DEFAULT NULL,
  `driver_acknowledged` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inspection_photos`
--

CREATE TABLE `inspection_photos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `inspection_id` bigint(20) UNSIGNED NOT NULL,
  `photo_url` varchar(500) NOT NULL,
  `caption` varchar(255) DEFAULT NULL,
  `tag` enum('exterior_front','exterior_back','exterior_left','exterior_right','interior','dashboard_odometer','damage_detail','other') NOT NULL DEFAULT 'other',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_claims`
--

CREATE TABLE `insurance_claims` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `policy_id` bigint(20) UNSIGNED NOT NULL,
  `accident_id` bigint(20) UNSIGNED DEFAULT NULL,
  `vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `claim_number` varchar(100) NOT NULL,
  `claim_date` date NOT NULL,
  `claim_amount` decimal(12,2) NOT NULL,
  `payout_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `deductible_applied` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` enum('submitted','under_review','approved','denied','settled') NOT NULL DEFAULT 'submitted',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_policies`
--

CREATE TABLE `insurance_policies` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `vehicle_id` bigint(20) UNSIGNED DEFAULT NULL,
  `policy_number` varchar(100) NOT NULL,
  `insurer_name` varchar(150) NOT NULL,
  `coverage_type` varchar(100) NOT NULL,
  `premium` decimal(12,2) NOT NULL,
  `deductible` decimal(12,2) NOT NULL DEFAULT 0.00,
  `effective_date` date NOT NULL,
  `expiry_date` date NOT NULL,
  `status` enum('active','expired','cancelled') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invitations`
--

CREATE TABLE `invitations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(255) NOT NULL,
  `role` enum('owner','secondary_admin','finance','fleet_maintenance','rental_operations','readonly_manager') NOT NULL,
  `token` varchar(255) NOT NULL,
  `invited_by` bigint(20) UNSIGNED DEFAULT NULL,
  `expires_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `accepted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `invoice_number` varchar(100) NOT NULL,
  `rental_id` bigint(20) UNSIGNED DEFAULT NULL,
  `driver_id` bigint(20) UNSIGNED NOT NULL,
  `issued_by` bigint(20) UNSIGNED DEFAULT NULL,
  `issue_date` date NOT NULL,
  `due_date` date NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `tax` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_amount` decimal(12,2) NOT NULL,
  `paid_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `balance` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` enum('draft','issued','partially_paid','paid','overdue','cancelled','void') NOT NULL DEFAULT 'draft',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoice_items`
--

CREATE TABLE `invoice_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `invoice_id` bigint(20) UNSIGNED NOT NULL,
  `description` varchar(255) NOT NULL,
  `category` enum('insurance','registration','oil_change','repairs','tires','towing','cleaning','tolls','parking','tickets','marketing','software','bank_fees','office','legal_accounting','other') DEFAULT NULL,
  `quantity` decimal(8,2) NOT NULL DEFAULT 1.00,
  `unit_price` decimal(12,2) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `knex_migrations`
--

CREATE TABLE `knex_migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `batch` int(11) DEFAULT NULL,
  `migration_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `knex_migrations`
--

INSERT INTO `knex_migrations` (`id`, `name`, `batch`, `migration_time`) VALUES
(1, '001_create_users_and_auth_tables.js', 1, '2026-11-16 07:32:09'),
(2, '002_create_audit_logs_table.js', 1, '2026-11-16 07:32:10'),
(3, '003_create_vehicles_and_drivers_tables.js', 1, '2026-11-16 07:32:10'),
(4, '004_create_rentals_tables.js', 1, '2026-11-16 07:32:11'),
(5, '005_create_inspections_and_photos_tables.js', 1, '2026-11-16 07:32:12'),
(6, '006_create_accidents_and_insurance_tables.js', 1, '2026-11-16 07:32:12'),
(7, '007_create_vendors_expenses_and_maintenance_tables.js', 1, '2026-11-16 07:32:14'),
(8, '008_create_invoices_and_ledger_tables.js', 1, '2026-11-16 07:32:15'),
(9, '009_create_tolls_tickets_table.js', 1, '2026-11-16 07:32:16'),
(10, '010_create_documents_tables.js', 1, '2026-11-16 07:32:16'),
(11, '011_create_employee_paperwork_table.js', 1, '2026-11-16 07:32:17'),
(12, '012_create_settings_and_notifications_tables.js', 1, '2026-11-16 07:32:17');

-- --------------------------------------------------------

--
-- Table structure for table `knex_migrations_lock`
--

CREATE TABLE `knex_migrations_lock` (
  `index` int(10) UNSIGNED NOT NULL,
  `is_locked` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `knex_migrations_lock`
--

INSERT INTO `knex_migrations_lock` (`index`, `is_locked`) VALUES
(1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `ledger_entries`
--

CREATE TABLE `ledger_entries` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `rental_id` bigint(20) UNSIGNED DEFAULT NULL,
  `driver_id` bigint(20) UNSIGNED DEFAULT NULL,
  `invoice_id` bigint(20) UNSIGNED DEFAULT NULL,
  `recorded_by` bigint(20) UNSIGNED DEFAULT NULL,
  `entry_type` enum('charge','payment','deposit','refund','credit','adjustment','reversal') NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `payment_method` enum('cash','zelle','stripe','card','bank_transfer','credit','adjustment') DEFAULT NULL,
  `reference_no` varchar(100) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `entry_date` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_records`
--

CREATE TABLE `maintenance_records` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `vendor_id` bigint(20) UNSIGNED DEFAULT NULL,
  `service_date` date NOT NULL,
  `odometer` int(11) NOT NULL,
  `service_type` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `cost` decimal(12,2) NOT NULL,
  `invoice_url` varchar(500) DEFAULT NULL,
  `next_service_odometer` int(11) DEFAULT NULL,
  `next_service_date` date DEFAULT NULL,
  `status` enum('scheduled','in_progress','completed','cancelled') NOT NULL DEFAULT 'scheduled',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mfa_backup_codes`
--

CREATE TABLE `mfa_backup_codes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `code_hash` varchar(255) NOT NULL,
  `used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notification_rules`
--

CREATE TABLE `notification_rules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `event_type` varchar(100) NOT NULL,
  `title` varchar(200) NOT NULL,
  `channel` enum('email','sms','both') NOT NULL DEFAULT 'email',
  `lead_time_days` int(11) NOT NULL DEFAULT 0,
  `recipients` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`recipients`)),
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notification_rules`
--

INSERT INTO `notification_rules` (`id`, `event_type`, `title`, `channel`, `lead_time_days`, `recipients`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'overdue_payments', 'Overdue Driver Lease Payments', 'both', 1, '[\"finance\",\"owner\"]', 1, '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(2, 'contract_ending', 'Upcoming Rental Contract Expirations', 'email', 7, '[\"rental_operations\",\"secondary_admin\"]', 1, '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(3, 'document_expiry', 'Driver License, Registration or Insurance Expiration', 'both', 14, '[\"fleet_maintenance\",\"rental_operations\"]', 1, '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(4, 'oil_change_due', 'Vehicle 5,000-Mile Oil Change Due', 'email', 3, '[\"fleet_maintenance\"]', 1, '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(5, 'unpaid_tolls_tickets', 'Unpaid Tolls or Violation Citations Received', 'email', 2, '[\"rental_operations\",\"finance\"]', 1, '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(6, 'missing_documents', 'Missing Required Driver or Vehicle Documents', 'email', 0, '[\"rental_operations\"]', 1, '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(7, 'unresolved_accidents', 'Unresolved Accident Reports & Open Insurance Claims', 'both', 0, '[\"fleet_maintenance\",\"owner\"]', 1, '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(8, 'vehicles_awaiting_inspection', 'Vehicles Awaiting Pickup or Return Inspection', 'email', 0, '[\"fleet_maintenance\",\"rental_operations\"]', 1, '2026-11-16 07:36:28', '2026-11-16 07:36:28');

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `expires_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `refresh_tokens`
--

CREATE TABLE `refresh_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `expires_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `revoked_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `refresh_tokens`
--

INSERT INTO `refresh_tokens` (`id`, `user_id`, `token_hash`, `expires_at`, `revoked_at`, `created_at`, `updated_at`) VALUES
(1, 1, '4b57db30c2238296a1fe24ccb219e5d6cee916bb5ed993b75dca6a51cf6aa26e', '2026-11-23 11:44:12', NULL, '2026-11-16 11:44:12', '2026-11-16 11:44:12'),
(2, 1, '55b5a815f545d40522c50278a0c0dfbfff8d7db60a117b6908a91bee5232bf8b', '2026-11-23 11:44:36', NULL, '2026-11-16 11:44:36', '2026-11-16 11:44:36'),
(3, 1, '76830f0c3dcb111626d7002c5a6be97c2616da16c819432a65a9c93513832f4f', '2026-11-23 11:45:31', NULL, '2026-11-16 11:45:31', '2026-11-16 11:45:31'),
(4, 1, 'ee4178134d4dc1257c4f56b894383b61081bd18c4825d23cd952a0a8e6792da7', '2026-11-23 11:45:40', NULL, '2026-11-16 11:45:40', '2026-11-16 11:45:40'),
(5, 2, '68ccc63847b4cd030e46bbc739385d4e554979644833833fcd0c4b05d68c0636', '2026-11-23 11:45:40', NULL, '2026-11-16 11:45:40', '2026-11-16 11:45:40'),
(6, 3, '566a91f3160a30b586365b27ab45411ffda0bae3170cd508125c0dd8409315cf', '2026-11-23 11:45:40', NULL, '2026-11-16 11:45:40', '2026-11-16 11:45:40'),
(7, 4, '0867cf69826f5463237e58ce38fa6609361893449f45c8763a5a63e884d7cbdd', '2026-11-23 11:45:40', NULL, '2026-11-16 11:45:40', '2026-11-16 11:45:40'),
(8, 5, '5f24f306a37b605f6bd9d2ed027fcd088732aa0a97b345a8fdd0ade1b62620f7', '2026-11-23 11:45:40', NULL, '2026-11-16 11:45:40', '2026-11-16 11:45:40'),
(9, 6, '49a88984bc8d9b2f298b336cdb743df02083259e78bfcc8698ae6ebe002edab4', '2026-11-23 11:45:40', NULL, '2026-11-16 11:45:40', '2026-11-16 11:45:40'),
(10, 1, '6de3e8d2c801ed9ca4c39f8b464020c522e28cf96edfdf94d5e685275cf27ddd', '2026-11-23 11:48:14', NULL, '2026-11-16 11:48:14', '2026-11-16 11:48:14'),
(11, 1, 'c2ec1ea620cac0385f47022577282f0f9288ffd5ae66d995923dc91beff6031b', '2026-11-23 11:48:38', NULL, '2026-11-16 11:48:38', '2026-11-16 11:48:38'),
(12, 1, 'ca7d2b0ef1f94f5319d7354df1e8317624b3aaa30c4b09fd8917dd579665be49', '2026-11-23 11:49:25', NULL, '2026-11-16 11:49:25', '2026-11-16 11:49:25'),
(13, 1, 'ae5e3ed28cf26aaa71bf35fd2da5f07c641e06244d4c16922547bd18958143d7', '2026-11-23 12:01:47', NULL, '2026-11-16 12:01:47', '2026-11-16 12:01:47'),
(14, 1, 'eefbb6a2e3942fe060b4c16d9ebf390e881ba1ccfca10e6e69891d8795a4076a', '2026-11-23 12:01:57', NULL, '2026-11-16 12:01:57', '2026-11-16 12:01:57'),
(15, 1, 'e0d2ea45563b9f34f29869f68ff4606e91bba30b849d31c94c75c84b37f1c6c5', '2026-11-23 12:05:30', NULL, '2026-11-16 12:05:30', '2026-11-16 12:05:30'),
(16, 1, 'a6bbe1cf5c055d150baf3a4afa176c93386cc9dbd97756e02b9ca9a0b76e0608', '2026-11-23 12:05:51', NULL, '2026-11-16 12:05:51', '2026-11-16 12:05:51'),
(17, 1, '51ac644d35b0d8929a8ed96e67519037c3f7920af4cd34fb45ee629c928dec8a', '2026-11-23 12:10:07', NULL, '2026-11-16 12:10:07', '2026-11-16 12:10:07'),
(18, 1, '91b64dde47f3e483b323f646b629c7796bf71f350179fa88a9b3faa4195b99c5', '2026-11-23 12:13:18', NULL, '2026-11-16 12:13:18', '2026-11-16 12:13:18'),
(19, 1, 'fe1ae2b36446647b9475b01a079ec2af511e84d3d0f2f8556d466822249314e7', '2026-11-23 12:13:58', NULL, '2026-11-16 12:13:58', '2026-11-16 12:13:58'),
(20, 1, '08cb7f32e5c95fc75a6c2670bfcf64827496062fec6bfe646b5f8ff3df8336bb', '2026-11-23 12:14:33', NULL, '2026-11-16 12:14:33', '2026-11-16 12:14:33'),
(21, 1, '032e00ad7d1e205cdf20d5288ee09abb73fd3871dccd1fcc64758d05ccf1a191', '2026-11-23 12:15:01', NULL, '2026-11-16 12:15:01', '2026-11-16 12:15:01'),
(22, 1, '1d8561e5858ab92cfa9b2c25863939641006dd89495f4e1b29ee88b33fdebb03', '2026-11-23 12:22:14', NULL, '2026-11-16 12:22:14', '2026-11-16 12:22:14'),
(23, 1, '35088070d49d66a53eec33ba0305097867df5aeaab43f063a62fd3f41bc847d2', '2026-11-23 12:22:25', NULL, '2026-11-16 12:22:25', '2026-11-16 12:22:25'),
(24, 1, '530851bc4e3b071a4b487e9ae60f5e1ea5a66caecbb599f53f46cad714e5e736', '2026-11-23 12:22:46', NULL, '2026-11-16 12:22:46', '2026-11-16 12:22:46'),
(25, 1, '35ed200bba337d914d8c023a64581ddd753e0c51d9d43354f96a150cbb60b1d6', '2026-11-23 12:23:17', NULL, '2026-11-16 12:23:17', '2026-11-16 12:23:17'),
(26, 1, '3d9ae59c5085d3c18be55aa6dac4bb8f3ef9f8f72aee62a0e387a26d57411151', '2026-11-23 12:27:34', NULL, '2026-11-16 12:27:34', '2026-11-16 12:27:34'),
(27, 1, '2574eb451b1bb346069226550a1f53a42070025e198b39b24515ef9477ad68c1', '2026-11-23 12:27:52', NULL, '2026-11-16 12:27:52', '2026-11-16 12:27:52'),
(28, 1, '6f58f68ce64770c9f31207251dfc9154862dbedadcea009459eb0ae4103455a1', '2026-11-23 12:39:53', NULL, '2026-11-16 12:39:53', '2026-11-16 12:39:53'),
(29, 1, 'fb40bb75d8e20d49bab113457132e8c6f086d6ca73d7619c50abc430b53163af', '2026-11-23 12:41:51', NULL, '2026-11-16 12:41:51', '2026-11-16 12:41:51'),
(30, 1, '473b8e529fccd3c6a93b8c3516936980c1c529ad91eb11ef7a280e7d2dac06f5', '2026-11-23 12:42:24', NULL, '2026-11-16 12:42:24', '2026-11-16 12:42:24'),
(31, 1, '310bd1cb230e649c1e7da64bb575ad0318c0982ee67567bedf68a1901ef15e74', '2026-11-23 13:05:34', NULL, '2026-11-16 13:05:34', '2026-11-16 13:05:34');

-- --------------------------------------------------------

--
-- Table structure for table `rentals`
--

CREATE TABLE `rentals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `contract_no` varchar(100) NOT NULL,
  `vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `driver_id` bigint(20) UNSIGNED NOT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('draft','awaiting_signature','active','renewed','terminated','completed') NOT NULL DEFAULT 'draft',
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `weekly_rate` decimal(12,2) NOT NULL,
  `deposit_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `mileage_at_pickup` int(11) NOT NULL DEFAULT 0,
  `mileage_at_return` int(11) DEFAULT NULL,
  `terms` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rentals`
--

INSERT INTO `rentals` (`id`, `contract_no`, `vehicle_id`, `driver_id`, `created_by`, `status`, `start_date`, `end_date`, `weekly_rate`, `deposit_amount`, `mileage_at_pickup`, `mileage_at_return`, `terms`, `created_at`, `updated_at`) VALUES
(1, 'RNT-2024-001', 1, 1, 1, 'active', '2025-07-01', '2025-07-31', 350.00, 500.00, 24500, NULL, 'Standard commercial rental agreement', '2026-11-16 07:13:21', '2026-11-16 07:13:21');

-- --------------------------------------------------------

--
-- Table structure for table `rental_amendments`
--

CREATE TABLE `rental_amendments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `rental_id` bigint(20) UNSIGNED NOT NULL,
  `amended_by` bigint(20) UNSIGNED DEFAULT NULL,
  `amendment_type` varchar(100) NOT NULL,
  `previous_end_date` date DEFAULT NULL,
  `new_end_date` date DEFAULT NULL,
  `previous_weekly_rate` decimal(12,2) DEFAULT NULL,
  `new_weekly_rate` decimal(12,2) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rental_signatures`
--

CREATE TABLE `rental_signatures` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `rental_id` bigint(20) UNSIGNED NOT NULL,
  `signer_name` varchar(255) NOT NULL,
  `signer_role` enum('driver','owner','manager') NOT NULL,
  `signature_data` longtext NOT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `signed_at` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `setting_key`, `setting_value`, `description`, `created_at`, `updated_at`) VALUES
(1, 'company_name', 'PrimeRoute Fleet Solutions', 'Official registered company business name', '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(2, 'company_email', 'operations@primeroute.io', 'Primary customer support and operations email', '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(3, 'company_phone', '+1 (555) 234-5678', 'Primary company phone number', '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(4, 'company_address', '1200 Fleet Management Way, Suite 400, Chicago, IL 60607', 'Headquarters physical address', '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(5, 'oil_change_interval_miles', '5000', 'Standard mileage threshold trigger for scheduled routine oil change', '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(6, 'default_weekly_deposit', '500.00', 'Standard refundable security deposit held per vehicle lease', '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(7, 'currency', 'USD', 'Default operational and accounting currency', '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(8, 'timezone', 'America/Chicago', 'Default operational timezone', '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(9, 'late_fee_percentage', '5.00', 'Percentage penalty applied on overdue driver lease balances', '2026-11-16 07:36:28', '2026-11-16 07:36:28');

-- --------------------------------------------------------

--
-- Table structure for table `tolls_tickets`
--

CREATE TABLE `tolls_tickets` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `driver_id` bigint(20) UNSIGNED DEFAULT NULL,
  `rental_id` bigint(20) UNSIGNED DEFAULT NULL,
  `violation_number` varchar(100) NOT NULL,
  `violation_date` datetime NOT NULL,
  `issuing_authority` varchar(150) NOT NULL,
  `violation_type` enum('toll','speeding','red_light','parking','other') NOT NULL DEFAULT 'toll',
  `amount` decimal(12,2) NOT NULL,
  `due_date` date DEFAULT NULL,
  `status` enum('unassigned','under_review','assigned','charged','paid','disputed') NOT NULL DEFAULT 'unassigned',
  `driver_charged` tinyint(1) NOT NULL DEFAULT 0,
  `invoice_id` bigint(20) UNSIGNED DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('owner','secondary_admin','finance','fleet_maintenance','rental_operations','readonly_manager') NOT NULL DEFAULT 'readonly_manager',
  `status` enum('active','inactive','suspended') NOT NULL DEFAULT 'active',
  `phone` varchar(50) DEFAULT NULL,
  `mfa_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `mfa_secret` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `role`, `status`, `phone`, `mfa_enabled`, `mfa_secret`, `created_at`, `updated_at`) VALUES
(1, 'Marcus Brody', 'marcus.brody@primeroute.io', '$2a$10$B7./cqCSYMTmaDHLRebOD.avikokxXcgOX110DquXBNvcwXnxT0gW', 'owner', 'active', '+1 (555) 019-2831', 0, NULL, '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(2, 'Elena Vance', 'elena.vance@primeroute.io', '$2a$10$B7./cqCSYMTmaDHLRebOD.avikokxXcgOX110DquXBNvcwXnxT0gW', 'secondary_admin', 'active', '+1 (555) 019-2832', 0, NULL, '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(3, 'Michael Chang', 'michael.chang@primeroute.io', '$2a$10$B7./cqCSYMTmaDHLRebOD.avikokxXcgOX110DquXBNvcwXnxT0gW', 'finance', 'active', '+1 (555) 019-2833', 0, NULL, '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(4, 'Tom Gallagher', 'tom.gallagher@primeroute.io', '$2a$10$B7./cqCSYMTmaDHLRebOD.avikokxXcgOX110DquXBNvcwXnxT0gW', 'fleet_maintenance', 'active', '+1 (555) 019-2834', 0, NULL, '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(5, 'Sarah Connor', 'sarah.connor@primeroute.io', '$2a$10$B7./cqCSYMTmaDHLRebOD.avikokxXcgOX110DquXBNvcwXnxT0gW', 'rental_operations', 'active', '+1 (555) 019-2835', 0, NULL, '2026-11-16 07:36:28', '2026-11-16 07:36:28'),
(6, 'Rachel Green', 'rachel.green@primeroute.io', '$2a$10$B7./cqCSYMTmaDHLRebOD.avikokxXcgOX110DquXBNvcwXnxT0gW', 'readonly_manager', 'active', '+1 (555) 019-2836', 0, NULL, '2026-11-16 07:36:28', '2026-11-16 07:36:28');

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `vin` varchar(50) NOT NULL,
  `plate` varchar(50) NOT NULL,
  `make` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  `year` int(11) NOT NULL,
  `color` varchar(50) DEFAULT NULL,
  `mileage` int(11) NOT NULL DEFAULT 0,
  `status` enum('available','reserved','rented','maintenance','unavailable','sold_retired') NOT NULL DEFAULT 'available',
  `purchase_date` date DEFAULT NULL,
  `purchase_price` decimal(12,2) DEFAULT NULL,
  `financing_details` text DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `archived_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vehicles`
--

INSERT INTO `vehicles` (`id`, `vin`, `plate`, `make`, `model`, `year`, `color`, `mileage`, `status`, `purchase_date`, `purchase_price`, `financing_details`, `location`, `archived_at`, `created_at`, `updated_at`) VALUES
(1, '4T1B11HK5JU192831', 'PR-2024-TC', 'Toyota', 'Camry SE', 2024, 'Midnight Black', 24500, 'rented', '2024-01-15', 28500.00, 'PrimeRoute Fleet', 'Main Yard Hub', NULL, '2026-11-16 07:13:21', '2026-11-16 07:13:21');

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_assignments`
--

CREATE TABLE `vehicle_assignments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `vehicle_id` bigint(20) UNSIGNED NOT NULL,
  `driver_id` bigint(20) UNSIGNED NOT NULL,
  `assigned_by` bigint(20) UNSIGNED DEFAULT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vendors`
--

CREATE TABLE `vendors` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(200) NOT NULL,
  `service_type` varchar(100) DEFAULT NULL,
  `contact_person` varchar(150) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accidents`
--
ALTER TABLE `accidents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `accidents_vehicle_id_index` (`vehicle_id`),
  ADD KEY `accidents_driver_id_index` (`driver_id`),
  ADD KEY `accidents_rental_id_index` (`rental_id`),
  ADD KEY `accidents_accident_date_index` (`accident_date`),
  ADD KEY `accidents_status_index` (`status`);

--
-- Indexes for table `alert_history`
--
ALTER TABLE `alert_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `alert_history_rule_id_index` (`rule_id`),
  ADD KEY `alert_history_event_type_index` (`event_type`),
  ADD KEY `alert_history_severity_index` (`severity`),
  ADD KEY `alert_history_related_entity_type_related_entity_id_index` (`related_entity_type`,`related_entity_id`),
  ADD KEY `alert_history_resolved_at_index` (`resolved_at`),
  ADD KEY `alert_history_resolved_by_index` (`resolved_by`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audit_logs_user_id_index` (`user_id`),
  ADD KEY `audit_logs_module_index` (`module`),
  ADD KEY `audit_logs_action_index` (`action`),
  ADD KEY `audit_logs_entity_type_entity_id_index` (`entity_type`,`entity_id`),
  ADD KEY `audit_logs_created_at_index` (`created_at`);

--
-- Indexes for table `documents`
--
ALTER TABLE `documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `documents_vehicle_id_index` (`vehicle_id`),
  ADD KEY `documents_driver_id_index` (`driver_id`),
  ADD KEY `documents_rental_id_index` (`rental_id`),
  ADD KEY `documents_uploaded_by_index` (`uploaded_by`),
  ADD KEY `documents_document_type_index` (`document_type`),
  ADD KEY `documents_expiry_date_index` (`expiry_date`);

--
-- Indexes for table `document_versions`
--
ALTER TABLE `document_versions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `document_versions_document_id_index` (`document_id`),
  ADD KEY `document_versions_uploaded_by_index` (`uploaded_by`);

--
-- Indexes for table `drivers`
--
ALTER TABLE `drivers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `drivers_email_index` (`email`),
  ADD KEY `drivers_license_number_index` (`license_number`),
  ADD KEY `drivers_license_expiry_index` (`license_expiry`),
  ADD KEY `drivers_status_index` (`status`),
  ADD KEY `drivers_archived_at_index` (`archived_at`);

--
-- Indexes for table `employee_paperwork`
--
ALTER TABLE `employee_paperwork`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_paperwork_user_id_index` (`user_id`),
  ADD KEY `employee_paperwork_driver_id_index` (`driver_id`),
  ADD KEY `employee_paperwork_status_index` (`status`),
  ADD KEY `employee_paperwork_submitted_at_index` (`submitted_at`),
  ADD KEY `employee_paperwork_reviewed_by_index` (`reviewed_by`);

--
-- Indexes for table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expenses_recorded_by_foreign` (`recorded_by`),
  ADD KEY `expenses_approver_id_foreign` (`approver_id`),
  ADD KEY `expenses_vehicle_id_index` (`vehicle_id`),
  ADD KEY `expenses_vendor_id_index` (`vendor_id`),
  ADD KEY `expenses_rental_id_index` (`rental_id`),
  ADD KEY `expenses_category_index` (`category`),
  ADD KEY `expenses_expense_date_index` (`expense_date`),
  ADD KEY `expenses_status_index` (`status`);

--
-- Indexes for table `inspections`
--
ALTER TABLE `inspections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inspections_rental_id_index` (`rental_id`),
  ADD KEY `inspections_vehicle_id_index` (`vehicle_id`),
  ADD KEY `inspections_inspector_id_index` (`inspector_id`),
  ADD KEY `inspections_inspection_type_index` (`inspection_type`),
  ADD KEY `inspections_inspection_date_index` (`inspection_date`);

--
-- Indexes for table `inspection_photos`
--
ALTER TABLE `inspection_photos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inspection_photos_inspection_id_index` (`inspection_id`),
  ADD KEY `inspection_photos_tag_index` (`tag`);

--
-- Indexes for table `insurance_claims`
--
ALTER TABLE `insurance_claims`
  ADD PRIMARY KEY (`id`),
  ADD KEY `insurance_claims_policy_id_index` (`policy_id`),
  ADD KEY `insurance_claims_accident_id_index` (`accident_id`),
  ADD KEY `insurance_claims_vehicle_id_index` (`vehicle_id`),
  ADD KEY `insurance_claims_claim_number_index` (`claim_number`),
  ADD KEY `insurance_claims_status_index` (`status`);

--
-- Indexes for table `insurance_policies`
--
ALTER TABLE `insurance_policies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `insurance_policies_vehicle_id_index` (`vehicle_id`),
  ADD KEY `insurance_policies_policy_number_index` (`policy_number`),
  ADD KEY `insurance_policies_expiry_date_index` (`expiry_date`),
  ADD KEY `insurance_policies_status_index` (`status`);

--
-- Indexes for table `invitations`
--
ALTER TABLE `invitations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invitations_token_unique` (`token`),
  ADD KEY `invitations_email_index` (`email`),
  ADD KEY `invitations_invited_by_index` (`invited_by`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invoices_invoice_number_unique` (`invoice_number`),
  ADD KEY `invoices_rental_id_index` (`rental_id`),
  ADD KEY `invoices_driver_id_index` (`driver_id`),
  ADD KEY `invoices_issued_by_index` (`issued_by`),
  ADD KEY `invoices_issue_date_index` (`issue_date`),
  ADD KEY `invoices_due_date_index` (`due_date`),
  ADD KEY `invoices_status_index` (`status`);

--
-- Indexes for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoice_items_invoice_id_index` (`invoice_id`);

--
-- Indexes for table `knex_migrations`
--
ALTER TABLE `knex_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `knex_migrations_lock`
--
ALTER TABLE `knex_migrations_lock`
  ADD PRIMARY KEY (`index`);

--
-- Indexes for table `ledger_entries`
--
ALTER TABLE `ledger_entries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ledger_entries_rental_id_index` (`rental_id`),
  ADD KEY `ledger_entries_driver_id_index` (`driver_id`),
  ADD KEY `ledger_entries_invoice_id_index` (`invoice_id`),
  ADD KEY `ledger_entries_recorded_by_index` (`recorded_by`),
  ADD KEY `ledger_entries_entry_type_index` (`entry_type`),
  ADD KEY `ledger_entries_reference_no_index` (`reference_no`),
  ADD KEY `ledger_entries_entry_date_index` (`entry_date`);

--
-- Indexes for table `maintenance_records`
--
ALTER TABLE `maintenance_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `maintenance_records_vehicle_id_index` (`vehicle_id`),
  ADD KEY `maintenance_records_vendor_id_index` (`vendor_id`),
  ADD KEY `maintenance_records_service_date_index` (`service_date`),
  ADD KEY `maintenance_records_status_index` (`status`);

--
-- Indexes for table `mfa_backup_codes`
--
ALTER TABLE `mfa_backup_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `mfa_backup_codes_user_id_index` (`user_id`);

--
-- Indexes for table `notification_rules`
--
ALTER TABLE `notification_rules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `notification_rules_event_type_unique` (`event_type`),
  ADD KEY `notification_rules_event_type_index` (`event_type`),
  ADD KEY `notification_rules_is_active_index` (`is_active`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `password_resets_user_id_index` (`user_id`),
  ADD KEY `password_resets_token_hash_index` (`token_hash`);

--
-- Indexes for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `refresh_tokens_user_id_index` (`user_id`),
  ADD KEY `refresh_tokens_token_hash_index` (`token_hash`),
  ADD KEY `refresh_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `rentals`
--
ALTER TABLE `rentals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `rentals_contract_no_unique` (`contract_no`),
  ADD KEY `rentals_vehicle_id_index` (`vehicle_id`),
  ADD KEY `rentals_driver_id_index` (`driver_id`),
  ADD KEY `rentals_created_by_index` (`created_by`),
  ADD KEY `rentals_status_index` (`status`),
  ADD KEY `rentals_start_date_index` (`start_date`),
  ADD KEY `rentals_end_date_index` (`end_date`);

--
-- Indexes for table `rental_amendments`
--
ALTER TABLE `rental_amendments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rental_amendments_rental_id_index` (`rental_id`),
  ADD KEY `rental_amendments_amended_by_index` (`amended_by`);

--
-- Indexes for table `rental_signatures`
--
ALTER TABLE `rental_signatures`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rental_signatures_rental_id_index` (`rental_id`),
  ADD KEY `rental_signatures_signed_at_index` (`signed_at`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `settings_setting_key_unique` (`setting_key`),
  ADD KEY `settings_setting_key_index` (`setting_key`);

--
-- Indexes for table `tolls_tickets`
--
ALTER TABLE `tolls_tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tolls_tickets_vehicle_id_index` (`vehicle_id`),
  ADD KEY `tolls_tickets_driver_id_index` (`driver_id`),
  ADD KEY `tolls_tickets_rental_id_index` (`rental_id`),
  ADD KEY `tolls_tickets_violation_number_index` (`violation_number`),
  ADD KEY `tolls_tickets_violation_date_index` (`violation_date`),
  ADD KEY `tolls_tickets_status_index` (`status`),
  ADD KEY `tolls_tickets_invoice_id_index` (`invoice_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_email_index` (`email`),
  ADD KEY `users_role_index` (`role`),
  ADD KEY `users_status_index` (`status`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `vehicles_vin_unique` (`vin`),
  ADD UNIQUE KEY `vehicles_plate_unique` (`plate`),
  ADD KEY `vehicles_status_index` (`status`),
  ADD KEY `vehicles_make_model_index` (`make`,`model`),
  ADD KEY `vehicles_archived_at_index` (`archived_at`);

--
-- Indexes for table `vehicle_assignments`
--
ALTER TABLE `vehicle_assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vehicle_assignments_vehicle_id_index` (`vehicle_id`),
  ADD KEY `vehicle_assignments_driver_id_index` (`driver_id`),
  ADD KEY `vehicle_assignments_assigned_by_index` (`assigned_by`),
  ADD KEY `vehicle_assignments_start_date_index` (`start_date`),
  ADD KEY `vehicle_assignments_end_date_index` (`end_date`);

--
-- Indexes for table `vendors`
--
ALTER TABLE `vendors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vendors_name_index` (`name`),
  ADD KEY `vendors_service_type_index` (`service_type`),
  ADD KEY `vendors_status_index` (`status`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accidents`
--
ALTER TABLE `accidents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `alert_history`
--
ALTER TABLE `alert_history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `documents`
--
ALTER TABLE `documents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `document_versions`
--
ALTER TABLE `document_versions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `drivers`
--
ALTER TABLE `drivers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `employee_paperwork`
--
ALTER TABLE `employee_paperwork`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `inspections`
--
ALTER TABLE `inspections`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inspection_photos`
--
ALTER TABLE `inspection_photos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_claims`
--
ALTER TABLE `insurance_claims`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_policies`
--
ALTER TABLE `insurance_policies`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invitations`
--
ALTER TABLE `invitations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoice_items`
--
ALTER TABLE `invoice_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `knex_migrations`
--
ALTER TABLE `knex_migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `knex_migrations_lock`
--
ALTER TABLE `knex_migrations_lock`
  MODIFY `index` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `ledger_entries`
--
ALTER TABLE `ledger_entries`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `maintenance_records`
--
ALTER TABLE `maintenance_records`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mfa_backup_codes`
--
ALTER TABLE `mfa_backup_codes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notification_rules`
--
ALTER TABLE `notification_rules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `rentals`
--
ALTER TABLE `rentals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `rental_amendments`
--
ALTER TABLE `rental_amendments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rental_signatures`
--
ALTER TABLE `rental_signatures`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tolls_tickets`
--
ALTER TABLE `tolls_tickets`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `vehicle_assignments`
--
ALTER TABLE `vehicle_assignments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `vendors`
--
ALTER TABLE `vendors`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accidents`
--
ALTER TABLE `accidents`
  ADD CONSTRAINT `accidents_driver_id_foreign` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`),
  ADD CONSTRAINT `accidents_rental_id_foreign` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`id`),
  ADD CONSTRAINT `accidents_vehicle_id_foreign` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`);

--
-- Constraints for table `alert_history`
--
ALTER TABLE `alert_history`
  ADD CONSTRAINT `alert_history_resolved_by_foreign` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `alert_history_rule_id_foreign` FOREIGN KEY (`rule_id`) REFERENCES `notification_rules` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `documents`
--
ALTER TABLE `documents`
  ADD CONSTRAINT `documents_driver_id_foreign` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`),
  ADD CONSTRAINT `documents_rental_id_foreign` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`id`),
  ADD CONSTRAINT `documents_uploaded_by_foreign` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `documents_vehicle_id_foreign` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`);

--
-- Constraints for table `document_versions`
--
ALTER TABLE `document_versions`
  ADD CONSTRAINT `document_versions_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `document_versions_uploaded_by_foreign` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `employee_paperwork`
--
ALTER TABLE `employee_paperwork`
  ADD CONSTRAINT `employee_paperwork_driver_id_foreign` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`),
  ADD CONSTRAINT `employee_paperwork_reviewed_by_foreign` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `employee_paperwork_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `expenses`
--
ALTER TABLE `expenses`
  ADD CONSTRAINT `expenses_approver_id_foreign` FOREIGN KEY (`approver_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `expenses_recorded_by_foreign` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `expenses_rental_id_foreign` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`id`),
  ADD CONSTRAINT `expenses_vehicle_id_foreign` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  ADD CONSTRAINT `expenses_vendor_id_foreign` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`);

--
-- Constraints for table `inspections`
--
ALTER TABLE `inspections`
  ADD CONSTRAINT `inspections_inspector_id_foreign` FOREIGN KEY (`inspector_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `inspections_rental_id_foreign` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`id`),
  ADD CONSTRAINT `inspections_vehicle_id_foreign` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`);

--
-- Constraints for table `inspection_photos`
--
ALTER TABLE `inspection_photos`
  ADD CONSTRAINT `inspection_photos_inspection_id_foreign` FOREIGN KEY (`inspection_id`) REFERENCES `inspections` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `insurance_claims`
--
ALTER TABLE `insurance_claims`
  ADD CONSTRAINT `insurance_claims_accident_id_foreign` FOREIGN KEY (`accident_id`) REFERENCES `accidents` (`id`),
  ADD CONSTRAINT `insurance_claims_policy_id_foreign` FOREIGN KEY (`policy_id`) REFERENCES `insurance_policies` (`id`),
  ADD CONSTRAINT `insurance_claims_vehicle_id_foreign` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`);

--
-- Constraints for table `insurance_policies`
--
ALTER TABLE `insurance_policies`
  ADD CONSTRAINT `insurance_policies_vehicle_id_foreign` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`);

--
-- Constraints for table `invitations`
--
ALTER TABLE `invitations`
  ADD CONSTRAINT `invitations_invited_by_foreign` FOREIGN KEY (`invited_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_driver_id_foreign` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`),
  ADD CONSTRAINT `invoices_issued_by_foreign` FOREIGN KEY (`issued_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `invoices_rental_id_foreign` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`id`);

--
-- Constraints for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD CONSTRAINT `invoice_items_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ledger_entries`
--
ALTER TABLE `ledger_entries`
  ADD CONSTRAINT `ledger_entries_driver_id_foreign` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`),
  ADD CONSTRAINT `ledger_entries_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`),
  ADD CONSTRAINT `ledger_entries_recorded_by_foreign` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `ledger_entries_rental_id_foreign` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`id`);

--
-- Constraints for table `maintenance_records`
--
ALTER TABLE `maintenance_records`
  ADD CONSTRAINT `maintenance_records_vehicle_id_foreign` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  ADD CONSTRAINT `maintenance_records_vendor_id_foreign` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`);

--
-- Constraints for table `mfa_backup_codes`
--
ALTER TABLE `mfa_backup_codes`
  ADD CONSTRAINT `mfa_backup_codes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD CONSTRAINT `password_resets_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD CONSTRAINT `refresh_tokens_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `rentals`
--
ALTER TABLE `rentals`
  ADD CONSTRAINT `rentals_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `rentals_driver_id_foreign` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`),
  ADD CONSTRAINT `rentals_vehicle_id_foreign` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`);

--
-- Constraints for table `rental_amendments`
--
ALTER TABLE `rental_amendments`
  ADD CONSTRAINT `rental_amendments_amended_by_foreign` FOREIGN KEY (`amended_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `rental_amendments_rental_id_foreign` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`id`);

--
-- Constraints for table `rental_signatures`
--
ALTER TABLE `rental_signatures`
  ADD CONSTRAINT `rental_signatures_rental_id_foreign` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`id`);

--
-- Constraints for table `tolls_tickets`
--
ALTER TABLE `tolls_tickets`
  ADD CONSTRAINT `tolls_tickets_driver_id_foreign` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`),
  ADD CONSTRAINT `tolls_tickets_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`),
  ADD CONSTRAINT `tolls_tickets_rental_id_foreign` FOREIGN KEY (`rental_id`) REFERENCES `rentals` (`id`),
  ADD CONSTRAINT `tolls_tickets_vehicle_id_foreign` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`);

--
-- Constraints for table `vehicle_assignments`
--
ALTER TABLE `vehicle_assignments`
  ADD CONSTRAINT `vehicle_assignments_assigned_by_foreign` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `vehicle_assignments_driver_id_foreign` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`),
  ADD CONSTRAINT `vehicle_assignments_vehicle_id_foreign` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
