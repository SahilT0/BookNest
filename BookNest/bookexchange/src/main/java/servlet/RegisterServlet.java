package servlet;

import java.io.IOException;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.SessionFactory;

import DAO.UserDao;
import Validate.UserValidator;
import dto.UserDTO;
import model.Roles;
import model.User;
import util.PasswordUtil;
import util.hibernateUtil;

//@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private SessionFactory sessionfactory = hibernateUtil.getSessionFactory();
       
    public RegisterServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String username = request.getParameter("fullname");
		String email = request.getParameter("email").toLowerCase();
		String password = request.getParameter("password");
		String roleName = request.getParameter("role");
		String phone = request.getParameter("contact");
		
		UserDTO u1 = new UserDTO();
		u1.setFullname(username);
		u1.setEmail(email);
		u1.setPassword(password);
		u1.setPhone(phone);
		u1.setRole(roleName);
		
		
		if(UserValidator.validate(u1).isValid()) {
			try {
				UserDao d = new UserDao(sessionfactory);
				if(d.emailExists(u1.getEmail())) {
					request.setAttribute("error", "User already exists.");
					request.getRequestDispatcher("register.jsp").forward(request, response);
					return;
				}else if(d.phoneExists(phone)){
					request.setAttribute("error", "Phone number already exists.");
					request.getRequestDispatcher("register.jsp").forward(request, response);
					return;
					
				}else {
					User user = new User();
					Roles roleEntity = null;
					user.setFullname(u1.getFullname());
					user.setEmail(u1.getEmail());
					user.setPhone(u1.getPhone());
					
					String pass = PasswordUtil.getPassword(u1.getPassword());
					user.setPassword_hash(pass);
					
					if(roleName != null && !roleName.isEmpty()) {
						try {
							Roles.Rolename roleEnum = Roles.Rolename.valueOf(roleName);
							roleEntity = d.getRoleByName(roleEnum);
						}catch (IllegalArgumentException e) {
							
						}
					}
					
					if(roleEntity == null) {
						roleEntity = d.getRoleByName(Roles.Rolename.BUYER);
					}
					
					Set<Roles> roles = new HashSet<>();
					roles.add(roleEntity);
					user.setRoles(roles);
					
					d.saveUser(user);
						
					response.sendRedirect("login.jsp");
				}
			}catch (Exception ex) {
				System.out.println(ex);
			}
		}else {
			Map<String, String> map = UserValidator.validate(u1).getFeildErrors();
			Set <String> errors = map.keySet();
			String error = errors.iterator().next();
			request.setAttribute("errors", map.get(error));
			request.setAttribute("form", u1);
			request.getRequestDispatcher("register.jsp").forward(request, response);
		}
		
		
		
		
	}

}
