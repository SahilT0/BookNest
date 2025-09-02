<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Register - BOOKNEST</title>
    <link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Inter', Arial, sans-serif;
            background: linear-gradient(rgba(26, 35, 126, 0.40), rgba(26, 35, 126, 0.15)),
                url('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAdH70KlGrgGhXeOldHyZLUKlJec3AgjQd9A&s')
                no-repeat center center fixed;
            background-size: cover;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 12px;
        }
        .register-container {
            background: rgba(0, 0, 64, 0.75);
            backdrop-filter: blur(12px);
            border-radius: 20px;
            padding: 36px 40px;
            max-width: 420px;
            width: 100%;
            box-shadow: 0 6px 36px rgba(0, 0, 64, 0.40);
        }
        h1 {
            margin-top: 0;
            margin-bottom: 30px;
            font-weight: 700;
            font-size: 2em;
            text-align: center;
            color: #ffd60a;
            text-shadow: 0 0 10px #ffc107aa;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            font-weight: 600;
            margin-bottom: 6px;
            margin-top: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.95em;
            color: #fff9d1;
        }
        input[type="text"], input[type="email"], input[type="password"], select {
            padding: 12px 14px;
            font-size: 1em;
            border-radius: 8px;
            border: none;
            outline: none;
            background: #f0f0f0;
            color: #222;
            transition: box-shadow 0.3s ease;
        }
        input[type="text"]:focus, input[type="email"]:focus, input[type="password"]:focus, select:focus {
            box-shadow: 0 0 12px 3px #ffd60a8a;
        }
        select {
            cursor: pointer;
            appearance: none;
            background-image: url("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3fN3AF_fd01uO3NOwdShwHDPEeCvPGs0tpA&s");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 12px;
            padding-right: 36px;
        }
        .btn-register {
            margin-top: 26px;
            padding: 14px 0;
            background: linear-gradient(90deg, #ffd60a 60%, #ffa500 100%);
            border-radius: 10px;
            border: none;
            font-weight: 700;
            font-size: 1.15em;
            color: #0d47a1;
            text-transform: uppercase;
            cursor: pointer;
            transition: background-color 0.3s ease;
            box-shadow: 0 5px 18px rgba(255, 214, 10, 0.4);
        }
        .btn-register:hover {
            background: linear-gradient(90deg, #ffa500 60%, #ffd60a 100%);
        }
        .login-link {
            margin-top: 24px;
            text-align: center;
            color: #ffd60a;
            font-size: 0.95em;
        }
        .login-link a {
            color: #fff7c2;
            font-weight: 600;
            text-decoration: underline;
            transition: color 0.2s ease;
        }
        .login-link a:hover {
            color: white;
        }
        .error-msg {
            color: #e91e63;
            margin-top: 12px;
            font-weight: 600;
            display: none;
            text-align: center;
            letter-spacing: 0.03em;
            font-size: 1em;
        }
    </style>
</head>
<body>
    <div class="register-container" role="main">
        <h1>Create Account</h1>
        <form id="registerForm" onsubmit="return validateRegister(event)">
            <label for="fullname">Full Name</label>
            <input type="text" id="fullname" name="fullname" placeholder="Sahil Tuli" required>

            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="you@example.com" required>

            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter password" required minlength="6">

            <label for="confirm-password">Confirm Password</label>
            <input type="password" id="confirm-password" name="confirm-password" placeholder="Confirm password" required minlength="6">

            <label for="role">User Role</label>
            <select id="role" name="role" required>
                <option value="" disabled selected>Select role</option>
                <option value="Admin">Admin</option>
                <option value="Buyer">Buyer</option>
                <option value="Seller">Seller</option>
                <option value="Student">Student (Donation)</option>
            </select>

            <div class="error-msg" id="errorMsg"></div>

            <button type="submit" class="btn-register">Register</button>
        </form>

        <div class="login-link">
            Already have an account? <a href="login.jsp">Login here</a>
        </div>
    </div>

    <script>
        function validateRegister(event) {
            event.preventDefault();

            const fullname = document.getElementById('fullname').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirm-password').value;
            const role = document.getElementById('role').value;
            const errorMsg = document.getElementById('errorMsg');

            errorMsg.style.display = 'none';

            if (!fullname || !email || !password || !confirmPassword || !role) {
                showError('Please fill in all fields.');
                return false;
            }

            // Simple email regex for validation
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
                showError('Please enter a valid email address.');
                return false;
            }

            if (password.length < 6) {
                showError('Password must be at least 6 characters.');
                return false;
            }

            if (password !== confirmPassword) {
                showError('Passwords do not match.');
                return false;
            }

            // Validation passed - you can submit the form or handle with JS
            alert('Registration form is valid. Implement backend integration.');
            return false;
        }

        function showError(message) {
            const errorMsg = document.getElementById('errorMsg');
            errorMsg.textContent = message;
            errorMsg.style.display = 'block';
        }
    </script>
</body>
</html>
