<?php
session_start();
require_once __DIR__ . '/config.php';

function isLoggedIn()
{
    return isset($_SESSION['doctor_id']);
}

function generateCsrfToken()
{
    if (!isset($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

function validateCsrfToken($token)
{
    return isset($_SESSION['csrf_token']) && hash_equals($_SESSION['csrf_token'], $token);
}

// FIXED ERROR REDIRECTION
function redirectWithError($error, $email = '')
{
    $_SESSION['login_error'] = $error;
    $_SESSION['old_email'] = $email;
    header("Location: ../login_page.php"); // Changed path
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'login') {
    if (!isset($_POST['csrf_token']) || !validateCsrfToken($_POST['csrf_token'])) {
        redirectWithError("Security validation failed.");
    }

    $email = trim($_POST['Gmail']);
    $password = $_POST['password'];

    if (empty($email) || empty($password)) {
        redirectWithError("Email and password are required.", $email);
    }

    try {
        $stmt = $pdo->prepare("SELECT * FROM doctors WHERE email = :email");
        $stmt->execute(['email' => $email]);
        $doctor = $stmt->fetch(PDO::FETCH_OBJ);
        

        if ($doctor && password_verify($password, $doctor->password)) {
            $_SESSION['username'] = $doctor->username;
            $_SESSION['full_name'] = $doctor->full_name;
            $_SESSION['doctor_id'] = $doctor->doctor_id;
            session_regenerate_id(true);

            unset($_SESSION['login_error'], $_SESSION['old_email']);
            header("Location: /PHPprog/MALADY/Platform/dashboard.php");
            exit();
        } else {
            error_log("Failed login attempt for: $email");
            redirectWithError("Invalid email or password.", $email);
        }
    } catch (PDOException $e) {
        error_log("DB Error: " . $e->getMessage());
        redirectWithError("System temporarily unavailable. Try later.");
    }
}
if (isset($_GET['action']) && $_GET['action'] === 'logout') {
    // Verify CSRF token
    if (isset($_GET['csrf_token']) && validateCsrfToken($_GET['csrf_token'])) {
        // Unset all session variables
        $_SESSION = [];

        // Destroy the session
        session_destroy();

        // Redirect to the homepage
        header("Location: ../login_page.php"); // Adjust the path to your homepage
        exit();
    } else {
        // Invalid CSRF token, handle the error (e.g., display a message)
        $_SESSION['errorMessage'] = "Invalid security token.";
        header("Location: dashboard.php"); // Or wherever you want to redirect on error
        exit();
    }
}
