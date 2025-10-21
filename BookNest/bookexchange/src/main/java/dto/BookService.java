package dto;

import java.util.List;

import DAO.ListingDao;
import model.Listing;
import util.PagedResult;
import util.hibernateUtil;

public class BookService {
	
	private static ListingDao listingDao = new ListingDao(hibernateUtil.getSessionFactory());
	
	public static PagedResult<Listing> browse(int pages, int size){
		int totalCount = listingDao.countAll();
		List<Listing> books = listingDao.findAll(pages, size);
		
		return new PagedResult<Listing>(books, totalCount, pages, size);
	}
}
