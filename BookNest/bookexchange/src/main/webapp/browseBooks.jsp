<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.User" isELIgnored="false" %>
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
    String bookTypeParam = request.getParameter("type");
    String searchParam = request.getParameter("search");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>BROWSE BOOKS - BOOKNEST</title>
<link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
    background: #f6f7fb;
    color: #263266;
    font-family: 'Segoe UI', Arial, sans-serif;
    margin: 0;
    min-height: 100vh;
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

.page-row {
    margin: 0;
    display: flex;
    flex-direction: row;
    align-items: flex-start;
    min-height: 88vh;
    gap: 32px;
    padding: 30px 20px 0 20px;
    max-width: 1900px;
}

.sidebar {
    min-width: 310px;
    max-width: 350px;
    padding-right: 10px;
}

.filters-card {
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 4px 20px rgba(38, 50, 102, 0.10);
    padding: 22px;
    margin-bottom: 24px;
}
.filters-card h3 {
    font-size: 1.15rem;
    font-weight: 750;
    color: #263266;
    margin-bottom: 10px;
    border-bottom: 2px solid #ffd60044;
    padding-bottom: 6px;
}
.filters-card ul {
    list-style: none;
    margin-bottom: 17px;
    margin-top: 2px;
    padding-left: 0;
}
.filters-card li label {
    color: #444a77;
    font-size: .95rem;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 6px;
    margin-bottom: 2px;
}
.filter-row {
    display: flex;
    gap: 8px;
    margin-bottom: 16px;
}
.filters-card input[type="number"], .filters-card input[type="search"] {
    border-radius: 8px;
    border: 1.4px solid #ccc;
    background: #fafafc;
    padding: 7px;
    font-size: .98em;
}
.filters-card input[type="checkbox"] {
    accent-color: #ffd600;
    margin-right: 7px;
}

/* Main Content */
.main-content {
    flex: 1 1 0px;
    min-width: 0;
    display: flex;
    flex-direction: column;
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 4px 22px 0 #28359313;
    padding: 30px 24px 32px 24px;
}
.sort-bar {
    display: flex;
    justify-content: flex-end;
    margin-bottom: 18px;
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

.pagination {
    display: flex;
    justify-content: center;
    gap: 10px;
    margin: 26px 0 7px 0;
}
.pagination button, .pagination .page-link {
    border: none;
    background: #fff;
    border-radius: 10px;
    padding: 8px 14px;
    font-weight: 700;
    font-size: 0.95rem;
    color: #263266;
    box-shadow: 0 3px 10px rgba(38, 50, 102, 0.15);
    cursor: pointer;
    transition: background 0.18s, color 0.18s;
}
.pagination button.active, .pagination .active>.page-link {
    background: #ffd600;
    color: #1a1f4d;
}
.pagination button:hover {
    background: #ffd600;
    color: #263266;
    transform: translateY(-2px);
}

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

/* Responsive layout */
@media (max-width: 1200px) {
    .page-row { flex-direction: column; gap:18px;}
    .sidebar { max-width: 100%; min-width: 185px; margin-bottom:22px;}
    .main-content { padding: 13px 4vw 22px 4vw; }
}
@media (max-width: 700px){
    .book-grid { grid-template-columns: 1fr; }
    .main-content { padding: 8px 5vw 15px 5vw;}
    .navbar, .footer { padding-left: 10px; padding-right: 10px;}
}
</style>

</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <form id="filterForm" method="get" action="browseBooks" class="navbar-left">
            <img class="brand-logo" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZCHHvhgc3NLwTEkw4aJJ-IBU_H-F8J93cXQ&s" alt="BOOKNEST logo">
            <span class="logo">BOOKNEST</span>
        
            <button type="submit" name="type" value="" class="book-nav-btn ${empty typeParam ? 'active' : ''}">All Books</button>
            <button type="submit" name="type" value="NEW" class="book-nav-btn ${typeParam == 'NEW' ? 'active' : ''}">New Books</button>
            <button type="submit" name="type" value="OLD" class="book-nav-btn ${typeParam == 'OLD' ? 'active' : ''}">Old Books</button>
            <button type="submit" name="type" value="DONATION" class="book-nav-btn ${typeParam == 'DONATION' ? 'active' : ''}">Donated Books</button>

            <a href="MyOrders" class="book-nav-btn">My Orders</a>
            <a href="CartServlet" class="book-nav-btn">🛒 Cart</a>

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
        <!-- Sidebar: Filters only -->
        <aside class="sidebar">
            <div class="filters-card">
                <form id="filters" action="browseBooks" method="get">
                    <h3>Search Books</h3>
                    <input type="search" class="form-control mb-3" name="search" placeholder="Title, Author or ISBN" value="${searchParam}" onkeydown="if(event.key==='Enter'){this.form.submit();}"/>
                    <h3>Categories</h3>
                    <ul>
                        <li><label><input type="checkbox" name="category" value="Fiction" form="filters" onchange="this.form.submit()" <c:if test="${categoriesParam.contains('Fiction')}">checked</c:if>> Fiction</label></li>
                        <li><label><input type="checkbox" name="category" value="Non-Fiction" form="filters" onchange="this.form.submit()" <c:if test="${categoriesParam.contains('Non-Fiction')}">checked</c:if>> Non-Fiction</label></li>
                        <li><label><input type="checkbox" name="category" value="Academic" form="filters" onchange="this.form.submit()" <c:if test="${categoriesParam.contains('Academic')}">checked</c:if>> Academic</label></li>
                        <li><label><input type="checkbox" name="category" value="Competitive Exams" form="filters" onchange="this.form.submit()" <c:if test="${categoriesParam.contains('Competitive Exams')}">checked</c:if>> Comp. Exams</label></li>
                        <li><label><input type="checkbox" name="category" value="Kids Books" form="filters" onchange="this.form.submit()" <c:if test="${categoriesParam.contains('Kids Books')}">checked</c:if>> Kids Books</label></li>
                    </ul>
                    <h3>Price Range</h3>
                    <div class="filter-row">
                        <input type="number" class="form-control" name="minPrice" placeholder="Min" value="${minPriceParam}" min="0"/>
                        <input type="number" class="form-control" name="maxPrice" placeholder="Max" value="${maxPriceParam}" min="0"/>
                    </div>
                    <h3>Condition</h3>
                    <ul>
                        <li><label><input type="checkbox" name="type" value="NEW" form="filters" ${typeParam == 'NEW' ? 'checked' : ''} onchange="this.form.submit()"/> New</label></li>
                        <li><label><input type="checkbox" name="type" value="OLD" form="filters" ${typeParam == 'OLD' ? 'checked' : ''} onchange="this.form.submit()"/> Old</label></li>
                        <li><label><input type="checkbox" name="type" value="DONATION" form="filters" ${typeParam == 'DONATION' ? 'checked' : ''} onchange="this.form.submit()"/> Donated</label></li>
                    </ul>
                    <button type="submit" class="buy-btn mt-3">Apply Filters</button>
                </form>
            </div>
        </aside>

        <!-- Main Book Grid and Sort Bar -->
        <div class="main-content">
            <div class="sort-bar">
                <form id="sortForm" method="get" action="browseBooks">
                    <!-- Pass all filters along with sort -->
                    <input type="hidden" name="type" value="${typeParam}" />
                    <input type="hidden" name="search" value="${searchParam}"/>
                    <select name="sort" class="form-select w-auto d-inline-block" style="min-width: 220px;" onchange="this.form.submit()">
                        <option value="popularity" ${sortParam == 'popularity' ? 'selected' : ''}>Sort by Popularity</option>
                        <option value="priceAsc" ${sortParam == 'priceAsc' ? 'selected' : ''}>Price: Low to High</option>
                        <option value="priceDesc" ${sortParam == 'priceDesc' ? 'selected' : ''}>Price: High to Low</option>
                        <option value="latest" ${sortParam == 'latest' ? 'selected' : ''}>Newest Arrivals</option>
                    </select>
                </form>
            </div>
            <section id="booksGrid" class="book-grid" aria-label="Book listings grid">
                <c:forEach var="book" items="${booksList}">
                    <article class="book-card" tabindex="0" aria-label="${book.book.title} by ${book.book.author}">
                        <img src="${book.imageUrls[0]}" alt="Cover of ${book.book.title}" class="book-cover" />
                        <div class="book-info">
                            <h3 class="book-title">${book.book.title}</h3>
                            <p class="book-author">by ${book.book.author}</p>
                            <p class="book-price">₹${book.price}</p>
                            <p class="book-condition">Condition: ${book.conditionGrade}</p>
                            <button class="buy-btn" type="button" onclick="window.location.href='bookDetails?id=${book.id}'">View</button>
                        </div>
                    </article>
                </c:forEach>
            </section>
            <!-- PAGINATION (centered under the grid) -->
            <nav class="pagination" aria-label="Pagination navigation">
                <button type="submit" form="filterForm" name="page" value="${currentPage > 1 ? currentPage - 1 : 1}" ${currentPage == 1 ? "disabled" : ""}>&laquo; Prev</button>
                <c:forEach var="p" items="${pageNumbers}">
                <button type="submit" form="filterForm" name="page" value="${p}" class="${currentPage == p ? 'active' : ''}">${p}</button>
                </c:forEach>
                <button type="submit" form="filterForm" name="page" value="${currentPage < totalPages ? currentPage + 1 : totalPages}" ${currentPage == totalPages ? "disabled" : ""}>Next &raquo;</button>
            </nav>
        </div>
    </div>
    <!-- Footer -->
    <footer class="footer">
       <p>&copy; 2025 BookNest | All Rights Reserved</p>
       <p><a href="browseBooks" class="text-light">Browse</a> | 
       <a href="MyOrders" class="text-light">My Orders</a> | 
       <a href="help.jsp" class="text-light">Help</a></p>
    </footer>
</body>
</html>
