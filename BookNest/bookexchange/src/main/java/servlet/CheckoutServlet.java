package servlet;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import DAO.AddressesDao;
import DAO.CartDao;
import DAO.OrderDao;
import model.Addresses;
import model.Cart;
import model.CartItems;
import model.Order;
import model.OrderItem;
import model.User;
import util.hibernateUtil;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CartDao cartDao;
    private OrderDao orderDao;
    private AddressesDao addressesDao;

    @Override
    public void init() {
        this.orderDao = new OrderDao(hibernateUtil.getSessionFactory());
        this.cartDao = new CartDao(hibernateUtil.getSessionFactory());
        this.addressesDao = new AddressesDao(hibernateUtil.getSessionFactory());
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get cartId from parameter or from active cart
        String cartIdStr = request.getParameter("cartId");
        long cartId;
        if (cartIdStr == null || cartIdStr.isEmpty()) {
            // Fallback to user's active cart
            Cart cart = cartDao.getOrCreateActiveCartForBuyer(user.getId());
            cartId = cart.getId();
        } else {
            cartId = Long.parseLong(cartIdStr);
        }

        List<CartItems> cartItems = cartDao.getCartItemsByCart(cartId);

        if (cartItems == null || cartItems.isEmpty()) {
            request.setAttribute("cartError", "Your cart is empty. Please add items before checkout.");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            return;
        }

        // Calculate subtotal from cart items
        double subtotal = cartItems.stream()
                .mapToDouble(item -> item.getUnitPrice() * item.getQuantity())
                .sum();

        // Default delivery charge for initial load (standard)
        double deliveryCharge = 0.0;
        double totalAmount = subtotal + deliveryCharge;

        // Find user's default address, if any
        Addresses defaultAddress = addressesDao.getDefaultAddress(user.getId());

        // Set all data needed by checkout.jsp form
        request.setAttribute("user", user);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("deliveryCharge", deliveryCharge);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("cartId", cartId);
        request.setAttribute("defaultAddress", defaultAddress);

        request.getRequestDispatcher("Checkout.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        long cartId = Long.parseLong(request.getParameter("cartId"));
        List<CartItems> cartItems = cartDao.getCartItemsByCart(cartId);
        if (cartItems == null || cartItems.isEmpty()) {
            request.setAttribute("cartError", "Your cart is empty. Please add items before proceeding to checkout.");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            return;
        }

        // Parameters
        boolean useDefault = "on".equals(request.getParameter("useDefault"));
        boolean makeDefault = "on".equals(request.getParameter("makeDefault"));
        String address1 = request.getParameter("address1");
        String address2 = request.getParameter("address2");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");
        String paymentMethod = request.getParameter("paymentMethod");
        String deliveryOption = request.getParameter("deliveryOption");

        double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));

        // Validate required fields (basic)
        if ((!useDefault && (address1 == null || address1.trim().isEmpty() || city == null || city.trim().isEmpty()
                || state == null || state.trim().isEmpty() || pincode == null || pincode.trim().isEmpty()))
                || paymentMethod == null || deliveryOption == null) {
            request.setAttribute("message", "All mandatory fields are required.");
            request.getRequestDispatcher("Checkout.jsp").forward(request, response);
            return;
        }

        Addresses shippingAddress = null;

        if (useDefault) {
            // Use existing default address
            shippingAddress = addressesDao.getDefaultAddress(user.getId());
            if (shippingAddress == null) {
                // No default address exists, fall back to form inputs
                shippingAddress = new Addresses();
                populateAddressFromRequest(shippingAddress, user, address1, address2, city, state, pincode);
                addressesDao.addAddress(shippingAddress);
            }
        } else {
            // User entered/edited new address
            shippingAddress = new Addresses();
            populateAddressFromRequest(shippingAddress, user, address1, address2, city, state, pincode);

         // Set default flag before saving
            if (makeDefault) {
                // Add new as default and unset old default
                addressesDao.setDefaultAddress(user.getId(), null); // unset previous default
                shippingAddress.setIs_default(true);
            }

            addressesDao.addAddress(shippingAddress);

            if (makeDefault) {
                // Now explicitly set new address as default
                addressesDao.setDefaultAddress(user.getId(), shippingAddress.getId());
            }

        }

        // Create order
        Order order = new Order();
        order.setBuyer(user);
        order.setAddress(shippingAddress);
        order.setPaymentMethod(Order.PaymentMethod.valueOf(paymentMethod));
        order.setDeliveryMethod(Order.DeliveryMethod.valueOf(deliveryOption.toUpperCase()));
        order.setTotalAmount(totalAmount);
        order.setOrderType(Order.OrderType.PURCHASE);
        order.setCreated_At(LocalDateTime.now());
        order.setUpdated_At(LocalDateTime.now());
        order.setRazorpayOrderId(null);
        
        List<OrderItem> orderItems = new ArrayList<>();	

        for (CartItems item : cartItems) {
            OrderItem orderItem = new OrderItem();
            orderItem.setListing(item.getListing());
            orderItem.setQuantity(item.getQuantity());
            orderItem.setUnitPrice(item.getUnitPrice());
            orderItem.setOrder(order);
            orderItems.add(orderItem);
        }
        order.setOrder_items(orderItems);

     // Set status based on payment method
        if ("COD".equalsIgnoreCase(paymentMethod)) {
            order.setStatus(Order.Status.PENDING); // or PAID if you want
            boolean orderSuccess = orderDao.placeOrder(order, order.getOrder_items());
            if (orderSuccess) {
                cartDao.clearCart(cartId);
                response.sendRedirect("OrderConfirmation?orderId=" + order.getId()+"&delivery="+order.getDeliveryMethod());

            } else {
                request.setAttribute("message", "Order could not be placed. Try again.");
                request.getRequestDispatcher("Checkout.jsp").forward(request, response);
            }
        } else if ("UPI".equalsIgnoreCase(paymentMethod)) {
            order.setStatus(Order.Status.PENDING);
            boolean orderSuccess = orderDao.placeOrder(order, order.getOrder_items());
            if (orderSuccess) {
                // Redirect to UPI payment page/servlet
            	request.setAttribute("orderId", order.getId());
            	request.getRequestDispatcher("redirectToPayment.jsp").forward(request, response);
            } else {
                request.setAttribute("message", "Order could not be placed. Try again.");
                request.getRequestDispatcher("Checkout.jsp").forward(request, response);
            }
        }

    }

    private void populateAddressFromRequest(Addresses address, User user, String address1, String address2,
            String city, String state, String pincode) {
        address.setLine1(address1);
        address.setLine2(address2);
        address.setCity(city);
        address.setState(state);
        address.setPostal_code(pincode);
        address.setUser_id(user);
        address.setCountry("India");
    }
}
