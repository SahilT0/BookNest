package servlet;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import DAO.BookDao;
import DAO.OrderDao;
import model.Order;
import model.OrderItem;
import model.User;
import util.hibernateUtil;

@WebServlet("/OrderConfirmation")
public class OrderConfirmationServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private OrderDao orderDao;
	private BookDao bookDao;

    @Override
    public void init() throws ServletException {
        // Obtain the Hibernate SessionFactory from application scope or utility
        this.orderDao = new OrderDao(hibernateUtil.getSessionFactory());
        this.bookDao = new BookDao(hibernateUtil.getSessionFactory());
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // **** 1. Set no-cache headers for sensitive order info (security) ****
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // **** 2. Session and authentication check ****
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User sessionUser = (User) session.getAttribute("user");

        // **** 3. Get orderId from request (defensive) ****
        String orderIdRaw = request.getParameter("orderId");
        long orderId;
        try {
            orderId = Long.parseLong(orderIdRaw);
        } catch (Exception e) {
        	System.out.println(e.getMessage());
            response.sendRedirect("myOrders.jsp");
            return;
        }

        // **** 4. Fetch order + items using DAO ****
        Order order = orderDao.getOrderWithItems(orderId);
        if (order == null) {
            request.setAttribute("errorMsg", "Order not found.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
        
        Date createdAtDate = convertToDate(order.getCreated_At());
        request.setAttribute("createdAtDate", createdAtDate);
        
        String deliveryMethod = request.getParameter("delivery");
        double delivery = 0.0;
        
        if(Order.DeliveryMethod.valueOf(deliveryMethod) == Order.DeliveryMethod.EXPRESS) {
        	delivery = 50.0;
        }
        
        request.setAttribute("delivery", delivery);
        
        for(OrderItem orderItems : order.getOrder_items()) {
        	List<String> urls = bookDao.findImageUrlsByBook(orderItems.getListing().getBook());
        	if(urls != null && !urls.isEmpty()) {
        		orderItems.getListing().setImageUrls(urls);
        	}
        }

        // **** 5. Authorization: Only current buyer can view ****
        if (order.getBuyer() == null || order.getBuyer().getId() != sessionUser.getId()) {
            request.setAttribute("errorMsg", "Unauthorized access.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        // **** 6. Pass order object to JSP (all details in order/items/address) ****
        request.setAttribute("order", order);
        request.getRequestDispatcher("orderConfirmation.jsp").forward(request, response);
    }
    
    private Date convertToDate(LocalDateTime ldt) {
        if(ldt == null) return null;
        return Date.from(ldt.atZone(ZoneId.systemDefault()).toInstant());
    }
}

