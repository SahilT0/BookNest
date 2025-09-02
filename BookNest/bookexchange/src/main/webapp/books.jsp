<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Books Showcase</title>
    <link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet"/>
    <style>
        /* Brand-consistent Navbar similar to index.jsp */
        body {
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            background: #f9f9f9;
            color: #333;
            transition: background-color 0.3s, color 0.3s;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        /* Navbar */
        nav {
            background-color: #004d99;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #fff;
            box-shadow: 0 2px 6px rgb(0 0 0 / 0.15);
        }

        nav .brand {
            font-weight: 700;
            font-size: 1.5rem;
            letter-spacing: 2px;
        }

        nav ul {
            list-style: none;
            display: flex;
            gap: 1.5rem;
            margin: 0;
            padding: 0;
        }

        nav ul li {
            font-weight: 600;
        }

        nav ul li a:hover {
            text-decoration: underline;
        }

        /* Hero Banner */
        .hero-banner {
            background: url('https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=1350&q=80') no-repeat center center/cover;
            color: #fff;
            padding: 4rem 2rem;
            text-align: center;
            font-size: 1.8rem;
            font-weight: 600;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.7);
        }

        /* Main Section */
        main {
            max-width: 1200px;
            margin: 2rem auto 4rem auto;
            padding: 0 1rem;
        }

        /* Filter & Search Bar Container */
        .filter-search {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            margin-bottom: 1.5rem;
            gap: 1rem;
        }

        .filter-search select,
        .filter-search input[type="search"] {
            padding: 0.5rem 1rem;
            font-size: 1rem;
            border-radius: 4px;
            border: 1px solid #ccc;
            min-width: 200px;
        }

        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
        }

        /* Book Card */
        .book-card {
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgb(0 0 0 / 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .book-card:hover {
            transform: scale(1.03);
            box-shadow: 0 8px 16px rgb(0 0 0 / 0.2);
        }

        .book-image {
            width: 100%;
            height: 180px;
            background-color: #ddd;
            background-size: cover;
            background-position: center;
        }

        .book-content {
            padding: 1rem;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .book-title {
            font-weight: 700;
            font-size: 1.25rem;
            margin-bottom: 0.25rem;
            color: #004d99;
        }

        .book-author {
            font-style: italic;
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }

        .book-category {
            font-size: 0.85rem;
            font-weight: 600;
            color: #0073e6;
            margin-bottom: 0.5rem;
        }

        .book-description {
            font-size: 0.9rem;
            color: #444;
            margin-bottom: 0.75rem;
            flex-grow: 1;
            line-height: 1.3;
        }

        .book-status {
            font-weight: 600;
            font-size: 0.85rem;
            margin-bottom: 1rem;
            color: #008000; /* green for available by default */
        }

        .status-available {
            color: #008000;
        }

        .status-donated {
            color: #a67c00;
        }

        .status-for-sale {
            color: #b22222;
        }

        .btn-details {
            background-color: #004d99;
            color: #fff;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s;
            text-align: center;
        }

        .btn-details:hover {
            background-color: #003366;
        }

        /* CTA Banner Bottom */
        .cta-banner {
            background-color: #004d99;
            color: #fff;
            padding: 2rem 1rem;
            text-align: center;
            font-size: 1.4rem;
            font-weight: 700;
            letter-spacing: 1px;
            margin-top: 3rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .cta-banner .btn-register {
            background: #ffbe00;
            color: #004d99;
            border: none;
            padding: 0.7rem 1.5rem;
            font-weight: 700;
            border-radius: 30px;
            cursor: pointer;
            text-transform: uppercase;
            transition: background-color 0.3s, color 0.3s;
            box-shadow: 0 4px 8px rgb(255 190 0 / 0.6);
        }

        .cta-banner .btn-register:hover {
            background: #e6a700;
            color: #00264d;
        }

        /* Footer - same style as index.jsp (example style) */
        footer {
            background-color: #222;
            color: #bbb;
            text-align: center;
            padding: 1rem 0;
            font-size: 0.9rem;
            user-select: none;
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            nav ul {
                gap: 1rem;
            }
            .filter-search {
                flex-direction: column;
                gap: 0.75rem;
            }
            .cta-banner {
                font-size: 1.1rem;
                flex-direction: column;
                gap: 0.75rem;
            }
        }
    </style>
</head>

<body>

<!-- Navbar same structure and links as index.jsp for brand consistency -->
<nav>
    <div class="brand">BookNest</div>
    <ul>
        <li><a href="index.jsp">Home</a></li>
        <li><a href="login.jsp">Login</a></li>
        <li><a href="register.jsp">Register</a></li>
    </ul>
</nav>

<!-- Hero Banner -->
<section class="hero-banner" aria-label="Discover books banner">
    Explore books available for buy, sell, or donation
</section>

<main>
    <!-- Optional Search and Filter -->
    <div class="filter-search">
        <input type="search" id="search-input" placeholder="Search books by title, author, or subject" aria-label="Search books" onkeyup="filterBooks()" />
        <select id="filter-subject" aria-label="Filter by Subject" onchange="filterBooks()">
            <option value="">All Subjects</option>
            <option value="Programming">Programming</option>
            <option value="Finance">Finance</option>
            <option value="Science">Science</option>
            <option value="Literature">Literature</option>
        </select>
        <select id="filter-status" aria-label="Filter by Status" onchange="filterBooks()">
            <option value="">All Status</option>
            <option value="Available">Available</option>
            <option value="Donated">Donated</option>
            <option value="For Sale">For Sale</option>
        </select>
    </div>

    <!-- Books Cards Grid -->
    <section id="books-grid" class="cards-grid" aria-live="polite" aria-label="Books list">
        <!-- Sample book card entries hardcoded -->

        <article class="book-card" data-title="Let Us C" data-author="Yashavant Kanetkar" data-subject="Programming"
                 data-status="Available">
            <div class="book-image" style="background-image: url('https://m.media-amazon.com/images/I/61NsRXh-d4L._UF1000,1000_QL80_.jpg');" aria-label="Cover image of Let Us C"></div>
            <div class="book-content">
                <h2 class="book-title">Let Us C</h2>
                <p class="book-author">Yashavant Kanetkar</p>
                <p class="book-category">Programming</p>
                <p class="book-description">A classic introduction to the C programming language offering clear concepts and examples.</p>
                <p class="book-status status-available">Status: Available</p>
                <button class="btn-details" onclick="redirectToRegister()">Login to Contact Owner</button>
            </div>
        </article>

        <article class="book-card" data-title="Data Structures in Java" data-author="Narasimha Karumanchi" data-subject="Programming"
                 data-status="For Sale">
            <div class="book-image" style="background-image: url('https://m.media-amazon.com/images/I/91xUMlj0ooL.jpg');" aria-label="Cover image of Data Structures in Java"></div>
            <div class="book-content">
                <h2 class="book-title">Data Structures in Java</h2>
                <p class="book-author">Narasimha Karumanchi</p>
                <p class="book-category">Programming</p>
                <p class="book-description">Comprehensive guide covering essential Java data structures and algorithms.</p>
                <p class="book-status status-for-sale">Status: For Sale</p>
                <button class="btn-details" onclick="redirectToRegister()">Login to Contact Owner</button>
            </div>
        </article>

        <article class="book-card" data-title="Rich Dad Poor Dad" data-author="Robert Kiyosaki" data-subject="Finance"
                 data-status="Donated">
            <div class="book-image" style="background-image: url('https://m.media-amazon.com/images/I/814XbqXAz-L._UF894,1000_QL80_.jpg');" aria-label="Cover image of Rich Dad Poor Dad"></div>
            <div class="book-content">
                <h2 class="book-title">Rich Dad Poor Dad</h2>
                <p class="book-author">Robert Kiyosaki</p>
                <p class="book-category">Finance</p>
                <p class="book-description">A personal finance classic that teaches financial literacy and independence.</p>
                <p class="book-status status-donated">Status: Donated</p>
                <button class="btn-details" onclick="redirectToRegister()">Login to Contact Owner</button>
            </div>
        </article>

        <article class="book-card" data-title="NCERT Physics Class 12 – Part I" data-author="NCERT" data-subject="Science"
                 data-status="Available">
            <div class="book-image" style="background-image: url('https://ncert.nic.in/textbook/pdf/leph1cc.jpg');" aria-label="Cover image of NCERT Physics Class 12 – Part I"></div>
            <div class="book-content">
                <h2 class="book-title">NCERT Physics Class 12 – Part I</h2>
                <p class="book-author">NCERT</p>
                <p class="book-category">Science</p>
                <p class="book-description">Standard NCERT textbook for Class 12 physics covering concepts with illustrations.</p>
                <p class="book-status status-available">Status: Available</p>
                <button class="btn-details" onclick="redirectToRegister()">Login to Contact Owner</button>
            </div>
        </article>
    </section>

    <!-- Call to Action Banner -->
    <section class="cta-banner" aria-label="Call to action to register">
        <span>Want to buy, sell, or donate books? Register now and start sharing 📚</span>
        <button class="btn-register" onclick="location.href='register.jsp'">Register</button>
    </section>
</main>

<!-- Footer same as index.jsp -->
<footer>
    &copy; 2025 BookNest. All rights reserved.
</footer>

<script>
    // Redirect to register page for contact
    function redirectToRegister() {
        window.location.href = 'register.jsp';
    }

    // Simple client-side filter function for demonstration
    function filterBooks() {
        const searchTerm = document.getElementById('search-input').value.toLowerCase();
        const subjectFilter = document.getElementById('filter-subject').value;
        const statusFilter = document.getElementById('filter-status').value;
        const books = document.querySelectorAll('.book-card');

        books.forEach(book => {
            const title = book.getAttribute('data-title').toLowerCase();
            const author = book.getAttribute('data-author').toLowerCase();
            const subject = book.getAttribute('data-subject');
            const status = book.getAttribute('data-status');

            // Check search term in title or author or subject
            const matchesSearch = title.includes(searchTerm) || author.includes(searchTerm) || subject.toLowerCase().includes(searchTerm);
            // Check filters
            const matchesSubject = subjectFilter === '' || subject === subjectFilter;
            const matchesStatus = statusFilter === '' || status === statusFilter;

            if (matchesSearch && matchesSubject && matchesStatus) {
                book.style.display = '';
            } else {
                book.style.display = 'none';
            }
        });
    }
</script>

</body>

</html>
