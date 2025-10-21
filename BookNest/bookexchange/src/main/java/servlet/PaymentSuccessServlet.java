package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.json.JSONObject;
import com.razorpay.Utils;
import DAO.OrderDao;
import model.Order;
import util.hibernateUtil;

@WebServlet("/PaymentSuccessServlet")
public class PaymentSuccessServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	private static final String KEY_SECRET = "OQ1cgcAv7qWwDmNvV9KpI3eg";

    private OrderDao orderDao;

    @Override
    public void init() {
        orderDao = new OrderDao(hibernateUtil.getSessionFactory());
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String paymentId = request.getParameter("paymentId");
        String razorpayOrderId = request.getParameter("orderId");
        String signature = request.getParameter("signature");

        try {
            JSONObject options = new JSONObject();
            options.put("razorpay_order_id", razorpayOrderId);
            options.put("razorpay_payment_id", paymentId);
            options.put("razorpay_signature", signature);

            // Verify signature to confirm payment authenticity
            boolean isValid = Utils.verifyPaymentSignature(options, KEY_SECRET);

            if (isValid) {
                // Update order status to PAID in your DB
                Order order = orderDao.getOrderByRazorpayOrderId(razorpayOrderId);
                if (order != null) {

                    orderDao.updateOrderStatus(order.getId(), Order.Status.PAID);
                }

                // Redirect to order confirmation page
                response.sendRedirect("orderConfirmation.jsp");
            } else {
                // Signature mismatch, treat as payment failure
                response.sendRedirect("paymentFailed.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // On error, redirect to failure page
            response.sendRedirect("paymentFailed.jsp");
        }
    }
}
