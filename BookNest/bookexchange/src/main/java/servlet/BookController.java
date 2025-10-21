package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.BookService;
import model.Listing;
import util.PagedResult;

/**
 * Servlet implementation class BookController
 */
//@WebServlet("/BookController")
public class BookController extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int page = 1;
		int size = 8;
		
		String pageParam = request.getParameter("page");
		String sizeParam = request.getParameter("size");
		
		if(pageParam != null) {
			try {
				page = Integer.parseInt(pageParam);
			}catch(NumberFormatException e) {
				page = 1;
			}
		}
		
		if(sizeParam != null) {
			try {
				size = Integer.parseInt(sizeParam);
			}catch(NumberFormatException e) {
				size = 8;
			}
		}
		
		String categoryParam = request.getParameter("category");
		Listing.ListingType category = Listing.ListingType.NEW;
		
		if(categoryParam != null && !categoryParam.isEmpty()) {
			try {
				category = Listing.ListingType.valueOf(categoryParam.toUpperCase());
			}catch(IllegalArgumentException e) {
				category = null;
			}
		}
		
		
		String minVal = request.getParameter("minimumPrice");
		String maxVal = request.getParameter("maximumPrice");
		
		double minPrice = 0.0;
		double maxPrice = Double.MAX_VALUE;
		
		if(minVal != null) {
			try {
				minPrice = Double.parseDouble(minVal);
			}catch(NumberFormatException e) {
				minPrice = 0;
			}
		}
		
		if(maxVal != null) {
			try {
				maxPrice = Double.parseDouble(maxVal);
			}catch(NumberFormatException e) {
				maxPrice = Double.MAX_VALUE;
			}
		}
		
		PagedResult<Listing> pagedBooks = BookService.browse(page, size);
		
		request.setAttribute("books", pagedBooks.getResults());
		request.setAttribute("totalCount", pagedBooks.getTotalCount());
		request.setAttribute("currentPage", pagedBooks.getPage());
		request.setAttribute("pageSize", pagedBooks.getSize());
		
		request.setAttribute("selectedCategory", category);
		request.setAttribute("selectedMinPrice", minPrice);
		request.setAttribute("selectedMaxPrice", maxPrice);
		
		request.getRequestDispatcher("buyerPortal.jsp").forward(request, response);
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
