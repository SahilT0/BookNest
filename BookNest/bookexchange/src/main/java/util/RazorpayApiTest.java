package util;

import com.razorpay.RazorpayClient;
import org.json.JSONObject;

public class RazorpayApiTest {
    public static void main(String[] args) {
        try {
            // Use your test or live keys here
            RazorpayClient client = new RazorpayClient("rzp_test_RPNtCSamYtwQH7", "OQ1cgcAv7qWwDmNvV9KpI3eg");

            // Try fetching list of orders or create a test order
            JSONObject options = new JSONObject();
            options.put("amount", 100); // smallest amount in paise
            options.put("currency", "INR");
            options.put("receipt", "test_receipt_001");
            options.put("payment_capture", 1);

            com.razorpay.Order order = client.Orders.create(options);
            System.out.println("Razorpay order created successfully: " + order);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
