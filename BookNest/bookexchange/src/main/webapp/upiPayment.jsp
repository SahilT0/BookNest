<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>PAYMENT - BOOKNEST</title>
<link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />

<style>
  #timer {
    font-size: 20px;
    font-weight: bold;
    color: #ff0000;
  }
  #paymentPlaceholder {
    margin-top: 20px;
    /* add styling as needed */
    border: 1px dashed #ccc;
    padding: 10px;
    width: fit-content;
  }
</style>

<script src="https://checkout.razorpay.com/v1/checkout.js"></script>

<script>
    var seconds = 180; // 3 minutes

    function countdown() {
        var min = Math.floor(seconds / 60);
        var sec = seconds % 60;
        document.getElementById('timer').innerText = "Time remaining: " + min + ":" + (sec < 10 ? '0' + sec : sec);
        if(seconds > 0){
            seconds--;
            setTimeout(countdown, 1000);
        } else {
            alert("Payment time expired. Please try again.");
            window.location.href = "paymentTimeout.jsp"; // Customize as needed
        }
    }

    // Poll payment status every 5 seconds
    function pollPaymentStatus() {
        fetch("CheckPaymentStatusServlet?orderId=${param.orderId}")
        .then(response => response.json())
        .then(data => {
            if(data.status === 'PAID'){
                window.location.href = "orderConfirmation";
            }
        })
        .catch(error => console.log("Error polling payment status:", error));
    }

    function startPolling() {
        setInterval(pollPaymentStatus, 5000);
    }

    window.onload = function() {
        countdown();
        startPolling();

        var options = {
            "key": "${keyId}",
            "amount": "${amount}",
            "currency": "INR",
            "name": "Your Shop Name",
            "description": "Order Payment",
            "order_id": "${razorpayOrderId}",
            "handler": function (response){
                // Payment succeeded, redirect for verification
                window.location.href = "PaymentSuccessServlet?paymentId=" + response.razorpay_payment_id +
                                       "&orderId=" + response.razorpay_order_id +
                                       "&signature=" + response.razorpay_signature;
            },
            "modal": {
                "ondismiss": function(){
                    alert("Payment popup closed. You can try again.");
                    window.location.href = "Cart.jsp"; // Adjust as needed
                }
            },
            "theme": {
                "color": "#528FF0"
            }
        };
        var rzp = new Razorpay(options);
        rzp.open();

        // Placeholder for QR code or payment button, if needed
        // Example usage: you could append a generated QR element here
        // document.getElementById('paymentPlaceholder').innerHTML = '<img src="some-qr-code-url"/>';
    };
</script>
</head>
<body>
<h2>Please complete your payment</h2>
<p id="timer">Time remaining: 3:00</p>

<div id="paymentPlaceholder">
    <!-- QR code or payment button will appear here if you generate one -->
</div>

</body>
</html>
