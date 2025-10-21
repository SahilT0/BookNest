<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.User" import="model.Book" isELIgnored="false" import="model.BookImage" import="DAO.BookDao"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
        response.sendRedirect(selectedRole + "Portal.jsp");
        return;
    }
    String bookType = request.getParameter("type");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>BUYER PORTAL - BOOKNEST</title>
<link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />
 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
    margin: 0;
    font-family: 'Segoe UI', Arial, sans-serif;
    background: #f6f7fb;
    color: #283593;
}
/* ------------ NAVBAR ------------ */
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
/* Left side: book filter buttons */
.navbar-left {
    display: flex;
    align-items: center;
    gap: 15px;
    flex-wrap: nowrap;
}
#searchInput {
    min-width: 350px;
    max-width: 380px;
    flex-shrink: 0;
    margin-left: 150px;
    transition: box-shadow 0.3s ease;
}

#searchInput:focus {
    box-shadow: 0 0 10px 3px #ffd600aa;
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
/* Right side: role selector and logout */
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
/* -------- PROFILE CARD -------- */
.profile-card {
    background: linear-gradient(135deg, #ffffff, #f9f9ff);
    border-radius: 18px;
    padding: 25px 20px;
    text-align: center;
    box-shadow: 0 6px 22px rgba(38, 50, 102, 0.15);
    margin-bottom: 28px;
    transition: transform 0.25s ease, box-shadow 0.25s ease;
}
.profile-card:hover {
    transform: translateY(-6px);
    box-shadow: 0 10px 35px rgba(38, 50, 102, 0.25);
}
.profile-avatar {
    width: 75px;
    height: 75px;
    border-radius: 50%;
    background: #263266;
    color: #ffd600;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 2rem;
    font-weight: 800;
    margin: 0 auto 14px auto;
    box-shadow: 0 4px 14px rgba(38, 50, 102, 0.25);
}
.profile-details h2 {
    font-size: 1.35rem;
    font-weight: 800;
    margin: 5px 0 10px 0;
    color: #263266;
}
.profile-details span {
    display: block;
    font-size: 0.95rem;
    color: #4a4e87;
    margin-bottom: 4px;
}
.profile-actions {
    margin-top: 15px;
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
    justify-content: center;
}
.profile-actions button {
    background: #ffd600;
    border: none;
    border-radius: 10px;
    padding: 8px 14px;
    font-weight: 700;
    font-size: 0.95rem;
    color: #263266;
    cursor: pointer;
    box-shadow: 0 3px 10px rgba(255, 214, 0, 0.35);
    transition: background 0.2s, transform 0.2s;
}
.profile-actions button:hover {
    background: #ffe876;
    transform: translateY(-2px);
}

/* ---- MAIN LAYOUT/BOX ---- */
.page-row {
    display: flex;
    justify-content: flex-start;
    align-items: flex-start;
    margin: 0 50px;
    max-width: 2500px;
    min-height: calc(100vh - 78px);
    gap: 32px;
    padding: 40px 20px 0 20px;        /* uniform and more generous spacing */
    background: #f6f7fb;
}

.main-content {
    flex: 1 1 0px;
    min-width: 0;
    display: flex;
    flex-direction: column;
    margin-left: 100px;
    padding: 30px 22px 32px 22px;     /* internal padding for breathing room */
    background: #fff;
    border-radius: 18px;
    box-shadow: 0 4px 32px #28359313;
    min-height: 720px;                /* keeps content box tall even with few books */
}

/* Search bar styling */
#searchInput {
    transition: box-shadow 0.3s ease;
}
#searchInput:focus {
    box-shadow: 0 0 10px 3px #ffd600aa;
}

/* ---- BOOKS GRID ---- */
.main-content h2 {
    text-align: center;
    font-size: 2.25rem;
    font-weight: 850;
    color: #263266;
    margin-bottom: 34px;
    margin-top: 8px;
    letter-spacing: 1px;
    /* Style with subtle gradient underline */
    position: relative;
    background: linear-gradient(90deg, #ffd600 10%, #ffc107 90%);
    background-clip: text;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

.main-content h2::after {
    content: "";
    display: block;
    margin: 12px auto 0 auto;
    width: 72px;
    height: 4px;
    border-radius: 2px;
    background: linear-gradient(90deg, #ffec9f 0%, #ffd600 60%, #283593 100%);
    opacity: 0.85;
}


.book-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
    gap: 27px;                       /* increased gap for breathing room */
    width: 100%;
    margin-bottom: 30px;
}

.book-card {
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 4px 22px 0 #28359313, 0 1.5px 4px #5a649e13;
    display: flex;
    flex-direction: column;
    min-height: 340px;
    transition: transform 0.2s, box-shadow 0.2s;
    padding-bottom: 12px;
    overflow: hidden;
    border: 1px solid #ebecff;
    position: relative;
}
.book-card:hover {
    transform: scale(1.03);
    box-shadow: 0 10px 40px #26326628;
    border-color: #ffd600;
}
.book-cover {
    width: 100%;
    height: 160px;
    object-fit: contain;
    background: #f8f8f8;
    border-bottom: 1px solid #f3f3f3;
}
.book-info {
    padding: 13px 16px 0 16px;
    display: flex;
    flex-direction: column;
    flex-grow: 1;
}

.book-title {
    color: #263266;
    font-size: .95rem;
    font-weight: 750;
    margin-bottom: 4px;
    line-height: 1.27;
    height: 38px; overflow: hidden;
    text-overflow: ellipsis;
}
.book-author {
    font-style: italic;
    color: #58598d;
    font-size: 1rem; margin-bottom: 4px;
    height: 24px; overflow: hidden;
}
.book-price {
    font-weight: 700;
    color: #fa6800;
    font-size: 1.09rem;
    margin-top: 3px;
}
.book-condition {
    font-weight: 600;
    color: #283593b0;
    font-size: 0.99rem;
    margin: 8px 0 0 0;
}

.buy-btn {
    background: linear-gradient(90deg,#ffd600 70%,#ffc107 100%);
    border: none;
    border-radius: 12px;
    padding: 9px 0;
    font-weight: 700;
    font-size: 1.02rem;
    color: #1d216d;
    cursor: pointer;
    margin-top: auto;
    box-shadow: 0 3px 12px #f8b40b56;
    width: 100%;
    transition: background 0.18s, color 0.22s;
}
.buy-btn:hover {
    background: #ffe876;
    color: #263266;
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
}


/* Responsive */
@media (max-width:1100px) {
    .page-row, .sidebar, .main-content { flex-direction: column; }
    .main-content { width: 100%; margin-left: 0; padding: 13px 5vw 32px 5vw;}
    .sidebar { width: 100%; max-width: 100%; margin-left: 0;}
}
@media (max-width:700px){
    .book-grid { grid-template-columns: 1fr; }
    .main-content { padding: 12px 3vw 20px 3vw;}
}

.logout-btn {
    background: linear-gradient(90deg, #ffd600 70%, #ffc107 100%);
    color: #263266; 
    border-radius: 7px; 
    border: none; 
    font-weight: 700; 
    font-size: 1em;
    padding: 8px 21px;
    cursor: pointer; 
    box-shadow: 0 3px 12px #ffd60020;
    transition: background 0.2s, color 0.2s;
}
.logout-btn:hover {
    background: #ffef81;
    color: #111c37;
}

/* ------------- KEEP EXISTING YOUR CSS ------------- */
/* Page row, sidebar, profile-card, main-content etc. assumed same */
/* Keep your existing CSS here as you provided */

</style>
</head>
<body>
    <!-- NAVBAR -->
    <div class="navbar">
        <form id="filterForm" method="get" action="browseBooks" class="navbar-left">
            <img class="brand-logo" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZCHHvhgc3NLwTEkw4aJJ-IBU_H-F8J93cXQ&s" alt="BOOKNEST logo">
            <span class="logo">BOOKNEST</span>
        
            <button type="submit" name="type" value="" class="book-nav-btn ${empty typeParam ? 'active' : ''}">All Books</button>
            <button type="submit" name="type" value="NEW" class="book-nav-btn ${typeParam == 'NEW' ? 'active' : ''}">New Books</button>
            <button type="submit" name="type" value="OLD" class="book-nav-btn ${typeParam == 'OLD' ? 'active' : ''}">Old Books</button>
            <button type="submit" name="type" value="DONATION" class="book-nav-btn ${typeParam == 'DONATION' ? 'active' : ''}">Donated Books</button>
            <a href="MyOrders" class="book-nav-btn">My Orders</a>

            <input type="search" id="searchInput" name="search" placeholder="Search by title, author, or ISBN"
                value="${searchParam}" onkeydown="if(event.key==='Enter'){this.form.submit();}"/>
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
        </aside>
        
        <!-- --- MAIN BOOK CONTENT --- -->
        <div class="main-content">
            <h2>Newest Arrivals</h2>
            <section id="booksGrid" class="book-grid" aria-label="Book listings grid">
                <c:forEach var="book" items="${booksList}">
                    <article class="book-card" tabindex="0" aria-label="${book.book.title} by ${book.book.author}">
                         <img src="${book.imageUrls[0]}" alt="Cover of ${book.book.title}" class="book-cover" />
                         <div class="book-info">
                             <h3 class="book-title">${book.book.title}</h3>
                             <p class="book-author">by ${book.book.author}</p>
                             <p class="book-price">₹${book.price}</p>
                             <p class="book-condition">Condition: ${book.conditionGrade}</p>
                             <button class="buy-btn" type="button" onclick="window.location.href='bookDetails?id=${book.book.id}'">View</button>
                         </div>
                         
                    </article>
                </c:forEach>
            </section>
        </div>
    </div>
    
    <!-- FOOTER -->
    <footer class="footer">
       <p>&copy; 2025 BookNest | All Rights Reserved</p>
       <p><a href="buyerPortal" class="text-light">Home</a> | 
       <a href="browseBooks" class="text-light">Browse</a> | 
       <a href="MyOrders" class="text-light">My Orders</a> | 
       <a href="help.jsp" class="text-light">Help</a></p>
    </footer>

</body>
</html>
