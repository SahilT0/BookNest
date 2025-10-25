package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import DAO.ListingDao;
import DAO.OrderDao;
import DAO.UserDao;
import model.Order;
import model.User;
import util.hibernateUtil;

@WebServlet("/sellerPortal")
public class SellerPortalServlet extends HttpServlet {


	private static final long serialVersionUID = 1L;
	private UserDao userDao;
    private ListingDao listingDao;
    private OrderDao orderDao;

    @Override
    public void init() {
        this.userDao = new UserDao(hibernateUtil.getSessionFactory());
        this.listingDao = new ListingDao(hibernateUtil.getSessionFactory());
        this.orderDao = new OrderDao(hibernateUtil.getSessionFactory());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Check active role and set "seller"
        String activeRole = (String) session.getAttribute("activeRole");
        if (activeRole == null || !activeRole.equals("seller")) {
            activeRole = "seller";
            session.setAttribute("activeRole", activeRole);
        }

        // Ensure user has seller role in DB, add if missing
        boolean hasSellerRole = userDao.hasRole(user.getId(), "seller");
        if (!hasSellerRole) {
            userDao.addRole(user.getId(), "seller");
        }

        try {
            // Fetch seller dashboard stats
            int totalListings = listingDao.getTotalListingsBySeller(user.getId());
            int activeListings = listingDao.getActiveListingsBySeller(user.getId());
            int pendingOrders = orderDao.getPendingOrdersCountBySeller(user.getId());
            int completedSales = orderDao.getCompletedOrdersCountBySeller(user.getId());
            double totalEarnings = orderDao.getTotalEarningsBySeller(user.getId());
            List<Order> recentSales = orderDao.getRecentSalesBySeller(user.getId(), 5);
            
            for (Order order : recentSales) {
                order.getOrder_items().size();
            }

            // Set attributes for JSP
            request.setAttribute("totalListings", totalListings);
            request.setAttribute("activeListings", activeListings);
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("completedSales", completedSales);
            request.setAttribute("totalEarnings", totalEarnings);
            request.setAttribute("recentSales", recentSales);

            // Current date for header
            request.setAttribute("now", new java.util.Date());

            // Forward to JSP
            request.getRequestDispatcher("/sellerPortal.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to load seller dashboard data.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
