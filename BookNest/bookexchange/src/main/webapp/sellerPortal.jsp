<%@ page contentType="text/html;charset=UTF-8" language="java" import="model.User"%>
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
    // Handle role selection and redirect to corresponding portal immediately
    String selectedRole = request.getParameter("role");
    if (selectedRole != null && (selectedRole.equals("buyer") || selectedRole.equals("seller") 
            || selectedRole.equals("donor") || selectedRole.equals("admin"))) {
        activeRole = selectedRole;
        session.setAttribute("activeRole", selectedRole);
        response.sendRedirect(selectedRole + "Portal");
        return;
    }
    String bookType = request.getParameter("type");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>SELLER PORTAL - BOOKNEST</title>
  <link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />
  <style>
    body { background: #f6f7fb; color: #263266; font-family: 'Segoe UI', Arial, sans-serif; margin:0; }
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
    .navbar-left {
      display: flex;
      align-items: center;
      gap: 15px;
      flex-wrap: nowrap;
    }
    .brand-logo {
      height: 34px;
      width: auto;
      margin-right: 10px;
      cursor: pointer;
      vertical-align: middle;
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
      text-decoration: none;
    }
    .book-nav-btn.active, .book-nav-btn:hover {
      background: #ffd600;
      color: #263266;
      text-decoration: none;
    }
    .navbar-right {
      display: flex;
      align-items: center;
      gap: 18px;
    }
    .role-selector {
      background: #fff;
      color: #263266;
      border-radius: 7px;
      border: none;
      font-size: 1em;
      font-weight: 600;
      padding: 7px 20px 7px 14px;
      cursor: pointer;
      box-shadow: 0 2px 6px #26326618;
      transition: box-shadow 0.2s;
    }
    .role-selector:focus {
      box-shadow: 0 0 0 2px #ffd60088;
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
    .dashboard-header {
      background: #f2f7fb;
      border-radius: 14px;
      box-shadow: 0 4px 12px #20306013;
      margin: 38px auto 22px auto;
      padding: 34px 36px 22px 36px;
      max-width: 1100px;
      text-align: center;
    }
    .dashboard-header h1 {
      font-weight: 900; color: #263266; margin-bottom: 13px;
    }
    .dashboard-header .lead {
      color: #4260a3; font-size: 1.13em;
    }
    .quick-actions {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(235px,1fr));
      gap: 28px;
      max-width: 1080px;
      margin: 0 auto 40px auto;
    }
    .action-card {
      background: #fff;
      border-radius: 13px;
      box-shadow: 0 4px 14px #bac8ef25;
      padding: 22px 18px;
      text-align: center;
      transition: box-shadow 0.2s;
      position: relative;
      min-height: 175px;
    }
    .action-card:hover {
      box-shadow: 0 8px 22px #ffc107aa;
    }
    .action-icon {
      font-size: 2.25em;
      color: #ffd600;
      margin-bottom: 10px;
    }
    .action-title {
      font-weight: 800;
      font-size: 1.18em;
      color: #263266;
      margin-bottom: 7px;
    }
    .action-desc {
      color: #58688c;
      font-size: 1em;
      margin-bottom: 14px;
    }
    .action-btn {
      font-weight: 700;
      color: #263266;
      background: linear-gradient(90deg, #ffd600 70%, #ffc107 100%);
      border: none;
      border-radius: 9px;
      padding: 7px 21px;
      text-decoration: none;
      box-shadow: 0 2px 7px #ffd60045;
      transition: background 0.17s;
    }
    .action-btn:hover {
      background: #ffe876;
      color: #143266;
    }
    .stats-row {
      padding: 23px 14px 13px 14px;
      display: flex;
      justify-content: space-around;
      flex-wrap: wrap;
      margin: 20px auto 19px auto;
      background: #fff;
      border-radius: 12px;
      box-shadow: 0 3px 15px #e1e8fd33;
      max-width: 1060px;
      gap: 35px;
    }
    .stat-box {
      flex: 1 1 160px;
      text-align: center;
      background: #f7f9fc;
      border-radius: 9px;
      margin: 0 8px;
      padding: 17px 8px 7px 8px;
      box-shadow: 0 2px 7px #26326612;
    }
    .stat-label {
      font-size: 1em;
      color: #7b8daa;
      margin-bottom: 3px;
    }
    .stat-value {
      font-size: 2.1em;
      font-weight: 900;
      color: #263266;
    }
    .recent-table-block {
      margin: 34px auto 0 auto;
      max-width: 1060px;
      background: #fff;
      border-radius: 12px;
      box-shadow: 0 3px 14px #26326610;
      padding: 22px 19px 12px 19px;
    }
    .recent-table-block h4 {
      font-weight: 800;
      color: #263266;
    }
    .recent-table thead {
      background: #f5f6fb;
    }
    .recent-table th,
    .recent-table td {
      padding: 10px 12px;
    }
    .badge-status {
      font-weight: 700;
      border-radius: 7px;
      padding: 5px 14px;
      font-size: 0.97em;
    }
    .badge-DELIVERED {
      background: #e6ffe9;
      color: #21af49;
    }
    .badge-PENDING {
      background: #fff2cf;
      color: #d1a713;
    }
    .badge-SHIPPED {
      background: #e0ecff;
      color: #1685e6;
    }
    .badge-CANCELLED {
      background: #ffd7e0;
      color: #d22e67;
    }
    .dashboard-footer {
      background-color: #222;
      color: #fff;
      text-align: center;
      padding: 20px 0 12px 0;
      font-size: 15px;
      margin-top: 55px;
    }
    .dashboard-footer a {
      color: #ffd600;
      margin: 0 9px;
      transition: color 0.17s;
    }
    .dashboard-footer a:hover {
      text-decoration: underline;
      color: #ff97c1;
    }
    @media (max-width: 950px) {
      .quick-actions {
        grid-template-columns: 1fr 1fr;
      }
      .stats-row {
        flex-direction: column;
        align-items: center;
      }
      .stat-box {
        margin: 11px 0;
      }
    }
  </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
  <form id="filterForm" method="get" action="browseBooks" class="navbar-left">
    <img class="brand-logo" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZCHHvhgc3NLwTEkw4aJJ-IBU_H-F8J93cXQ&s" alt="BOOKNEST logo" />
    <span class="logo">BOOKNEST</span>
    
    <a href="sellerPortal" class="book-nav-btn">Home</a>
    <a href="MyOrders" class="book-nav-btn">Orders</a>
    <a href="MyListings" class="book-nav-btn">My Listings</a>
    <a href="Notifications" class="book-nav-btn">Alerts</a>

  </form>

  <div class="navbar-right">
    <form id="roleForm" method="get" action="profile.jsp" style="margin:0;">
      <select id="roleSelect" name="role" class="role-selector" onchange="document.getElementById('roleForm').submit()">
        <option value="buyer" <%= "buyer".equals(activeRole) ? "selected" : "" %>>Buyer</option>
        <option value="seller" <%= "seller".equals(activeRole) ? "selected" : "" %>>Seller</option>
        <option value="donor" <%= "donor".equals(activeRole) ? "selected" : "" %>>Donor</option>
        <option value="admin" <%= "admin".equals(activeRole) ? "selected" : "" %>>Admin</option>
      </select>
    </form>
    <form id="logoutForm" action="<%= request.getContextPath() %>/LogoutServlet" method="post" style="display:inline;">
      <button type="submit" class="logout-btn">Logout</button>
    </form>
  </div>
</div>

<!-- Dashboard Header -->
<div class="dashboard-header">
  <h1>Welcome, <c:out value="${sessionScope.user.fullname}"/>!</h1>
  <p class="lead">
    Here’s a quick overview of your selling activity.<br />
    <span style="color:#5d6ba8; font-size:0.99em"
      ><fmt:formatDate value="${now}" pattern="dd MMM yyyy" />,
      make today a great day! 🚀</span
    >
  </p>
</div>

<!-- Quick Actions Card Grid -->
<div class="quick-actions">
  <div class="action-card">
    <span class="action-icon"><i class="fa-solid fa-plus"></i></span>
    <div class="action-title">Create Listing</div>
    <div class="action-desc">Add a new book/product for sale.</div>
    <a href="CreateListingServlet" class="action-btn">Add New</a>
  </div>
  <div class="action-card">
    <span class="action-icon"><i class="fa-solid fa-book"></i></span>
    <div class="action-title">My Listings</div>
    <div class="action-desc">See and manage all your listed books.</div>
    <a href="myListings" class="action-btn">View All</a>
  </div>
  <div class="action-card">
    <span class="action-icon"><i class="fa-solid fa-shopping-cart"></i></span>
    <div class="action-title">Orders</div>
    <div class="action-desc">Process pending and completed orders.</div>
    <a href="sellerOrders.jsp" class="action-btn">See Orders</a>
  </div>
  <div class="action-card">
    <span class="action-icon"><i class="fa-solid fa-chart-line"></i></span>
    <div class="action-title">Analytics</div>
    <div class="action-desc">Track your sales & performance.</div>
    <a href="analytics.jsp" class="action-btn">View Charts</a>
  </div>
  <div class="action-card">
    <span class="action-icon"><i class="fa-solid fa-bell"></i></span>
    <div class="action-title">Notifications</div>
    <div class="action-desc">See new messages and alerts.</div>
    <a href="notifications.jsp" class="action-btn">Check Alerts</a>
  </div>
</div>

<!-- Summary Stats Row -->
<div class="stats-row">
  <div class="stat-box">
    <div class="stat-label">Total Listings</div>
    <div class="stat-value"><c:out value="${totalListings}"/></div>
  </div>
  <div class="stat-box">
    <div class="stat-label">Active Listings</div>
    <div class="stat-value"><c:out value="${activeListings}"/></div>
  </div>
  <div class="stat-box">
    <div class="stat-label">Pending Orders</div>
    <div class="stat-value"><c:out value="${pendingOrders}"/></div>
  </div>
  <div class="stat-box">
    <div class="stat-label">Completed Sales</div>
    <div class="stat-value"><c:out value="${completedSales}"/></div>
  </div>
  <div class="stat-box">
    <div class="stat-label">Earnings (₹)</div>
    <div class="stat-value"><fmt:formatNumber value="${totalEarnings}" type="currency" currencySymbol="₹"/></div>
  </div>
</div>

<!-- Recent Sales Table -->
<div class="recent-table-block">
  <h4>Recent Sales</h4>
  <c:choose>
    <c:when test="${not empty recentSales}">
      <table class="table recent-table mt-2">
        <thead>
          <tr>
            <th>Buyer</th>
            <th>Book Title</th>
            <th>Order Date</th>
            <th>Amount</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="sale" items="${recentSales}">
            <tr>
              <td><c:out value="${sale.buyer.fullname}"/></td>
              <td><c:out value="${sale.order_items[0].listing.book.title}"/></td>
              <td><fmt:formatDate value="${sale.createdAt}" pattern="dd MMM yyyy"/></td>
              <td><fmt:formatNumber value="${sale.totalAmount}" type="currency" currencySymbol="₹"/></td>
              <td>
                <span class="badge-status badge-${sale.status.name()}"><c:out value="${sale.status}"/></span>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:when>
    <c:otherwise>
      <div class="orders-empty">No recent sales to display.</div>
    </c:otherwise>
  </c:choose>
</div>
<!-- Footer -->
<div class="dashboard-footer">
  © 2025 BookExchange Portal | All Rights Reserved.
  <br />
  <a href="about.jsp">About Us</a> |
  <a href="contact.jsp">Contact Support</a> |
  <a href="terms.jsp">Terms & Conditions</a> |
  <a href="privacy.jsp">Privacy Policy</a>
</div>
</body>
</html>
