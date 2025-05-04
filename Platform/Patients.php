<?php

require_once __DIR__ . '/../includs/auth.php';     // Adjust path as needed
if (!isset($_SESSION['doctor_id'])) {
    
    header("Location: ../login_page.php");// pour assurer que l'utilisateur passer premierment par le login
    exit();
}
// Get doctor's ID from session
$doctor_id = $_SESSION['doctor_id'];

// Initialize variables for form display and messages
$showAddForm = false;
$showEditForm = false;
$patientToEdit = null;
$successMessage = $_SESSION['success_message'] ?? '';
unset($_SESSION['success_message']);
$errorMessage = $_SESSION['error_message'] ?? '';
unset($_SESSION['error_message']);

// Determine the action based on the 'action' URL parameter or POST data
$action = $_GET['action'] ?? $_POST['action'] ?? 'view';

// Handle actions
if ($action === 'add') {
    $showAddForm = true;
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Process add form submission
        if (isset($_POST['add_patient'])) {

            // Sanitize text fields
            $cne      = isset($_POST['cne'])        ? filter_var($_POST['cne'],        FILTER_SANITIZE_STRING) : '';
            $firstName = isset($_POST['prenom'])     ? filter_var($_POST['prenom'],     FILTER_SANITIZE_STRING) : '';
            $lastName = isset($_POST['nom'])        ? filter_var($_POST['nom'],        FILTER_SANITIZE_STRING) : '';
            $address  = isset($_POST['adresse'])    ? filter_var($_POST['adresse'],    FILTER_SANITIZE_STRING) : '';

            // Dates and enums (you can add more validation here)
            $dob      = $_POST['naissance'] ?? '';   // e.g. YYYY-MM-DD
            $gender = filter_var($_POST['sexe'], FILTER_SANITIZE_STRING);

            // Phone number (strip everything but digits and “+”)
            $phone    = isset($_POST['telephone'])
                ? preg_replace('/[^\d\+]/', '', $_POST['telephone'])
                : '';

            // Numeric vitals (cast to int/float or null)
            $systolic  = isset($_POST['systolic'])  && $_POST['systolic'] !== ''
                ? (int) $_POST['systolic']
                : null;
            $diastolic = isset($_POST['diastolic']) && $_POST['diastolic'] !== ''
                ? (int) $_POST['diastolic']
                : null;
            $weight    = isset($_POST['weight_kg'])  && $_POST['weight_kg'] !== ''
                ? (float) $_POST['weight_kg']
                : null;
            $height    = isset($_POST['height_cm'])  && $_POST['height_cm'] !== ''
                ? (float) $_POST['height_cm']
                : null;
            $bmi       = isset($_POST['bmi'])       && $_POST['bmi'] !== ''
                ? (float) $_POST['bmi']
                : null;


            // Validate and sanitize other fields as needed

            if (!empty($firstName) && !empty($lastName)) {
                try {
                    $stmt = $pdo->prepare("INSERT INTO patients(doctor_id, first_name, last_name,cne, date_of_birth, gender, contact_number,systolic, diastolic, weight_kg, height_cm,bmi, adress) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
                    $stmt->execute([
                        $doctor_id,
                        $firstName,
                        $lastName,
                        $cne,
                        $dob,
                        $gender,
                        $phone,
                        $systolic,
                        $diastolic,
                        $weight,
                        $height,
                        $bmi,
                        $address
                    ]);
                    $_SESSION['success_message'] = "Patient added successfully.";
                    header("Location: patients.php"); // Redirect to refresh the list
                    exit();
                } catch (PDOException $e) {
                    $errorMessage = "Error adding patient: " . $e->getMessage();
                }
            } else {
                $errorMessage = "Please fill in all required fields.";
            }
        }
    }
} elseif ($action === 'search_delete' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['search_patient'])) {
        // Sanitize inputs
        $firstName = filter_var($_POST['first_name'], FILTER_SANITIZE_STRING);
        $lastName = filter_var($_POST['last_name'], FILTER_SANITIZE_STRING);

        try {
            // Search for matching patients
            $stmt = $pdo->prepare("SELECT * FROM patients 
                                 WHERE doctor_id = ? 
                                 AND first_name LIKE ? 
                                 AND last_name LIKE ?");
            $stmt->execute([
                $doctor_id,
                "%$firstName%",
                "%$lastName%"
            ]);
            $searchResults = $stmt->fetchAll(PDO::FETCH_ASSOC);
            if (empty($searchResults)) {
                $_SESSION['error_message'] = "No patients found matching your search.";
                $GLOBALS['errorMessage'] = $_SESSION['error_message'];
            } else {
                $_SESSION['search_results'] = $searchResults;
                // Clear any previous error if we found results
                unset($_SESSION['error_message']);
            }
        } catch (PDOException $e) {
            $_SESSION['error_message'] = "Error searching patients: " . $e->getMessage();
            $GLOBALS['errorMessage'] = $_SESSION['error_message'];
        }
    }
} elseif ($action === 'confirm_delete' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['confirm_delete']) && isset($_POST['patient_id'])) {
        $patientId = filter_var($_POST['patient_id'], FILTER_SANITIZE_NUMBER_INT);

        try {
            $stmt = $pdo->prepare("DELETE FROM patients
                                    WHERE patient_id = ?
                                    AND doctor_id = ?");
            $stmt->execute([$patientId, $doctor_id]);

            if ($stmt->rowCount() > 0) {
                $successMessage = "Patient deleted successfully.";
                // NE PAS rediriger ici immédiatement
            } else {
                $errorMessage = "Patient not found or you don't have permission to delete.";
            }
        } catch (PDOException $e) {
            $errorMessage = "Error deleting patient: " . $e->getMessage();
        } finally {
            unset($_SESSION['search_results']); // Ensure search results are cleared
        }
        // Définir les messages pour l'affichage sur la requête actuelle
        $GLOBALS['successMessage'] = $successMessage;
        $GLOBALS['errorMessage'] = $errorMessage;
    }
} elseif ($action === 'edit' && $_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['edit_patient'])) {
    // Process edit form submission
    $patientId = filter_var($_POST['patient_id'], FILTER_SANITIZE_NUMBER_INT);

    // Sanitize and validate all the updated fields (similar to the 'add' action)
    $cne = isset($_POST['cne']) ? filter_var($_POST['cne'], FILTER_SANITIZE_STRING) : '';
    $firstName = isset($_POST['prenom']) ? filter_var($_POST['prenom'], FILTER_SANITIZE_STRING) : '';
    $lastName = isset($_POST['nom']) ? filter_var($_POST['nom'], FILTER_SANITIZE_STRING) : '';
    $address = isset($_POST['adresse']) ? filter_var($_POST['adresse'], FILTER_SANITIZE_STRING) : '';
    $dob = $_POST['naissance'] ?? '';
    $gender = filter_var($_POST['sexe'], FILTER_SANITIZE_STRING);
    $phone = isset($_POST['telephone']) ? preg_replace('/[^\d\+]/', '', $_POST['telephone']) : '';
    $systolic = isset($_POST['systolic']) && $_POST['systolic'] !== '' ? (int) $_POST['systolic'] : null;
    $diastolic = isset($_POST['diastolic']) && $_POST['diastolic'] !== '' ? (int) $_POST['diastolic'] : null;
    $weight = isset($_POST['weight_kg']) && $_POST['weight_kg'] !== '' ? (float) $_POST['weight_kg'] : null;
    $height = isset($_POST['height_cm']) && $_POST['height_cm'] !== '' ? (float) $_POST['height_cm'] : null;
    $bmi = isset($_POST['bmi']) && $_POST['bmi'] !== '' ? (float) $_POST['bmi'] : null;

    // Perform the database update
    try {
        $stmt = $pdo->prepare("UPDATE patients SET
            cne = ?,
            first_name = ?,
            last_name = ?,
            date_of_birth = ?,
            gender = ?,
            contact_number = ?,
            systolic = ?,
            diastolic = ?,
            weight_kg = ?,
            height_cm = ?,
            bmi = ?,
            adress = ?
            WHERE patient_id = ? AND doctor_id = ?");
        $stmt->execute([
            $cne,
            $firstName,
            $lastName,
            $dob,
            $gender,
            $phone,
            $systolic,
            $diastolic,
            $weight,
            $height,
            $bmi,
            $address,
            $patientId,
            $doctor_id
        ]);

        if ($stmt->rowCount() > 0) {
            $_SESSION['success_message'] = "Patient information updated successfully.";
        } else {
            $_SESSION['error_message'] = "Error updating patient or no changes were made.";
        }
        header("Location: patients.php"); // Redirect to refresh the list
        exit();
    } catch (PDOException $e) {
        $errorMessage = "Error updating patient: " . $e->getMessage();
        $_SESSION['error_message'] = $errorMessage;
        header("Location: patients.php"); // Redirect to show error
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
    }
}
$patientsToShow = getPatientList($pdo, $doctor_id, 6);
$patients = getPatientList($pdo, $doctor_id);

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" sizes="16x16" href="../icon_web.ico">
    <title>MEDTRACK - Patients</title>
    <link href="../assets/dashboard.css" rel="stylesheet">
    <link href="../assets/patients.css" rel="stylesheet">
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
                    <li class="active">
                        <a href="patients.php"><i class='bx bxs-user'></i> Patients</a>
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

        <main class="main-content">
            <?php unset($_SESSION['error_message']); ?>
            <div class="patient-list-container">

                <div class="en-tete">
                    <h2><i class='bx bxs-user-detail'></i> Patients List</h2>

                    <?php if (!empty($GLOBALS['successMessage'])): ?>
                        <div id="successModal" class="modal" style="display: block;">
                            <div class="modal-content">
                                <span class="close" onclick="document.getElementById('successModal').style.display='none'">&times;</span>
                                <p><?php echo htmlspecialchars($GLOBALS['successMessage']); ?></p>
                            </div>
                        </div>
                        <script>
                            setTimeout(() => {
                                window.location.href = 'patients.php'; // Rediriger après l'affichage
                            }, 1500); // Délai avant la redirection (en millisecondes)
                        </script>
                    <?php endif; ?>

                    <?php if (!empty($GLOBALS['errorMessage'])): ?>
                        <div id="failModal" class="modal" style="display: block;">
                            <div class="modal-content">
                                <span class="close" onclick="document.getElementById('failModal').style.display='none'">&times;</span>
                                <p><?php echo htmlspecialchars($GLOBALS['errorMessage']); ?></p>
                            </div>
                        </div>
                        <script>
                            setTimeout(() => {
                                window.location.href = 'patients.php'; // Rediriger après l'affichage
                            }, 1500); // Délai avant la redirection (en millisecondes)
                        </script>
                    <?php endif; ?>
                    <?php if (!empty($patients) && !$showAddForm && !$showEditForm): ?>
                        <div class="add-new-patient">
                            <button onclick="document.getElementById('addPatientModal').style.display='block'">Add New Patient</button>
                            <button onclick="document.getElementById('deletePatientModal').style.display='block'" class="delete-button">Delete Patient</button>
                        </div>
                </div>
                <div class="search-bar">
                    <input type="text" id="patientSearch" placeholder="Search for a patient...">
                </div>
                <table class="patient-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>CNE</th>
                            <th>First Name</th>
                            <th>Last Name</th>
                            <th>date_of_birth</th>
                            <th>Adress</th>
                            <th>Gender</th>
                            <th>Contact number</th>
                            <!-- <th>systolic</th>
                            <th>diastolic</th>
                            <th>height</th>
                            <th>weight</th>
                            <th>bmi</th> -->
                            <th>Action</th>


                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($patients as $patient): ?>
                            <tr data-patient-id="<?php echo htmlspecialchars($patient['patient_id']); ?>">
                                <td><?php echo htmlspecialchars($patient['patient_id']); ?></td>
                                <td><?php echo htmlspecialchars($patient['cne']); ?></td>
                                <td><?php echo htmlspecialchars($patient['first_name']); ?></td>
                                <td><?php echo htmlspecialchars($patient['last_name']); ?></td>
                                <td><?php echo htmlspecialchars($patient['date_of_birth']); ?></td>
                                <td><?php echo htmlspecialchars($patient['adress']); ?></td>
                                <td><?php echo htmlspecialchars($patient['gender']); ?></td>
                                <td><?php echo htmlspecialchars($patient['contact_number']); ?></td>
                                <!--
                                <td><?php echo htmlspecialchars($patient['systolic']); ?></td>
                                <td><?php echo htmlspecialchars($patient['diastolic']); ?></td>
                                <td><?php echo htmlspecialchars($patient['height_cm']); ?></td>
                                <td><?php echo htmlspecialchars($patient['weight_kg']); ?></td>
                                <td><?php echo htmlspecialchars($patient['bmi']); ?></td> -->
                                <td>

                                    <button class="update-button" onclick="openEditModal(<?php echo htmlspecialchars(json_encode($patient)); ?>)">Update</button>
                                </td>



                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>

            <?php else: ?>
                <?php if (!$showAddForm && !$showEditForm): ?>
                    <p>No patients found.</p>
                <?php endif; ?>
            <?php endif; ?>
            </div>
        </main>

        <div id="addPatientModal" class="modal">
            <div class="modal-content">
                <span class="close-button" onclick="document.getElementById('addPatientModal').style.display='none'">&times;</span>
                <h3>Ajouter un Patient</h3>
                <form method="post" action="patients.php?action=add">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="cne">CNE:</label>
                            <input type="text" id="cne" name="cne" required>
                        </div>

                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="nom">Last name</label>
                            <input type="text" id="nom" name="nom" required>
                        </div>
                        <div class="form-group">
                            <label for="prenom">First name</label>
                            <input type="text" id="prenom" name="prenom" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="naissance"> DOB</label>
                            <input type="date" id="naissance" name="naissance" placeholder="jj-mm-aaaa" required>
                        </div>
                        <div class="form-group">
                            <label for="sexe">GENDER</label>
                            <select id="sexe" name="sexe" required>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">

                        <div class="form-group">
                            <label for="telephone">Phone number</label>
                            <input type="tel" id="telephone" name="telephone" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="systolic">Systolic:</label>
                            <input type="number" id="systolic" name="systolic">
                        </div>
                        <div class="form-group">
                            <label for="diastolic">Diastolic:</label>
                            <input type="number" id="diastolic" name="diastolic">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="weight_kg">Weight (kg):</label>
                            <input type="number" step="0.01" id="weight_kg" name="weight_kg" required oninput="calculateBMI()">
                        </div>
                        <div class="form-group">
                            <label for="height_cm">Height (cm):</label>
                            <input type="number" step="0.01" id="height_cm" name="height_cm" required oninput="calculateBMI()">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="bmi">BMI:</label>
                            <input type="text" id="bmi" name="bmi" readonly> <small>Calculated automatically</small>
                        </div>
                        <div class="form-group">
                        </div>
                    </div>

                    <div class="form-column">
                        <div class="form-group">
                            <label for="adresse">Adress</label>
                            <textarea id="adresse" name="adresse" rows="3" required></textarea>
                        </div>
                    </div>

                    <div class="form-buttons">
                        <button type="submit" name="add_patient">add</button>
                        <button type="button" class="cancel-button" onclick="document.getElementById('addPatientModal').style.display='none'">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

        <div id="deletePatientModal" class="modal">
            <div class="modal-content">
                <span class="close-button" onclick="document.getElementById('deletePatientModal').style.display='none'">&times;</span>
                <h3>Delete Patient</h3>
                <form method="post" action="patients.php?action=search_delete">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="search_first_name">First Name:</label>
                            <input type="text" id="search_first_name" name="first_name" required value="<?= $_POST['first_name'] ?? '' ?>">
                        </div>
                        <div class="form-group">
                            <label for="search_last_name">Last Name:</label>
                            <input type="text" id="search_last_name" name="last_name" required value="<?= $_POST['last_name'] ?? '' ?>">
                        </div>
                    </div>

                    <div class="form-buttons">
                        <button type="submit" name="search_patient">Search</button>
                        <button type="button" class="cancel-button" onclick="document.getElementById('deletePatientModal').style.display='none'">Cancel</button>
                    </div>

                </form>

                <?php if (isset($_POST['search_patient']) && !empty($searchResults)): ?>
                    <div class="search-results">
                        <h4>Search Results:</h4>
                        <form method="post" action="patients.php?action=confirm_delete">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Select</th>
                                        <th>First Name</th>
                                        <th>Last Name</th>
                                        <th>CNE</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($searchResults as $patient): ?>
                                        <tr>
                                            <td><input type="radio" name="patient_id" value='<?php echo $patient['patient_id']; ?>' required></td>
                                            <td><?php echo htmlspecialchars($patient['first_name']); ?></td>
                                            <td><?php echo htmlspecialchars($patient['last_name']); ?></td>
                                            <td><?php echo htmlspecialchars($patient['cne']); ?></td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                            <div class="form-buttons">
                                <button type="submit" name="confirm_delete" class="delete-button">Confirm Delete</button>
                            </div>
                        </form>
                    </div>
                <?php endif; ?>
            </div>
        </div>

        <div id="editPatientModal" class="modal">
            <div class="modal-content">
                <span class="close-button" onclick="document.getElementById('editPatientModal').style.display='none'">&times;</span>
                <h3>Edit Patient</h3>
                <form method="post" action="patients.php?action=edit">
                    <input type="hidden" id="edit_patient_id" name="patient_id">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="edit_cne">CNE:</label>
                            <input type="text" id="edit_cne" name="cne" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="edit_nom">Last name</label>
                            <input type="text" id="edit_nom" name="nom" required>
                        </div>
                        <div class="form-group">
                            <label for="edit_prenom">First name</label>
                            <input type="text" id="edit_prenom" name="prenom" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="edit_naissance">DOB</label>
                            <input type="date" id="edit_naissance" name="naissance" required>
                        </div>
                        <div class="form-group">
                            <label for="edit_sexe">Gender</label>
                            <select id="edit_sexe" name="sexe" required>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="edit_telephone">Phone number</label>
                            <input type="tel" id="edit_telephone" name="telephone" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="edit_systolic">Systolic:</label>
                            <input type="number" id="edit_systolic" name="systolic">
                        </div>
                        <div class="form-group">
                            <label for="edit_diastolic">Diastolic:</label>
                            <input type="number" id="edit_diastolic" name="diastolic">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="edit_weight_kg">Weight (kg):</label>
                            <input type="number" step="0.01" id="edit_weight_kg" name="weight_kg" required oninput="calculateBMI()">
                        </div>
                        <div class="form-group">
                            <label for="edit_height_cm">Height (cm):</label>
                            <input type="number" step="0.01" id="edit_height_cm" name="height_cm" required oninput="calculateBMI()">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="edit_bmi">BMI:</label>
                            <input type="text" id="edit_bmi" name="bmi" readonly> <small>Calculated automatically</small>
                        </div>
                        <div class="form-group">
                        </div>
                    </div>

                    <div class="form-column">
                        <div class="form-group">
                            <label for="edit_adresse">Adress</label>
                            <textarea id="edit_adresse" name="adresse" rows="3" required></textarea>
                        </div>
                    </div>

                    <div class="form-buttons">
                        <button type="submit" name="edit_patient">Update Patient</button>
                        <button type="button" class="cancel-button" onclick="document.getElementById('editPatientModal').style.display='none'">Cancel</button>
                    </div>
                </form>
            </div>
        </div>


        <script>
  function calculateBMI() {
    const weight = parseFloat(document.getElementById('weight_kg').value);
    const height = parseFloat(document.getElementById('height_cm').value);

    if (weight > 0 && height > 0) {
      const heightInMeters = height / 100;
      const bmi = weight / (heightInMeters * heightInMeters);
      document.getElementById('bmi').value = bmi.toFixed(2);
    } else {
      document.getElementById('bmi').value = '';
    }
  }

  function openEditModal(patientData) {
    console.log('openEditModal appelée avec les données:', patientData);
    const editModal = document.getElementById('editPatientModal');
    const patientIdInput = document.getElementById('edit_patient_id');
    const cneInput = document.getElementById('edit_cne');
    const firstNameInput = document.getElementById('edit_prenom');
    const lastNameInput = document.getElementById('edit_nom');
    const dobInput = document.getElementById('edit_naissance');
    const genderSelect = document.getElementById('edit_sexe');
    const phoneInput = document.getElementById('edit_telephone');
    const systolicInput = document.getElementById('edit_systolic');
    const diastolicInput = document.getElementById('edit_diastolic');
    const weightInput = document.getElementById('edit_weight_kg');
    const heightInput = document.getElementById('edit_height_cm');
    const bmiInput = document.getElementById('edit_bmi');
    const addressTextarea = document.getElementById('edit_adresse');

    // Populate the form fields with the patient's data
    patientIdInput.value = patientData.patient_id;
    cneInput.value = patientData.cne;
    firstNameInput.value = patientData.first_name;
    lastNameInput.value = patientData.last_name;
    dobInput.value = patientData.date_of_birth;
    genderSelect.value = patientData.gender;
    phoneInput.value = patientData.contact_number;
    systolicInput.value = patientData.systolic;
    diastolicInput.value = patientData.diastolic;
    weightInput.value = patientData.weight_kg;
    heightInput.value = patientData.height_cm;
    bmiInput.value = patientData.bmi;
    addressTextarea.value = patientData.adress;

    // Show the edit modal
    editModal.style.display = 'block';
  }

  window.onload = () => {
    const successModal = document.getElementById('successModal');
    const errorModal = document.getElementById('failModal');
    const deletePatientModal = document.getElementById('deletePatientModal');

    if (successModal && successModal.style.display === 'block') {
      if (deletePatientModal) {
        deletePatientModal.style.display = 'none';
      }
      setTimeout(() => {
        successModal.style.display = 'none';
      }, 3000);
    }

    if (errorModal && errorModal.style.display === 'block') {
      if (deletePatientModal) {
        deletePatientModal.style.display = 'none';
      }
      setTimeout(() => {
        errorModal.style.display = 'none';
      }, 3000);
    }
  };

  document.addEventListener('DOMContentLoaded', function() {
    const deletePatientModal = document.getElementById('deletePatientModal');
    const searchForm = document.querySelector('#deletePatientModal form[action="patients.php?action=search_delete"]');
    const searchInput = document.getElementById('patientSearch');
    const patientTableBody = document.querySelector('.patient-table tbody');
    const allPatients = <?php echo json_encode(getPatientList($pdo, $doctor_id)); ?>;
    let displayedRows = [];

    // Initially, hide the delete modal
    if (deletePatientModal) {
      deletePatientModal.style.display = 'none';
    }

    // Show the delete modal if there are search results on initial load after a search
    <?php if (!empty($_SESSION['search_results'])): ?>
      if (deletePatientModal) {
        deletePatientModal.style.display = 'block';
        // Clear the search results from the session after displaying them
        <?php unset($_SESSION['search_results']); ?>
      }
    <?php endif; ?>

    const renderTable = (patients) => {
      patientTableBody.innerHTML = '';
      let foundPatientId = null;

      if (patients.length === 0 && searchInput.value.trim() !== '') {
        const noMatchRow = document.createElement('tr');
        const noMatchCell = document.createElement('td');
        noMatchCell.colSpan = 8; // Adjust based on the number of columns in your table
        noMatchCell.textContent = 'Aucun patient trouvé.';
        noMatchCell.style.textAlign = 'center';
        patientTableBody.appendChild(noMatchRow);
        noMatchRow.appendChild(noMatchCell);
      } else {
        patients.slice(0, 6).forEach(patient => {
          const row = document.createElement('tr');
          row.dataset.patientId = patient.patient_id;
          row.innerHTML = `
            <td>${patient.patient_id}</td>
            <td>${patient.cne}</td>
            <td>${patient.first_name}</td>
            <td>${patient.last_name}</td>
            <td>${patient.date_of_birth}</td>
            <td>${patient.adress}</td>
            <td>${patient.gender}</td>
            <td>${patient.contact_number}</td>
            <td>
              <button class="update-button" data-patient='${JSON.stringify(patient)}'>Update</button>
            </td>
          `;
          patientTableBody.appendChild(row);
          displayedRows.push(row);
          if (foundPatientId === null) {
            foundPatientId = patient.patient_id;
          }
        });
      }
      return foundPatientId;
    };

    // Initial display of the first 6 patients
    const initialPatients = allPatients.slice(0, 6);
    renderTable(initialPatients);

    // Délégation d'événements pour les boutons "Update"
    patientTableBody.addEventListener('click', function(event) {
      if (event.target.classList.contains('update-button')) {
        try {
          const patientData = JSON.parse(event.target.dataset.patient);
          openEditModal(patientData);
        } catch (error) {
          console.error("Erreur lors de la récupération des données du patient:", error);
        }
      }
    });

    searchInput.addEventListener('input', function() {
      const searchTerm = searchInput.value.toLowerCase();
      const searchResults = allPatients.filter(patient => {
        const textContent = Object.values(patient).join(' ').toLowerCase();
        return textContent.includes(searchTerm);
      });

      renderTable(searchResults);
    });
  });


  document.addEventListener('DOMContentLoaded', function() {
    if (localStorage.getItem('showPatientModal') === 'true') {
        const modal = document.getElementById('addPatientModal');
        if (modal) modal.style.display = 'block';
        localStorage.removeItem('showPatientModal'); // Clean up
    }
});
</script>

<script src="assets/patients.js"></script>
       
</body>


</html>