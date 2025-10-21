package servlet;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import DAO.BookDao;
import DAO.CartDao;
import DAO.ListingDao;
import model.Cart;
import model.CartItems;
import model.Listing;
import model.User;
import util.hibernateUtil;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private CartDao cartDao;
    private ListingDao listingDao;
    private BookDao bookDao;

    @Override
    public void init() {
        this.listingDao = new ListingDao(hibernateUtil.getSessionFactory());
        this.cartDao = new CartDao(hibernateUtil.getSessionFactory());
        this.bookDao = new BookDao(hibernateUtil.getSessionFactory());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Cart cart = cartDao.getOrCreateActiveCartForBuyer(user.getId());
        List<CartItems> cartItems = cartDao.getCartItemsByCart(cart.getId());

        // Calculate subtotal and grand total (future: apply discounts etc.)
        double subtotal = cartItems.stream()
                .mapToDouble(item -> item.getListing().getPrice() * item.getQuantity())
                .sum();
        double grandTotal = subtotal;
        
		for (CartItems c : cartItems) {
			List<String> urls = this.bookDao.findImageUrlsByBook(c.getListing().getBook());
			c.getListing().setImageUrls(urls);
		}

        request.setAttribute("cart", cart);
        request.setAttribute("", session);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("grandTotal", grandTotal);

        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("update".equals(action)) {
            Long cartItemId = Long.parseLong(request.getParameter("cartItemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            CartItems cartItem = cartDao.getCartItemById(cartItemId);

            if (cartItem != null) {
                Listing listing = cartItem.getListing();
                int availableQuantity = listing.getQuantity();

                if (quantity > availableQuantity) {
                    request.getSession().setAttribute("cartError", "Cannot update quantity. Only " + availableQuantity + " items are available.");
                    response.sendRedirect("CartServlet"); 
                    return;
                }

                cartItem.setQuantity(quantity);
                cartItem.setTotalPrice(quantity * listing.getPrice());
                cartDao.saveOrUpdate(cartItem);
            }
        } else if ("remove".equals(action)) {
            Long cartItemId = Long.parseLong(request.getParameter("cartItemId"));
            cartDao.removeCartItem(cartItemId);
        } else if ("add".equals(action)) {
            Long listingId = Long.parseLong(request.getParameter("listingId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            Cart cart = cartDao.getOrCreateActiveCartForBuyer(user.getId());
            Listing listing = listingDao.fetchById(listingId);

            List<CartItems> currentItems = cartDao.getCartItemsByCart(cart.getId());
            CartItems existingItem = null;
            for (CartItems ci : currentItems) {
                if (ci.getListing().getId().equals(listingId)) {
                    existingItem = ci;
                    break;
                }
            }

            int availableQuantity = listing.getQuantity();
            int existingQuantity = existingItem != null ? existingItem.getQuantity() : 0;
            int requestedQuantity = existingQuantity + quantity;

            if (requestedQuantity > availableQuantity) {
                request.getSession().setAttribute("cartError", "Cannot add to cart. Only " + availableQuantity + " items available.");
                response.sendRedirect("CartServlet");  // Redirect to previous page to show error
                return;
            }

            if (existingItem != null) {
                existingItem.setQuantity(requestedQuantity);
                existingItem.setTotalPrice(requestedQuantity * existingItem.getListing().getPrice());
                cartDao.saveOrUpdate(existingItem);
            } else {
                CartItems newItem = new CartItems();
                newItem.setCart(cart);
                newItem.setListing(listing);
                newItem.setQuantity(quantity);
                newItem.setAddedAt(LocalDateTime.now());
                newItem.setUnitPrice(listing.getPrice());
                newItem.setTotalPrice(quantity * listing.getPrice());
                cartDao.addCartItem(newItem);
            }
        }


        // After POST action, redirect to GET (Post-Redirect-Get pattern)
        response.sendRedirect("CartServlet");
    }
}
