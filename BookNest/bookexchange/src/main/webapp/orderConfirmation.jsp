<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.User" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String activeRole = (String) session.getAttribute("activeRole");
    if (activeRole == null) {
        activeRole = "buyer";
        session.setAttribute("activeRole", activeRole);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Order Confirmation - BOOKNEST</title>
    <link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/orderConfirmation.css"/>
    <style>
      body { background: #f6f7fb; color: #263266; font-family: 'Segoe UI', Arial, sans-serif; margin: 0; }
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
    height: 34px;         /* Set desired logo height */
    width: auto;          /* Maintain aspect ratio */
    margin-right: 10px;   /* Space between logo and text */
    cursor: pointer;      /* Shows pointer cursor on hover */
    vertical-align: middle; /* Align vertically with adjacent text */
}
.logo {
    font-weight: 800;
    font-size: 1.6em;
    color: #ffd600;
    letter-spacing: 2px;
}
      .logo { font-weight: 800; font-size: 1.6em; color: #ffd600; letter-spacing: 2px; }
      .footer a { color: #ffd600; margin: 0 6px;}
      .footer a:hover { text-decoration: underline; }
      .hero-banner { margin: 40px auto 35px auto; padding: 35px 0 18px 0; background: #fff; box-shadow: 0 4px 13px #26326615; text-align: center; border-radius: 15px; max-width: 700px;}
      .icon.success { font-size:3em; color:#22bb33;}
      .icon.pending { font-size:3em; color:#f99c16;}
      .icon.cancelled { font-size:3em; color:#dd3030;}
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
}
.book-nav-btn.active, .book-nav-btn:hover {
    background: #ffd600;
    color: #263266;
}
      .order-summary, .address-block, .items-list, .totals-block{ background:#fff; border-radius:10px; box-shadow:0 2px 12px #26326613; margin:20px auto; max-width: 900px; padding:24px;}
      .cta-buttons { text-align:center; margin:34px 0 38px 0;}
      .cta-buttons a { margin:0 10px; font-weight:700; border-radius:10px; padding:10px 26px; background:linear-gradient(90deg,#ffd600 70%,#ffc107 100%); color:#263266; text-decoration:none; border:none;}
      .cta-buttons a.btn-secondary { background:#fafafa; color:#263266; border:1.5px solid #ffd600;}
      .cta-buttons a:hover { box-shadow:0 2px 8px #ffd60033;}
      table { width:100%; border-collapse:collapse; margin-top:18px;}
      th, td { padding:10px 7px; border-bottom:1px solid #e4e6ee; }
      th { background:#f5f6fb; }
      .progress { border-radius: 5px; padding: 10px; background: #f7fafc; text-align: center; margin-top: 10px; }
      .current { font-weight:800; color:#22bb33; margin-left:9px;}
      .cta-buttons a.btn-primary,
.cta-buttons button.btn-primary, /* <-- Style both */
.cta-action-btn {
    margin: 0 10px;
    font-weight: 700;
    border-radius: 10px;
    padding: 10px 26px;
    background: linear-gradient(90deg, #ffd600 70%, #ffc107 100%);
    color: #263266;
    text-decoration: none;
    border: none;
    box-shadow: 0 2px 8px #ffd60033;
    transition: background 0.18s, color 0.2s;
    font-size: 1em;
    outline: none;
}
.cta-buttons button.btn-primary:focus,
.cta-buttons button.btn-primary:hover,
.cta-buttons a.btn-primary:hover {
    background: #ffef81;
    color: #1a1f4d;
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
    color: #fff; 
}
      @media(max-width:700px){
        .order-summary, .address-block, .items-list, .totals-block, .order-timeline {padding:11px;}
        .hero-banner {padding:22px 0 9px 0;}
      }
    </style>
</head>
<body>
    <!-- Navbar -->
    <div class="navbar d-flex justify-content-between align-items-center">
        <div>
            <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZCHHvhgc3NLwTEkw4aJJ-IBU_H-F8J93cXQ&s" height="34" style="margin-right:12px;vertical-align:middle;" />
            <span class="logo">BOOKNEST</span>
            <a href="browseBooks" class="book-nav-btn">Home</a>
            <a href="browseBooks" class="book-nav-btn">Browse Books</a>
            <a href="MyOrders" class="book-nav-btn">My Orders</a>
            <a href="CartServlet" class="book-nav-btn">🛒 Cart</a>
        </div>
        <form id="logoutForm" action="<%= request.getContextPath() %>/LogoutServlet" method="post" style="display:inline;">
            <button type="submit" class="btn btn-warning fw-bold px-3 py-1" style="color:#263266;">Logout</button>
        </form>
    </div>

    <!-- Hero / Success Banner -->
    <div class="hero-banner">
        <c:choose>
            <c:when test="${order.status.name() == 'CONFIRMED'}">
                <div class="icon success">&#10004;</div>
                <h1 class="mb-2">Order Confirmed&nbsp;&mdash; Thanks for your purchase!</h1>
                <p>We’ve emailed your receipt to <c:out value="${order.buyer.email}"/>. Expect a response within 24 hours.</p>
            </c:when>
            <c:when test="${order.status.name() == 'PENDING'}">
                <div class="icon pending">&#9888;</div>
                <h1>Payment Pending&nbsp;&mdash; Awaiting Confirmation</h1>
                <p>Your order is waiting for payment. <a href="upiPayment.jsp?orderId=${order.id}">Resume Payment</a>. This session will expire soon.</p>
            </c:when>
            <c:when test="${order.status == 'CANCELLED'}">
                <div class="icon cancelled">&#10060;</div>
                <h1>Order Cancelled</h1>
                <p>If you think this is a mistake, contact support at <a href="mailto:support@booknest.example">support@booknest.example</a>.</p>
            </c:when>
        </c:choose>
    </div>

    <!-- Order Summary Block -->
    <div class="order-summary">
        <h2>Order Summary</h2>
        <div>
            <strong>Order ID:</strong> <c:out value="${order.id}"/>
            <br>
            <strong>Order Date:</strong><fmt:formatDate value="${createdAtDate}" pattern="yyyy-MM-dd HH:mm"/>
            <br>
            <strong>Status:</strong> <c:out value="${order.status}"/>
            <br>
            <strong>Payment Method:</strong> <c:out value="${order.paymentMethod}"/>
            <c:if test="${order.paymentMethod == 'UPI'}">
                <br>
                <strong>Transaction ID:</strong> <c:out value="${order.transactionId}"/>
            </c:if>
            <br>
                <strong>Estimated Delivery:</strong>
                <c:choose>
                    <c:when test="${delivery == 50.0}">
                         2–3 business days
                    </c:when>
                    <c:otherwise>
                         5–7 business days
                    </c:otherwise>
                </c:choose>
            <br>
            <strong>Contact:</strong> <span>support@booknest.example</span>
        </div>
    </div>

    <!-- Shipping / Billing Address Block -->
    <div class="address-block">
        <h2>Shipping Address</h2>
        <div>
            <c:out value="${order.buyer.fullname}"/><br>
            <c:out value="${order.address.line1}"/>, <c:out value="${order.address.city}"/><br>
            <c:out value="${order.address.state}"/>, <c:out value="${order.address.postal_code}"/><br>
            Phone: <c:out value="${order.buyer.phone}"/>
        </div>
    </div>

    <!-- Items List Block -->
    <div class="items-list">
        <h2>Items Purchased</h2>
        <table>
            <thead>
            <tr>
                <th>Image</th>
                <th>Title</th>
                <th>Author</th>
                <th>Edition/Condition</th>
                <th>Quantity</th>
                <th>Unit Price</th>
                <th>Line Total</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${order.order_items}">
                <tr>
                    <td>
                        <img src="${item.listing.imageUrls[0]}" alt="Book cover" style="width:50px;"/>
                    </td>
                    <td>
                        <a href="bookDetails"><c:out value="${item.listing.book.title}"/></a>
                    </td>
                    <td><c:out value="${item.listing.book.author}"/></td>
                    <td><c:out value="${item.listing.book.edition}"/>, <c:out value="${item.listing.conditionGrade}"/></td>
                    <td><c:out value="${item.quantity}"/></td>
                    <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₹"/></td>
                    <td><fmt:formatNumber value="${item.quantity * item.unitPrice}" type="currency" currencySymbol="₹"/></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Order Totals Block -->
    <div class="totals-block">
        <h2>Totals</h2>
        <div>
            <strong>Subtotal:</strong>
            <fmt:formatNumber value="${order.totalAmount - delivery}" type="currency" currencySymbol="₹"/>
            <br>
            <strong>Shipping:</strong>
            <fmt:formatNumber value="${delivery}" type="currency" currencySymbol="₹"/>
            <br>
            <strong>Grand Total:</strong>
            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₹"/>
        </div>
    </div>

    <!-- CTA Buttons Block -->
    <<div class="cta-buttons">
    <a href="myOrders.jsp" class="btn-primary">View My Orders</a>
    <a href="browseBooks" class="btn-secondary">Continue Shopping</a>
    <a href="InvoiceServlet?orderId=${order.id}" class="btn-secondary">Print/Download Invoice</a>
    <c:if test="${order.status.name() == 'PENDING'}">
        <form action="UpiPaymentServlet" method="post" style="display:inline;">
            <input type="hidden" name="orderId" value="${order.id}"/>
            <button type="submit" class="btn-primary cta-action-btn">Resume Payment</button>
        </form>
    </c:if>
</div>


    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2025 BookNest | All Rights Reserved</p>
        <p>
            <a href="browseBooks.jsp" class="text-light">Browse</a> | 
            <a href="MyOrders" class="text-light">My Orders</a> | 
            <a href="help.jsp" class="text-light">Help</a>
        </p>
    </footer>
</body>
</html>
