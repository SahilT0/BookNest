package DAO;

import java.math.BigDecimal;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import model.Listing;

public class ListingDao {
	
	private final SessionFactory sessionfactory;
	
	public ListingDao(SessionFactory sessionfactory) {
		this.sessionfactory = sessionfactory;
	}
	
	// fetching Active Listings
	public List<Listing> fetchActiveListings(){
		try(Session session = sessionfactory.openSession()){
			String hql = "From Listing where status = :status";
			Query<Listing> query = session.createQuery(hql, Listing.class);
			query.setParameter("status", Listing.Status.ACTIVE);
			return query.list();
		}
	}
	
	// fetching Listing by Listing type    -- New old Donation
	public List<Listing> fetchListingsByType(Listing.ListingType type){
		try(Session session = sessionfactory.openSession()){
			String hql = "from Listing where ListingType = :listingType";
			Query<Listing> query = session.createQuery(hql, Listing.class);
			query.setParameter("listingType", type);
			return query.list();
		}
	}
	
	// Fetch listings by price range
	public List<Listing> fetchListingsByPriceRange(BigDecimal minPrice, BigDecimal maxPrice){
		try(Session session = sessionfactory.openSession()){
			String hql = "From Listing where price >= :min and price <= max";
			Query<Listing> query = session.createQuery(hql, Listing.class);
			query.setParameter("min", minPrice);
			query.setParameter("max", maxPrice);
			return query.list();
		}
	}
	
	// fetch Listings by Book id
	public List<Listing> fetchListingsByBookId(int book_id){
		try(Session session = sessionfactory.openSession()){
			String hql = "From Listing where book_id = :id";
			Query<Listing> query = session.createQuery(hql, Listing.class);
			query.setParameter("id", book_id);
			return query.list();
		}
	}
	
	// fetch Listings by condition Grades 
	public List<Listing> fetchListingsByConditionGrade(Listing.ConditionGrade grade){
		try(Session session = sessionfactory.openSession()){
			String hql = "from Listing where condition_grade = :grade";
			Query<Listing> query = session.createQuery(hql, Listing.class);
			query.setParameter("grade", grade);
			return query.list();
		}
	}
	
	//fetch Listing by seller id 
	public List<Listing> fetchListingBySellerId(int id){
		try(Session session = sessionfactory.openSession()){
			String hql = "from Listing where seller_id = :seller_id";
			Query<Listing> query = session.createQuery(hql, Listing.class);
			query.setParameter("seller_id", id);
			return query.list();
		}	
	}
	
	//Insert Listing 
	public void insertListing(Listing listing) {
		Transaction tx = null;
		try(Session session = sessionfactory.openSession()){
			tx = session.beginTransaction();
			session.save(listing);
			tx.commit();
		} catch(Exception ex) {
			if(tx != null) tx.rollback();
			throw ex;
		}
	}
	
	// Listing status update
	public boolean updateListinStatus(int id, Listing.Status newStatus) {
		Transaction tx = null;
		try(Session session = sessionfactory.openSession()){
			tx = session.beginTransaction();
			Listing listing = session.get(Listing.class, id);
			if(listing == null) {
				return false;             // Listing not found 
			}
			listing.setStatus(newStatus);
			session.update(listing);
			tx.commit();
			return true;
		}catch(Exception exp) {
			if(tx != null) tx.rollback();
			throw exp;
		}
	}
 
}
