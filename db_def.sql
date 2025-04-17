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