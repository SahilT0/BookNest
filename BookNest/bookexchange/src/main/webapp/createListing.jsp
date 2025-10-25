<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.User"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <title>Create Listing - BOOKNEST</title>
    <link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.css" />
    <style>
        body {
            background: #f9fafc;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            color: #263266;
        }
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
        /* Form Styles */
        .container {
            max-width: 950px;
            margin: 30px auto;
            background: white;
            padding: 25px 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(38, 50, 102, 0.2);
        }
        h2 {
            margin-bottom: 20px;
            color: #263266;
        }
        label {
            margin-top: 15px;
            display: block;
            font-weight: 700;
        }
        input[type="text"], input[type="number"], textarea, select {
            width: 100%;
            padding: 8px 12px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 15px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        .btn-group {
            margin-top: 25px;
            display: flex;
            justify-content: flex-end;
            gap: 15px;
        }
        button {
            background: #FFD43B;
            border: none;
            padding: 12px 28px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 700;
            color: #263266;
            font-size: 16px;
            transition: background 0.3s ease;
        }
        button:hover {
            background: #e6be2a;
        }
        /* Image Upload Section */
        .image-upload {
            margin-top: 20px;
        }
        .image-upload input[type="file"] {
            display: block;
            margin-bottom: 15px;
        }
        #preview {
            max-width: 100%;
            max-height: 400px;
            display: none;
            margin-bottom: 15px;
        }
        #cropContainer {
            max-width: 100%;
            max-height: 400px;
            margin-bottom: 20px;
        }
        /* Hide Remove button initially */
        #removeCropBtn {
            display: none;
            background: #c62828;
            color: white;
            border: none;
            padding: 8px 15px;
            cursor: pointer;
            border-radius: 6px;
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
    <form id="logoutForm" action="<%= request.getContextPath() %>/LogoutServlet" method="post" style="display:inline;">
      <button type="submit" class="logout-btn">Logout</button>
    </form>
  </div>
</div>

    <!-- Main Container -->
    <div class="container">
        <h2>Create New Listing</h2>
        <form id="listingForm" action="CreateListingServlet" method="post" enctype="multipart/form-data">
            <!-- Book Information -->
            <label for="title">Title *</label>
            <input type="text" id="title" name="title" required />

            <label for="author">Author *</label>
            <input type="text" id="author" name="author" required />

            <label for="isbn">ISBN *</label>
            <input type="text" id="isbn" name="isbn" required/>

            <label for="edition">Edition</label>
            <input type="text" id="edition" name="edition" />

            <!-- Listing Information -->
            <label for="listingType">Listing Type *</label>
            <select id="listingType" name="listingType" required onchange="togglePrice()">
                <option value="NEW">NEW</option>
                <option value="OLD">OLD</option>
                <option value="DONATION">DONATION</option>
            </select>

            <label for="condition">Condition *</label>
            <select id="condition" name="condition" required>
                <option value="NEW">NEW</option>
                <option value="LIKE_NEW">LIKE NEW</option>
                <option value="GOOD">GOOD</option>
                <option value="FAIR">FAIR</option>
                <option value="POOR">POOR</option>
            </select>

            <div id="priceField">
                <label for="price">Price *</label>
                <input type="number" id="price" name="price" min="0" step="any" required />
            </div>

            <label for="quantity">Quantity *</label>
            <input type="number" id="quantity" name="quantity" min="1" step="1" required />

            <label for="description">Description</label>
            <textarea id="description" name="description" placeholder="Any additional details..."></textarea>

            <label for="category">Category *</label>
            <select id="category" name="category" required>
                <option value="">-- Select Category --</option>
                <option value="Academic">Academic</option>
                <option value="Fiction">Fiction</option>
                <option value="Non-fiction">Non-fiction</option>
                <option value="Science">Comp. Exams</option>
                <option value="Biography">Kids Books</option>
            </select>

            <!-- Image Upload with Cropper -->
            <div class="image-upload">
                <label for="images">Upload Images (up to 5 images):</label>
                <input type="file" id="images" name="images" accept="image/*" multiple />
                <div>
                    <img id="preview" alt="Image Preview" />
                </div>
                <div id="cropContainer">
                    <canvas id="canvas" style="max-width: 100%; display:none;"></canvas>
                </div>
                <button type="button" id="cropBtn" style="background:#449d44; color:white; display:none;">Crop Image</button>
                <button type="button" id="removeCropBtn">Remove Crop</button>
            </div>

            <div class="btn-group">
                <button type="submit">Submit</button>
                <button type="button" onclick="location.href='sellerPortal'">Cancel</button>
            </div>
        </form>
    </div>

    <!-- Scripts -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.js"></script>
    <script>
        // Hide price field if DONATION selected
        function togglePrice() {
            const type = document.getElementById('listingType').value;
            const priceField = document.getElementById('priceField');
            priceField.style.display = (type === 'DONATION') ? 'none' : 'block';
        }
        togglePrice();

        // Cropper related variables
        let cropper;
        const preview = document.getElementById('preview');
        const imagesInput = document.getElementById('images');
        const cropBtn = document.getElementById('cropBtn');
        const removeCropBtn = document.getElementById('removeCropBtn');
        const canvas = document.getElementById('canvas');

        // Handle file selection
        imagesInput.addEventListener('change', (e) => {
            const file = e.target.files[0];
            if (!file) return;

            const url = URL.createObjectURL(file);
            preview.src = url;
            preview.style.display = 'block';
            cropBtn.style.display = 'inline-block';
            removeCropBtn.style.display = 'none';

            // Destroy previous cropper instance
            if (cropper) cropper.destroy();

            // Initialize cropper on image
            cropper = new Cropper(preview, {
                aspectRatio: 4 / 5,
                viewMode: 1,
                autoCropArea: 1,
            });
        });

        cropBtn.addEventListener('click', () => {
            if (!cropper) return;
            // Get cropped canvas and display it
            const croppedCanvas = cropper.getCroppedCanvas({
                width: 400,
                height: 500,
            });
            canvas.style.display = 'block';
            preview.style.display = 'none';
            cropBtn.style.display = 'none';
            removeCropBtn.style.display = 'inline-block';
            // Show cropped image on canvas
            const ctx = canvas.getContext('2d');
            canvas.width = croppedCanvas.width;
            canvas.height = croppedCanvas.height;
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.drawImage(croppedCanvas, 0, 0);
            // You can later get the cropped image data with canvas.toDataURL()
        });

        removeCropBtn.addEventListener('click', () => {
            if (cropper) cropper.destroy();
            cropper = null;
            canvas.style.display = 'none';
            preview.style.display = 'block';
            cropBtn.style.display = 'inline-block';
            removeCropBtn.style.display = 'none';
        });

        // You will need additional handling in the servlet to receive this cropped image data in base64 or convert to Blob for actual saving

    </script>
</body>
</html>
