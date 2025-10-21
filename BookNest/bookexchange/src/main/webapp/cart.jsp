<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.User,model.Cart,model.CartItems,model.Book,model.Listing" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String buyerName = user.getFullname();
    Cart cart = (Cart) request.getAttribute("cart");
    java.util.List<CartItems> cartItems = (java.util.List<CartItems>) request.getAttribute("cartItems");
    double subtotal = (Double) request.getAttribute("subtotal");
    double grandTotal = (Double) request.getAttribute("grandTotal");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>YOUR CART - BOOKNEST</title>
<link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
<style>
body { background: #f6f7fb; }
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

/* -------- Page Heading -------- */
.cart-heading {
    margin: 34px auto 16px auto;
    max-width: 1250px;
    color: #283593;
    padding-left: 6px;
}
.cart-heading h1 { font-size: 2rem; font-weight: 800; }
.cart-heading p { font-size: 1.07rem; color: #5c6175; }
/* -------- Table and Layout -------- */
.cart-main-row {
    display: flex;
    gap: 56px;
    align-items: flex-start;
    justify-content: flex-start;
    max-width: 1550px;
    margin: 0 auto 55px auto;
}
.cart-table-section {
    flex: 7 1 0px;
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 4px 22px #28359312;
    padding: 32px 18px 18px 18px;
    min-width: 570px;
}
.cart-summary-section {
    flex: 3 1 220px;
    align-self: flex-start;
    background: #fffbe6;
    border-radius: 15px;
    box-shadow: 0 0px 16px #c0b35530;
    padding: 27px 24px;
    min-width: 250px;
    margin-top: 14px;
    position: sticky;
    top: 110px;
}
.cart-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0 11px;
}
.cart-table th, .cart-table td {
    padding: 10px 13px;
    font-size: 1.08rem;
    text-align: center;
}
.cart-table th {
    background: #f4f5ff;
    color: #263266;
    font-weight: 700;
    border-top-left-radius: 8px;
    border-top-right-radius: 8px;
}
.cart-table td { background: #fff; }
.book-thumb-img {
    width: 60px; height: 84px; object-fit: cover; border-radius: 8px;
    box-shadow: 0 2px 9px #c5c4f915;
}
/* Book title link */
.cart-book-link {
    font-weight: 700; color: #283593;
    text-decoration: none;
    transition: color .13s;
}
.cart-book-link:hover { color: #fb8c00; text-decoration: underline; }
.cart-author { font-size: .98em; color: #5c6175; font-style: italic;}
.cart-action-btn {
    padding: 6px 16px; margin: 2px 2px 0 0;
    border: none; border-radius: 7px; font-weight: 700;
    cursor: pointer;
    background: #ffd600; color: #263266;
    box-shadow: 0 2px 8px #ffd60016;
    transition: background .13s, color .12s;
}
.cart-action-btn:hover { background: #faeb91;}
.cart-summary-section h4 { font-weight: 800; color: #283593; margin-bottom: 18px; }
.cart-summary-section .totals-row {
    display: flex; justify-content: space-between; margin: 10px 0;
    font-size: 1.08em;
}
.cart-summary-section .total-main {
    font-weight: 800; color: #ef6c00;
    font-size: 1.3em; margin-top: 15px;
}
.cart-summary-section .checkout-btn {
    width: 100%; margin-top: 26px; padding: 12px 0; border-radius: 10px;
    background: linear-gradient(90deg,#ffd600 60%,#ffc107 100%);
    font-weight: 900; border: none; color: #283593; font-size: 1.15em; cursor: pointer;
    box-shadow: 0 3px 11px #f8b40b31; transition: background .17s;
}
.cart-summary-section .checkout-btn:hover { background: #ffe876; color: #183075;}

.footer {
    background-color: #222;
    color: #fff;
    text-align: center;
    padding: 18px 0 10px 0;
    margin-top: 38px;
    font-size: 15px;
    border-top: 2px solid #444;
}
.footer a { color: #ffd600; text-decoration: none; margin: 0 5px;}
.footer a:hover { text-decoration: underline; }

/* Responsive adjustments */
@media (max-width: 950px) {
    .cart-main-row { flex-direction: column; gap: 20px; }
    .cart-table-section, .cart-summary-section { width: 100%; min-width: unset;}
    .cart-summary-section { position: relative; top: 0;}
}
@media (max-width: 700px){
    .cart-heading, .cart-main-row { padding-left: 1vw; padding-right: 1vw;}
    .navbar { flex-direction: column; padding: 10px 8px;}
    .cart-table th, .cart-table td { padding: 6px 2px; font-size: 0.97em;}
    .cart-table-section { padding: 8px 2vw;}
}
</style>
</head>
<body>
<!-- Navbar -->
<div class="navbar">
    <form id="navForm" method="get" action="browseBooks" class="navbar-left">
        <img class="brand-logo" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZCHHvhgc3NLwTEkw4aJJ-IBU_H-F8J93cXQ&s" alt="BOOKNEST logo">
        <span class="logo">BOOKNEST</span>
        <a href="buyerPortal" class="book-nav-btn">Home</a>
        <button type="submit" name="page" value="browseBooks" class="book-nav-btn">Browse Books</button>
        <a href="MyOrders" class="book-nav-btn">My Orders</a>
        <a href="CartServlet" class="book-nav-btn active">🛒 Cart</a>
        
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
<!-- Heading/Banner -->
<div class="cart-heading">
    <h1>🛒 Your Cart</h1>
    <p>Here are the books you’ve added to your cart. Review before checkout.</p>
</div>
<c:if test="${not empty sessionScope.cartError}">
    <div style="max-width: 1250px; margin: 20px auto; padding: 12px 20px;
        background-color: #ffcccc; color: #a00; border-radius: 8px; font-weight: 700;">
        ${sessionScope.cartError}
    </div>
    <%
       session.removeAttribute("cartError");
    %>
</c:if>
<div class="cart-main-row">
    <!-- Cart Table -->
    <div class="cart-table-section">
        <table class="cart-table">
            <thead>
                <tr>
                    <th>Book</th>
                    <th>Title & Author</th>
                    <th>Condition</th>
                    <th>Unit Price</th>
                    <th>Quantity</th>
                    <th>Total Price</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${cartItems}">
                    <tr>
                        <td>
                          <img src="${item.listing.imageUrls[0]}" alt="Book Image" class="book-thumb-img"/>
                        </td>
                        <td>
                            <a class="cart-book-link" href="bookDetails.?id=${item.listing.book.id}">${item.listing.book.title}</a>
                            <div class="cart-author">${item.listing.book.author}</div>
                        </td>
                        <td>${item.listing.conditionGrade}</td>
                        <td>₹${item.listing.price}</td>
                        <td>
                            <form action="CartServlet" method="post" style="display:flex; align-items:center;">
                              <input type="hidden" name="action" value="update"/>
                              <input type="hidden" name="cartItemId" value="${item.id}"/>
                              <input type="number" name="quantity" min="1" max="${item.listing.quantity}" value="${item.quantity}" style="width:50px;"/>
                              <button class="cart-action-btn" type="submit">Update</button>
                            </form>
                        </td>
                        <td>₹${item.listing.price * item.quantity}</td>
                        <td>
                            <form action="CartServlet" method="post">
                              <input type="hidden" name="action" value="remove"/>
                              <input type="hidden" name="cartItemId" value="${item.id}"/>
                              <button class="cart-action-btn" type="submit">Remove</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty cartItems}">
                    <tr><td colspan="7" style="color:#999; font-style:italic; text-align:center;">Your cart is empty!</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
    <!-- Cart Summary -->
    <div class="cart-summary-section">
        <h4>Order Summary</h4>
        <div class="totals-row">
            <span>Subtotal</span>
            <span>₹${subtotal}</span>
        </div>
        <!-- Uncomment for future offers/discounts
        <div class="totals-row">
            <span>Discount</span>
            <span>-₹0</span>
        </div>
        -->
        <div class="totals-row total-main">
            <span>Grand Total</span>
            <span>₹${grandTotal}</span>
        </div>
        <form action="CheckoutServlet" method="get">
            <input type="hidden" name="cartId" value="${cart.id}" />
            <input type="hidden" name="totalAmount" value="${grandTotal}" />
            <input type="hidden" name="subtotal" value="${subtotal}" />
            <input type="hidden" name="deliveryCharge" value="${deliveryCharge != null ? deliveryCharge : 0.0}" />
            <input type="hidden" name="action" value="checkout"/>
            <button class="checkout-btn" type="submit">Proceed to Checkout</button>
        </form>
    </div>
</div>
<!-- FOOTER -->
<footer class="footer">
  <p>&copy; 2025 BookNest. All Rights Reserved.</p>
  <a href="aboutUs.jsp">About Us</a> |
  <a href="contactUs.jsp">Contact</a> |
  <a href="terms.jsp">Terms & Privacy</a>
</footer>
</body>
</html>
