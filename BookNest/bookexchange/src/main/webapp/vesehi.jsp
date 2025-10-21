<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="model.User"%>
<!--<%

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
%>-->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - BOOKNEST</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.js"></script>
    <script>AOS.init({ duration: 1000, once: true });</script>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
        }

        /* --- Navbar --- */
        .navbar-brand img {
            height: 50px;
        }

        .navbar-brand-text {
            display: flex;
            flex-direction: column;
            line-height: 1;
            margin-left: 10px;
        }

        .navbar-brand-text .brand-title {
            font-weight: 700;
            font-size: 1.5rem;
            color: #274C77;
        }

        .navbar-brand-text .brand-tagline {
            font-size: 0.8rem;
            font-weight: 500;
            color: #6096BA;
        }
        
        .navbar .nav-link {
            color: #343a40;
            font-weight: 500;
            margin: 0 10px;
            transition: color 0.3s;
            position: relative;
        }
        
        .navbar .nav-link::after {
            content: "";
            position: absolute;
            left: 0;
            bottom: -5px;
            width: 0;
            height: 2px;
            background: #274C77;
            transition: width 0.3s;
        }
        
        .navbar .nav-link:hover {
            color: #274C77;
        }
        
        .navbar .nav-link:hover::after{
            width: 100%;
        }
        
        .navbar .btn-logout {
            border-color: #A3CEF1;
            color: #274C77;
            font-weight: 500;
        }

        .navbar .btn-logout:hover {
            background-color: #274C77;
            color: #fff;
        }
        
        .btn{
            border-radius: 50px !important;
        }

        /* --- Hero Slider --- */
        #hero-slider {
            height: 90vh;
        }

        .carousel-item {
            height: 90vh;
            background-size: cover;
            background-position: center;
        }
        
        .carousel-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5); /* Dark overlay for text readability */
        }
        
        .carousel-caption {
            top: 50%;
            transform: translateY(-50%);
            bottom: auto;
            text-align: center;
        }

        .carousel-caption h1 {
            font-size: 3.5rem;
            font-weight: 700;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.7);
        }
        
        .carousel-caption .btn {
            font-weight: 500;
            padding: 12px 30px;
            border-radius: 50px;
            margin-top: 20px;
            transition: transform 0.3s, background-color 0.3s;
        }

        .carousel-caption .btn:hover {
            transform: translateY(-3px);
        }

        /* --- Section Styles --- */
        section {
            padding: 80px 0;
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.8s ease;
        }
        
        section.show{
             opacity: 1;
             transform: translateY(0);
        }
        
        .section-title {
            text-align: center;
            margin-bottom: 50px;
            font-weight: 700;
            color: #274C77;
        }
        
        #about {
            background-color: #E7ECEF;
        }

        /* --- Services Section --- */
        .service-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            text-align: center;
            background-color: #fff;
        }

        .service-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .service-card img {
            width: 100px;
            height: 100px;
            object-fit: contain;
            margin: 20px auto;
        }
        
        .service-card .card-body {
            padding: 30px;
        }

        /* --- Contact Section --- */
        #contact {
             background-color: #A3CEF1;
             color: #274C77;
        }
        
        .contact-info {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .contact-info img {
            width: 40px;
        }
        
        /* --- Footer --- */
        footer {
            background-color: #274C77;
            color: #f8f9fa;
            padding: 20px 0;
        }
        
        @media (max-width: 768px) {
            .carousel-caption h1 {
                font-size: 2rem;
            }
            section {
                padding: 50px 20px;
            }
            .navbar-brand-text .brand-title {
                font-size: 1.2rem;
            }
       } 

    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm sticky-top">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="#">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZCHHvhgc3NLwTEkw4aJJ-IBU_H-F8J93cXQ&s" alt="BookNest Logo">
                <div class="navbar-brand-text">
                    <span class="brand-title">BOOKNEST</span>
                    <span class="brand-tagline">Exchange. Save. Learn</span>
                </div>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="#">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#about">About</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#services">Services</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#contact">Contact</a>
                    </li>
                    <li class="nav-item ms-lg-3">
                         <a class="btn btn-outline-primary btn-logout" href="logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <header id="hero-slider" class="carousel slide carousel-fade" data-bs-ride="carousel" data-bs-interval="3000">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#hero-slider" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
            <button type="button" data-bs-target="#hero-slider" data-bs-slide-to="1" aria-label="Slide 2"></button>
            <button type="button" data-bs-target="#hero-slider" data-bs-slide-to="2" aria-label="Slide 3"></button>
            <button type="button" data-bs-target="#hero-slider" data-bs-slide-to="3" aria-label="Slide 4"></button>
        </div>
        <div class="carousel-inner">
            <div class="carousel-item active" style="background-image: url('https://images.unsplash.com/photo-1521587760476-6c12a4b040da?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Ym9vayUyMGJhY2tncm91bmR8ZW58MHx8MHx8fDA%3D');">
                <div class="carousel-caption">
                    <h1 class="display-4">A book is a dream that you hold in your hand.</h1>
                    <p class="lead">Find your next adventure at an affordable price.</p>
                    <a href="#services" class="btn btn-primary btn-lg">Start Buying</a>
                </div>
            </div>
            <div class="carousel-item" style="background-image: url('https://images.unsplash.com/photo-1457369804613-52c61a468e7d?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Ym9va3xlbnwwfHwwfHx8MA%3D%3D');">
                <div class="carousel-caption">
                    <h1 class="display-4">Let your old books find a new home.</h1>
                    <p class="lead">Give your books a second life and earn from it.</p>
                    <a href="#services" class="btn btn-success btn-lg">Start Selling</a>
                </div>
            </div>
            <div class="carousel-item" style="background-image: url('https://m.media-amazon.com/images/I/71lniOVVc3L._UF1000,1000_QL80_.jpg');">
                <div class="carousel-caption">
                    <h1 class="display-4">The more that you read, the more things you will know.</h1>
                    <p class="lead">Join a community of students passionate about learning.</p>
                    <a href="#about" class="btn btn-info btn-lg">Explore BookNest</a>
                </div>
            </div>
            <div class="carousel-item" style="background-image: url('https://png.pngtree.com/thumb_back/fh260/background/20240913/pngtree-stack-of-books-in-a-library-with-blurred-bookshelves-background-image_16181415.jpg');">
                <div class="carousel-caption">
                    <h1 class="display-4">One book, one pen, one child, can change the world.</h1>
                    <p class="lead">Donate a book and empower a fellow student's education.</p>
                    <a href="#services" class="btn btn-warning btn-lg">Start Donating</a>
                </div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#hero-slider" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#hero-slider" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </header>

    <section id="about">
        <div class="container">
            <h2 class="section-title">About Us (BOOKNEST)</h2>
            <div class="row g-5 align-items-center">
                <div class="col-lg-6">
                    <h3>Platform Purpose</h3>
                    <p>BOOKNEST is a student-friendly book exchange and donation platform. It helps students buy, sell, exchange, and donate books (new or old) at affordable prices. We aim to promote the reusability of books and reduce waste, creating a sustainable learning environment.</p>
                    <h3>Vision & Mission</h3>
                    <p><strong>Vision:</strong> To make knowledge accessible to every student by providing affordable and shared access to books.<br>
                       <strong>Mission:</strong> To build a sustainable ecosystem where students can easily exchange academic and recreational books.</p>
                </div>
                <div class="col-lg-6">
                    <h3>Who We Serve</h3>
                    <ul>
                        <li>Students who need affordable educational materials.</li>
                        <li>Book lovers who want to share or exchange their collections.</li>
                        <li>Donors who wish to help underprivileged students.</li>
                    </ul>
                    <h3>Why Choose BOOKNEST?</h3>
                     <ul>
                        <li>Affordable prices tailored for students.</li>
                        <li>Easy-to-use portal with dedicated profiles.</li>
                        <li>Encourages sustainability and community support.</li>
                        <li>Transparent system managed by students.</li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <section id="services">
        <div class="container">
            <h2 class="section-title">Our Services</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card service-card h-100">
                        <img src="https://static.vecteezy.com/system/resources/previews/019/030/443/non_2x/buy-letter-royalty-mandala-shape-logo-buy-brush-art-logo-buy-logo-for-a-company-business-and-commercial-use-vector.jpg" class="card-img-top" alt="Buy Books">
                        <div class="card-body">
                            <h5 class="card-title fw-bold">Buy Books</h5>
                            <p class="card-text">Access a wide range of academic and fictional books from other students at unbeatable prices. Find exactly what you need for your next semester.</p>
                            <a href="#" class="btn btn-primary">Buy Now</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card service-card h-100">
                        <img src="https://cdn.shopify.com/app-store/listing_images/474d0b01a3f282ae1c16f8150056907a/icon/CPDOkL7qxvsCEAE=.jpeg" class="card-img-top" alt="Sell Books">
                        <div class="card-body">
                            <h5 class="card-title fw-bold">Sell Books</h5>
                            <p class="card-text">Finished with your books? Sell them to fellow students on our platform. It's quick, easy, and helps you declutter while earning money.</p>
                            <a href="#" class="btn btn-success">Sell Now</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card service-card h-100">
                        <img src="https://www.shutterstock.com/image-illustration/heart-hand-giving-logo-template-260nw-1238767783.jpg" class="card-img-top" alt="Donate Books">
                        <div class="card-body">
                            <h5 class="card-title fw-bold">Donate Books</h5>
                            <p class="card-text">Make a difference by donating your old books. Your contribution can provide valuable resources to students in need and support their education.</p>
                            <a href="#" class="btn btn-warning">Donate Now</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="contact" class="text-center">
        <div class="container">
            <div class="contact-info">
                <img src="https://media.istockphoto.com/id/2153656363/vector/headset-with-microphone-vector-icon.jpg?s=612x612&w=0&k=20&c=ZzwVB9xwVG0tN9FSgrcbPOKd5H-W0t1jWBT-aCx4T8k=" alt="Support Icon">
                <h3 class="mb-0">Online Support 24 * 7</h3>
            </div>
            <p class="mt-3">If you have any query, mail us at <a href="mailto:booknesthelp@gmail.com" class="text-white fw-bold">booknesthelp@gmail.com</a>. You will get a reply within 24 hours.</p>
        </div>
    </section>

    <footer class="text-center">
        <div class="container">
            <p class="mb-1">Designed by</p>
            <p class="mb-1"><strong>Sahil Tuli</strong></p>
            <p class="mb-0">&copy; 2025 BookNest. All Rights Reserved.</p>
        </div>
    </footer>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Smooth scroll for internal links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
        
        const sections = document.querySelectorAll("section");
        window.addEventListener("scroll", () => {
            sections.forEach(sec => {
                const pos = sec.getBoundingClientRect().top;
                if (pos < window.innerHeight - 100) {
                    sec.classList.add("show");
                }
            });
        });

    </script>

</body>
</html>