<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.User"%>
<%@ page import="java.util.*" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp"); return;
    }
    String activeRole = (String) session.getAttribute("activeRole");
    if (activeRole == null) { activeRole = "buyer"; session.setAttribute("activeRole", activeRole); }
    String selectedRole = request.getParameter("role");
    if (selectedRole != null && (selectedRole.equals("buyer") || selectedRole.equals("seller") || selectedRole.equals("donor"))) {
        activeRole = selectedRole; session.setAttribute("activeRole", activeRole);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>Profile - BOOKNEST</title>
<link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />
<style>
body {
    margin: 0;
    font-family: 'Segoe UI', Arial, sans-serif;
    background: #f6f7fb;
    color: #283593;
}
/* ------------ NAVBAR ------------ */
.navbar {
    display: flex; align-items: center; justify-content: space-between;
    padding: 15px 38px; background: #263266; color: #fff;
    box-shadow: 0 1px 10px 0 rgba(40,53,147,0.08);
    position: relative;
}
.logo {font-weight:800;font-size:1.6em;color:#ffd600;letter-spacing:2px;}
.navbar-center {
    position: absolute;
    left: 50%;
    top: 0; bottom: 0;
    transform: translateX(-50%);
    display: flex;
    align-items: center; height: 100%;
    width: 480px;
    z-index: 1;
}
.search-bar-large {
    width: 100%; max-width: 100%; padding: 13px 22px; font-size: 1.13rem;
    border-radius: 8px; border: none; outline: none; background: #fff;
    box-shadow: 0 2px 12px #28359318;
}
.navbar-controls {
    display: flex;
    align-items: center;
    gap: 13px;
    margin-left: 18px;
}
.role-selector {
    background: #fff; color: #263266;
    border-radius: 7px; border: none;
    font-size: 1em; font-weight: 600;
    padding: 7px 20px 7px 14px; margin-right: 4px;
    box-shadow: 0 2px 6px #26326618;
    cursor: pointer; appearance: none;
    transition: box-shadow 0.2s;
}
.role-selector:focus {box-shadow: 0 0 0 2px #ffd60088;}
.logout-btn {
    background: linear-gradient(90deg, #ffd600 70%, #ffc107 100%);
    color: #263266; border-radius:7px; border:none; font-weight:700; font-size:1em;
    padding:8px 21px; cursor:pointer; box-shadow:0 3px 12px #ffd60020;
    transition: background 0.2s, color 0.2s;
}
.logout-btn:hover { background:#ffef81;color:#111c37;}
/* ------------ LAYOUT BODY ------------ */
.page-row {
    display: flex; justify-content: flex-start; align-items: flex-start; margin: 0 auto; padding: 30px 14px 0 14px;
    max-width: 1300px; min-height: calc(100vh - 78px);
    gap:32px;
}
.sidebar {
    width: 295px; min-width:250px; max-width:340px; flex-shrink:0;
    display: flex; flex-direction: column; gap: 20px;
    align-items: flex-start;
    margin-left: 0.5rem;
}
.profile-card, .filters-card {
    background: #fff; border-radius: 18px; box-shadow: 0 6px 32px #28359317;
    margin-bottom: 0; padding: 27px 16px 21px 16px;
}
.profile-card { text-align: center;}
.profile-avatar {
    width: 72px; height: 72px; border-radius: 50%;
    margin: 0 auto 12px auto;
    background: linear-gradient(135deg,#dbeafe 60%,#e7f5ff 100%);
    display: flex; align-items: center; justify-content: center;
    font-size: 2em; color: #263266; font-weight: bold;
}
.profile-details { margin-bottom: 13px; color:#283593;}
.profile-details h2 { margin:0 0 13px 0; font-weight:800;}
.profile-details span { display:block;margin:6px 0;font-size:1.01em;color:#56577e;}
.profile-actions { margin-top:14px;}
.profile-actions button {
    margin: 0 7px 7px 7px; padding: 7px 17px; border-radius:7px; border:none;
    font-weight:700; font-size:1em; background:#263266; color:#ffd600;
    cursor:pointer; transition: background 0.2s,color 0.2s; box-shadow:0 2px 6px #2632660f;
}
.profile-actions button:hover { background:#ffd600;color:#192041;}
.filters-card h3 { margin:0 0 9px 0; color:#283593;font-size:1.08em; }
.filters-card ul {padding:0; margin:0 0 10px 0; list-style:none;}
.filters-card li {margin-bottom:8px;}
.filters-card label {cursor:pointer;user-select:none;}
.filters-card input[type=checkbox] {margin-right:4px;accent-color:#283593;}
.filter-row { display: flex; gap: 9px; margin-bottom:9px;}
.filters-card input[type=number] {width:62px;padding:5px 7px;border-radius:6px;border:1px solid #ccc;}
.filters-card select {border-radius:6px;padding:6px 10px;border:1px solid #ccc;font-size:1em;margin-top:7px;width:100%;}
/* ------------- MAIN CONTENT ------------- */
.main-content {flex:1 1 0px;min-width:0;display:flex;flex-direction:column;margin-left:0;}
.sort-bar {display:flex;justify-content:flex-end;margin-bottom:14px;}
.sort-bar select {border-radius:8px;padding:7px 13px;font-size:1em;border:1.5px solid #ccc;outline:none;}
.book-grid {
    display: grid; grid-template-columns: repeat(auto-fill,minmax(260px,1fr));
    gap:26px; width:100%;
}
.book-card {
    background: #fff; border-radius: 14px; box-shadow: 0 3px 15px #28359310;
    overflow:hidden; display:flex;flex-direction:column;
    padding-bottom: 17px; transition: transform 0.3s, box-shadow 0.3s;
    min-height:355px;
}
.book-card:hover { transform:scale(1.04); box-shadow:0 8px 40px #28359324;}
.book-cover { width:100%; height:168px; object-fit:contain; background:#f8f8f8; border-bottom:1px solid #f3f3f3;}
.book-info { padding:11px 15px 2px 15px; flex-grow:1;display:flex;flex-direction:column;}
.book-title {font-weight:700; color:#283593; font-size:1.08rem; margin-bottom:5px;}
.book-author {font-style:italic; color:#666; font-size:0.97rem; margin-bottom:7px;}
.book-price {font-weight:700; color:#fa6800; font-size:1.02rem;}
.book-condition {font-weight:600; color:#283593cc; font-size:0.93rem; margin-bottom:10px;}
.buy-btn {
    background-color: #ffc107; border: none; border-radius: 11px;
    padding: 8px 14px; font-weight: 700; font-size: 0.97rem; color: #283593; cursor: pointer;
    margin-top: 8px; box-shadow: 0 4px 13px #f8b40b99; transition: background 0.3s;
}
.buy-btn:hover { background-color: #ffcd39;}
/* -------- PAGINATION --------- */
.pagination {
    margin: 26px 0 17px 0;
    text-align: center;
    user-select: none;
}
.pagination button {
    margin: 0 5px;
    border: none;
    background: #283593cc;
    color: #fff;
    font-weight: 700;
    font-size: 1.09rem;
    padding: 8px 16px;
    border-radius: 9px;
    cursor: pointer;
    transition: background 0.3s;
}
.pagination button:disabled { background: #aaa; cursor: not-allowed;}
.pagination button:hover:not(:disabled) { background: #3f51b5; }
/* ------------ RESPONSIVENESS ------------ */
@media (max-width:1100px) {
    .navbar-center, .sidebar { position: static; left: unset; transform: none; width: 100%;}
    .page-row{flex-direction:column;gap:16px;padding:22px 7px 0 7px;}
    .main-content{width:99vw;}
}
@media (max-width:600px){
    .sidebar, .page-row, .main-content{flex-direction:column; gap: 8px;}
    .profile-card, .filters-card { margin-bottom: 10px; }
    .book-grid { grid-template-columns: 1fr; }
    .search-bar-large { width: 95vw; min-width: 135px;}
}
</style>
</head>
<body>
    <!-- NAVBAR -->
    <div class="navbar">
        <span class="logo">BOOKNEST</span>
        <div class="navbar-center">
            <form onsubmit="return false;" style="width:100%;margin:0;">
                <input class="search-bar-large" type="search" id="searchInput" placeholder="Search by title, author, or ISBN" aria-label="Search books" />
            </form>
        </div>
        <div class="navbar-controls">
            <form id="roleForm" method="get" action="profile.jsp" style="margin:0;">
                <select id="roleSelect" name="role" class="role-selector" onchange="document.getElementById('roleForm').submit()">
                    <option value="buyer" <%= "buyer".equals(activeRole) ? "selected" : "" %>>Buyer</option>
                    <option value="seller" <%= "seller".equals(activeRole) ? "selected" : "" %>>Seller</option>
                    <option value="donor" <%= "donor".equals(activeRole) ? "selected" : "" %>>Donor</option>
                </select>
            </form>
            <form id="logoutForm" action="<%= request.getContextPath() %>/LogoutServlet" method="post" style="display:inline;">
                 <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </div>
    <div class="page-row">
        <!-- --- SIDEBAR (Profile + Filters) --- -->
        <aside class="sidebar">
            <!-- Profile Card -->
            <div class="profile-card">
                <div class="profile-avatar"><%= user.getFullname().substring(0,1).toUpperCase() %></div>
                <div class="profile-details">
                    <h2><%= user.getFullname() %></h2>
                    <span><b>Email:</b> <%= user.getEmail() %></span>
                    <span><b>Contact:</b> <%= user.getPhone() %></span>
                </div>
                <div class="profile-actions">
                    <button onclick="location.href='editProfile.jsp'">Edit Profile</button>
                    <button onclick="location.href='changePassword.jsp'">Change Password</button>
                </div>
            </div>
            <!-- Filters Card -->
            <div class="filters-card">
                <h3>Categories</h3>
                <ul>
                    <li><label><input type="checkbox" name="category" value="Fiction">Fiction</label></li>
                    <li><label><input type="checkbox" name="category" value="Non-Fiction">Non-Fiction</label></li>
                    <li><label><input type="checkbox" name="category" value="Academic">Academic</label></li>
                    <li><label><input type="checkbox" name="category" value="Competitive Exams">Competitive Exams</label></li>
                    <li><label><input type="checkbox" name="category" value="Kids Books">Kids Books</label></li>
                </ul>
                <h3>Price Range</h3>
                <div class="filter-row">
                    <input type="number" placeholder="Min" min="0" />
                    <input type="number" placeholder="Max" min="0" />
                </div>
                <h3>Condition</h3>
                <select>
                    <option>All</option>
                    <option>New</option>
                    <option>Old</option>
                </select>
            </div>
        </aside>
        <!-- --- MAIN BOOK CONTENT --- -->
        <div class="main-content">
            <div class="sort-bar">
                <select id="sortSelect">
                    <option value="popularity">Sort by Popularity</option>
                    <option value="priceAsc">Price: Low to High</option>
                    <option value="priceDesc">Price: High to Low</option>
                    <option value="latest">Newest Arrivals</option>
                    <option value="rating">Rating</option>
                </select>
            </div>
            <section id="booksGrid" class="book-grid" aria-label="Book listings grid">
            <%
                class Book {
                    public String title, author, coverUrl, condition;
                    public double price;
                    public Book(String t,String a,String c,double p,String cond){
                        title=t; author=a; coverUrl=c; price=p; condition=cond;
                    }
                }
                List<Book> books = new ArrayList<>();
                books.add(new Book("Effective Java", "Joshua Bloch", "https://images-na.ssl-images-amazon.com/images/I/41OINFSaWYL._SX376_BO1,204,203,200_.jpg", 39.99, "New"));
                books.add(new Book("Clean Code", "Robert C. Martin", "https://images-na.ssl-images-amazon.com/images/I/41xShlnTZTL._SX374_BO1,204,203,200_.jpg", 29.99, "Old"));
                books.add(new Book("The Pragmatic Programmer", "Andrew Hunt", "https://images-na.ssl-images-amazon.com/images/I/41as+WafrFL._SX331_BO1,204,203,200_.jpg", 45.00, "New"));
                books.add(new Book("Introduction to Algorithms", "Cormen et al.", "https://images-na.ssl-images-amazon.com/images/I/41-MN91G9lL._SX396_BO1,204,203,200_.jpg", 55.00, "Old"));
                books.add(new Book("Harry Potter and the Sorcerer's Stone", "J.K. Rowling", "https://images-na.ssl-images-amazon.com/images/I/51UoqRAxwEL._SX331_BO1,204,203,200_.jpg", 24.50, "New"));
                for (Book book : books) {
            %>
                <article class="book-card" tabindex="0" aria-label="<%= book.title %> by <%= book.author %>">
                    <img src="<%= book.coverUrl %>" alt="Cover of <%= book.title %>" class="book-cover" />
                    <div class="book-info">
                        <h3 class="book-title"><%= book.title %></h3>
                        <p class="book-author">by <%= book.author %></p>
                        <p class="book-price">$<%= String.format("%.2f", book.price) %></p>
                        <p class="book-condition">Condition: <%= book.condition %></p>
                        <button class="buy-btn" type="button" onclick="alert('Buy feature coming soon!')">Buy</button>
                    </div>
                </article>
            <% } %>
            </section>
            <!-- PAGINATION (centered under the grid) -->
            <nav class="pagination" aria-label="Pagination navigation">
                <button disabled>&laquo; Prev</button>
                <button>1</button>
                <button>2</button>
                <button>3</button>
                <button>Next &raquo;</button>
            </nav>
        </div>
    </div>
</body>
</html>
