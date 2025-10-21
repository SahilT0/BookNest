package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Order;
import model.OrderItem;
import model.User;
import util.OrderService;

//@WebServlet("/OrderController")
public class OrderController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private OrderService orderService = new OrderService();
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		if(session == null || session.getAttribute("user") == null) {
			response.sendRedirect("login.jsp");
			return;
		}
		
		User buyer = (User) session.getAttribute("user");
		
		try {
			int addressId = Integer.parseInt(request.getParameter("addressId"));
			
			List<OrderItem> items = (List<OrderItem>) session.getAttribute("cart");
			if(items == null || items.isEmpty()) {
				request.setAttribute("error", "Your cart is Empty!");
				request.getRequestDispatcher("buyerPortal.jsp").forward(request, response);
				return;
			}
			
//			String paymentMethod = request.getParameter("paymentMethod");
			Order.OrderType orderType = Order.OrderType.PURCHASE;
			String orderTypeParam = request.getParameter("orderType");
			
			if(orderTypeParam != null) {
				try {
					orderType = Order.OrderType.valueOf(orderTypeParam.toUpperCase());
				}catch(IllegalArgumentException e) {
					orderType = null;
				}
			}
			
			if(orderType != null) {
				Order order = orderService.placeOrder(buyer, items, addressId, orderType);
				
				if(order != null) {
					session.removeAttribute("cart");
					
					request.setAttribute("order", order);
					request.getRequestDispatcher("orderConfirmation.jsp").forward(request, response);
				}else {
					request.setAttribute("error", "Order Placement failed! Try again");
					request.getRequestDispatcher("buyerPortal.jsp").forward(request, response);
				}
			}else {
				request.setAttribute("error", "Order Placement failed! Try again");
				request.getRequestDispatcher("buyerPortal.jsp").forward(request, response);
			}
		}catch(Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "Something went wrong: "+e.getMessage());
			request.getRequestDispatcher("buyerPortal.jsp").forward(request, response);
		}
	}
}
