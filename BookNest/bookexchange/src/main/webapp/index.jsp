<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">

    <title>BOOKNEST</title>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZCHHvhgc3NLwTEkw4aJJ-IBU_H-F8J93cXQ&s">
    
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <style>
        
        :root {
            --primary: #1E3A8A;
            --primary-dark: #0D47A1;
            --accent: #00BCD4;
            --accent-light: #e0ffff;
            --bg-gradient1: #F9FAFB;
            --bg-gradient2: #E3F2FD;
            --card-shadow: 0 10px 36px 0 rgba(30,58,138,0.11), 0 2px 12px 0 rgba(0,0,0,.07);
            --card-border: linear-gradient(120deg,#1E3A8A,#00BCD4 95%);
            --text-gray: #555;
            --text-dark: #333;
            --nav-height: 70px;
            --cta-color: #00BCD4;
            --footer-gray: #bcd0e7;
        }
        
        html { scroll-behavior: smooth; }
        
        body {
            font-family: 'Inter', Arial, sans-serif;
            background: linear-gradient(135deg, var(--bg-gradient1), var(--bg-gradient2) 90%);
            min-height: 100vh;
            margin:0;
            color:var(--text-dark);
            display: flex;
            flex-direction: column;
        }
        
        /* Navbar */
        header {
            position:fixed;
            top:0; left:0; right:0;
            z-index:90;
            width:100%;
            background: rgba(30,58,138,0.98);
            backdrop-filter: blur(6px);
            box-shadow: 0 1.5px 18px 0 rgba(30,58,138,0.05);
            transition: background 0.5s;
        }
      
        header.scrolled {
            background: rgba(30,58,138,0.78);
            box-shadow: 0 8px 18px 0 rgba(30,58,138,0.11);
        }
      
        .navbar {
            display:flex;
            align-items:center;
            justify-content:space-between;
            max-width:1140px;
            margin:0 auto;
            padding:0 1.8rem;
            height: var(--nav-height);
        }
      
        .brand {
            display:flex;
            align-items:center;
            gap: 0.63rem;
        }
      
        .brand-logo {
            height: 32px; width: 32px;
            border-radius: 5px; background:white;
        }
      
        .brand-title {
            color:#fff;
            font-size: 1.29rem;
            font-weight: 700;
            letter-spacing:.5px;
        }
      
        .brand-tagline {
            display:block;
            font-weight:500;
            font-size:0.89em;
            letter-spacing:.15em;
            color:#b3e5fc;
            margin-left:3px;
            margin-top:-2px;
        }
      
        .nav-links {
            display:flex;
            align-items:center;
            gap:1.3rem;
        }
      
        .nav-links a {
            color: var(--accent);
            background:transparent;
            text-decoration: none;
            font-weight: 700;
            text-transform:uppercase;
            font-size:1.05em;
            letter-spacing:.5px;
            display:flex;
            align-items:center;
            gap:7px;
            border-radius:8px;
            padding:8px 18px;
            position:relative;
            transition: background 0.2s, color 0.16s, box-shadow 0.17s;
        }
      
        .nav-links a:hover {
            background: var(--accent-light);
            color: var(--primary);
            box-shadow: 0 2px 9px #80deea2e;
        }
      
        .nav-icon{ font-size:1.05rem; }
      
        .hamburger { display:none; }
      
        /* Main Layout */
        main {
            flex:1;
            display:flex;
            align-items:center;
            justify-content:center;
            min-height:calc(100vh - 85px);
            padding:0 1vw;
            margin-top:var(--nav-height);
        }
      
        .hero {
            display:flex;
            gap:3vw;
            align-items:center;
            justify-content:center;
            width:100%;
            max-width:980px;
        }
      
        .illustration {
            max-width:240px;
            width:23vw;
            min-width:120px;
            margin-left:0;
            margin-right:2vw;
            animation: floatIn 1.3s cubic-bezier(.24,1.12,.33,.97) both, floatY 3.5s infinite ease-in-out;
        }
      
        @keyframes floatIn {
            from{ opacity:0; transform:translateY(100px) scale(.92);}
            to{ opacity:1; transform:translateY(0) scale(1);}
        }
      
        @keyframes floatY {
            0%,100%{ transform:translateY(0);}
            45%{ transform:translateY(-17px);}
            60%{ transform:translateY(-9px);}
        }
      
        .welcome-card {
            background: var(--container-bg);
            border-radius: 20px;
            box-shadow: var(--card-shadow);
            max-width:380px;
            min-width:270px;
            padding:47px 36px 32px 36px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content:center;
            position:relative;
            border: 3px solid transparent;
            background-clip: padding-box;
            transition:box-shadow .28s, transform .22s, border .32s;
            border-image: var(--card-border) 1;
            margin: 0 auto;
        }
      
        .welcome-card:hover {
            transform: scale(1.021);
            box-shadow: 0 24px 60px 0 rgba(30,58,138,0.17), 0 2px 12px rgba(0,0,0,0.07);
            border-image: linear-gradient(120deg,#1E88E5,#00BCD4 90%) 1;
        }
      
        .welcome-card h2 {
            font-size: 2.36em;
            font-weight: bold;
            margin-bottom: 6px;
            margin-top: 0;
            background: linear-gradient(90deg,#1976d2,#00BCD4 65%);
            -webkit-background-clip:text;
            -webkit-text-fill-color:transparent;
            background-clip:text;
            text-fill-color:transparent;
            letter-spacing: 0.7px;
            transition: font-size .22s;
        }
      
        .welcome-card p {
            font-size: 1.13em;
            color: var(--text-gray);
            font-weight: 500;
            line-height: 1.59;
            margin:0 0 26px 0;
        }
      
        /* Buttons / CTA */
        .btns-row {
            display: flex; gap: 18px; width:100%; justify-content: center;
        }
      
        .btn-primary, .btn-secondary {
            padding: 13px 0;
            min-width:117px;
            font-size: 1.11em;
            font-weight: bold;
            text-transform:uppercase;
            letter-spacing: 1px;
            border-radius:7px;
            outline:none;
            display: flex;
            justify-content: center;
            align-items: center;
            gap:8px;
            transition: background .16s, color .12s, border .2s, box-shadow .19s, transform .18s;
            border-width: 2px;
            border-style: solid;
            cursor:pointer;
            box-shadow: 0 3px 15px rgba(30,58,138,0.067);
            will-change: transform;
        }
      
        .btn-primary {
            background: var(--primary);
            color: #fff;
            border-color: var(--primary-dark);
        }
      
        .btn-primary:hover {
            background: var(--primary-dark);
            color:#fff;
            box-shadow: 0 7px 28px #1E88e51c;
            transform: translateY(-3.5px) scale(1.045);
        }
      
        .btn-secondary {
            background: #fff;
            color: var(--primary-dark);
            border-color: var(--primary);
        }
      
        .btn-secondary:hover {
            background: var(--primary);
            color: #fff;
            border-color: var(--primary-dark);
            box-shadow: 0 7px 28px #00bcd43b;
            transform: translateY(-3.5px) scale(1.045);
        }
      
        /* Floating CTA */
        .floating-cta {
            position:fixed;
            bottom:28px; right:28px;
            background:var(--cta-color);
            color:var(--primary-dark);
            border-radius:48px;
            box-shadow:0 2px 28px #00bcd429;
            padding:13px 24px;
            font-weight:bold;
            font-size:1.17em;
            display:flex; 
            align-items:center; 
            gap:12px;
            z-index:91;
            cursor:pointer;
            border:none;
            transition:background .14s, transform .18s, box-shadow .13s;
            animation:bounceIn 0.87s both 0.64s;
        }
      
        .floating-cta:hover {
            background: #0097a7;
            color:#fff;
            box-shadow:0 12px 24px #00bcd436;
            transform:translateY(-3px) scale(1.04);
        }
      
        @keyframes bounceIn {
            0%{ opacity:.5; transform:scale(.6) translateY(70px);}
            80%{opacity:1;transform:scale(1.04) translateY(-7px);}
            100%{opacity:1;transform:scale(1);}
        }
      
        /* Dark/Light Mode */
        .dark-mode body{
            background: linear-gradient(110deg, #212D3B 48%, #0C2336 100%);
            color:#e0e3f5;
        }
      
        .dark-mode .welcome-card {
            background:#232b37;
            color:#cdd1db;
            border-image:linear-gradient(120deg,#0288d1,#3acfd5 98%) 1;
        }
      
        .dark-mode .welcome-card h2 { 
            background: linear-gradient(90deg,#81D4FA,#0288D1 100%);
            -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text; text-fill-color:transparent;
        }
      
        .dark-mode .welcome-card p { color: #abb7ca;}
      
        .dark-mode .btn-primary, .dark-mode .btn-primary:hover {
            background:#0288d1; color:#fff; border-color:#0277bd;
        }
      
        .dark-mode .btn-secondary {
            background:#162039; color:#55d6fe; border:2px solid #0288d1;
        }
      
        .dark-mode .btn-secondary:hover {
            background: #0288d1; color:#fff; border-color:#0277bd;
        }
      
        .dark-mode footer { background: linear-gradient(90deg,#181c22 72%, #025667 100%); color:#a7b5ca;}
      
        .dark-mode .floating-cta { background: #0288d1; color:#fff;}
      
        .dark-mode header, .dark-mode header.scrolled { background: rgba(13,47,73,0.94);}
      
        .dark-mode .popup-content { background: #1E293B; color: #e6eefa;}
      
        /* Footer */
        footer {
            background: linear-gradient(90deg,var(--primary-dark) 79%, #233472 100%);
            text-align: center;
            padding: 12px 0 8px 0;
            font-size: .95em;
            color: var(--footer-gray);
            margin-top:auto;
            opacity: 0;
            animation: fadeInFooter .92s both 1.5s;
        }
      
        @keyframes fadeInFooter {
            from{opacity:0;}
            to{opacity:1;}
        }
      
        /* Welcome Popup */
        #welcomePopup {
            position: fixed; left: 0; top: 0; width: 100vw; height: 100vh;
            display: flex; align-items: center; justify-content: center;
            background: rgba(30,58,138,0.07); z-index: 2500;
            backdrop-filter: blur(2px); transition: opacity 0.3s;
        }
      
        #welcomePopup.hide { opacity: 0; visibility: hidden; pointer-events: none; }
      
        .popup-content {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 8px 40px rgba(30,80,150,.15);
            padding: 38px 38px 22px 38px; min-width:280px; text-align: center;
            display:flex; flex-direction:column; align-items:center;
            animation: fadein 0.5s;
        }
      
        .popup-content h3 {
            margin:20px 0 7px; font-size:1.19em; font-weight:900; color: #00BCD4;
        }
      
        .popup-content p {
            font-size: 1.06em; color: #222;
        }
      
        .popup-btn {
            margin-top: 16px; padding: 8px 28px; border: none; border-radius: 4px;
            color: white; background: var(--primary-dark); font-size: 1em;
            font-weight:600; cursor: pointer; transition: background 0.13s;
        }
      
        .popup-btn:hover { background: var(--accent); color: var(--primary-dark);}
      
        /* Responsive Styles */
        @media (max-width:900px) {
            .hero { flex-direction:column; gap:22px; }
            .welcome-card{margin-top:12px; margin-bottom:12px;}
            .illustration{margin:0; max-width:55vw;}
        }
      
        @media (max-width:600px) {
            header{padding-bottom:8px;}
            .navbar{max-width:98vw; padding:0 12px;}
            main{padding:0;}
            .hero{padding:0 0vw;}
            .welcome-card{padding:20px 11px 21px 11px;}
            .illustration{max-width:90vw;}
            .floating-cta{bottom:14px; right:10px; font-size:0.95em;}
        }
      
        @media (max-width:480px){
            .welcome-card{padding:17px 4px 18px 4px;}
            .btns-row{gap:10px;}
            .floating-cta{padding:10px 12px;}
        }
      
        /* Hamburger */
        @media (max-width:650px) {
            .nav-links {
                position: absolute;
                top: var(--nav-height);
                right: 16px;
                flex-direction: column;
                gap:10px;
                background: var(--primary);
                border-radius:10px;
                box-shadow:0 10px 18px #10204022;
                padding: 20px 22px 14px 22px;
                min-width:54vw;
                display: none;
            }
            .nav-links.open {display: flex;}
            .hamburger { display: flex;
                flex-direction: column; gap: 4px; cursor: pointer;
                margin-left: 15px;}
            .hamburger span { width: 27px; height: 3.2px; background: #fff;
                border-radius:2px; transition: all 0.28s;}
        }
        
    </style>

</head>

<body>

    <!-- Navbar -->
    <header id="mainNav">
        <nav class="navbar">
            <div class="brand">
                <img class="brand-logo" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZCHHvhgc3NLwTEkw4aJJ-IBU_H-F8J93cXQ&s" alt="BOOKNEST logo">
                
                <div>
                    <div class="brand-title">BOOKNEST</div>
                    <div class="brand-tagline">Exchange. Save. Learn.</div>
                </div>    
            </div>
            
            <div class="nav-links" id="menuLinks">
                <a href="Login.jsp"><i class="fas fa-sign-in-alt nav-icon"></i>LOGIN</a>
                <a href="register.jsp"><i class="fas fa-user-plus nav-icon"></i>REGISTER</a>
            </div>
            
            <div class="hamburger" id="hamburger" onclick="toggleMenu()">
                <span></span><span></span><span></span>
            </div>
            
        </nav>
    
    </header>
    
    <!-- Main Hero Section -->
    <main>
    
        <div class="hero">
    
            <img class="illustration" src="https://img.freepik.com/free-vector/hand-drawn-flat-design-stack-books-illustration_23-2149341898.jpg?w=360" alt="Books illustration">
    
            <div class="welcome-card">
                <h2>Welcome to BOOKNEST</h2>
    
                <p>
                    A platform designed for students to conveniently <b>buy</b>, <b>sell</b>, or <b>donate</b> books.<br>
                    Find the right books, give old ones a new home, and save money!
                </p>
    
                <div class="btns-row">
                    <a href="login.jsp" class="btn-primary"><i class="fas fa-sign-in-alt"></i>LOGIN</a>
                    <a href="register.jsp" class="btn-secondary"><i class="fas fa-user-plus"></i>REGISTER</a>
                </div>
    
            </div>
    
        </div>
    
    </main>
    
    <footer>
        © 2025 BOOKNEST. All rights reserved.
    </footer>

    <!-- Floating CTA -->
    <a href="books.jsp" class="floating-cta" title="Browse Books">
        <i class="fas fa-book"></i> Browse Books
    </a>
    
    <!-- Welcome Popup -->
    <div id="welcomePopup">
        <div class="popup-content">
            <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" style="width:54px; border-radius:7px; box-shadow:0 2px 10px rgba(60,60,120,0.13); background:white;" alt="BOOKNEST welcome"/>
            <h3>Welcome to BOOKNEST!</h3>
            <p>Your place to buy, sell, or donate books 📚</p>
            <button class="popup-btn" onclick="closePopup()">Get Started</button>
        </div>
    </div>

    <!-- Dark Mode Toggle -->
    <button 
        onclick="toggleDarkMode()" 
        aria-label="Switch dark mode" 
        title="Toggle dark mode" 
        style="
            position:fixed; top:11px; right:14px; z-index:190;
            background: #fff; color: #1E3A8A; border: none; 
            border-radius: 24px; box-shadow:0 2px 10px rgba(30,58,138,0.09); 
            padding: 8px 15px 8px 13px; cursor:pointer; font-size:1.19em;
            transition: background .17s, color .13s;">
        <i class="fas fa-moon"></i>
    </button>

    <script>
        // Hamburger
        function toggleMenu() {
            var navLinks = document.getElementById('menuLinks');
            navLinks.classList.toggle('open');
        }
        // Navbar on scroll (semi-transparent)
        window.addEventListener('scroll', function() {
            var header = document.getElementById('mainNav');
            if(window.scrollY > 40) header.classList.add('scrolled');
            else header.classList.remove('scrolled');
        });
  
        // Hide welcome popup on click
        function closePopup() {
            document.getElementById('welcomePopup').classList.add('hide');
        }
        // close popup on clicking outside
        document.getElementById('welcomePopup').addEventListener('click', function(e) {
            if (e.target === this) closePopup();
        });
        
        // Dark mode toggle
        function toggleDarkMode() {
            document.documentElement.classList.toggle('dark-mode');
            var icon = document.querySelector('button[aria-label="Switch dark mode"] i');
            if(document.documentElement.classList.contains('dark-mode')) {
                icon.classList.remove('fa-moon'); icon.classList.add('fa-sun');
            } else {
                icon.classList.remove('fa-sun'); icon.classList.add('fa-moon');
            }
        }
        // Micro-interaction for buttons
        document.querySelectorAll('.btn-primary, .btn-secondary').forEach(btn => {
            btn.addEventListener('animationend', ()=>{ btn.style.animation=''; });
        });
    </script>
</body>
</html>
