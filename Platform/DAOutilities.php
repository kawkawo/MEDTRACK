<?php
// Get doctor's ID from session
$doctor_id = $_SESSION['doctor_id'];
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
?>