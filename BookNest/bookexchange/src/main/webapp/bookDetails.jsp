<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.User,model.Book,model.Listing" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    String selectedRole = request.getParameter("role");
    if (selectedRole != null && (selectedRole.equals("buyer") || selectedRole.equals("seller") || selectedRole.equals("donor") || selectedRole.equals("admin"))) {
        activeRole = selectedRole;
        session.setAttribute("activeRole", selectedRole);
        response.sendRedirect(selectedRole + "Portal.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>BOOK DETAILS - ${book.title} - BOOKNEST</title>
<link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
<style>
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

/* Container with two-column layout */
.container {
  max-width: 1540px;
  margin: 36px auto;
  padding: 0 8px;
}
.book-details {
  display: flex;
  flex-direction: row;
  gap: 32px;
  justify-content: flex-start; /* align left */
  align-items: flex-start;
  min-height: 550px;
  margin-bottom: 40px;
}
.book-gallery {
  flex: 1 1 45%;
  min-width: 330px;
  max-width: 420px;
  display: flex;
  flex-direction: column;
  align-items: flex-start;   /* Images left */
  margin-right: 10px;
}
.main-image {
  width: 100%;
  max-width: 370px;
  height: 460px;
  object-fit: contain;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(38,50,102,0.15);
  background: #fafafe;
}
.thumbnails {
  margin-top: 18px;
  display: flex;
  gap: 12px;
  justify-content: flex-start;
  width: 100%;
}
.thumbnail-img {
  width: 62px;
  height: 62px;
  object-fit: cover;
  border-radius: 9px;
  cursor: pointer;
  box-shadow: 0 2px 6px rgba(38,50,102,0.12);
  border: 2px solid transparent;
}
.thumbnail-img.selected {
  border-color: #ffd600;
  box-shadow: 0 4px 14px #ffd600a0;
}
.book-info-panel {
  flex: 1 1 37%;
  min-width: 280px;
  max-width: 890px;
  min-height: 
  top: 100px;
  background: none;
  padding-top: 6px;
}
.book-title {
  font-size: 2.5rem;
  font-weight: 900;
  color: #263266;
  margin-bottom: 12px;
}
.book-subtitle {
  font-size: 1.1rem;
  font-weight: 600;
  color: #58598d;
  margin-bottom: 4px;
}
.book-meta {
  font-size: 0.95rem;
  color: #283593b0;
  margin-bottom: 6px;
  cursor: pointer;
}
.book-meta span {
  margin-right: 10px;
  border-radius: 4px;
  padding: 3px 8px;
  background: #f1f1f7;
  color: #595969;
  font-weight: 700;
}
.rating-stars {
  margin: 10px 0;
  color: #fa6800;
  font-size: 1.25rem;
  cursor: default;
}
.review-count {
  font-size: 0.9rem;
  color: #283593aa;
  cursor: pointer;
  margin-left: 6px;
}
.book-teaser {
  margin-top: 12px;
  color: #444a77;
  line-height: 1.6;
  max-height: 4.2em; /* Approximately 3 lines */
  overflow: hidden;
  position: relative;
}
.book-teaser.expanded {
  max-height: none;
}
.read-more {
  color: #263266;
  font-weight: 700;
  cursor: pointer;
  margin-top: 6px;
  user-select: none;
}
.buy-box form {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 12px;
}
.buy-box .form-group {
  display: flex;
  flex-direction: column;
}
.buy-box .select-seller {
  flex: 2 1 220px;
}
.buy-box .quantity-select {
  flex: 1 1 80px;
}
.buy-box select {
  width: 100%;
  padding: 8px 10px;
  border-radius: 6px;
  border: 1.2px solid #ccc;
  font-size: 1rem;
}
.buy-box .btn-buy {
  flex: 1 1 auto;
  padding: 12px 18px;
  background: #ffd600;
  color: #263266;
  font-weight: 900;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  box-shadow: 0 4px 15px #c1a314a1;
  transition: background-color 0.2s ease;
  min-width: 115px;
}
.buy-box .btn-buy:hover {
  background-color: #ffe876;
}
.buy-box .btn-request {
  margin-top: 12px;
  background: #ffd600;
  border: none;
  border-radius: 10px;
  padding: 12px 18px;
  font-weight: 700;
  color: #263266;
  cursor: pointer;
  box-shadow: 0 4px 15px #c1a314a1;
  transition: background-color 0.2s ease;
  width: 100%;
}
.details-section {
  margin-top: 40px;
}
.details-tabs {
  border-bottom: 2px solid #ffd600aa;
  display: flex;
  gap: 24px;
  font-weight: 700;
  color: #263266;
  cursor: pointer;
}
.details-tabs .tab.active {
  border-bottom: 3px solid #ffd600;
  color: #000;
}
.details-content {
  margin-top: 20px;
  color: #444a77;
  font-size: 1rem;
  line-height: 1.6;
}
.listings-table {
  margin-top: 25px;
  width: 100%;
  border-collapse: collapse;
  font-size: 1rem;
}
.listings-table th, .listings-table td {
  border: 1px solid #ddd;
  padding: 10px;
  text-align: center;
}
.listings-table th {
  background-color: #f1f1f7;
  color: #263266;
}
.related-books {
  margin-top: 48px;
}
.related-books .related-title {
  font-size: 1.85rem;
  font-weight: 800;
  margin-bottom: 22px;
  color: #263266;
}
.related-books-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
  gap: 28px;
}
.related-book-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgb(38 50 102 / 0.15);
  transition: transform 0.3s ease;
  cursor: pointer;
}
.related-book-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 10px 35px rgb(38 50 102 / 0.25);
}
.related-book-cover {
  border-radius: 12px 12px 0 0;
  width: 100%;
  height: 180px;
  object-fit: contain;
}
.related-book-info {
  padding: 10px 12px;
}
.related-book-title {
  font-weight: 700;
  color: #263266;
  font-size: 1rem;
}
.related-book-author {
  font-style: italic;
  font-weight: 500;
  color: #7a7a8a;
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

/* Responsive adjustments */
@media (max-width: 1024px) {
  .book-details {
    flex-direction: column;
  }
  .book-gallery, .book-info-panel, .buy-box {
    position: relative;
    top: initial;
    width: 100%;
  }
}

/* Responsive (Tablet/Mobile) */
@media (max-width: 950px) {
  .container { max-width: 98vw; padding: 0 2vw; }
  .book-details { flex-direction: column; gap: 12px; min-height: unset; }
  .book-gallery, .book-info-panel, .buy-box { max-width: 100%; width: 100%; }
  .main-image { max-width: 96vw; height: 320px; }
  .book-gallery { align-items: center; margin-right: 0; }
}

@media (max-width: 600px) {
  .container { padding: 0 0.5vw; }
  .navbar { flex-direction: column; padding: 10px 8px;}
  .main-image { height: 200px; }
  .book-title { font-size: 1.3rem; }
  .book-meta span, .review-count { font-size: 0.95rem; }
  .thumbnails { gap: 7px; }
  .thumbnail-img { width: 42px; height: 42px;}
  .buy-box { margin-top: 16px; padding: 12px; }
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

<!-- Book Details Container -->
<div class="container book-details">
  <!-- Left: Gallery -->
  <section class="book-gallery">
    <img id="mainImage" src="${listing.imageUrls[0]}" alt="Cover Image" class="main-image" loading="lazy" />
    <div class="thumbnails mt-3">
      <c:forEach var="img" items="${listing.imageUrls}">
        <img src="${img}" alt="Thumbnail" class="thumbnail-img" loading="lazy" onclick="switchImage(this)" />
      </c:forEach>
    </div>
  </section>

  <!-- Right: Book Info & Buy Box -->
  <section class="book-info-panel">
    <h1 class="book-title">${book.title}</h1>
    <h4 class="book-subtitle">Edition: ${book.edition} </h4>
    <div class="book-meta">
      <span>by ${book.author}</span>
      <br/>
      <span>${book.publisher} | ${book.publishingYear} | ISBN: ${book.isbn}</span>
      <br/>
      <span>Language: ${book.language}</span>
      <br/>
      <span>Category: <a href="browseBooks.jsp?category=${book.category}">${book.category}</a></span>
      <div class="rating-stars" title="Average Rating: ${listing.averageRating}">⭐⭐⭐⭐⭐</div>
      <div class="review-count">${listing.reviewCount} Reviews</div>
    </div>
    <p class="book-teaser" id="teaser">${book.description.length() > 500 ? book.description.substring(0, 500) : book.description}...</p>
    <button class="read-more" onclick="expandDescription()">Read more</button>

   <div class="buy-box">
  <form action="CartServlet" method="post" id="purchaseForm">
    <input type="hidden" name="listingId" value="${listing.id}" />

    <div class="form-group select-seller">
      <label for="listingSelect">Select Seller:</label>
      <select id="listingSelect" name="listingId" onchange="updateBuyBox(this)">
        <c:forEach var="list" items="${listing.otherListings}">
          <option value="${list.id}">
            ${list.seller.fullname} — ₹${list.price} — ${list.conditionGrade} — ${list.quantity} available
          </option>
        </c:forEach>
      </select>
    </div>

    <div class="form-group quantity-select">
      <label for="quantitySelect">Quantity:</label>
      <select id="quantitySelect" name="quantity">
        <c:forEach begin="1" end="${listing.quantity > 10 ? 10 : listing.quantity}" var="q">
          <option value="${q}">${q}</option>
        </c:forEach>
      </select>
    </div>

    <button type="submit" name="action" value="add" class="btn-buy">Add to Cart</button>
  </form>
  
  <c:if test="${listing.listingType == 'DONATION'}">
    <button type="button" class="btn-request" onclick="requestDonation()">Request Donation</button>
  </c:if>
</div>
  </section>
</div>

<!-- Details/Description/Reviews/Tabs Section -->
<div class="container details-section">
  <div class="details-tabs">
    <div class="tab active" onclick="showTab('description')">Description</div>
    <div class="tab" onclick="showTab('details')">Details</div>
    <div class="tab" onclick="showTab('reviews')">Reviews</div>
    <div class="tab" onclick="showTab('listings')">Seller Listings</div>
    <div class="tab" onclick="showTab('qa')">Q & A</div>
  </div>
  <div class="details-content" id="description">
    <p>${book.description}</p>
  </div>
  <div class="details-content" id="details" style="display:none;">
    <table class="details-table">
      <tr><th>ISBN</th><td>${book.isbn}</td></tr>
      <tr><th>Publisher</th><td>${book.publisher}</td></tr>
      <tr><th>Edition</th><td>${book.edition}</td></tr>
      <tr><th>Pages</th><td>${book.pages}</td></tr>
      <tr><th>Language</th><td>${book.language}</td></tr>
    </table>
  </div>
  <div class="details-content" id="reviews" style="display:none;">
    <p>Reviews & Ratings coming soon.</p>
  </div>
  <div class="details-content" id="listings" style="display:none;">
    <p>Seller Listings table coming soon.</p>
  </div>
  <div class="details-content" id="qa" style="display:none;">
    <p>Q&A section coming soon.</p>
  </div>
</div>

<!-- Footer -->
<footer class="footer">
  <p>&copy; 2025 BookNest. All Rights Reserved.</p>
  <p><a href="aboutUs.jsp">About Us</a> |
  <a href="contactUs.jsp">Contact</a> |
  <a href="terms.jsp">Terms & Privacy</a></p>
</footer>

<script>
  // Thumbnail image switch
  function switchImage(elem) {
    document.getElementById('mainImage').src = elem.src;
    const thumbnails = document.querySelectorAll('.thumbnail-img');
    thumbnails.forEach(t => t.classList.remove('selected'));
    elem.classList.add('selected');
  }

  // Read more toggle
  function expandDescription() {
    const teaser = document.getElementById('teaser');
    teaser.classList.toggle('expanded');
  }

  // Update buy box listing
  function updateBuyBox(select) {
    const selectedOption = select.options[select.selectedIndex];
    const details = selectedOption.text.split(' — ');
    // update price, qty etc dynamically if needed
  }

  function requestDonation() {
    alert('Request donation feature coming soon!');
  }

  // Tabs functionality
  function showTab(tabId) {
    const tabs = document.querySelectorAll('.details-content');
    tabs.forEach(tab => tab.style.display = 'none');
    document.getElementById(tabId).style.display = 'block';

    const tabButtons = document.querySelectorAll('.details-tabs .tab');
    tabButtons.forEach(tab => tab.classList.remove('active'));
    event.currentTarget.classList.add('active');
  }

  // Show description tab by default
  document.addEventListener('DOMContentLoaded', () => showTab('description'));
</script>

</body>
</html>
