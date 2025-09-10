<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,model.User" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Buyer Portal - BOOKNEST</title>
    <link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            background: #f4f7fa;
            color: #333;
        }
        /* Navbar */
        .navbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #283593;
            padding: 13px 36px 13px 28px;
            box-shadow: 0 2px 8px rgba(40,53,147,0.13);
        }
        .logo {
            font-weight: 700;
            font-size: 1.7rem;
            color: #ffd600;
            letter-spacing: 2px;
        }
        .navbar-center {
            flex: 1;
            display: flex;
            justify-content: center;
            margin: 0 36px;
        }
        .search-bar-large {
            width: 450px;
            padding: 13px 22px;
            font-size: 1.15rem;
            border-radius: 8px;
            border: none;
            outline: none;
            background: #fff;
            transition: box-shadow 0.3s;
            box-shadow: 0 2px 12px #28359318;
        }
        .navbar-controls {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .role-dropdown {
            font-weight: 600;
            padding: 8px 20px;
            border-radius: 7px;
            border: none;
            cursor: pointer;
            font-size: 1rem;
            margin-right: 12px;
        }
        .logout-btn {
            background-color: #ffc107;
            border: none;
            padding: 8px 20px;
            border-radius: 7px;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            color: #283593;
            transition: background-color 0.3s;
        }
        .logout-btn:hover { background-color: #ffca28; }
        /* Portal layout */
        .portal-body {
            display: flex;
            max-width: 1350px;
            margin: 0 auto;
            padding: 32px 0 0 0;
            gap: 34px;
        }
        /* Sidebar: profile+filters left-aligned and tight */
        .sidebar {
            flex-basis: 25%;
            min-width: 260px;
            max-width: 320px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .profile-card, .filters-section {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 18px #28359313;
            margin-bottom: 0;
            padding: 25px 18px 16px 18px;
        }
        .profile-card {
            text-align: center;
            margin-bottom: 12px;
        }
        .profile-avatar {
            width: 66px; height: 66px;
            margin: 0 auto 9px auto;
            border-radius: 50%;
            background: #e3e7fa;
            font-size: 2.3em;
            color: #283593;
            font-weight: bold;
            display: flex; align-items: center; justify-content: center;
        }
        .profile-info {
            font-size: 1.09em;
            margin-bottom: 15px;
            color: #283593;
        }
        .profile-info span { display: block; color: #333; }
        .profile-btns button {
            margin: 7px 3px 0 3px;
            padding: 7px 14px;
            font-weight: 600;
            font-size: 1em;
            border-radius: 7px;
            border: none;
            background: #283593;
            color: #fff;
            cursor: pointer;
            transition: background 0.18s;
        }
        .profile-btns button:hover { background:#1d2766;}
        .filters-section h3 {
            margin-top: 2px;
            margin-bottom: 8px;
            color: #283593;
            font-weight: 700;
            font-size: 1.09em;
        }
        .filters-section ul { list-style: none; padding: 0; margin: 0 0 10px 0;}
        .filters-section li { margin-bottom: 8px; }
        .filters-section label { cursor: pointer; user-select: none; }
        .filters-section input[type=checkbox] { margin-right: 5px; accent-color: #283593; }
        .filter-row {
            display: flex;
            gap: 9px;
            margin-bottom: 8px;
        }
        .filters-section input[type=number] {
            width: 62px;
            padding: 5px 7px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        .filters-section select {
            border-radius: 6px;
            padding: 6px 10px;
            border: 1px solid #ccc;
            font-size: 1em;
            margin-top: 7px;
            width: 100%;
        }
        /* Main: book grid */
        .main-content {
            flex-basis: 75%;
            min-width: 0;
            display: flex;
            flex-direction: column;
        }
        .sort-bar {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 10px;
        }
        .sort-bar select {
            border-radius: 8px;
            padding: 7px 13px;
            font-size: 1em;
            border: 1.5px solid #ccc;
            outline: none;
        }
        .book-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(270px,1fr));
            gap: 28px;
        }
        .book-card {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 3px 15px #28359319;
            overflow: hidden;
            display: flex; flex-direction: column;
            padding-bottom: 17px;
            transition: transform 0.3s, box-shadow 0.3s;
            height: 350px;
        }
        .book-card:hover {
            transform: scale(1.035);
            box-shadow: 0 7px 36px #28359345;
        }
        .book-cover {
            width: 100%; height: 175px;
            object-fit: contain;
            background: #f8f8f8;
            border-bottom: 1px solid #f3f3f3;
        }
        .book-info {
            padding: 11px 15px 2px 15px;
            flex-grow: 1;
            display: flex; flex-direction: column;
        }
        .book-title { font-weight: 700; color: #283593; font-size: 1.10rem; margin-bottom: 6px; }
        .book-author { font-style: italic; color: #666; font-size: 0.97rem; margin-bottom: 7px; }
        .book-price { font-weight: 700; color: #fa6800; font-size: 1.02rem; }
        .book-condition { font-weight: 600; color: #283593cc; font-size: 0.92rem; margin-bottom: 10px;}
        .buy-btn {
            background-color: #ffc107; border: none; border-radius: 11px;
            padding: 8px 14px; font-weight: 700; font-size: 0.97rem; color: #283593; cursor: pointer;
            margin-top: 8px; box-shadow: 0 4px 13px #f8b40b99; transition: background 0.3s;
        }
        .buy-btn:hover { background-color: #ffcd39; }
        /* Pagination at bottom, centered */
        .pagination {
            margin: 30px 0 25px 0;
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
        .pagination button:disabled { background: #aaa; cursor: not-allowed; }
        .pagination button:hover:not(:disabled) { background: #3f51b5; }
        @media (max-width: 1024px) {
            .portal-body { flex-direction: column; padding: 22px 6px 0 6px;}
            .sidebar { max-width: 100vw; flex-direction: row; gap: 16px; }
            .main-content { max-width: 100vw; }
        }
        @media (max-width:640px){
            .sidebar, .portal-body, .main-content { flex-direction: column; gap: 12px;}
            .profile-card, .filters-section { margin-bottom: 16px; }
            .book-grid { grid-template-columns: 1fr; }
            .search-bar-large {width: 99vw; min-width: 195px;}
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <span class="logo">BOOKNEST</span>
        <div class="navbar-center">
            <form onsubmit="return false;" style="width: 100%;">
                <input class="search-bar-large" type="search" id="searchInput" placeholder="Search by title, author, or ISBN" aria-label="Search books" />
            </form>
        </div>
        <div class="navbar-controls">
            <form id="roleForm" method="get" action="profile.jsp">
                <select name="role" class="role-dropdown" onchange="document.getElementById('roleForm').submit()">
                    <option value="buyer" selected>Buyer</option>
                    <option value="seller">Seller</option>
                    <option value="donor">Donor</option>
                </select>
            </form>
            <form id="logoutForm" action="<%= request.getContextPath() %>/LogoutServlet" method="post" style="display:inline;">
                 <button type="submit" class="logout-btn">Logout</button>
            </form>
            
        </div>
    </div>

    <div class="portal-body">
        <!-- Sidebar -->
        <aside class="sidebar">
            <!-- Profile Card -->
            <div class="profile-card">
                <div class="profile-avatar"><%= user.getFullname().substring(0,1).toUpperCase() %></div>
                <div class="profile-info">
                    <strong><%= user.getFullname() %></strong>
                    <span><b>Email:</b> <%= user.getEmail() %></span>
                    <span><b>Contact:</b> <%= user.getPhone() != null ? user.getPhone() : "Not set" %></span>
                </div>
                <div class="profile-btns">
                    <button onclick="location.href='editProfile.jsp'">Edit Profile</button>
                    <button onclick="location.href='changePassword.jsp'">Change Password</button>
                </div>
            </div>
            <!-- Filters and Categories -->
            <div class="filters-section">
                <h3>Categories</h3>
                <ul>
                    <li><label><input type="checkbox" name="category" value="Fiction"> Fiction</label></li>
                    <li><label><input type="checkbox" name="category" value="Non-Fiction"> Non-Fiction</label></li>
                    <li><label><input type="checkbox" name="category" value="Academic"> Academic</label></li>
                    <li><label><input type="checkbox" name="category" value="Competitive Exams"> Competitive Exams</label></li>
                    <li><label><input type="checkbox" name="category" value="Kids Books"> Kids Books</label></li>
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
        <!-- Main Content: Books -->
        <main class="main-content">
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
                // Static sample book data
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
            <!-- Pagination below grid, centered -->
            <nav class="pagination" aria-label="Pagination navigation">
                <button disabled>&laquo; Prev</button>
                <button>1</button>
                <button>2</button>
                <button>3</button>
                <button>Next &raquo;</button>
            </nav>
        </main>
    </div>
</body>
</html>
