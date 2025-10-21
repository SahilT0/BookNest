package servlet;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import DAO.OrderDao;
import model.Order;
import model.User;


@WebServlet("/MyOrders")
public class MyOrdersServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private OrderDao orderDao;

    @Override
    public void init() {
        // You'll need to replace this with your project’s utility for sessionFactory if it's different
        orderDao = new OrderDao(util.hibernateUtil.getSessionFactory());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User buyer = (User) (session != null ? session.getAttribute("user") : null);
        if (buyer == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Order> orders = orderDao.getOrdersByBuyerId(buyer.getId());
        
        List<Date> orderDates = new ArrayList<>();
        for (Order o : orders) {
            orderDates.add(convertToDate(o.getCreated_At()));
        }
        request.setAttribute("orders", orders);
        request.setAttribute("orderDates", orderDates);

        request.getRequestDispatcher("myOrder.jsp").forward(request, response);
    }
    
    public Date convertToDate(LocalDateTime ldt) {
        if (ldt == null) return null;
        return Date.from(ldt.atZone(ZoneId.systemDefault()).toInstant());
    }
}
