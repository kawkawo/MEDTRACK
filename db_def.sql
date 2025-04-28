-- Create the database
CREATE DATABASE IF NOT EXISTS medical_db;
USE medical_db;
-- Table 1: Doctors (Admin Users)
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL COMMENT 'Store bcrypt hashed passwords',
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    specialization VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Table 2: Patients (Minimal fields for admin management)
CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    age INT CHECK (age > 0),
    gender ENUM('Male', 'Female', 'Other'),
    contact_number VARCHAR(20),
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Table 3: Diagnoses (Core admin functionality)
CREATE TABLE diagnoses (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    disease_name VARCHAR(100) NOT NULL,
    notes TEXT,
    diagnosis_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);
-- Table 4: Treatments (Prescribed by admin)
CREATE TABLE treatments (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    diagnosis_id INT NOT NULL,
    prescription TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status ENUM('Active', 'Completed', 'Cancelled') DEFAULT 'Active',
    FOREIGN KEY (diagnosis_id) REFERENCES diagnoses(diagnosis_id) ON DELETE CASCADE
);


-- Add doctor_id column to patients table
ALTER TABLE patients
ADD COLUMN doctor_id INT NOT NULL,
ADD FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id);



-- modify the comumn created att that i add manually by myphpadmin
ALTER TABLE patients
MODIFY COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP; 



-- Insert Doctors (Admins)
INSERT INTO doctors (
        username,
        password,
        full_name,
        email,
        specialization
    )
VALUES (
        'admin1',
        '$2y$12$F.L5KgSfrtiQvG7w2I6AOuSwtrVk/mTTiCI/eO2W0C5RElTx2f/Ju',
        'Dr. Fatima zahra Bouzhar',
        'FBouzhar@hospital.com',
        'Cardiology'
    ),
    (
        'admin2',
        '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'Dr. John Doe',
        'john@hospital.com',
        'Neurology'
    );
-- Insert Patients (For doctors to manage)
INSERT INTO patients (
        first_name,
        last_name,
        age,
        gender,
        contact_number
    )
VALUES ('Alice', 'Johnson', 32, 'Female', '+1234567890'),
    ('Bob', 'Williams', 45, 'Male', '+1987654321'),
    ('Charlie', 'Brown', 28, 'Other', '+1122334455');
-- Insert Diagnoses (Made by doctors)
INSERT INTO diagnoses (patient_id, doctor_id, disease_name, notes)
VALUES (
        1,
        1,
        'Hypertension',
        'Patient has stage 1 hypertension. Recommended lifestyle changes.'
    ),
    (
        2,
        2,
        'Migraine',
        'Chronic migraines with aura. Prescribed pain management.'
    );
-- Insert Treatments (Prescribed by doctors)
INSERT INTO treatments (
        diagnosis_id,
        prescription,
        start_date,
        end_date,
        status
    )
VALUES (
        1,
        'Lisinopril 10mg daily',
        '2024-01-15',
        '2024-07-15',
        'Active'
    ),
    (
        2,
        'Sumatriptan 50mg as needed',
        '2024-02-01',
        NULL,
        'Active'
    );

-- j'ajoute ces colomuns pour que je trouve de paramétre utiles poue les visualisations
-- Add blood pressure metrics
ALTER TABLE patients
ADD systolic INT COMMENT 'Normal range: 90-120',
ADD diastolic INT COMMENT 'Normal range: 60-80';

-- Add body metrics
ALTER TABLE patients
ADD weight_kg DECIMAL(5,2),
ADD height_cm DECIMAL(5,2);

-- Add calculated BMI (automatically updates)
ALTER TABLE patients
ADD bmi DECIMAL(5,2) 
    GENERATED ALWAYS AS (weight_kg/POW(height_cm/100,2)) 
    STORED COMMENT 'BMI formula: kg/m²';


ALTER TABLE patients
ADD COLUMN cne VARCHAR(255); -- Adjust VARCHAR length as needed
ALTER TABLE patients
ADD COLUMN adress TEXT; -- Use TEXT for potentially longer addresses
ALTER TABLE patients
ADD COLUMN date_of_birth DATE;
ALTER TABLE patients
DROP COLUMN age;

UPDATE patients SET 
   cne = 'AO4578',
   adress = '14, asfi babloun',
   date_of_birth = '1990-05-10'
WHERE patient_id = 1;
 
UPDATE patients SET 
   cne = 'AO8015',
   adress = 'zohor Atlas Marrakech',
   date_of_birth = '1999-01-20'
WHERE patient_id = 2;
 
UPDATE patients SET 
   cne = 'BO1789',
   adress = '452, medina Marrakech',
   date_of_birth = '1990-05-10'
WHERE patient_id = 3;


UPDATE patients SET
    systolic = 120,
    diastolic = 80,
    weight_kg = 68.5,
    height_cm = 165
WHERE patient_id = 1;

UPDATE patients SET
    systolic = 135,
    diastolic = 90,
    weight_kg = 82.0,
    height_cm = 178
WHERE patient_id = 2;

UPDATE patients SET
    systolic = 118,
    diastolic = 78,
    weight_kg = 59.0,
    height_cm = 160
WHERE patient_id = 3;







-- Appointments Table
CREATE TABLE IF NOT EXISTS appointments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Canceled'),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


ALTER TABLE appointments
ADD CONSTRAINT unique_patient_date UNIQUE (patient_id, DATE(appointment_date));

-- Indexes for faster queries
CREATE INDEX idx_patients_doctor ON patients(doctor_id);
CREATE INDEX idx_appointments_doctor ON appointments(doctor_id);
CREATE INDEX idx_reports_doctor ON reports(doctor_id);



INSERT INTO appointments (doctor_id, patient_id, appointment_date, status, notes)
VALUES 
(1, 1, '2025-04-16 00:00:00', 'Scheduled', NULL),
(1, 2, '2025-04-17 00:00:00', 'Scheduled', NULL),
(1, 3, '2025-04-18 00:00:00', 'Scheduled', NULL),
(1, 8, '2025-04-16 10:00:00', 'Scheduled', NULL),
(1, 9, '2025-04-17 11:15:00', 'Scheduled', NULL),
(1, 20, '2025-04-28 10:00:00', 'Scheduled', NULL),
(1, 22, '2025-04-30 12:30:00', 'Scheduled', NULL),
(1, 23, '2025-05-01 09:45:00', 'Scheduled', NULL),
(1, 24, '2025-05-02 14:00:00', 'Scheduled', NULL),
(1, 25, '2025-05-03 16:15:00', 'Scheduled', NULL),
(1, 26, '2025-05-04 10:30:00', 'Scheduled', NULL),
(1, 27, '2025-05-05 11:45:00', 'Scheduled', NULL),
(1, 34, '2025-04-23 18:08:54', 'Scheduled', NULL),
(1, 35, '2025-04-23 18:13:23', 'Scheduled', NULL),
(1, 37, '2025-04-23 20:14:31', 'Scheduled', NULL),
(1, 38, '2025-04-23 21:24:14', 'Scheduled', NULL),
(1, 39, '2025-04-23 21:26:41', 'Scheduled', NULL);

ALTER TABLE appointments 
DROP FOREIGN KEY appointments_ibfk_2;

ALTER TABLE appointments 
ADD CONSTRAINT appointments_ibfk_2 
FOREIGN KEY (patient_id) REFERENCES patients(patient_id) 
ON DELETE CASCADE;