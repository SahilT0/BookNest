package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import DAO.BookDao;
import DAO.ListingDao;
import model.Listing;
import util.hibernateUtil;

@WebServlet("/bookDetails")
public class bookDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	private ListingDao listingDao;
	private BookDao bookDao;
	
	@Override
    public void init() {
        this.listingDao = new ListingDao(hibernateUtil.getSessionFactory());
        this.bookDao = new BookDao(hibernateUtil.getSessionFactory());
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String activeRole = (String) session.getAttribute("activeRole");
        if (activeRole == null) {
            activeRole = "buyer";
            session.setAttribute("activeRole", activeRole);
        }
        String selectedRole = request.getParameter("role");
        if (selectedRole != null && (selectedRole.equals("buyer") || selectedRole.equals("seller") 
                || selectedRole.equals("donor") || selectedRole.equals("admin"))) {
            session.setAttribute("activeRole", selectedRole);
            response.sendRedirect(selectedRole + "Portal.jsp");
            return;
        }

        try {
            String listingIdParam = request.getParameter("id");
            if (listingIdParam == null || listingIdParam.isEmpty()) {
                response.sendRedirect("browseBooks.jsp"); 
                return;
            }
            
            long listingId = Integer.parseInt(listingIdParam);

            Listing listing = listingDao.fetchById(listingId);
            if (listing == null) {
                response.sendRedirect("browseBooks.jsp");
                return;
            }
            
            List<String> urls = this.bookDao.findImageUrlsByBook(listing.getBook());
            listing.setImageUrls(urls);
            
            List<Listing> otherListings = this.listingDao.findAllListingOfSeller(listing.getBook().getId());
            listing.setOtherListings(otherListings);

            request.setAttribute("listing", listing);
            request.setAttribute("book", listing.getBook());

            request.getRequestDispatcher("bookDetails.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("browseBooks.jsp"); 
        }
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
