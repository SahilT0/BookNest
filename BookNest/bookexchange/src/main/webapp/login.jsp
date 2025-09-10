<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   
   <title>Login - BOOKNEST</title>
   
   <link rel="icon" type="image/png" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgHHZaCTnqvfR92rclgqHcVWHAaCXSDZSZ5g&s" />
   
   <style type="text/css">
       body, html {
            height: 100%;
            margin: 0
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background:
                 linear-gradient(rgba(26, 35, 126, 0.25), rgba(26, 35, 126, 0.15)), 
                url('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQESE_h_-jhGJZpEIrUCTHRnqToSe3J3wZn_Q&s') no-repeat center center fixed;
            background-size: cover;
            color: white;
       }
       
       .login-container{
            background: rgba(0, 0, 64, 0.80);
            max-width: 420px;
            margin: 6% auto 10% auto;
            padding: 44px 38px 38px 38px;
            border-radius: 14px;
            box-shadow: 0 0 22px 9px rgba(50,50,140,0.30);
            text-align: center;
            animation: fadeSlideIn 0.95s ease forwards;  
       }
       
       @keyframes fadeSlideIn {
            from { opacity: 0; transform: translateY(20px);}
            to { opacity: 1; transform: translateY(0);}
        }
        
        h1 {
            margin-bottom: 18px;
            font-weight: 900;
            letter-spacing: 2px;
            font-size: 2.1rem;
            color: #ffc107;
            text-shadow: 0 0 7px rgba(255,193,7,0.3);
        }
        
        form {
            margin-top: 15px;
        }
        
        label {
            display: block;
            text-align: left;
            font-weight: 600;
            margin: 16px 0 7px 0;
            font-size: 1.07em;
            color: #ffe082;
        }
        
        input[type=email],
        input[type=password] {
            width: 100%;
            padding: 12px 15px;
            margin-top: 3px;
            border: none;
            border-radius: 6px;
            font-size: 1.1em;
            outline: none;
            transition: box-shadow 0.3s ease;
            background: #eeeeee;
            color: #212121;
        }
        
        input[type=email]:focus,
        input[type=password]:focus {
            box-shadow: 0 0 12px 3px #ffc107a0;
            background-color: #fffde7;
        }
        
        .btn-login {
            margin-top: 27px;
            background-color: #ffc107;
            padding: 14px 0;
            width: 100%;
            border: none;
            border-radius: 8px;
            font-size: 1.18em;
            font-weight: 700;
            color: #1a237e;
            cursor: pointer;
            box-shadow: 0 6px 18px rgba(255, 193, 7, 0.27);
            transition: background-color 0.3s ease;
        }
        
        .btn-login:hover {
            background-color: #ffca28c0;
            box-shadow: 0 8px 28px rgba(255, 193, 7, 0.41);
        }
        
        .other-links {
            margin-top: 22px;
            font-size: 1em;
        }
        
        .other-links a {
            color: #ffe082;
            text-decoration: underline;
            font-weight: 600;
            transition: color 0.3s ease;
        }
        
        .other-links a:hover {
            color: #fffde7;
        }
        
        .error-msg {
            color: #ff5252;
            font-weight: 700;
            margin-top: 10px;
            display: none;
        }
        
        footer {
            color: #eeeeeecc;
            text-align: center;
            margin-top: 40px;
            font-size: 1em;
            user-select: none;
            letter-spacing: 1px;
        }     
   </style>
   
</head>

<body>

   <div class="login-container" role="main">
       <h1>Login to BOOKNEST</h1>
       
       <form name="loginForm" action="LoginServlet" method="post" >
            
            <label for="email">Email address</label>
            <input type="email" id="email" name="email" placeholder="you@example.com" required="required" autofocus="autofocus">
            
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter your password" required="required">
            
            <div class="error-msg" id="error-msg"
                 style="<%= (request.getAttribute("error") != null || request.getAttribute("errors") != null) ? "display:block;" : "display:none;" %>">
                  <%= (request.getAttribute("error") != null) ? request.getAttribute("error") : "" %>
            </div>
            
            <button class="btn-login" type="submit">Login</button>
            
      </form>
      <div class="other-links">
            Don't have an account?  <a href="register.jsp">Register here</a>
      </div>
   </div>
   
    <footer>© 2025 BOOKNEST. All rights reserved.</footer>
    
</body>
</html>