package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import DAO.BookDao;
import DAO.ListingDao;
import model.Book;
import model.Listing;
import model.User;
import util.hibernateUtil;

//@WebServlet("/ListingController")
public class ListingController extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private ListingDao listingDao = new ListingDao(hibernateUtil.getSessionFactory());   
    private BookDao bookDao = new BookDao(hibernateUtil.getSessionFactory());
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if(session == null || session.getAttribute("user") == null) {
			response.sendRedirect("login.jsp");
			return;
		}
		
		User seller = (User) session.getAttribute("user");
		
		try {
			String title = request.getParameter("title");
			String author = request.getParameter("author");
			String isbn = request.getParameter("isbn");
			Double price = Double.parseDouble(request.getParameter("price"));
			int quantity = Integer.parseInt(request.getParameter("quantity"));
			
			String listingTypeParam = request.getParameter("listingType");
			Listing.ListingType listingType = Listing.ListingType.valueOf(listingTypeParam.toUpperCase());
			
			Book book = bookDao.fetchBooksByISBN(isbn);
			if(book == null) {
				book = new Book();
				book.setTitle(title);
				book.setAuthor(author);
				book.setIsbn(isbn);
				bookDao.saveOrUpdate(book);
			}
			
			Listing listing = new Listing();
			listing.setBook(book);
			listing.setPrice(price);
			listing.setQuantity(quantity);
			listing.setListingType(listingType);
			listing.setSeller(seller);
			listing.setStatus(Listing.Status.ACTIVE);
			
			listingDao.insertListing(listing);
			
			request.setAttribute("message","Listing created Successfully!");
			request.getRequestDispatcher("sellerPortal.jsp").forward(request, response);
		}catch (Exception e) {
		    e.printStackTrace();
		    request.setAttribute("error", "Failed to create listing: "+e.getMessage());
		    request.getRequestDispatcher("sellerPortal.jsp").forward(request, response);
		}
	}

}
