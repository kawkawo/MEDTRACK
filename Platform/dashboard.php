<?php
// Start session and check authentication
require_once __DIR__ . '/../includs/auth.php'; // Adjust path as needed
/*
if (!isLoggedIn()) {
    header("Location: login_page.php");
    exit();
}*/

// Get doctor's information from session
$doctor_id = $_SESSION['doctor_id'];
$doctor_name = $_SESSION['full_name'];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MEDTRACK Dashboard</title>
    <link href="../assets/dashboard.css" rel="stylesheet">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
</head>
<body>
    <!-- Dashboard Container -->
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>MEDTRACK</h2>
                <p>Welcome,  <?php echo htmlspecialchars($doctor_name); ?></p>
            </div>
            
            <nav class="sidebar-menu">
                <ul>
                    <li class="active">
                        <a href="#"><i class='bx bxs-dashboard'></i> Dashboard</a>
                    </li>
                    <li>
                        <a href="patients.php"><i class='bx bxs-user'></i> Patients</a>
                    </li>
                    <li>
                        <a href="#"><i class='bx bxs-report'></i> Reports</a>
                    </li>
                    <li>
                        <a href="#"><i class='bx bxs-calendar'></i> Appointments</a>
                    </li>
                    <li>
                        <a href="auth.php?action=logout&csrf_token=<?= generateCsrfToken() ?>">
                            <i class='bx bx-log-out'></i> Logout
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Header -->
            <header class="dashboard-header">
                <h1>Dashboard Overview</h1>
                <div class="header-info">
                    <span><?php echo date('l, F j, Y'); ?></span>
                </div>
            </header>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <i class='bx bxs-user'></i>
                    <h3>Total Patients</h3>
                    <p>1,234</p>
                </div>
                
                <div class="stat-card">
                    <i class='bx bxs-calendar'></i>
                    <h3>Today's Appointments</h3>
                    <p>15</p>
                </div>
                
                <div class="stat-card">
                    <i class='bx bxs-report'></i>
                    <h3>Pending Reports</h3>
                    <p>23</p>
                </div>
            </div>

            <!-- Recent Activity -->
            <section class="recent-activity">
                <h2><i class='bx bxs-time'></i> Recent Patients</h2>
                <div class="activity-list">
                    <!-- Sample Data - Replace with PHP/Database -->
                    <div class="activity-item">
                        <div class="patient-info">
                            <span>John Doe</span>
                            <span>Cardiology</span>
                        </div>
                        <div class="activity-meta">
                            <span>Last Visit: 2023-07-25</span>
                            <a href="#" class="btn-small">View Record</a>
                        </div>
                    </div>
                    <!-- More items... -->
                </div>
            </section>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <button class="action-btn">
                    <i class='bx bxs-plus-circle'></i>
                    New Patient
                </button>
                <button class="action-btn">
                    <i class='bx bxs-file'></i>
                    Generate Report
                </button>
            </div>
        </main>
    </div>

    <script src="../assets/js/dashboard.js"></script>
</body>
</html>