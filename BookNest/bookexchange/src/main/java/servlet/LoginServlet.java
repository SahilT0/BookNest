package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import DAO.UserDao;
import model.Roles;
import model.User;
import util.PasswordUtil;
import util.hibernateUtil;

//@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public LoginServlet() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String email = request.getParameter("email").toLowerCase();
		String password = request.getParameter("password");
		
		if(email.isEmpty() && password.isEmpty()) {
			request.setAttribute("error", "Email and password cannot be empty.");
			request.getRequestDispatcher("login.jsp").forward(request, response);
		}else if(email.isEmpty()) {
			request.setAttribute("error", "Email is required!.");
			request.getRequestDispatcher("login.jsp").forward(request, response);
		}else if(password.isEmpty()) {
			request.setAttribute("error", "Password is required!");
			request.getRequestDispatcher("login.jsp").forward(request, response);
		}
		
		UserDao u1 = new UserDao(hibernateUtil.getSessionFactory());
		User user = u1.findByEmail(email);
		if(user != null && PasswordUtil.checkPassword(password, user.getPassword_hash())) {			
			HttpSession oldSession = request.getSession(false);
			
			if(oldSession != null) {
				oldSession.invalidate();
			} 
			
			HttpSession session = request.getSession(true);
			session.setAttribute("user", user);
			
			Roles.Rolename primaryRole = user.getRoles().iterator().next().getName();
			
			session.setAttribute("roleName", primaryRole);
			session.setAttribute("roleId", user.getRoles().iterator().next().getId());
			session.setMaxInactiveInterval(60*30);
			
			switch(primaryRole) {
			    case BUYER:
			    	response.sendRedirect("buyerPortal");
			    	return;
		        case SELLER:
		        	response.sendRedirect("sellerPortal.jsp");
		        	return;
		        case DONOR:
		        	response.sendRedirect("donorPortal.jsp");
		        	return;
		        case ADMIN:
		        	response.sendRedirect("adminPortal.jsp");
		        	return;
		   
		        default:
		        	response.sendRedirect("login.jsp");
			}
			
			response.sendRedirect("profile.jsp");
			
		}else if(user == null){
			request.setAttribute("error", "Invalid Email Id");
			request.getRequestDispatcher("login.jsp").forward(request, response);;
		}else {
			request.setAttribute("error", "Password does not matches!");
			request.getRequestDispatcher("login.jsp").forward(request, response);
			
		}
	}

}
