package servlet;

import java.io.IOException;
import java.util.ArrayList;
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

/**
 * Servlet implementation class browseBooks
 */
@WebServlet("/browseBooks")
public class browseBooks extends HttpServlet {
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
		String sort = request.getParameter("sort");
		String pageParam = request.getParameter("page");
		
		Double minPrice = (minPriceStr != null && !minPriceStr.isEmpty()) ? Double.parseDouble(minPriceStr) : null ;
		Double maxPrice = (maxPriceStr != null && !maxPriceStr.isEmpty()) ? Double.parseDouble(maxPriceStr) : null ;
		
		int pageNumber = 1;  // default to page 1
		if(pageParam != null) {
		    try {
		        pageNumber = Integer.parseInt(pageParam);
		    } catch(NumberFormatException e) {
		        pageNumber = 1;
		    }
		}
		
		int totalListings = listingDao.countAll();
		int pageSize = 12;
		int totalPages = (int) Math.ceil((double) totalListings / pageSize);
		
		int maxPagesToShow = 3;
		int startPage = Math.max(1, pageNumber - 1);
		int endPage = Math.min(totalPages, startPage + maxPagesToShow - 1);

		List<Integer> pageNumbers = new ArrayList<>();
		for (int i = startPage; i <= endPage; i++) {
		    pageNumbers.add(i);
		}
		
		Listing.ListingType.valueOf("DONATION");
		
		List<Listing> listings = this.listingDao.findWithFilters(search, listingType, categories, minPrice, maxPrice, sort, pageNumber, pageSize);
		
		for(Listing listing : listings) {
			List<String> urls = this.bookDao.findImageUrlsByBook(listing.getBook());
			listing.setImageUrls(urls);
		}
		
		request.setAttribute("currentPage", pageNumber);
		request.setAttribute("totalPages", totalPages);
		request.setAttribute("pageNumbers", pageNumbers);
		
		request.setAttribute("booksList", listings);
		
		request.setAttribute("searchParam", search);
		request.setAttribute("categoriesParam", (categories != null) ? Arrays.asList(categories) : Collections.emptyList());
		request.setAttribute("minPriceParam", minPrice);
		request.setAttribute("maxPriceParam", maxPrice);
		request.setAttribute("typeParam", listingType);

		request.getRequestDispatcher("browseBooks.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
