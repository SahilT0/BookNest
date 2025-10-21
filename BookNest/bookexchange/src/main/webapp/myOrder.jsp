<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.User" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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
    <title>My Orders - BOOKNEST</title>
    <link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
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
        
        .orders-header { background: #f2f7fb; padding: 35px 16px 16px 16px; text-align: center; border-radius: 15px; max-width: 960px; margin: 35px auto 18px auto; box-shadow: 0 4px 10px #28359310;}
        .orders-header h1 { font-weight: 800; color: #263266;}
        .orders-card, .orders-table { background:#fff; border-radius:10px; box-shadow:0 2px 15px #26326613; margin:0 auto 27px auto; max-width: 1260px; padding:24px;}
        .orders-table table { width:100%; border-collapse:collapse; }
        .orders-table th, .orders-table td { padding:12px 12px; border-bottom:1px solid #e0e3ec; font-size: 1.05em;}
        .orders-table th { background:#f5f6fb; text-align:left;}
        .badge-status { font-weight: 700; border-radius: 7px; padding: 5px 13px; font-size: .97em; }
        .badge-CONFIRMED, .badge-PAID, .badge-APPROVED { background: #e5fae5; color: #1abc37;}
        .badge-PENDING { background: #fffde0; color: #d1a713;}
        .badge-SHIPPED { background: #e4f2ff; color: #1669d9;}
        .badge-DELIVERED { background: #f4e5ff; color: #871ee7;}
        .badge-CANCELLED { background: #ffe5e5; color: #e11d48;}
        .badge-PACKED { background: #fdeee4; color: #e17a13;}
        .btn-action, .btn-invoice { padding:7px 19px; border-radius: 8px; font-weight:700; margin-right:6px; border:none;}
        .btn-action { background: #ffd600; color: #263266;}
        .btn-action:focus, .btn-action:hover { background: #ffef81;}
        .btn-invoice { background: #fafafa; color: #263266; border:1.5px solid #ffd600;}
        .btn-invoice:focus, .btn-invoice:hover { background: #fdec99;}
        .orders-empty { text-align:center; color:#757ba5; margin:54px 0 33px 0; }
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
</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <div>
            <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZCHHvhgc3NLwTEkw4aJJ-IBU_H-F8J93cXQ&s" height="34" style="margin-right:12px;vertical-align:middle;" />
            <span class="logo">BOOKNEST</span>
            <a href="buyerPortal" class="book-nav-btn">Home</a>
            <a href="browseBooks" class="book-nav-btn">Browse Books</a>
            <a href="MyOrders" class="book-nav-btn active">My Orders</a>
            <a href="CartServlet" class="book-nav-btn">🛒 Cart</a>
        </div>
        <form id="logoutForm" action="<%=request.getContextPath()%>/LogoutServlet" method="post" style="display:inline;">
            <button type="submit" class="btn-action">Logout</button>
        </form>
    </div>

    <!-- Banner/Header -->
    <div class="orders-header">
        <h1>My Orders</h1>
        <p>Track your order history, view order details, and download receipts.</p>
    </div>

    <div class="orders-table">
        <c:choose>
            <c:when test="${not empty orders}">
                <table>
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Payment</th>
                            <th>Total</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="order" items="${orders}" varStatus="status">
                        <tr>
                            <td>#ORD${order.id}</td>
                            <td>
                                <fmt:formatDate value="${orderDates[status.index]}" pattern="dd MMM yyyy"/>
                            </td>
                            <td>
                                <span class="badge-status badge-${order.status.name()}"><c:out value="${order.status}"/></span>
                            </td>
                            <td>
                                <c:out value="${order.paymentMethod}"/>
                            </td>
                            <td>
                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₹"/>
                            </td>
                            <td>
                                <a href="OrderDetails?orderId=${order.id}" class="btn-action">View Details</a>
                                <a href="InvoiceServlet?orderId=${order.id}" class="btn-invoice">Invoice</a>
                                <c:if test="${order.status.name() == 'PENDING'}">
                                    <form action="UpiPaymentServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="orderId" value="${order.id}"/>
                                        <button type="submit" class="btn-action">Resume Payment</button>
                                    </form>
                                    <form action="CancelOrderServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="orderId" value="${order.id}"/>
                                        <button type="submit" class="btn-invoice" onclick="return confirm('Cancel this order?');">Cancel</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="orders-empty">
                    <h4>You haven’t placed any orders yet.</h4>
                    <a href="browseBooks.jsp" class="btn-action mt-3">Browse Books</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <!-- Support Help Card (outside c:choose) -->
    <div class="orders-card" style="max-width:700px;text-align:center;margin-top:0;">
        <p>Need help with your order? Contact support at <a href="mailto:support@booknest.com">support@booknest.com</a></p>
    </div>
    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2025 BookNest. All Rights Reserved.</p>
        <p>
            <a href="aboutUs.jsp">About Us</a> |
            <a href="terms.jsp">Terms of Use</a> |
            <a href="privacy.jsp">Privacy Policy</a> |
            <a href="contact.jsp">Contact</a>
        </p>
    </footer>
</body>
</html>
