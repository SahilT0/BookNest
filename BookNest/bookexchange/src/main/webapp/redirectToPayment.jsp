<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
<form action="UpiPaymentServlet" method="POST" id="paymentForm">
    <input type="hidden" name="orderId" value="${orderId}"/>
</form>
<script>
    document.getElementById('paymentForm').submit();
</script>

</body>
</html>