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


function deleteAppointment(id) {
    // 1. Confirm deletion
    if (confirm('Are you sure you want to delete this appointment?')) {
        // 2. Send delete request to server
        fetch('delete_appointment.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `id=${id}`
        })
        .then(response => response.json())
        .then(data => {
            // 3. Handle response
            if (data.success) {
                alert('Appointment deleted successfully!');
                window.location.reload(); // Refresh the page
            } else {
                alert('Error: ' + data.message);
            }
        })
        .catch(error => console.error('Error deleting appointment:', error));
    }
}


function editAppointment(id) {
    // 1. Fetch appointment data from server
    fetch(`get_appointment.php?id=${id}`)
        .then(response => response.json()) // Convert response to JSON
        .then(data => {
            // 2. Populate the form with existing data
            document.getElementById('patient_id').value = data.patient_id;
            document.getElementById('appointment_date').value = data.date.split(' ')[0]; // Extract YYYY-MM-DD
            document.getElementById('appointment_time').value = data.date.split(' ')[1]; // Extract HH:MM
            document.getElementById('reason').value = data.reason;

            // 3. Add hidden field to track edit mode
            let hiddenInput = document.createElement('input');
            hiddenInput.type = 'hidden';
            hiddenInput.name = 'appointment_id';
            hiddenInput.value = id;
            document.querySelector('form').appendChild(hiddenInput);

            // 4. Show the form and scroll to it
            document.getElementById('create-appointment').style.display = 'block';
            document.getElementById('create-appointment').scrollIntoView({ behavior: 'smooth' });

            // 5. Update form title
            document.querySelector('#create-appointment h2').textContent = 'Edit Appointment';
        })
        .catch(error => console.error('Error fetching appointment:', error));
}
