<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Buyer Portal - BookNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f7f9fc; }
        .navbar { background-color: #0d1b4c; }
        .navbar-brand, .nav-link, .navbar-text { color: #fff !important; }
        .profile-card, .filter-card { background: #fff; border-radius: 10px; padding: 20px; margin-bottom: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .book-card { border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .book-card img { height: 200px; object-fit: cover; border-top-left-radius: 10px; border-top-right-radius: 10px; }
        .footer { background-color: #0d1b4c; color: #fff; padding: 15px 0; text-align: center; margin-top: 40px; }
    </style>
</head>
<body>

<!-- ✅ Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="buyerPortal.jsp">BOOKNEST</a>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item"><a class="nav-link" href="buyerPortal.jsp">All Books</a></li>
        <li class="nav-item"><a class="nav-link" href="browseBooks.jsp?type=new">New Books</a></li>
        <li class="nav-item"><a class="nav-link" href="browseBooks.jsp?type=old">Old Books</a></li>
        <li class="nav-item"><a class="nav-link" href="browseBooks.jsp?type=donated">Donated Books</a></li>
        <li class="nav-item"><a class="nav-link" href="myOrders.jsp">My Orders</a></li>
      </ul>
      <!-- Search bar -->
      <form class="d-flex me-2">
        <input class="form-control" type="search" placeholder="Search by title, author, or ISBN">
      </form>
      <!-- Role selector -->
      <select class="form-select me-2">
        <option>Buyer</option>
        <option>Seller</option>
      </select>
      <!-- Logout -->
      <a href="logout" class="btn btn-warning">Logout</a>
    </div>
  </div>
</nav>

<div class="container-fluid mt-4">
  <div class="row">
    
    <!-- ✅ Left Sidebar (Profile + Filters) -->
    <div class="col-md-3">
      <!-- Profile Card -->
      <div class="profile-card text-center">
        <div class="mb-3">
          <div class="rounded-circle bg-warning text-dark fw-bold d-inline-flex align-items-center justify-content-center" style="width:60px; height:60px; font-size:24px;">
            <c:out value="${sessionScope.currentUser.name.charAt(0)}" />
          </div>
        </div>
        <h5><c:out value="${sessionScope.currentUser.name}" /></h5>
        <p>Email: <c:out value="${sessionScope.currentUser.email}" /></p>
        <p>Contact: <c:out value="${sessionScope.currentUser.contact}" /></p>
        <button class="btn btn-warning btn-sm">Edit Profile</button>
        <button class="btn btn-warning btn-sm mt-2">Change Password</button>
      </div>

      <!-- Categories -->
      <div class="filter-card">
        <h6>Categories</h6>
        <div>
          <input type="checkbox" id="fiction"> Fiction <br>
          <input type="checkbox" id="non-fiction"> Non-Fiction <br>
          <input type="checkbox" id="academic"> Academic <br>
          <input type="checkbox" id="competitive"> Competitive Exams <br>
          <input type="checkbox" id="kids"> Kids Books
        </div>
      </div>

      <!-- Price Range -->
      <div class="filter-card">
        <h6>Price Range</h6>
        <div class="d-flex">
          <input type="number" class="form-control me-2" placeholder="Min">
          <input type="number" class="form-control" placeholder="Max">
        </div>
      </div>
    </div>

    <!-- ✅ Right Content (Book Listings) -->
    <div class="col-md-9">
      
      <!-- Sort Dropdown -->
      <div class="d-flex justify-content-end mb-3">
        <select class="form-select w-auto">
          <option>Sort by Popularity</option>
          <option>Price: Low to High</option>
          <option>Price: High to Low</option>
          <option>Newest First</option>
        </select>
      </div>

      <!-- Book Cards -->
      <div class="row">
        <c:forEach var="book" items="${books}">
          <div class="col-md-4 mb-4">
            <div class="card book-card">
              <img src="images/${book.image}" alt="Cover of ${book.title}" class="card-img-top">
              <div class="card-body">
                <h6 class="card-title">${book.title}</h6>
                <p class="card-text text-muted">by ${book.author}</p>
                <p class="text-danger fw-bold">₹${book.price}</p>
                <p>Condition: ${book.condition}</p>
                <form action="CartServlet" method="post">
                  <input type="hidden" name="bookId" value="${book.id}">
                  <input type="hidden" name="action" value="add">
                  <button type="submit" class="btn btn-warning w-100">Buy</button>
                </form>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>

      <!-- Pagination -->
      <nav>
        <ul class="pagination justify-content-center">
          <li class="page-item"><a class="page-link" href="#">&laquo; Prev</a></li>
          <li class="page-item"><a class="page-link" href="#">1</a></li>
          <li class="page-item"><a class="page-link" href="#">2</a></li>
          <li class="page-item"><a class="page-link" href="#">3</a></li>
          <li class="page-item"><a class="page-link" href="#">Next &raquo;</a></li>
        </ul>
      </nav>
    </div>
  </div>
</div>

<!-- ✅ Footer -->
<div class="footer">
  <p>&copy; 2025 BookNest | All Rights Reserved</p>
  <p><a href="buyerPortal.jsp" class="text-light">Home</a> | 
     <a href="browseBooks.jsp" class="text-light">Browse</a> | 
     <a href="myOrders.jsp" class="text-light">My Orders</a> | 
     <a href="help.jsp" class="text-light">Help</a></p>
</div>

</body>
</html>
