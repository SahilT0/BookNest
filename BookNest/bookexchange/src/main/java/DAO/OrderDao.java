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

}