<?php

require_once __DIR__ . '/../includs/auth.php';

// Get doctor's information from session
$doctor_id = $_SESSION['doctor_id'];
$doctor_name = $_SESSION['full_name'];
if (!isset($_SESSION['doctor_id'])) {

    header("Location: ../login_page.php"); // pour assurer que l'utilisateur passer premierment par le login
    exit();
}



// JE VEUX AJOUTER UNE PARTIE CONSACRE AU INFO PROPRE DE CHAQUE DOCTOR

$stmt = $pdo->prepare("SELECT full_name, email, photo FROM doctors WHERE doctor_id = ?");
$stmt->execute([$doctor_id]);
$doctorInfo = $stmt->fetch(PDO::FETCH_ASSOC);



try {
    // Total Patients
    $stmt = $pdo->prepare("SELECT COUNT(*) FROM patients WHERE doctor_id = ?");
    $stmt->execute([$doctor_id]);
    $total_patients = $stmt->fetchColumn();
    // Recent Patients (last 5)
    $stmt = $pdo->prepare("SELECT * FROM patients WHERE doctor_id = ? ORDER BY created_at DESC LIMIT 5");
    $stmt->execute([$doctor_id]);
    $recent_patients = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    die("Database error: " . $e->getMessage());
}

function getTodaysAppointmentsCountForDoctor($pdo, $doctor_id)
{
    $todayStart = date('Y-m-d 00:00:00');
    $todayEnd = date('Y-m-d 23:59:59');

    try {
        $stmt = $pdo->prepare("SELECT COUNT(*) AS appointment_count
                               FROM appointments
                               WHERE doctor_id = ?
                               AND appointment_date >= ?
                               AND appointment_date <= ?");
        $stmt->execute([$doctor_id, $todayStart, $todayEnd]);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['appointment_count'] ?? 0;
    } catch (PDOException $e) {
        $errorMessage = "Error fetching today's appointments count: " . $e->getMessage();
        $_SESSION['error_message'] = $errorMessage;
        return 0;
    }
}

$todaysAppointmentCount = getTodaysAppointmentsCountForDoctor($pdo, $doctor_id);

// timer pour donner l'effect dynamique au page
// Fetch today's appointments with their full datetime
$todayStart = date('Y-m-d 00:00:00');
$todayEnd = date('Y-m-d 23:59:59');

$stmtAppointments = $pdo->prepare("SELECT appointment_date FROM appointments WHERE doctor_id = ? AND appointment_date BETWEEN ? AND ? ORDER BY appointment_date ASC LIMIT 1"); // Fetch the very next one
$stmtAppointments->execute([$doctor_id, $todayStart, $todayEnd]);
$nextAppointment = $stmtAppointments->fetch(PDO::FETCH_ASSOC);

$nextAppointmentTime = null;
if ($nextAppointment) {
    $nextAppointmentTime = $nextAppointment['appointment_date'];
}

?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" sizes="16x16" href="../icon_web.ico">
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
                <h1 id="logo" >MEDTRACK<h1>
            </div>

            <nav class="sidebar-menu">
                <ul>
                    <li class="active">
                        <a href="#"><i class='bx bxs-dashboard'></i> Dashboard</a>
                    </li>
                    <li>
                        <a href="Patients.php"><i class='bx bxs-user'></i> Patients</a>
                    </li>
                    <li>
                        <a href="appointment.php"><i class='bx bxs-calendar'></i> Appointments</a>
                    </li>
                    <li>
                        <a href="records.php"><i class='bx bxs-file-blank'></i> Records</a>

                    </li>

                    <li>
                        <a href="../includs/auth.php?action=logout&csrf_token=<?= generateCsrfToken() ?>">
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

                <div class="doctor-profile">
                    <img src="../<?php echo htmlspecialchars($doctorInfo['photo']); ?>" alt="Doctor Photo" style="width: 100px; border-radius: 50%;">
                    <h3><?php echo htmlspecialchars($doctorInfo['full_name']); ?></h3>
                    <p><?php echo htmlspecialchars($doctorInfo['email']); ?></p>
                </div>
                <h1>Dashboard Overview</h1>
                <div class="header-info">

                    <span><?php echo date('l, F j, Y'); ?></span>
                </div>
            </header>
<section class="dash">
            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <i class='bx bxs-user'></i>
                    <h3>Total Patients</h3>
                    <p><?= $total_patients; ?></p>
                </div>

                <div class="stat-card">
                        <i class='bx bxs-calendar'></i>
                        <h3>Today's Appointments</h3>
                        <p> <?php echo htmlspecialchars($todaysAppointmentCount); ?></p>
                        <div class="countdown-timer" id="next-appointment-timer">
                            <?php if ($nextAppointmentTime): ?>
                                <span>Next Appointment In:</span>
                                <span id="timer"></span>
                            <?php else: ?>
                                <span>No appointments today.</span>
                            <?php endif; ?>
                        </div>
                    </div>


            </div>

            <!-- Recent Activity -->
            <section class="recent-activity">
                <h2><i class='bx bxs-time'></i> Recent Patients</h2>
                <div class="activity-list">
                    <?php foreach ($recent_patients as $patient): ?>
                        <!--nous allons faire le suivant pour les 5 new patients-->
                        <div class="activity-item">
                            <div class="patient-info">
                                <span><?php echo $patient['first_name'] . " " . $patient['last_name']; ?></span>
                            </div>
                            <div class="activity-meta">
                                <span style="color: #fff;"><?= $patient['created_at'] ?></span>

                            </div>
                        </div>
                    <?php endforeach; ?>
                    <!-- More items... -->
                </div>
            </section>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <button onclick="showAddPatientForm()" class="action-btn">
                    <i class='bx bxs-plus-circle'></i>
                    New Patient
                </button>

                <script>
                    function showAddPatientForm() {
                        localStorage.setItem('showPatientModal', 'true');
                        window.location.href = 'Patients.php';
                    }
                </script>

                <button onclick="window.location.href='Patients.php'" class="action-btn">
                    <i class='bx bxs-file'></i>
                    View all
                </button>
            </div>
</section>
        </main>
    </div>

    <script>
        function updateCountdown() {
            const nextAppointmentTime = '<?php echo $nextAppointmentTime; ?>'; // Get the time from PHP
            const timerElement = document.getElementById('timer');

            if (nextAppointmentTime) {
                const targetTime = new Date(nextAppointmentTime).getTime();
                const now = new Date().getTime();
                const difference = targetTime - now;

                if (difference > 0) {
                    const days = Math.floor(difference / (1000 * 60 * 60 * 24));
                    const hours = Math.floor((difference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                    const minutes = Math.floor((difference % (1000 * 60 * 60)) / (1000 * 60));
                    const seconds = Math.floor((difference % (1000 * 60)) / 1000);

                    timerElement.textContent = `${days}d ${hours}h ${minutes}m ${seconds}s`;
                } else {
                    timerElement.textContent = "Appointment time!";
                    // Optionally, refresh the page or update the appointment list
                }
            }
        }

        // Update the countdown every second
        setInterval(updateCountdown, 1000);
    </script>
</body>

</html>