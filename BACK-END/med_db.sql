-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mar. 29 avr. 2025 à 13:07
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
-- Base de données : `maladies`
--
CREATE DATABASE IF NOT EXISTS `maladies` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `maladies`;

-- --------------------------------------------------------

--
-- Structure de la table `patients`
--

CREATE TABLE `patients` (
  `cne` varchar(20) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `date_naissance` date NOT NULL,
  `sexe` enum('Homme','Femme') NOT NULL,
  `adresse` varchar(100) DEFAULT NULL,
  `telephone` varchar(15) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `patients`
--

INSERT INTO `patients` (`cne`, `nom`, `prenom`, `date_naissance`, `sexe`, `adresse`, `telephone`, `user_id`) VALUES
('E234442', 'ilyass', 'ahmimi', '2004-03-21', 'Homme', 'rue mhamid 9', '047383932', 26),
('ED4000', 'Larbi', 'Larbi', '1977-01-01', 'Homme', 'jmaa lfna', '', 37),
('EE171717', 'badr', 'rafia', '2005-01-09', 'Femme', 'mhamid 7', '3456789', 32),
('EE178233', 'mohamed', 'jalim', '1989-09-01', 'Homme', 'askejour lot haha', '0639415941', 36),
('EE200', 'saadia', 'lok', '1992-03-13', 'Femme', 'inknow', '222222222', 35),
('EE202020', 'anass', 'awida', '2002-06-05', 'Homme', 'takotat mrrakech', '0765432567', 31),
('EE23456', 'bouzhar', 'kawtar', '2025-04-09', 'Femme', '', '', 38),
('EE238754E', 'ayoub', 'amara', '2001-02-28', 'Homme', 'mhamid 9', '454768', 28),
('EE24242', 'badr', 'badr', '2006-03-28', 'Homme', 'rue massira', '65377986', 27),
('EE40234', 'abdo', 'abdo', '2012-02-01', 'Homme', 'mhamid', '456789', 30),
('EE73263', 'mohamad', 'sendopi', '2002-11-01', 'Homme', 'Rue lwidan', '063819372', 25),
('EEH34H4', 'habiba', 'homaiti', '2006-01-12', 'Femme', 'Rue massria', '0653929347', 23);

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('patient','doctor') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `role`) VALUES
(21, 'mohamad@gmail.com', '$2y$10$v/Rqif6NAa5N3IVjyV3/FOqPfeAcGIt1Tp.cMMS5/pSShZXrIi54e', 'doctor'),
(23, 'habiba@gmail.com', '$2y$10$3K1eJlCkt2THd.rOuAzn1u0hAshhAygq/0CyvqFon1rQt2S3ioS7K', 'patient'),
(25, 'sendopi@gmail.com', '$2y$10$2rLBpkCZDBEeYR09iEqVj.iRkR.5vwkwLQYHQjPTwmSzGo98QDrTC', 'patient'),
(26, 'iyass@gmail.com', '$2y$10$/rbnOtqQ80VEw8.FcQih5OYz/Nd5f.AEOisj.qNgpRgJ3FqJvGwou', 'patient'),
(27, 'badr@gmail.com', '$2y$10$8m5b31tLP6bQhxb8r98xx.Fxg1gtJTORDtFkRaDpRbddqmaSA1OH.', 'patient'),
(28, 'ayoub@gmail.com', '$2y$10$/ReHRvOdvLOKtAH5uMZHuOdu8zCEbNgp0pluAl/FB3fln6beigRYS', 'patient'),
(30, 'abdo@gmail.com', '$2y$10$6nj55EwV7ZaS/GOTNmxE4uYBZmBXlV8MekBE4I5P34F3l3sN9DhO2', 'patient'),
(31, 'anass@gmail.com', '$2y$10$cR8aSRf.taePL610PekKQuAJ9gA.r18TED4xXDaUVmhUTgTGcae6y', 'patient'),
(32, 'rafia@gmail.com', '$2y$10$P0883oGCiUqzXaP.NBdHW.tjo/vD3Skn/MqyVl4XBdFwQoGpR8wsq', 'patient'),
(33, 'lamin@gmail.com', '$2y$10$3hXvvE1mdmwPgl9CzsinVuq/3ab8FJXyrCHRAV1SZGLe2.X1oNjyi', 'patient'),
(34, 'mohamadjalim05@gmail.com', '$2y$10$zjwk7Sci/s1a8QYeJTlOku2y7XW4Gtdm/b9IHHW.e8LCZUhwSy.eK', 'patient'),
(35, 'saadialok@gmail.Com', '$2y$10$TD3fESndGIOeBbyeBedy5erLw3oYm.iSj4IUlj8HYdFBtbnuinyq2', 'patient'),
(36, 'mohamadjalim50@gmail.com', '$2y$10$Hbv3A4PTsOffKhY741kFmO1Sn7oIbfXDYLSCO3pfOxR/ydOkhSZvS', 'patient'),
(37, 'Larbi@gmail.com', '$2y$10$ZGarMq7TGq6H9r32qw/LLedYnQMRURhyOTjp8ymCvm/8pkmuhLvrK', 'patient'),
(38, 'kawtar@gmail.com', '$2y$10$0/vmFex4tYGk5J3rFh0qEujVyv2rdJ.HapDDCZtKT2k/yx9og6lLe', 'patient');

-- --------------------------------------------------------

--
-- Structure de la table `visits`
--

CREATE TABLE `visits` (
  `visit_id` int(11) NOT NULL,
  `cne` varchar(20) DEFAULT NULL,
  `date_visite` date NOT NULL,
  `symptomes` text NOT NULL,
  `diagnostic` text NOT NULL,
  `traitement` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`cne`),
  ADD UNIQUE KEY `unique_user_id` (`user_id`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Index pour la table `visits`
--
ALTER TABLE `visits`
  ADD PRIMARY KEY (`visit_id`),
  ADD KEY `cne` (`cne`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `visits`
--
ALTER TABLE `visits`
  MODIFY `visit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `patients`
--
ALTER TABLE `patients`
  ADD CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `visits`
--
ALTER TABLE `visits`
  ADD CONSTRAINT `visits_ibfk_1` FOREIGN KEY (`cne`) REFERENCES `patients` (`cne`) ON DELETE CASCADE;
--
-- Base de données : `medical_db`
--
CREATE DATABASE IF NOT EXISTS `medical_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `medical_db`;

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
(52, 1, 9, '2025-04-27 18:00:00', 'Scheduled', '', '2025-04-27 16:05:53');

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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `doctors`
--

INSERT INTO `doctors` (`doctor_id`, `username`, `password`, `full_name`, `email`, `specialization`, `created_at`) VALUES
(1, 'admin1', '$2y$12$F.L5KgSfrtiQvG7w2I6AOuSwtrVk/mTTiCI/eO2W0C5RElTx2f/Ju', 'Dr. Fatima zahra Bouzhar', 'FBouzhar@hospital.com', 'Cardiology', '2025-04-08 14:02:46'),
(2, 'admin2', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Dr. John Doe', 'john@hospital.com', 'Neurology', '2025-04-08 14:02:46');

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
(39, 'khadija', 'zekraoui', 'Female', '06478596', '2025-04-23 20:26:41', 1, '2025-04-23 20:26:41', 112, 85, 83.00, 170.00, 'Hk4578', 'mhamid 5,Marrakech', '2003-01-14'),
(43, 'lalala', 'coyaya', 'Female', '06457812', '2025-04-27 09:58:05', 1, '2025-04-27 09:58:05', 110, 75, 64.00, 164.00, 'JS47856', 'n° 1236 Bouakaz, Marrakech  ', '1999-03-17');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `diagnoses`
--
ALTER TABLE `diagnoses`
  MODIFY `diagnosis_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `doctor_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `patients`
--
ALTER TABLE `patients`
  MODIFY `patient_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `treatments`
--
ALTER TABLE `treatments`
  MODIFY `treatment_id` int(11) NOT NULL AUTO_INCREMENT;

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
--
-- Base de données : `phpmyadmin`
--
CREATE DATABASE IF NOT EXISTS `phpmyadmin` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `phpmyadmin`;

-- --------------------------------------------------------

--
-- Structure de la table `pma__bookmark`
--

CREATE TABLE `pma__bookmark` (
  `id` int(10) UNSIGNED NOT NULL,
  `dbase` varchar(255) NOT NULL DEFAULT '',
  `user` varchar(255) NOT NULL DEFAULT '',
  `label` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `query` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Bookmarks';

-- --------------------------------------------------------

--
-- Structure de la table `pma__central_columns`
--

CREATE TABLE `pma__central_columns` (
  `db_name` varchar(64) NOT NULL,
  `col_name` varchar(64) NOT NULL,
  `col_type` varchar(64) NOT NULL,
  `col_length` text DEFAULT NULL,
  `col_collation` varchar(64) NOT NULL,
  `col_isNull` tinyint(1) NOT NULL,
  `col_extra` varchar(255) DEFAULT '',
  `col_default` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Central list of columns';

-- --------------------------------------------------------

--
-- Structure de la table `pma__column_info`
--

CREATE TABLE `pma__column_info` (
  `id` int(5) UNSIGNED NOT NULL,
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `column_name` varchar(64) NOT NULL DEFAULT '',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `mimetype` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `transformation` varchar(255) NOT NULL DEFAULT '',
  `transformation_options` varchar(255) NOT NULL DEFAULT '',
  `input_transformation` varchar(255) NOT NULL DEFAULT '',
  `input_transformation_options` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Structure de la table `pma__designer_settings`
--

CREATE TABLE `pma__designer_settings` (
  `username` varchar(64) NOT NULL,
  `settings_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Settings related to Designer';

-- --------------------------------------------------------

--
-- Structure de la table `pma__export_templates`
--

CREATE TABLE `pma__export_templates` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL,
  `export_type` varchar(10) NOT NULL,
  `template_name` varchar(64) NOT NULL,
  `template_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved export templates';

-- --------------------------------------------------------

--
-- Structure de la table `pma__favorite`
--

CREATE TABLE `pma__favorite` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Favorite tables';

-- --------------------------------------------------------

--
-- Structure de la table `pma__history`
--

CREATE TABLE `pma__history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db` varchar(64) NOT NULL DEFAULT '',
  `table` varchar(64) NOT NULL DEFAULT '',
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp(),
  `sqlquery` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='SQL history for phpMyAdmin';

-- --------------------------------------------------------

--
-- Structure de la table `pma__navigationhiding`
--

CREATE TABLE `pma__navigationhiding` (
  `username` varchar(64) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `item_type` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Hidden items of navigation tree';

-- --------------------------------------------------------

--
-- Structure de la table `pma__pdf_pages`
--

CREATE TABLE `pma__pdf_pages` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `page_nr` int(10) UNSIGNED NOT NULL,
  `page_descr` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='PDF relation pages for phpMyAdmin';

-- --------------------------------------------------------

--
-- Structure de la table `pma__recent`
--

CREATE TABLE `pma__recent` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Recently accessed tables';

-- --------------------------------------------------------

--
-- Structure de la table `pma__relation`
--

CREATE TABLE `pma__relation` (
  `master_db` varchar(64) NOT NULL DEFAULT '',
  `master_table` varchar(64) NOT NULL DEFAULT '',
  `master_field` varchar(64) NOT NULL DEFAULT '',
  `foreign_db` varchar(64) NOT NULL DEFAULT '',
  `foreign_table` varchar(64) NOT NULL DEFAULT '',
  `foreign_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Relation table';

-- --------------------------------------------------------

--
-- Structure de la table `pma__savedsearches`
--

CREATE TABLE `pma__savedsearches` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `search_name` varchar(64) NOT NULL DEFAULT '',
  `search_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved searches';

-- --------------------------------------------------------

--
-- Structure de la table `pma__table_coords`
--

CREATE TABLE `pma__table_coords` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `pdf_page_number` int(11) NOT NULL DEFAULT 0,
  `x` float UNSIGNED NOT NULL DEFAULT 0,
  `y` float UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table coordinates for phpMyAdmin PDF output';

-- --------------------------------------------------------

--
-- Structure de la table `pma__table_info`
--

CREATE TABLE `pma__table_info` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `display_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Structure de la table `pma__table_uiprefs`
--

CREATE TABLE `pma__table_uiprefs` (
  `username` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `prefs` text NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Tables'' UI preferences';

-- --------------------------------------------------------

--
-- Structure de la table `pma__tracking`
--

CREATE TABLE `pma__tracking` (
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `version` int(10) UNSIGNED NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` datetime NOT NULL,
  `schema_snapshot` text NOT NULL,
  `schema_sql` text DEFAULT NULL,
  `data_sql` longtext DEFAULT NULL,
  `tracking` set('UPDATE','REPLACE','INSERT','DELETE','TRUNCATE','CREATE DATABASE','ALTER DATABASE','DROP DATABASE','CREATE TABLE','ALTER TABLE','RENAME TABLE','DROP TABLE','CREATE INDEX','DROP INDEX','CREATE VIEW','ALTER VIEW','DROP VIEW') DEFAULT NULL,
  `tracking_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Database changes tracking for phpMyAdmin';

-- --------------------------------------------------------

--
-- Structure de la table `pma__userconfig`
--

CREATE TABLE `pma__userconfig` (
  `username` varchar(64) NOT NULL,
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `config_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User preferences storage for phpMyAdmin';

--
-- Déchargement des données de la table `pma__userconfig`
--

INSERT INTO `pma__userconfig` (`username`, `timevalue`, `config_data`) VALUES
('root', '2019-10-21 13:37:09', '{\"Console\\/Mode\":\"collapse\"}');

-- --------------------------------------------------------

--
-- Structure de la table `pma__usergroups`
--

CREATE TABLE `pma__usergroups` (
  `usergroup` varchar(64) NOT NULL,
  `tab` varchar(64) NOT NULL,
  `allowed` enum('Y','N') NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User groups with configured menu items';

-- --------------------------------------------------------

--
-- Structure de la table `pma__users`
--

CREATE TABLE `pma__users` (
  `username` varchar(64) NOT NULL,
  `usergroup` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Users and their assignments to user groups';

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `pma__central_columns`
--
ALTER TABLE `pma__central_columns`
  ADD PRIMARY KEY (`db_name`,`col_name`);

--
-- Index pour la table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`);

--
-- Index pour la table `pma__designer_settings`
--
ALTER TABLE `pma__designer_settings`
  ADD PRIMARY KEY (`username`);

--
-- Index pour la table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_user_type_template` (`username`,`export_type`,`template_name`);

--
-- Index pour la table `pma__favorite`
--
ALTER TABLE `pma__favorite`
  ADD PRIMARY KEY (`username`);

--
-- Index pour la table `pma__history`
--
ALTER TABLE `pma__history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`,`db`,`table`,`timevalue`);

--
-- Index pour la table `pma__navigationhiding`
--
ALTER TABLE `pma__navigationhiding`
  ADD PRIMARY KEY (`username`,`item_name`,`item_type`,`db_name`,`table_name`);

--
-- Index pour la table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  ADD PRIMARY KEY (`page_nr`),
  ADD KEY `db_name` (`db_name`);

--
-- Index pour la table `pma__recent`
--
ALTER TABLE `pma__recent`
  ADD PRIMARY KEY (`username`);

--
-- Index pour la table `pma__relation`
--
ALTER TABLE `pma__relation`
  ADD PRIMARY KEY (`master_db`,`master_table`,`master_field`),
  ADD KEY `foreign_field` (`foreign_db`,`foreign_table`);

--
-- Index pour la table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_savedsearches_username_dbname` (`username`,`db_name`,`search_name`);

--
-- Index pour la table `pma__table_coords`
--
ALTER TABLE `pma__table_coords`
  ADD PRIMARY KEY (`db_name`,`table_name`,`pdf_page_number`);

--
-- Index pour la table `pma__table_info`
--
ALTER TABLE `pma__table_info`
  ADD PRIMARY KEY (`db_name`,`table_name`);

--
-- Index pour la table `pma__table_uiprefs`
--
ALTER TABLE `pma__table_uiprefs`
  ADD PRIMARY KEY (`username`,`db_name`,`table_name`);

--
-- Index pour la table `pma__tracking`
--
ALTER TABLE `pma__tracking`
  ADD PRIMARY KEY (`db_name`,`table_name`,`version`);

--
-- Index pour la table `pma__userconfig`
--
ALTER TABLE `pma__userconfig`
  ADD PRIMARY KEY (`username`);

--
-- Index pour la table `pma__usergroups`
--
ALTER TABLE `pma__usergroups`
  ADD PRIMARY KEY (`usergroup`,`tab`,`allowed`);

--
-- Index pour la table `pma__users`
--
ALTER TABLE `pma__users`
  ADD PRIMARY KEY (`username`,`usergroup`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `pma__history`
--
ALTER TABLE `pma__history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  MODIFY `page_nr` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Base de données : `test`
--
CREATE DATABASE IF NOT EXISTS `test` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `test`;
--
-- Base de données : `testdb`
--
CREATE DATABASE IF NOT EXISTS `testdb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `testdb`;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
