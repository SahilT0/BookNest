package DAO;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import model.Order;
import model.OrderItem; // FIX: Assuming your class is named OrderItem (Java convention)

public class OrderDao {

    private final SessionFactory sessionFactory;

    public OrderDao(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }
    
    public Order getOrderById(long orderId) {
        try (Session session = sessionFactory.openSession()) {
            return session.get(Order.class, orderId);
        }
    }

    // New Order Placement with order items & update Listing accordingly
    public boolean placeOrder(Order order, List<OrderItem> orderItems) {
    	Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            
            System.out.println("Creating order for user: " + order.getBuyer().getId());
            System.out.println("Order total: " + order.getTotalAmount());
            System.out.println("Address ID: " + order.getAddress().getId());
            
            // ADD THESE DEBUG LINES:
            System.out.println("Buyer object: " + (order.getBuyer() != null));
            System.out.println("Address object: " + (order.getAddress() != null));
            System.out.println("PaymentMethod: " + order.getPaymentMethod());
            System.out.println("DeliveryMethod: " + order.getDeliveryMethod());
            System.out.println("Created_at: " + order.getCreated_At());
            System.out.println("Updated_at: " + order.getUpdated_At());
            
            session.persist(order);
            transaction.commit();
            return true;

        } catch (Exception ex) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            
            // Print the ROOT CAUSE of the error
            Throwable cause = ex;
            while (cause.getCause() != null) {
                cause = cause.getCause();
            }
            
            System.out.println("=== ROOT CAUSE ===");
            System.out.println(cause.getClass().getSimpleName() + ": " + cause.getMessage());
            System.out.println("==================");
            
            ex.printStackTrace();
            throw ex;
        }
    }



    // fetch all orders by buyer (Order history)
    public List<Order> getOrdersByBuyerId(long buyerId) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "FROM Order o WHERE o.buyer.id = :buyerId";
            Query<Order> query = session.createQuery(hql, Order.class);
            query.setParameter("buyerId", buyerId);
            // MODERNIZED: Use getResultList()
            return query.getResultList();
        }
    }

    // fetch orders destined for a particular shipping address
    public List<Order> getOrdersByShippingAddress(long shippingAddressId) {
        try (Session session = sessionFactory.openSession()) {
            // FIX: Use the correct property path from the Order entity
            String hql = "FROM Order o WHERE o.shippingAddress.id = :addressId";
            Query<Order> query = session.createQuery(hql, Order.class);
            query.setParameter("addressId", shippingAddressId);
            return query.getResultList();
        }
    }

    // fetch order with details
    public Order getOrderWithItems(long orderId) {
        try (Session session = sessionFactory.openSession()) {
            Order order = session.get(Order.class, orderId);
            if (order != null) {
                // This forces the lazy-loaded collection to initialize before the session closes
                order.getOrder_items().size();
            }
            return order;
        }
    }

    // Update order status (e.g., PENDING, PAID, DELIVERED)
    public boolean updateOrderStatus(long l, Order.Status newStatus) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            Order order = session.get(Order.class, l);
            if (order == null) {
                transaction.commit();
                return false; // Order not found
            }
            order.setStatus(newStatus);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw e;
        }
    }
    
    public Order getOrderByRazorpayOrderId(String razorpayOrderId) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "FROM Order o WHERE o.razorpayOrderId = :razorpayOrderId";
            Query<Order> query = session.createQuery(hql, Order.class);
            query.setParameter("razorpayOrderId", razorpayOrderId);
            return query.uniqueResult();
        }
    }

    
    public void updateOrder(Order order) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            session.update(order);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }
    
 // Count of pending orders for given seller
    public int getPendingOrdersCountBySeller(long sellerId) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "SELECT COUNT(o) FROM Order o WHERE o.buyer.id = :sellerId AND o.status = :pendingStatus";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("sellerId", sellerId);
            query.setParameter("pendingStatus", Order.Status.PENDING);
            Long count = query.uniqueResult();
            return count != null ? count.intValue() : 0;
        }
    }

    // Count of completed (delivered) orders for given seller
    public int getCompletedOrdersCountBySeller(long sellerId) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "SELECT COUNT(o) FROM Order o WHERE o.buyer.id = :sellerId AND o.status = :deliveredStatus";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("sellerId", sellerId);
            query.setParameter("deliveredStatus", Order.Status.DELIVERED);
            Long count = query.uniqueResult();
            return count != null ? count.intValue() : 0;
        }
    }

    // Total earnings (sum of totalAmount) for delivered orders for given seller
    public double getTotalEarningsBySeller(long sellerId) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "SELECT SUM(o.totalAmount) FROM Order o WHERE o.buyer.id = :sellerId AND o.status = :deliveredStatus";
            Query<Double> query = session.createQuery(hql, Double.class);
            query.setParameter("sellerId", sellerId);
            query.setParameter("deliveredStatus", Order.Status.DELIVERED);
            Double sum = query.uniqueResult();
            return sum != null ? sum : 0.0;
        }
    }

 // Get recent sales/orders limited by 'limit' parameter for given seller
    public List<Order> getRecentSalesBySeller(long sellerId, int limit) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "SELECT DISTINCT o FROM Order o "
                       + "JOIN o.order_items oi "
                       + "JOIN oi.listing l "
                       + "WHERE l.seller.id = :sellerId "
                       + "ORDER BY o.created_At DESC";
            Query<Order> query = session.createQuery(hql, Order.class);
            query.setParameter("sellerId", sellerId);
            query.setMaxResults(limit);
            return query.getResultList();
        }
    }



}