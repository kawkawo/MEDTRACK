<?php
require_once __DIR__ . '/includs/auth.php';
// Start session (if not already started in auth.php)
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Get error message and old email from session
$error = $_SESSION['login_error'] ?? '';
$old_email = $_SESSION['old_email'] ?? '';

// Clear errors after displaying them
unset($_SESSION['login_error'], $_SESSION['old_email']);
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" sizes="16x16" href="icon_web.ico">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="assets/style.css">
    <link rel="stylesheet" href="assets/login_style.css">
    <title>Login page</title>
    <style>
        .error-message {
            color: #ff4444;
            background: rgba(255, 68, 68, 0.1);
            padding: 10px 15px;
            border-radius: 8px;
            margin: 15px 0;
            border: 1px solid rgba(255, 68, 68, 0.3);
            text-align: center;
        }
    </style>
</head>

<body>



    <div class="wrapper">
        <nav class="nav">
            <div class="nav-logo">
                <p>MEDTRACK</p>
            </div>
            <div class="nav-menu">
                <ul>
                    <li><a href="principale.html" class="link ">Home</a></li>
                    <li><a href="services.html" class="link">Services</a></li>
                    <li><a href="About.html" class="link">About</a></li>
                </ul>
            </div>
            <form action="login_page.php" method="post">
                <div class="nav-button">
                    <button class="btn" id="loginBtn">Log In</button>
                </div>
            </form>
            <div class="nav-menu-btn">
                <i class='bx bx-menu'></i>

            </div>

        </nav>
        <div class="form-box">
            <! -----------login form ------->
                <div class="login-container" id="log">
                    <div class="top">
                        <!--<span>don't have an account?<a href="#" onclick="register()">Login</a> </span>-->
                        <header>Sign In</header>
                    </div>
                    <!-- Error Message Display -->
                    <?php if (!empty($error)): ?>
                        <div class="error-message">
                            <?php echo htmlspecialchars($error); ?>
                        </div>
                    <?php endif; ?>

                    <form class="loginform" method="post" action="includs/auth.php">
                        <input type="hidden" name="action" value="login">
                        <input type="hidden" name="csrf_token" value="<?php echo generateCsrfToken(); ?>">

                        <div class="loginform">
                            <div class="input-box">
                                <input type="text" class="input-field" name="Gmail" placeholder="Enter your Email" value="<?php echo htmlspecialchars($old_email); ?>"
                                    required>
                                <i class='bx bxl-gmail'></i>
                            </div>
                            <div class="input-box">
                                <input type="password" class="input-field" name="password" placeholder="Enter your Password" required>
                                <i class='bx bx-lock-alt'></i>
                            </div>
                            <div class="input-box">
                                <input type="submit" class="submit" value="Log in">
                            </div>
                            <div class="two-col">
                                <div class="one">
                                    <input type="checkbox" id="register-check">
                                    <label for="register-check"> Remember Me</label>
                                </div>
                                <div class="two">
                                    <label>
                                        <a href='#'>Terms & Conditions</a>
                                    </label>
                                </div>
                            </div>
                        </div>

                </div>


        </div>
    </div>

    </div>
</body>

</html>