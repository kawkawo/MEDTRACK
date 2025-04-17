

document.getElementById("loginForm").addEventListener("submit", function (event) { 
    event.preventDefault();

    const gmail = document.getElementById("Gmail").value;
    const password = document.getElementById("password").value;

    // Send an AJAX request to the server to check the credentials
    fetch('login_page.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: new URLSearchParams({
            'Gmail': gmail,
            'password': password
        })
    })
    .then(response => response.json()) // Parse the response as JSON
    .then(data => {
        if (data.success) {
            alert("Login successful!");
            window.location.href = 'dashboard.php'; // Redirect to dashboard
        } else {
            alert(data.message); // Display error message
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('There was an error with the login request.');
    });
});