<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.User,model.CartItems,java.util.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) {
      response.sendRedirect("login.jsp");
      return;
  }
  List<CartItems> cartItems = (List<CartItems>) request.getAttribute("cartItems");
  double subtotal = (Double) request.getAttribute("subtotal");
  double deliveryCharge = (Double) request.getAttribute("deliveryCharge");
  double totalAmount = (Double) request.getAttribute("totalAmount");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>CHECKOUT - BOOKNEST</title>
<link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />
<style>
html, body {
  margin: 0;
  padding: 0;
  min-height: 100vh;
  background: #f6f7fb;
  font-family: Arial, sans-serif;
}

.navbar {
    display: flex; 
    align-items: center; 
    justify-content: space-between;
    padding: 15px 38px; 
    background: #263266; 
    color: #fff;
    box-shadow: 0 1px 10px 0 rgba(40,53,147,0.08);
    position: relative;
}

.brand-logo {
    height: 34px;
    margin-right: 10px;
    vertical-align: middle;
}
.logo {
    font-weight: 800;
    font-size: 1.6em;
    color: #ffd600;
    letter-spacing: 2px;
    margin-right: 12px;
    text-decoration: none;
}
.navbar-left {
    display: flex;
    align-items: center;
    gap: 15px;
    flex-wrap: nowrap;
}
.book-nav-btn {
    background: none;
    border: none;
    color: #ffd600;
    font-size: 1.05em;
    font-weight: 600;
    padding: 6px 14px;
    cursor: pointer;
    border-radius: 0 0 10px 10px;
    transition: background 0.2s, color 0.2s;
    text-decoration: none;
}
.book-nav-btn.active, .book-nav-btn:hover {
    background: #ffd600;
    color: #263266;
}
.navbar-right {
    display: flex;
    align-items: center;
    gap: 30px;
}
.logout-btn {
    background: linear-gradient(90deg, #ffd600 70%, #ffc107 100%);
    color: #263266;
    border-radius: 7px;
    border: none;
    font-weight: 700;
    font-size: 1em;
    padding: 8px 19px;
    cursor: pointer;
    box-shadow: 0 3px 12px #ffd60020;
    transition: background 0.18s, color 0.2s;
}
.logout-btn:hover {
    background: #ffef81;
    color: #1a1f4d;
}

/* Heading Style — Centered */
.checkout-heading {
    text-align: center;
    font-size: 2.6em;
    font-weight: 900;
    color: #283593;
    letter-spacing: 3px;
    margin-top: 34px;
    margin-bottom: 28px;
}

/* Main Layout */
.checkout-row {
    display: flex;
    max-width: 1200px;
    margin: 0 auto 54px auto;
    gap: 52px;
    align-items: flex-start;
}

/* Form Section with left gap */
.form-section {
    flex: 7 1 0px;
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 20px #28359316;
    padding: 26px 22px 26px 22px;
    margin-left: 45px;
    min-width: 500px;
    margin-right: 80px;
}

/* Order Summary */
.order-summary {
    flex: 4 1 0px;
    padding: 26px 18px;
    background: #fffbe6;
    border-radius: 12px;
    box-shadow: 0 0px 16px #c0b35530;
    min-width: 320px;
    top: 88px;
    margin-left: 50px;
    height: 450px;
}

.form-group label {
  font-weight: 600;
  display: block;
  margin-bottom: 6px;
}
.form-group input, .form-group select {
  width: 100%;
  padding: 8px 11px;
  border-radius: 6px;
  border: 1.3px solid #ccc;
  font-size: 1rem;
  margin-bottom: 12px;
}

.form-check {
  margin-bottom: 10px;
  display: flex;
  align-items: center;
}
.form-check input[type=radio] {
  margin-right: 10px;
}

#cardFields {
  margin-top: 20px;
  display: none;
}

.order-summary h3 { 
    font-size: 1.23em; 
    font-weight: 800; 
    color: #263266; 
    margin-bottom: 19px;}
.order-summary table { width: 100%; border-collapse: collapse;}
.order-summary th, .order-summary td { padding: 11px 9px; border-bottom: 1px solid #eaeaea; text-align: left;}
.order-summary th { background: #f4f5ff; color: #283593;}
.order-summary .total-row { font-weight: 900; font-size: 1.09em; color: #ef6c00;}
.checkout-btn {
  background: linear-gradient(90deg, #ffd600 70%, #ffc107 100%);
  border: none;
  border-radius: 14px;
  padding: 15px 0;
  width: 100%;
  font-weight: 900;
  color: #283593;
  font-size: 1.2em;
  cursor: pointer;
  box-shadow: 0 4px 18px #c1a31478;
  transition: background-color 0.29s ease;
  margin-top: 21px;
}
.checkout-btn:hover { background: #ffe876; }

/* -------- FOOTER -------- */
.footer {
    background-color: #222;   /* dark background */
    color: #fff;              /* white text */
    text-align: center;       /* center text */
    padding: 15px 0;          /* spacing */
    margin-top: 40px;         /* space above footer */
    font-size: 14px;          /* neat size */
    position: relative;       /* normal flow */
    bottom: 0;
    width: 100%;
    border-top: 2px solid #444; /* subtle top border */
}

.footer p {
    margin: 0;
    letter-spacing: 0.5px;
}
</style>
<script>
function togglePaymentFields(){
    var cardFields = document.getElementById('cardFields');
    var paymentRadios = document.getElementsByName('paymentMethod');
    var isCard = false;
    for (var i = 0; i < paymentRadios.length; i++) {
        if(paymentRadios[i].checked && paymentRadios[i].value === 'Card'){
            isCard = true; break;
        }
    }
    cardFields.style.display = isCard ? 'block' : 'none';
}
window.onload = togglePaymentFields;
</script>
</head>
<body>
<!-- Navbar -->
<div class="navbar">
    <form id="navForm" method="get" action="browseBooks" class="navbar-left">
        <img class="brand-logo" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZCHHvhgc3NLwTEkw4aJJ-IBU_H-F8J93cXQ&s" alt="BOOKNEST logo">
        <span class="logo">BOOKNEST</span>
        <button type="submit" name="page" value="buyerPortal" class="book-nav-btn">Home</button>
        <a href="browseBooks" class="book-nav-btn">Books</a>
        <a href="CartServlet" class="book-nav-btn">🛒 Cart</a>
        <a href="MyOrders" class="book-nav-btn">Orders</a>
    </form>
    <div class="navbar-right">
        <div class="user-area">
            Hello, ${user.fullname}
        </div>
        <form id="logoutForm" action="<%= request.getContextPath() %>/LogoutServlet" method="post" style="display:inline;">
            <button type="submit" class="logout-btn">Logout</button>
        </form>
    </div>
</div>

<div class="checkout-heading">Checkout</div>

<div class="checkout-row">
  <form method="post" action="CheckoutServlet" novalidate style="display:flex;gap:0;">
    <input type="hidden" name="buyerId" value="${user.id}" />
    <input type="hidden" name="totalAmount" value="${totalAmount}" />
    <input type="hidden" name="cartId" value="${cartId}" />

    <div class="form-section">
      <h3>Shipping Information</h3>
      <c:if test="${not empty defaultAddress}">
  <div class="form-check" style="margin-bottom: 18px;">
    <input type="checkbox" id="useDefault" name="useDefault" onchange="toggleAddressFields()" checked />
    <label for="useDefault" style="font-weight: 700;">Use Default Address</label>
  </div>
</c:if>
      
      <div class="form-group">
  <label for="address1">Address Line 1*</label>
  <input type="text" id="address1" name="address1" required value="${defaultAddress != null ? defaultAddress.line1 : ''}" />
</div>
<div class="form-group">
  <label for="address2">Address Line 2</label>
  <input type="text" id="address2" name="address2" value="${defaultAddress != null ? defaultAddress.line2 : ''}" />
</div>
<div class="form-group">
  <label for="city">City*</label>
  <input type="text" id="city" name="city" required value="${defaultAddress != null ? defaultAddress.city : ''}" />
</div>
<div class="form-group">
  <label for="state">State*</label>
  <input type="text" id="state" name="state" required value="${defaultAddress != null ? defaultAddress.state : ''}" />
</div>
<div class="form-group">
  <label for="pincode">Pincode*</label>
  <input type="text" id="pincode" name="pincode" pattern="[0-9]{6}" title="Enter 6 digit pincode" required value="${defaultAddress != null ? defaultAddress.postal_code : ''}" />
</div>
<div class="form-check">
  <input type="checkbox" id="makeDefault" name="makeDefault" />
  <label for="makeDefault">Make this my default address</label>
</div>

      <h3>Payment Method</h3>
      <div class="form-check">
        <input type="radio" id="cod" name="paymentMethod" value="COD" checked onchange="updateCheckoutBtn()" />
        <label for="cod">Cash on Delivery (COD)</label>
      </div>
      <div class="form-check">
        <input type="radio" id="upi" name="paymentMethod" value="UPI" onchange="updateCheckoutBtn()" />
        <label for="upi">UPI</label>
      </div>
      <h3>Delivery Options</h3>
      <div class="form-check">
        <input type="radio" id="standardDelivery" name="deliveryOption" value="Standard" checked />
        <label for="standardDelivery">Standard Delivery (Free, 5–7 days)</label>
      </div>
      <div class="form-check">
        <input type="radio" id="expressDelivery" name="deliveryOption" value="Express" />
        <label for="expressDelivery">Express Delivery (Extra charge, 2–3 days)</label>
      </div>
      <input type="hidden" name="deliveryCharge" value="${deliveryCharge}" />
<input type="hidden" name="totalAmount" value="${totalAmount}" />
      
    </div>
    <div class="order-summary">
      <h3>Order Summary</h3>
      <table>
        <thead>
          <tr>
            <th>Book Title</th>
            <th>Quantity</th>
            <th>Price</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="item" items="${cartItems}">
            <tr>
              <td>${item.listing.book.title}</td>
              <td>${item.quantity}</td>
              <td>₹${item.totalPrice}</td>
            </tr>
          </c:forEach>
        </tbody>
        <tfoot>
          <tr>
            <td colspan="2" class="total-row">Subtotal</td>
            <td class="total-row">₹${subtotal}</td>
          </tr>
          <tr>
            <td colspan="2">Delivery Charges</td>
            <td id="deliveryChargeCell">₹${deliveryCharge}</td>
          </tr>
          <tr>
            <td colspan="2" class="total-row">Total</td>
            <td id="totalAmountCell" class="total-row">₹${totalAmount}</td>
          </tr>
        </tfoot>
      </table>
      <button type="submit" id="checkout-btn" class="checkout-btn">Place Order</button>
    </div>
  </form>
</div>

<footer class="footer">
  <p>&copy; 2025 BookNest. All Rights Reserved.</p>
  <a href="aboutUs.jsp">About Us</a> |
  <a href="contactUs.jsp">Contact</a> |
  <a href="terms.jsp">Terms & Privacy</a>
</footer>

<script>
function updateCheckoutBtn() {
    var cod = document.getElementById('cod');
    var btn = document.getElementById('checkout-btn');
    if(cod.checked) {
        btn.textContent = 'Place Order';
    } else {
        btn.textContent = 'Proceed to Payment';
    }
}
function toggleAddressFields() {
    var useDefault = document.getElementById('useDefault') && document.getElementById('useDefault').checked;
    var fields = ['address1', 'address2', 'city', 'state', 'pincode'];
    fields.forEach(function(id) {
        var field = document.getElementById(id);
        if (field) {
            field.readOnly = useDefault;
            if (useDefault) {
                field.classList.add('readonly-input');
            } else {
                field.classList.remove('readonly-input');
            }
        }
    });
}
var subtotal = parseFloat('${subtotal}');
var expressCharge = 50; // set your express charge
var standardCharge = 0;
function updateTotals() {
    let deliveryCharge = standardCharge;
    if (document.getElementById('expressDelivery').checked) {
        deliveryCharge = expressCharge;
    }
    document.getElementById('deliveryChargeCell').textContent = '₹' + deliveryCharge.toFixed(2);
    let totalAmount = subtotal + deliveryCharge;
    document.getElementById('totalAmountCell').textContent = '₹' + totalAmount.toFixed(2);
    // Update the hidden field, so the servlet gets correct value
    if(document.getElementsByName('deliveryCharge')[0])
        document.getElementsByName('deliveryCharge')[0].value = deliveryCharge;
    if(document.getElementsByName('totalAmount')[0])
        document.getElementsByName('totalAmount')[0].value = totalAmount;
}

// Attach listeners in a single onload function
window.onload = function() {
    updateCheckoutBtn();
    if(document.getElementById('useDefault')) toggleAddressFields();
    updateTotals();

    if(document.getElementById('standardDelivery'))
        document.getElementById('standardDelivery').addEventListener('change', updateTotals);
    if(document.getElementById('expressDelivery'))
        document.getElementById('expressDelivery').addEventListener('change', updateTotals);
};

</script>

</body>
</html>
