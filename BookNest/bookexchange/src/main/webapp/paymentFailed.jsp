<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Payment Failed - BOOKNEST</title>
<link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />
<style>
body { background: #ffeaea; font-family: Arial, sans-serif; }
.center {
  max-width: 420px; margin: 120px auto; background: #fff; border-radius: 13px;
  box-shadow: 0 2px 10px #d32f2f33; text-align: center; padding: 38px 24px;
}
.icon { font-size: 3em; color: #d32f2f; margin-bottom: 20px; }
h2 { color: #d32f2f; }
.btn {
  background: #263266; color: #ffd600; font-weight:700;
  border: none; border-radius: 8px; padding: 10px 34px; font-size: 1.1em;
  text-decoration: none; cursor: pointer;
}
.btn:hover { background: #ffd600; color: #263266; }
</style>
</head>
<body>
<div class="center">
  <div class="icon">&#10060;</div>
  <h2>Payment Failed</h2>
  <p>Your payment could not be processed.<br>Please try again or choose another payment method.</p>
  <a class="btn" href="cart.jsp">Back to Cart</a>
</div>
</body>
</html>
