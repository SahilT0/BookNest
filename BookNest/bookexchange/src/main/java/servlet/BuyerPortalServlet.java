package servlet;

import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DAO.BookDao;
import DAO.ListingDao;
import model.Listing;
import util.hibernateUtil;

@WebServlet("/buyerPortal")
public class BuyerPortalServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private ListingDao listingDao;
	private BookDao bookDao;
    
    @Override
    public void init() {
    	this.listingDao = new ListingDao(hibernateUtil.getSessionFactory());
    	this.bookDao = new BookDao(hibernateUtil.getSessionFactory());
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String search = request.getParameter("search");
		String listingType = request.getParameter("type");
		String [] categories = request.getParameterValues("category");
		String minPriceStr = request.getParameter("minPrice");
		String maxPriceStr = request.getParameter("maxPrice");
		String sort = "latest";
		String pageParam = request.getParameter("page");
		
		Double minPrice = (minPriceStr != null && !minPriceStr.isEmpty()) ? Double.parseDouble(minPriceStr) : null ;
		Double maxPrice = (maxPriceStr != null && !maxPriceStr.isEmpty()) ? Double.parseDouble(maxPriceStr) : null ;
		
		int pageNumber = 1;
		if(pageParam != null) {
			try {
				pageNumber = Integer.parseInt(pageParam) ;
			}catch(NumberFormatException e) {
				pageNumber = 1;
			}
		}
		
		int pageSize = 12;
		
		List<Listing> listings = this.listingDao.findWithFilters(search, listingType, categories, minPrice, maxPrice, sort, pageNumber, pageSize);
		
		for(Listing listing : listings) {
			List<String> urls = this.bookDao.findImageUrlsByBook(listing.getBook());
			listing.setImageUrls(urls);
		}
		
		request.setAttribute("booksList", listings);
		
		request.setAttribute("searchParam", search);
		request.setAttribute("minPriceParam", minPrice);
		request.setAttribute("categoriesParam", (categories != null) ? Arrays.asList(categories) : Collections.emptyList());
		request.setAttribute("typeParam", listingType);

		request.getRequestDispatcher("buyerPortal.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}
