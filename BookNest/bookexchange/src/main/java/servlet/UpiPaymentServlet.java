package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;

import DAO.OrderDao;
import util.hibernateUtil;

@WebServlet("/UpiPaymentServlet")
public class UpiPaymentServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private static final String KEY_ID = "rzp_test_RPNtCSamYtwQH7";
    private static final String KEY_SECRET = "OQ1cgcAv7qWwDmNvV9KpI3eg";
    
    private OrderDao orderDao;
    
    @Override
    public void init() {
        orderDao = new OrderDao(hibernateUtil.getSessionFactory());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long orderId = Long.parseLong(request.getParameter("orderId"));
        model.Order order1 = orderDao.getOrderById(orderId);
        if(order1 == null){
            response.sendError(400, "Invalid order");
            return;
        }
        System.out.println(order1.getTotalAmount());
        int amountInPaise = (int)(order1.getTotalAmount() * 100);

        try {
            RazorpayClient client = new RazorpayClient(KEY_ID, KEY_SECRET);

            JSONObject options = new JSONObject();
            options.put("amount", amountInPaise);
            options.put("currency", "INR");
            options.put("receipt", String.valueOf(orderId));
            options.put("payment_capture", 1);

            Order order = client.Orders.create(options);
            String razorpayOrderId = order.get("id");
            order1 = orderDao.getOrderById(orderId);
            
            order1.setRazorpayOrderId(razorpayOrderId);
            orderDao.updateOrder(order1);
            

            // You can save razorpayOrderId against your orderId in DB if needed

            // Forward to JSP to show Razorpay payment modal
            request.setAttribute("razorpayOrderId", razorpayOrderId);
            request.setAttribute("amount", amountInPaise);
            request.setAttribute("keyId", KEY_ID);
            request.getRequestDispatcher("upiPayment.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendError(500, "Error creating payment order"+ e.getMessage());
        }
    }
}
