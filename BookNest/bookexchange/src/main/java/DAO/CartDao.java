package DAO;

import java.time.LocalDateTime;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import jakarta.persistence.NoResultException;
import model.Cart;
import model.CartItems;
import model.Listing;
import model.User;

public class CartDao {

    private final SessionFactory sessionFactory;

    public CartDao(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    // ✅ Save or update a cart item
    public void saveOrUpdate(CartItems cartItem) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            // MODERNIZED: merge() replaces deprecated saveOrUpdate()
            session.merge(cartItem);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw e;
        }
    }

    // ✅ Add a new cart item
    public void addCartItem(CartItems cartItem) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();

            Listing managedListing = session.get(Listing.class, cartItem.getListing().getId());
            cartItem.setListing(managedListing);

            session.persist(cartItem);
            transaction.commit();
        } catch (Exception e) {
            try {
                if (transaction != null && transaction.getStatus().canRollback()) {
                    transaction.rollback();
                }
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            throw e;
        }
    }



    // ✅ Remove a cart item by ID
    public void removeCartItem(Long cartItemId) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            CartItems cartItem = session.get(CartItems.class, cartItemId);
            if (cartItem != null) {
                session.remove(cartItem);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw e;
        }
    }

    // ✅ Get all cart items for a given cart
    public List<CartItems> getCartItemsByCart(long cartId) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "FROM CartItems WHERE cart.id = :cartId";
            Query<CartItems> query = session.createQuery(hql, CartItems.class);
            query.setParameter("cartId", cartId);
            // Modern: getResultList() instead of list()
            return query.getResultList();
        }
    }

    // ✅ Get single cart item by ID
    public CartItems getCartItemById(Long id) {
        try (Session session = sessionFactory.openSession()) {
            return session.get(CartItems.class, id);
        }
    }
    
    public User getUserById(long id) {
    	try(Session session = sessionFactory.openSession()){
    		Query<User> query = session.createQuery("from User u where u.id = :id", User.class);
    		query.setParameter("id", id);
    		return query.getSingleResult();
    	}
    }
    
    public Cart getOrCreateActiveCartForBuyer(long id) {
        Transaction tx = null;
        try (Session session = sessionFactory.openSession()) {
            tx = session.beginTransaction();

            // Fetch active cart for the buyer
            String hql = "FROM Cart c WHERE c.buyer.id = :id AND c.status = :status";
            Query<Cart> query = session.createQuery(hql, Cart.class);
            query.setParameter("id", id);
            query.setParameter("status", Cart.Status.ACTIVE);

            Cart cart;
            try {
                cart = query.getSingleResult();
            } catch (NoResultException e) {
                cart = null;
            }

            // If no active cart, create one
            if (cart == null) {
                cart = new Cart();
                User u = getUserById(id);
                cart.setBuyer(u);
                cart.setStatus(Cart.Status.ACTIVE);
                cart.setCreatedAt(LocalDateTime.now());
                cart.setUpdatedAt(LocalDateTime.now());

                session.persist(cart);
            }

            tx.commit();
            return cart;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }

    // ✅ Clear all items from a cart (useful on checkout)
    public void clearCart(long cart) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            String hql = "DELETE FROM CartItems WHERE cart.id = :cart";
            session.createQuery(hql)
                   .setParameter("cart", cart)
                   .executeUpdate();
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            throw e;
        }
    }
}
