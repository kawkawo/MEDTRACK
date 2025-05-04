-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : dim. 04 mai 2025 à 19:01
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `medical_db`
--

-- --------------------------------------------------------

--
-- Structure de la table `appointments`
--

CREATE TABLE `appointments` (
  `id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `appointment_date` datetime NOT NULL,
  `status` enum('Scheduled','Completed','Canceled') DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `appointments`
--

INSERT INTO `appointments` (`id`, `doctor_id`, `patient_id`, `appointment_date`, `status`, `notes`, `created_at`) VALUES
(2, 1, 2, '2025-04-17 00:00:00', 'Scheduled', NULL, '2025-04-26 17:50:14'),
(3, 1, 3, '2025-04-18 00:00:00', 'Scheduled', NULL, '2025-04-26 17:50:14'),
(4, 1, 8, '2025-04-16 10:00:00', 'Scheduled', NULL, '2025-04-26 17:50:14'),
(5, 1, 9, '2025-04-17 11:15:00', 'Scheduled', NULL, '2025-04-26 17:50:14'),
(6, 1, 20, '2025-04-28 10:00:00', 'Scheduled', NULL, '2025-04-26 17:50:14'),
(7, 1, 22, '2025-04-30 12:30:00', 'Scheduled', NULL, '2025-04-26 17:50:14'),
(8, 1, 23, '2025-05-01 09:45:00', 'Scheduled', NULL, '2025-04-26 17:50:14'),
(9, 1, 24, '2025-04-02 14:00:00', 'Completed', NULL, '2025-04-26 17:50:14'),
(10, 1, 25, '2025-04-03 16:15:00', 'Scheduled', NULL, '2025-04-26 17:50:14'),
(16, 1, 38, '2025-04-23 21:24:14', 'Scheduled', NULL, '2025-04-26 17:50:14'),
(17, 1, 39, '2025-04-23 21:26:41', 'Scheduled', NULL, '2025-04-26 17:50:14'),
(22, 1, 9, '2025-04-27 11:15:00', 'Scheduled', NULL, '2025-04-26 17:50:21'),
(52, 1, 9, '2025-04-27 18:00:00', 'Scheduled', '', '2025-04-27 16:05:53'),
(53, 1, 20, '2025-05-02 05:00:00', 'Scheduled', '', '2025-05-02 20:53:21'),
(54, 1, 9, '2025-05-04 18:05:00', 'Scheduled', 'rendez-vouz', '2025-05-04 16:59:15');

-- --------------------------------------------------------

--
-- Structure de la table `diagnoses`
--

CREATE TABLE `diagnoses` (
  `diagnosis_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `disease_name` varchar(100) NOT NULL,
  `notes` text DEFAULT NULL,
  `diagnosis_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `diagnoses`
--

INSERT INTO `diagnoses` (`diagnosis_id`, `patient_id`, `doctor_id`, `disease_name`, `notes`, `diagnosis_date`) VALUES
(1, 2, 1, 'Hypertension Stage 1', 'Elevated systolic pressure (135/90). Recommend lifestyle changes and monitoring.', '2025-04-17 09:00:00'),
(2, 3, 1, 'Normal', 'Blood pressure and BMI within normal range. No current issues.', '2025-04-18 09:00:00'),
(3, 8, 1, 'Normal', 'Stable vital signs and BMI. Routine check-up advised.', '2025-04-16 09:00:00'),
(4, 9, 1, 'Prehypertension', 'Systolic 125 and diastolic 85. Monitor regularly to prevent progression.', '2025-04-17 10:15:00'),
(5, 20, 1, 'Hypotension', 'Low systolic/diastolic readings (102/68). Patient advised hydration and follow-up.', '2025-04-28 09:00:00'),
(6, 22, 1, 'Normal', 'All readings within safe range. Continue regular health checks.', '2025-04-30 11:30:00'),
(7, 23, 1, 'Overweight', 'BMI over normal limits. Advised dietary management and exercise.', '2025-05-01 08:45:00'),
(8, 24, 1, 'Obesity Class 1', 'BMI indicates obesity. Recommend structured weight loss program.', '2025-04-02 14:00:00'),
(9, 25, 1, 'Pending Evaluation', 'First visit. Awaiting lab test results for full assessment.', '2025-04-03 16:15:00'),
(10, 38, 1, 'Hypertension Stage 2', 'Patient reported high blood pressure and headaches. Medication prescribed.', '2025-04-23 20:24:14'),
(11, 39, 1, 'Normal', 'Patient in good health. No concerns at this time.', '2025-04-23 20:26:41');

-- --------------------------------------------------------

--
-- Structure de la table `doctors`
--

CREATE TABLE `doctors` (
  `doctor_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL COMMENT 'Store bcrypt hashed passwords',
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `specialization` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `photo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `doctors`
--

INSERT INTO `doctors` (`doctor_id`, `username`, `password`, `full_name`, `email`, `specialization`, `created_at`, `photo`) VALUES
(1, 'admin1', '$2y$12$F.L5KgSfrtiQvG7w2I6AOuSwtrVk/mTTiCI/eO2W0C5RElTx2f/Ju', 'Dr. Fatima zahra Bouzhar', 'FBouzhar@hospital.com', 'Cardiology', '2025-04-08 14:02:46', 'images/dr.avif'),
(2, 'admin2', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Dr. John Doe', 'john@hospital.com', 'Neurology', '2025-04-08 14:02:46', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `patients`
--

CREATE TABLE `patients` (
  `patient_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `registered_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `doctor_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `systolic` int(11) DEFAULT NULL COMMENT 'Normal range: 90-120',
  `diastolic` int(11) DEFAULT NULL COMMENT 'Normal range: 60-80',
  `weight_kg` decimal(5,2) DEFAULT NULL,
  `height_cm` decimal(5,2) DEFAULT NULL,
  `bmi` decimal(5,2) GENERATED ALWAYS AS (`weight_kg` / pow(`height_cm` / 100,2)) STORED COMMENT 'BMI formula: kg/m²',
  `cne` varchar(255) DEFAULT NULL,
  `adress` text DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `patients`
--

INSERT INTO `patients` (`patient_id`, `first_name`, `last_name`, `gender`, `contact_number`, `registered_at`, `doctor_id`, `created_at`, `systolic`, `diastolic`, `weight_kg`, `height_cm`, `cne`, `adress`, `date_of_birth`) VALUES
(2, 'Bob', 'Williams', 'Male', '+1987654321', '2025-04-08 13:53:09', 1, '2025-04-16 23:00:00', 135, 90, 82.00, 178.00, 'AO8015', 'zohor Atlas Marrakech', '1999-01-20'),
(3, 'Charlie', 'Brown', 'Male', '+1122334466', '2025-04-08 13:53:09', 1, '2025-04-17 23:00:00', 118, 78, 59.00, 160.00, 'BO1789', '452, medina Marrakech', '1990-05-10'),
(8, 'Fatima', 'Zahraoui', 'Female', '+212612345678', '2025-04-08 14:00:00', 1, '2025-04-16 09:00:00', 110, 75, 62.50, 162.00, 'AZ123456', '10 Rue Al Massira, Marrakech', '1992-03-15'),
(9, 'Ahmed', 'Bebali', 'Male', '+212698765432', '2025-04-08 14:05:00', 1, '2025-04-17 10:15:00', 125, 85, 78.00, 175.00, 'BX78910', 'Appartement 3, Avenue Hassan II, Casablanca', '1988-11-20'),
(20, 'Soukaina', 'Ouahabi', 'Female', '+212799001122', '2025-04-08 15:00:00', 1, '2025-04-28 09:00:00', 102, 68, 52.00, 152.00, 'MF456789', 'Villa 5, Quartier Sidi Youssef, Marrakech', '1997-11-30'),
(22, 'Zineb', 'Ramdani', 'Female', '+212700112233', '2025-04-08 15:10:00', 1, '2025-04-30 11:30:00', 116, 77, 66.00, 166.00, 'OH678901', '39 Rue des Iris, Rabat', '1991-08-15'),
(23, 'Hassan', 'Sefrioui', 'Male', '+212644556677', '2025-04-08 15:15:00', 1, '2025-05-01 08:45:00', 126, 86, 75.00, 173.00, 'PI234567', 'Immeuble 8, Rue de Fès, Marrakech', '1989-05-10'),
(24, 'Amina', 'Taoufik', 'Female', '+212711223344', '2025-04-08 15:20:00', 1, '2025-05-02 13:00:00', 100, 65, 50.00, 150.00, 'QJ890123', '25 Avenue de la Paix, Casablanca', '1996-01-25'),
(25, 'Imad', 'Uahmed', 'Male', '+212655667788', '2025-04-08 15:25:00', 1, '2025-05-03 15:15:00', 138, 98, 95.00, 188.00, 'RK456789', '42 Rue des Oliviers, Rabat', '1983-09-01'),
(26, 'Salma', 'Vakili', 'Female', '+212722334455', '2025-04-08 15:30:00', 1, '2025-05-04 09:30:00', 114, 77, 63.00, 163.00, 'SL012345', 'Villa 10, Quartier Les Iris, Marrakech', '1992-04-20'),
(27, 'Yassine', 'Ziani', 'Male', '+212666778899', '2025-04-08 15:35:00', 1, '2025-05-05 10:45:00', 124, 84, 79.00, 176.00, 'TM678901', '19 Avenue Yacoub El Mansour, Casablanca', '1988-12-05'),
(38, 'youssef', 'sakhi', 'Male', '0612789562', '2025-04-23 20:24:14', 1, '2025-04-23 20:24:14', 89, 90, 79.00, 188.00, 'EA1973', 'hay sallam,Knitera', '2004-12-08'),
(39, 'khadija', 'zekraoui', 'Female', '06478596', '2025-04-23 20:26:41', 1, '2025-04-23 20:26:41', 112, 85, 83.00, 170.00, 'Hk4578', 'mhamid 5,Marrakech', '2003-01-14');

-- --------------------------------------------------------

--
-- Structure de la table `treatments`
--

CREATE TABLE `treatments` (
  `treatment_id` int(11) NOT NULL,
  `diagnosis_id` int(11) NOT NULL,
  `prescription` text NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('Active','Completed','Cancelled') DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `treatments`
--

INSERT INTO `treatments` (`treatment_id`, `diagnosis_id`, `prescription`, `start_date`, `end_date`, `status`) VALUES
(1, 1, 'Lisinopril 10mg daily. Low-sodium diet. 30 min daily exercise.', '2025-04-17', '2025-07-17', 'Active'),
(2, 2, 'No medication. Routine check-up in 6 months.', '2025-04-18', '2025-10-18', 'Active'),
(3, 3, 'No prescription. Seasonal flu vaccination recommended.', '2025-04-16', '2025-10-16', 'Active'),
(4, 4, 'No medication. Stress management and regular exercise.', '2025-04-17', '2025-07-17', 'Active'),
(5, 5, 'Fludrocortisone 0.1mg daily if symptoms persist. Increase fluid intake.', '2025-04-28', '2025-05-28', 'Active'),
(6, 6, 'No treatment required.', '2025-04-30', NULL, 'Completed'),
(7, 7, 'Low-calorie diet. Exercise 5x/week. Monitor BMI.', '2025-05-01', '2025-08-01', 'Active'),
(8, 8, 'Orlistat 120mg if needed. Refer to dietician. Start weight loss program.', '2025-04-02', '2025-07-02', 'Active'),
(9, 9, 'Lifestyle advice provided. Await lab results.', '2025-04-03', '2025-04-17', 'Completed'),
(10, 10, 'Amlodipine 5mg daily. Reduce salt and caffeine. Paracetamol for headaches.', '2025-04-23', '2025-07-23', 'Active'),
(11, 11, 'No medication. General wellness advice. Annual check-up suggested.', '2025-04-23', '2026-04-23', 'Active');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_appointments_doctor` (`doctor_id`),
  ADD KEY `appointments_ibfk_2` (`patient_id`);

--
-- Index pour la table `diagnoses`
--
ALTER TABLE `diagnoses`
  ADD PRIMARY KEY (`diagnosis_id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `doctor_id` (`doctor_id`);

--
-- Index pour la table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`doctor_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Index pour la table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`patient_id`),
  ADD KEY `idx_patients_doctor` (`doctor_id`);

--
-- Index pour la table `treatments`
--
ALTER TABLE `treatments`
  ADD PRIMARY KEY (`treatment_id`),
  ADD KEY `diagnosis_id` (`diagnosis_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT pour la table `diagnoses`
--
ALTER TABLE `diagnoses`
  MODIFY `diagnosis_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `doctor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `patients`
--
ALTER TABLE `patients`
  MODIFY `patient_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT pour la table `treatments`
--
ALTER TABLE `treatments`
  MODIFY `treatment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`),
  ADD CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `diagnoses`
--
ALTER TABLE `diagnoses`
  ADD CONSTRAINT `diagnoses_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `diagnoses_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`);

--
-- Contraintes pour la table `patients`
--
ALTER TABLE `patients`
  ADD CONSTRAINT `patients_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`);

--
-- Contraintes pour la table `treatments`
--
ALTER TABLE `treatments`
  ADD CONSTRAINT `treatments_ibfk_1` FOREIGN KEY (`diagnosis_id`) REFERENCES `diagnoses` (`diagnosis_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
