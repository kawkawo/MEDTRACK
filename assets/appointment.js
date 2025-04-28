document.getElementById('appSearch').addEventListener('input', function() {
    const searchTerm = this.value.trim().toLowerCase();
    const rows = document.querySelectorAll('.appointments-table tbody tr');
    
    rows.forEach(row => {
        const patientName = row.cells[1].textContent.toLowerCase();
        const dateCell = row.cells[2].textContent; // Format: "YYYY-MM-DD HH:MM"
        
        // Extract just the date part (before the space)
        const dateOnly = dateCell.split(' ')[0]; // "YYYY-MM-DD"
        
        // Check if search matches name OR any part of date
        const matchesName = patientName.includes(searchTerm);
        const matchesDate = dateOnly.includes(searchTerm);
        
        row.style.display = (matchesName || matchesDate) ? '' : 'none';
    });
});
// pour afficher ou bien masquer la modale
function openDeleteModal(appointmentId) {
    document.getElementById('deleteModal').style.display = 'block';
    document.getElementById('deleteAppointmentId').value = appointmentId;
}

function closeDeleteModal() {
    document.getElementById('deleteModal').style.display = 'none';
    document.getElementById('deleteAppointmentId').value = ''; // Clear the ID when closing
}

// Close the modal if the user clicks outside of it
window.onclick = function(event) {
    const modal = document.getElementById('deleteModal');
    if (event.target === modal) {
        modal.style.display = 'none';
        document.getElementById('deleteAppointmentId').value = ''; // Clear the ID
    }
}

function openEditModal(appointmentId) {
    const modal = document.getElementById('editModal');
    const appointmentIdInput = document.getElementById('editAppointmentId');
    const dateInput = document.getElementById('edit_appointment_date');
    const timeInput = document.getElementById('edit_appointment_time');
    const statusSelect = document.getElementById('edit_status');

    // Fetch the appointment data using AJAX
    fetch(`appointment.php?action=get_appointment_data&id=${appointmentId}`)
        .then(response => response.json())
        .then(data => {
            if (data) {
                appointmentIdInput.value = appointmentId;
                const dateTimeParts = data.appointment_date.split(' ');
                dateInput.value = dateTimeParts[0];
                timeInput.value = dateTimeParts[1].substring(0, 5); // Remove seconds
                statusSelect.value = data.status;
                modal.style.display = 'block';
            } else {
                alert('Error fetching appointment data.');
            }
        })
        .catch(error => {
            console.error('Error fetching appointment:', error);
            alert('Error fetching appointment data.');
        });
}

function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
}

// Close the edit modal if the user clicks outside of it
window.onclick = function(event) {
    const modal = document.getElementById('editModal');
    if (event.target === modal) {
        modal.style.display = 'none';
    }
}