<?php

require_once __DIR__ . '/../includs/auth.php';     // Adjust path as needed

// Get doctor's ID from session
$doctor_id = $_SESSION['doctor_id'];

$successMessage = $_SESSION['success_message'] ?? '';
unset($_SESSION['success_message']);
$errorMessage = $_SESSION['error_message'] ?? '';
unset($_SESSION['error_message']);


// Determine the action based on the 'action' URL parameter or POST data
$action = $_GET['action'] ?? $_POST['action'] ?? 'view';


if ($action === 'add') {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Process add form submission
        $patient_id = $_POST['patient_id'] ?? null;
        $appointment_date = $_POST['appointment_date'] ?? null;
        $appointment_time = $_POST['appointment_time'] ?? null;
        $reason = $_POST['reason'] ?? '';

        // Validate input
        $errors = [];
        if (empty($patient_id) || !is_numeric($patient_id) || $patient_id <= 0) {
            $errors[] = "Please select a valid patient.";
        }
        if (empty($appointment_date)) {
            $errors[] = "Please select an appointment date.";
        }
        if (empty($appointment_time)) {
            $errors[] = "Please select an appointment time.";
        }

        
        if (empty($errors)) {
            // Combine date and time into a DATETIME format for the database
            $appointment_datetime_str = $appointment_date . ' ' . $appointment_time . ':00'; // Add seconds

            try {
                $stmt = $pdo->prepare("INSERT INTO appointments (doctor_id, patient_id, appointment_date, notes, status)
                                       VALUES (?, ?, ?, ?, ?)");
                $stmt->execute([$doctor_id, $patient_id, $appointment_datetime_str, $reason, 'Scheduled']);

                $_SESSION['successMessage'] = "Appointment scheduled successfully.";
                header("Location: appointment.php"); // Redirect after successful scheduling
                exit();

            } catch (PDOException $e) {
                $errorMessage = "Error scheduling appointment: " . $e->getMessage();
                $_SESSION['errorMessage'] = $errorMessage;
                header("Location: appointment.php#create-appointment"); // Redirect even on error to display message
                exit();
            }
        } else {
            // Store validation errors in $_SESSION['errorMessage']
            $_SESSION['errorMessage'] = "Please correct the following errors:<br>" . implode("<br>", $errors);
            header("Location: appointment.php#create-appointment"); // Redirect back to the form to show errors
            exit();
        }
    }
}
// --- DELETE APPOINTMENT ---
if ($action === 'delete' && $_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['id']) && is_numeric($_POST['id'])) {
    $appointment_id = $_POST['id'];

    try {
        $stmt = $pdo->prepare("DELETE FROM appointments WHERE id = ? AND doctor_id = ?");
        $stmt->execute([$appointment_id, $doctor_id]);

        if ($stmt->rowCount() > 0) {
            $_SESSION['successMessage'] = "Appointment deleted successfully.";
        } else {
            $_SESSION['errorMessage'] = "Error: Appointment not found or you are not authorized to delete it.";
        }
    } catch (PDOException $e) {
        $_SESSION['errorMessage'] = "Error deleting appointment: " . $e->getMessage();
    }

    header("Location: appointment.php");
    exit();
}

// --- GET APPOINTMENT DATA FOR EDIT MODAL (AJAX) ---
if ($action === 'get_appointment_data' && isset($_GET['id']) && is_numeric($_GET['id'])) {
    $appointment_id = $_GET['id'];

    try {
        $stmt = $pdo->prepare("SELECT id, appointment_date, status
                               FROM appointments
                               WHERE id = ? AND doctor_id = ?");
        $stmt->execute([$appointment_id, $doctor_id]);
        $appointmentData = $stmt->fetch(PDO::FETCH_ASSOC);

        header('Content-Type: application/json');
        echo json_encode($appointmentData);
        exit();

    } catch (PDOException $e) {
        // Log the error for debugging
        error_log("Error fetching appointment data: " . $e->getMessage());
        http_response_code(500); // Internal Server Error
        echo json_encode(['error' => 'Failed to fetch appointment data.']);
        exit();
    }
}

// --- UPDATE APPOINTMENT ---
if ($action === 'update' && $_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['appointment_id']) && is_numeric($_POST['appointment_id'])) {
    $appointment_id = $_POST['appointment_id'];
    $appointment_date = $_POST['appointment_date'] ?? null;
    $appointment_time = $_POST['appointment_time'] ?? null;
    $status = $_POST['status'] ?? null;

    // Validate input for date and status
    $errors = [];
    if (empty($appointment_date)) {
        $errors[] = "Please select an appointment date.";
    }
    if (empty($appointment_time)) {
        $errors[] = "Please select an appointment time.";
    }
    if (empty($status)) {
        $errors[] = "Please select a status.";
    }

    if (empty($errors)) {
        $appointment_datetime_str = $appointment_date . ' ' . $appointment_time . ':00';

        try {
            $stmt = $pdo->prepare("UPDATE appointments
                                   SET appointment_date = ?,
                                       status = ?
                                   WHERE id = ? AND doctor_id = ?");
            $stmt->execute([$appointment_datetime_str, $status, $appointment_id, $doctor_id]);

            if ($stmt->rowCount() > 0) {
                $_SESSION['successMessage'] = "Appointment updated successfully.";
            } else {
                $_SESSION['errorMessage'] = "Error: Could not update appointment or you are not authorized.";
            }
            header("Location: appointment.php");
            exit();

        } catch (PDOException $e) {
            $_SESSION['errorMessage'] = "Error updating appointment: " . $e->getMessage();
            header("Location: appointment.php"); // Redirect back to the main page on error
            exit();
        }
    } else {
        $_SESSION['errorMessage'] = "Please correct the following errors:<br>" . implode("<br>", $errors);
        header("Location: appointment.php"); // Redirect back to the main page on validation errors
        exit();
    }
}

// Fetch the list of patients for the view
function getPatientList($pdo, $doctor_id, $limit = null)
{
    try {
        $sql = "SELECT * FROM patients WHERE doctor_id = ? ORDER BY last_name, first_name";
        if ($limit !== null && is_numeric($limit) && $limit > 0) {
            $sql .= " LIMIT ?";
        }
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(1, $doctor_id, PDO::PARAM_INT);
        if ($limit !== null && is_numeric($limit) && $limit > 0) {
            $stmt->bindParam(2, $limit, PDO::PARAM_INT);
        }
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (PDOException $e) {
        die("Error fetching patients: " . $e->getMessage());
        $errorMessage = $_SESSION['error_message'];
    }
}
$patients = getPatientList($pdo, $doctor_id);
function getAllAppointmentsForDoctor($pdo, $doctor_id)
{
    try {
        $stmt = $pdo->prepare("SELECT
                                   a.id AS ID,
                                   p.first_name AS Patient_first_name,
                                   p.last_name AS Patient_last_name,
                                   a.appointment_date AS date,
                                   a.status AS Status,
                                   a.notes AS Notes
                               FROM appointments a
                               JOIN patients p ON a.patient_id = p.patient_id
                               WHERE a.doctor_id = ?
                               ORDER BY a.appointment_date DESC");
        $stmt->execute([$doctor_id]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (PDOException $e) {
        $errorMessage = "Error fetching appointments: " . $e->getMessage();
        $_SESSION['error_message'] = $errorMessage;
        return [];
    }
}

$appointmentsofdate = getAllAppointmentsForDoctor($pdo, $doctor_id);
$today = date('Y-m-d');

?>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" sizes="16x16" href="../icon_web.ico">
    <title>MEDTRACK - Appointments</title>
    <link href="../assets/dashboard.css" rel="stylesheet">
    <link href="../assets/patients.css" rel="stylesheet">
    <link href="../assets/appointment.css" rel="stylesheet">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>

</head>

<body>
    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>MEDTRACK</h2>
                <p> </p>
            </div>

            <nav class="sidebar-menu">
                <ul>
                    <li>
                        <a href="dashboard.php"><i class='bx bxs-dashboard'></i> Dashboard</a>
                    </li>
                    <li>
                        <a href="patients.php"><i class='bx bxs-user'></i> Patients</a>
                    </li>

                    <li class="active">
                        <a href="appointment.php"><i class='bx bxs-calendar'></i> Appointments</a>
                    </li>
                    <li>
                        <a href="#"><i class='bx bxs-file-blank'></i> Records</a>

                    </li>

                    <li>
                        <a href="auth.php?action=logout&csrf_token=<?= generateCsrfToken() ?>">
                            <i class='bx bx-log-out'></i> Logout</a>
                    </li>
                </ul>
            </nav>
        </aside>

        <main class="main-content">
            <?php unset($_SESSION['error_message']); ?>
            <div class="appointment-list-container">
                <h1>Appointment Management</h1>
                <?php if (!empty($_SESSION['successMessage'])): ?>
                    <div id="successModal" class="modal" style="display: block;">
                        <div class="modal-content">
                            <span class="close" onclick="document.getElementById('successModal').style.display='none'">&times;</span>
                            <p><?php echo htmlspecialchars($_SESSION['successMessage']); ?></p>
                        </div>
                    </div>
                    <script>
                        setTimeout(() => {
                            <?php unset($_SESSION['successMessage']); ?>
                            window.location.href = 'appointment.php'; // Rediriger après l'affichage
                        }, 1500); // Délai avant la redirection (en millisecondes)
                    </script>
                <?php endif ?>
                <?php if (!empty($_SESSION['errorMessage'])): ?>
                    <div id="failModal" class="modal" style="display: block;">
                        <div class="modal-content">
                            <span class="close" onclick="document.getElementById('failModal').style.display='none'">&times;</span>
                            <p><?php echo htmlspecialchars($_SESSION['errorMessage']); ?></p>
                        </div>
                    </div>
                    <script>
                        setTimeout(() => {
                            <?php unset($_SESSION['errorMessage']); ?>
                            window.location.href = 'appointment.php'; // Rediriger après l'affichage
                        }, 1500); // Délai avant la redirection (en millisecondes)
                    </script>
                <?php endif; ?>
                <div class="button-container">
                    <button class="button" onclick="scrollToAppointmentForm()">
                        Register Appointment
                    </button>
                </div>
                <script>
                    // Replace the ENTIRE scrollToAppointmentForm() function with this:
                    function scrollToAppointmentForm() {
                        const appointmentForm = document.getElementById('create-appointment');

                        // Toggle form visibility
                        if (appointmentForm.style.display === 'none' || appointmentForm.style.display === '') {
                            appointmentForm.style.display = 'block';
                            appointmentForm.scrollIntoView({
                                behavior: 'smooth'
                            });
                        } else {
                            appointmentForm.style.display = 'none';
                        }
                    }

                    // Keep this part (it's fine as-is):
                    document.addEventListener('DOMContentLoaded', function() {
                        document.getElementById('create-appointment').style.display = 'none';
                    });

                </script>
                <div class="search">
                    <input type="text" id="appSearch" placeholder="Search by patient name or date (YYYY-MM-DD)....">
                </div>

                <section id="view-appointments">
                    <table class="appointments-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Patient</th>
                                <th>date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
                            $today = date('Y-m-d');
                            if (empty($appointmentsofdate)):
                            ?>
                                <tr>
                                    <td colspan="5" style="text-align: center; font-style: italic; color: #777;">No appointments today.</td>
                                </tr>
                                <?php else:
                                foreach ($appointmentsofdate as $appointment):
                                ?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($appointment['ID']); ?></td>
                                        <td><?php echo htmlspecialchars($appointment['Patient_first_name'] . ' ' . $appointment['Patient_last_name']); ?></td>
                                        <td><?php echo htmlspecialchars(substr($appointment['date'], 0, 16)); ?></td>
                                        <td><?php echo htmlspecialchars($appointment['Status']); ?></td>
                                        <td>
                                        <button class="button edit-button" data-id="<?php echo $appointment['ID'];?>" onclick="openEditModal(<?php echo $appointment['ID']; ?>)">Edit</button>
                                        <button class="button delete-button" data-id="<?php echo $appointment['ID'];?>" onclick="openDeleteModal(<?php echo $appointment['ID']; ?>)">Delete</button>
                                        </td>
                                    </tr>
                            <?php endforeach;
                            endif;
                            ?>
                        </tbody>
                    </table>
                </section>

                <section id="create-appointment" style="display:none;">
                    <h2>Schedule New Appointment</h2>

                    <form action="appointment.php?action=add" method="POST">
                        <div class="form-group">
                            <label for="patient_id">Patient:</label>
                            <select id="patient_id" name="patient_id" required>
                                <option value="">Select a patient</option>
                                <?php
                                foreach ($patients as $patient):
                                ?>
                                    <option value="<?php echo htmlspecialchars($patient['patient_id']); ?>">
                                        <?php echo htmlspecialchars($patient['first_name'] . ' ' . $patient['last_name']); ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="appointment_date">Appointment Date:</label>
                            <input type="date" id="appointment_date" name="appointment_date" value="<?php echo $today; ?>" required>
                        </div>
                        <div class="form-group">
                            <label for="appointment_time">Appointment Time:</label>
                            <input type="time" id="appointment_time" name="appointment_time" required>
                        </div>
                        <div class="form-group">
                            <label for="reason">Reason for Appointment:</label>
                            <textarea id="reason" name="reason" rows="3"></textarea>
                        </div>
                        <button type="submit" class="button">Schedule Appointment</button>
                    </form>
                </section>

            </div>

            <script src="../assets/appointment.js"></script>

    </div>
    </main>
    <div id="deleteModal" class="modal" style="display: none;">
    <div class="modal-content">
        <span class="close-button" onclick="closeDeleteModal()">&times;</span>
        <h3>Confirm Delete</h3>
        <p>Are you sure you want to delete this appointment?</p>
        <form action="appointment.php?action=delete" method="POST">
            <input type="hidden" id="deleteAppointmentId" name="id" value="">
            <div class="modal-buttons">
                <button type="button" class="button secondary" onclick="closeDeleteModal()">Cancel</button>
                <button type="submit" id="danger" class="button">Delete</button>
            </div>
        </form>
    </div>
</div>

<div id="editModal" class="modal" style="display: none;">
    <div class="modal-content">
        <span class="close-button" onclick="closeEditModal()">&times;</span>
        <h3>Edit Appointment</h3>
        <form action="appointment.php?action=update" method="POST">
            <input type="hidden" id="editAppointmentId" name="appointment_id" value="">

            <div class="form-group">
                <label for="edit_appointment_date">Appointment Date:</label>
                <input type="date" id="edit_appointment_date" name="appointment_date" required>
            </div>
            <div class="form-group">
                <label for="edit_appointment_time">Appointment Time:</label>
                <input type="time" id="edit_appointment_time" name="appointment_time" required>
            </div>
            <div class="form-group">
                <label for="edit_status">Status:</label>
                <select id="edit_status" name="status" required>
                    <option value="Scheduled">Scheduled</option>
                    <option value="Completed">Completed</option>
                    <option value="Cancelled">Cancelled</option>
                </select>
            </div>
            <div class="modal-buttons">
                <button type="button" class="button secondary" onclick="closeEditModal()">Cancel</button>
                <button type="submit" class="button primary">Update</button>
            </div>
        </form>
    </div>
</div>


</body>

</html>