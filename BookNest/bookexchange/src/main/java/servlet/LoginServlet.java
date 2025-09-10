package servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import DAO.UserDao;
import model.User;
import util.PasswordUtil;

//@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		doGet(request, response);
		
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
		
		UserDao u1 = new UserDao();
		User user = u1.findByEmail(email);
		if(user != null && PasswordUtil.checkPassword(password, user.getPassword_hash())) {			
			HttpSession oldSession = request.getSession(false);
			
			if(oldSession != null) {
				oldSession.invalidate();
			} 
			
			HttpSession session = request.getSession(true);
			session.setAttribute("user", user);
			session.setMaxInactiveInterval(1*60);
			
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
