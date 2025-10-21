package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import DAO.OrderDao;
import model.Order;
import util.hibernateUtil;

@WebServlet("/CheckPaymentStatusServlet")
public class CheckPaymentStatusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OrderDao orderDao;

    @Override
    public void init() {
        orderDao = new OrderDao(hibernateUtil.getSessionFactory());
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        String orderId = request.getParameter("orderId");
        if(orderId == null) {
            response.getWriter().write("{\"status\":\"ERROR\"}");
            return;
        }
        // Get order by RAZORPAY order id (or use your own internal orderId)
        Order order = orderDao.getOrderByRazorpayOrderId(orderId);
        if (order == null) {
            response.getWriter().write("{\"status\":\"ERROR\"}");
            return;
        }
        response.getWriter().write("{\"status\":\"" + order.getStatus().toString() + "\"}");
    }
}
