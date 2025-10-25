package DAO;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import jakarta.persistence.NoResultException;
import model.Listing;

public class ListingDao {

    private final SessionFactory sessionFactory;

    public ListingDao(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    // --- READ-ONLY METHODS ---

    public Listing fetchById(Long long1) {
        try (Session session = sessionFactory.openSession()) {
            return session.get(Listing.class, long1);
        }
    }

    // fetching Listing by Listing type
    public List<Listing> fetchListingsByType(Listing.ListingType type) {
        try (Session session = sessionFactory.openSession()) {
            // FIX: Use correct camelCase property name 'listingType'
            String hql = "FROM Listing WHERE listingType = :type";
            Query<Listing> query = session.createQuery(hql, Listing.class);
            query.setParameter("type", type);
            return query.getResultList();
        }
    }
    
    // fetch Listings by Book id
    public List<Listing> fetchListingsByBookId(int bookId) {
        try (Session session = sessionFactory.openSession()) {
            // FIX: Use correct property path 'book.id'
            String hql = "FROM Listing WHERE book.id = :bookId";
            Query<Listing> query = session.createQuery(hql, Listing.class);
            query.setParameter("bookId", bookId);
            return query.getResultList();
        }
    }

    // Fully corrected findWithFilters method
    public List<Listing> findWithFilters(String search, String listingType, String[] categories, Double minPrice, Double maxPrice, String sort, int page, int size) {
        StringBuilder hql = new StringBuilder("SELECT l FROM Listing l JOIN l.book b WHERE l.status = :status");
        Map<String, Object> params = new HashMap<>();
        params.put("status", Listing.Status.ACTIVE);

        if (search != null && !search.trim().isEmpty()) {
            hql.append(" AND (b.title LIKE :search OR b.author LIKE :search OR b.isbn LIKE :search)");
            params.put("search", "%" + search.trim() + "%");
        }
        if (listingType != null && !listingType.trim().isEmpty()) {
            hql.append(" AND l.listingType = :listingType");
            params.put("listingType", Listing.ListingType.valueOf(listingType));
        }
        if (categories != null && categories.length > 0) {
            hql.append(" AND b.category IN (:categories)");
            params.put("categories", Arrays.asList(categories));
        }
        if (minPrice != null) {
            hql.append(" AND l.price >= :minPrice");
            params.put("minPrice", minPrice);
        }
        if (maxPrice != null) {
            hql.append(" AND l.price <= :maxPrice");
            params.put("maxPrice", maxPrice);
        }

        String orderBy = " ORDER BY l.createdAt DESC";
        if (sort != null) {
            switch (sort) {
                case "priceAsc": orderBy = " ORDER BY l.price ASC"; break;
                case "priceDesc": orderBy = " ORDER BY l.price DESC"; break;
                case "latest": orderBy = " ORDER BY l.createdAt DESC"; break;
            }
        }
        hql.append(orderBy);

        try (Session session = sessionFactory.openSession()) {
            Query<Listing> query = session.createQuery(hql.toString(), Listing.class);
            for (Map.Entry<String, Object> entry : params.entrySet()) {
                if (entry.getValue() instanceof List) {
                    query.setParameterList(entry.getKey(), (List<?>) entry.getValue());
                } else {
                    query.setParameter(entry.getKey(), entry.getValue());
                }
            }

            query.setFirstResult((page - 1) * size);
            query.setMaxResults(size);
            return query.getResultList();
        }
    }

    // --- WRITE METHODS (INSERT/UPDATE) ---

    // Insert Listing
    public void insertListing(Listing listing) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            session.persist(listing); // Use persist() for new objects
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw e; // Re-throw the exception after rolling back
        }
    }

    // Listing status update
    public boolean updateListingStatus(int id, Listing.Status newStatus) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            Listing listing = session.get(Listing.class, id);
            if (listing == null) {
                transaction.commit(); // Commit even if nothing was done
                return false; // Listing not found
            }
            listing.setStatus(newStatus);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw e;
        }
    }
    
    public List<Listing> findAll(int page, int size) {
        try (Session session = sessionFactory.openSession()) {
            Query<Listing> query = session.createQuery(
                "FROM Listing l WHERE l.status = 'ACTIVE'", Listing.class
            );
            query.setFirstResult((page - 1) * size);
            query.setMaxResults(size);
            return query.list();
        }
    }
    
    public List<Listing> findAllListingOfSeller(long bookId){
    	try(Session session = sessionFactory.openSession()){
    		Query<Listing> query = session.createQuery("From Listing l where l.book.id = :bookId", Listing.class);
    		query.setParameter("bookId", bookId);
    		return query.list();
    	}
    }
    
    public int countAll() {
    	try(Session session = sessionFactory.openSession()){
    		Query<Long> query = session.createQuery("Select count(l.id) from Listing l", Long.class);
    		
    		try {
    			return query.getSingleResult().intValue();
    		}catch(NoResultException e) {
    			return 0;
    		}
    	}
    }
    
 // Get total number of listings for a seller
    public int getTotalListingsBySeller(long sellerId) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "SELECT COUNT(l) FROM Listing l WHERE l.seller.id = :sellerId";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("sellerId", sellerId);
            Long count = query.uniqueResult();
            return count != null ? count.intValue() : 0;
        }
    }

    // Get number of active listings for a seller
    public int getActiveListingsBySeller(long sellerId) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "SELECT COUNT(l) FROM Listing l WHERE l.seller.id = :sellerId AND l.status = 'ACTIVE'";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("sellerId", sellerId);
            Long count = query.uniqueResult();
            return count != null ? count.intValue() : 0;
        }
    }

}