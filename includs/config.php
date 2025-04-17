<?php
// Database credentials
$host = 'localhost';      // MySQL server (usually 'localhost' in XAMPP/WAMP)
$db   = 'medical_db';     // Your database name
$user = 'root';           // Default MySQL username in XAMPP/WAMP
$pass = '';               // Default password (empty in XAMPP/WAMP)
$charset = 'utf8mb4';     // Supports special characters/emojis

// Data Source Name (DSN) for PDO
$dsn = "mysql:host=$host;dbname=$db;charset=$charset";

// PDO connection options
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION, // Throw errors if SQL fails
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_OBJ,          // Return objects (not arrays)
    PDO::ATTR_EMULATE_PREPARES   => false,                  // Use real prepared statements
];

try {
    // Create the PDO connection object
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (PDOException $e) {
    // If connection fails, show error (don't expose details in production!)
    throw new PDOException("Database connection failed: " . $e->getMessage());
}
