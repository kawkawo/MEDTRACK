<?php
require_once __DIR__ . '/../includs/auth.php';
require_once __DIR__ . '/DAOutilities.php'; // Include to use getPatientList function

if (!isset($_SESSION['doctor_id'])) {
    
    header("Location: ../login_page.php");
    exit();
}

$doctor_id = $_SESSION['doctor_id'];

$patients = getPatientList($pdo, $doctor_id);
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" sizes="16x16" href="../icon_web.ico">
    <title>MEDTRACK - Patient Records</title>
    <link href="../assets/dashboard.css" rel="stylesheet">
    <link href="../assets/patients.css" rel="stylesheet">

    <link href="../assets/records.css" rel="stylesheet">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
</head>

<body>
    <div class="dashboard-container">
        <aside class="sidebar">
        <div class="sidebar-header">
                <h1 id="logo" >MEDTRACK<h1>
            </div>

            <nav class="sidebar-menu">
                <ul>
                    <li>
                        <a href="dashboard.php"><i class='bx bxs-dashboard'></i> Dashboard</a>
                    </li>
                    <li>
                        <a href="patients.php"><i class='bx bxs-user'></i> Patients</a>
                    </li>
                    <li>
                        <a href="appointment.php"><i class='bx bxs-calendar'></i> Appointments</a>
                    </li>
                    <li class="active">
                        <a href="records.php"><i class='bx bxs-file-blank'></i> Records</a>
                    </li>
                    <a  class="out" href="../includs/auth.php?action=logout&csrf_token=<?= generateCsrfToken() ?>">
                        <i class='bx bx-log-out'></i> Logout </a>
                </ul>
            </nav>
        </aside>

        <main class="main-content">
            <h1>Patient Records</h1>

            <section class="patient-selection">
                <h2>View Patient Records</h2>
                <form method="GET">
                    <div class="form-group">
                        <label for="patient_id">Select Patient:</label>
                        <select id="patient_id" name="patient_id">
                            <option value="">-- Select a Patient --</option>
                            <?php foreach ($patients as $patient): ?>
                                <option value="<?php echo htmlspecialchars($patient['patient_id']); ?>"
                                    <?php if (isset($_GET['patient_id']) && $_GET['patient_id'] == $patient['patient_id']) echo 'selected'; ?>>
                                    <?php echo htmlspecialchars($patient['first_name'] . ' ' . $patient['last_name']); ?>
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <button type="submit" class="button">View Records</button>
                </form>
            </section>

            <section class="patient-records">
                <?php if (isset($_GET['patient_id']) && is_numeric($_GET['patient_id'])): ?>
                    <?php
                    $selected_patient_id = $_GET['patient_id'];

                    // Fetch patient details (optional, for display)
                    $stmt_patient = $pdo->prepare("SELECT first_name, last_name FROM patients WHERE patient_id = ? AND doctor_id = ?");
                    $stmt_patient->execute([$selected_patient_id, $doctor_id]);
                    $patient_details = $stmt_patient->fetch(PDO::FETCH_ASSOC);

                    if ($patient_details):
                    ?>
                        <h3>Records for: <?php echo htmlspecialchars($patient_details['first_name'] . ' ' . $patient_details['last_name']); ?></h3>
                        <?php
                        // Fetch diagnoses for the selected patient
                        $stmt_diagnoses = $pdo->prepare("SELECT * FROM diagnoses WHERE patient_id = ? AND doctor_id = ? ORDER BY diagnosis_date DESC");
                        $stmt_diagnoses->execute([$selected_patient_id, $doctor_id]);
                        $diagnoses = $stmt_diagnoses->fetchAll(PDO::FETCH_ASSOC);

                        if ($diagnoses):
                            echo '<h4>Diagnoses:</h4>';
                            echo '<ul class="diagnoses-list">';
                            foreach ($diagnoses as $diagnosis):
                                echo '<li>';
                                echo '<strong>' . htmlspecialchars($diagnosis['disease_name']) . '</strong> (' . date('Y-m-d H:i', strtotime($diagnosis['diagnosis_date'])) . ')';
                                if (!empty($diagnosis['notes'])) {
                                    echo '<p>Notes: ' . htmlspecialchars($diagnosis['notes']) . '</p>';
                                }

                                // Fetch treatments for this diagnosis
                                $stmt_treatments = $pdo->prepare("SELECT * FROM treatments WHERE diagnosis_id = ? ORDER BY start_date DESC");
                                $stmt_treatments->execute([$diagnosis['diagnosis_id']]);
                                $treatments = $stmt_treatments->fetchAll(PDO::FETCH_ASSOC);

                                if ($treatments):
                                    echo '<ul class="treatments-list">';
                                    echo '<h5>Treatments:</h5>';
                                    foreach ($treatments as $treatment):
                                        echo '<li>';
                                        echo '<strong>Prescription:</strong> ' . htmlspecialchars($treatment['prescription']) . '<br>';
                                        echo '<strong>Start Date:</strong> ' . htmlspecialchars($treatment['start_date']);
                                        if (!empty($treatment['end_date'])) {
                                            echo ', <strong>End Date:</strong> ' . htmlspecialchars($treatment['end_date']);
                                        }
                                        echo ', <strong>Status:</strong> ' . htmlspecialchars($treatment['status']);
                                        echo '</li>';
                                    endforeach;
                                    echo '</ul>';
                                else:
                                    echo '<p>No treatments recorded for this diagnosis.</p>';
                                endif;

                                echo '</li>';
                            endforeach;
                            echo '</ul>';
                        else:
                            echo '<p>No diagnoses recorded for this patient.</p>';
                        endif;
                        ?>
                    <?php else: ?>
                        <p>Patient not found.</p>
                    <?php endif; ?>
                <?php endif; ?>
            </section>
            <section class="record-actions">
                <h2>Record Management</h2>
                <button class="button" onclick="toggleRecordForm()">Generate New Record</button>
            </section>

            <section id="generate-record-form" style="display: none;">
                <h2>Generate New Patient Record</h2>
                <form method="POST" action="record.php?action=generate">
                    <div class="form-group">
                        <label for="patient_id_new">Select Patient:</label>
                        <select id="patient_id_new" name="patient_id" required>
                            <option value="">-- Select a Patient --</option>
                            <?php foreach ($patients as $patient): ?>
                                <option value="<?php echo htmlspecialchars($patient['patient_id']); ?>">
                                    <?php echo htmlspecialchars($patient['first_name'] . ' ' . $patient['last_name']); ?>
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="disease_name">Disease Name:</label>
                        <input type="text" id="disease_name" name="disease_name" required>
                    </div>
                    <div class="form-group">
                        <label for="diagnosis_notes">Diagnosis Notes:</label>
                        <textarea id="diagnosis_notes" name="diagnosis_notes" rows="3"></textarea>
                    </div>
                    <div class="treatment-section">
                        <h3>Treatment</h3>
                        <div class="form-group">
                            <label for="prescription">Prescription:</label>
                            <textarea id="prescription" name="prescription" rows="3" required></textarea>
                        </div>
                        <div class="form-group">
                            <label for="start_date">Start Date:</label>
                            <input type="date" id="start_date" name="start_date" required>
                        </div>
                        <div class="form-group">
                            <label for="end_date">End Date (Optional):</label>
                            <input type="date" id="end_date" name="end_date">
                        </div>
                        <div class="form-group">
                            <label for="status">Status:</label>
                            <select id="status" name="status">
                                <option value="Active" selected>Active</option>
                                <option value="Completed">Completed</option>
                                <option value="Cancelled">Cancelled</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" class="button primary">Submit</button>
                </form>
            </section>

            <script>
                function toggleRecordForm() {
                    const form = document.getElementById('generate-record-form');
                    form.style.display = form.style.display === 'none' ? 'block' : 'none';
                }
            </script>
        </main>
    </div>
</body>

</html>