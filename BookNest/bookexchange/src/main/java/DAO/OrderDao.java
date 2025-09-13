package DAO;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import model.Listing;
import model.Order;
import model.Order_items;

public class OrderDao {
	
	private final SessionFactory sessionfactory;
	
	public OrderDao(SessionFactory sessionfactory) {
		this.sessionfactory = sessionfactory;
	}
	
	// New Order Placement with order items & update Listing accordingly
	public boolean placeOrder(Order order, List<Order_items> order_items) {
		Transaction tx = null;
		try(Session session = sessionfactory.openSession()){
			tx = session.beginTransaction();
			// Save the order table
			session.save(order);
			
			// For each item: create OrderItem and update listing stock
			for(Order_items item : order_items) {
				item.setOrder(order);   // link to order
				session.save(item);
				
				// Reduce quantity in listing or mark as SOLD_OUT if last copy
				Listing listing = item.getListing();
				int newQty = listing.getQuantity() - item.getQuantity();
				if(newQty <= 0) {
					listing.setQuantity(0);
					listing.setStatus(Listing.Status.SOLD_OUT);
				}else {
					listing.setQuantity(newQty);
				}
				session.update(listing);
			}
			tx.commit();
			return true;

 		}catch (Exception ex) {
 			if(tx != null) tx.rollback();
 			throw ex;
 		}
	}
	
	// fetch all orders by buyer (Order history)
	public List<Order> getOrderByBuyerId(int buyerId){
		try(Session session = sessionfactory.openSession()){
			String hql = "from Order where buyer.id = :id";
			Query<Order> query = session.createQuery(hql, Order.class);
			query.setParameter("id", buyerId);
			return query.list();
		}
	}
	
	// fetch order by order type
	public List<Order> getOrderByOrderType(Order.OrderType orderType){
		try(Session session = sessionfactory.openSession()){
			String hql = "from Order where orderType = :type";
			Query<Order> query = session.createQuery(hql, Order.class);
			query.setParameter("type", orderType);
			return query.list();
		}
	}
	
	// fetch all Orders by status
	public List<Order> getOrdersByStatus(Order.Status status){
		try(Session session = sessionfactory.openSession()){
			String hql = "from Order where status = :status";
			Query<Order> query = session.createQuery(hql, Order.class);
			query.setParameter("status", status);
			return query.list();
		}
	}
	
	// fetch orders destined for a particular shipping address
	public List<Order> getOrdersByShipingAddress(int shipingAddress){
		try(Session session = sessionfactory.openSession()){
			String hql = "from Order where Addresses.id = :id";
			Query<Order> query = session.createQuery(hql, Order.class);
			query.setParameter("id", shipingAddress);
			return query.list();
		}
	}
	
	// fetch order with details 
	public Order getOrderWithItems(int orderId) {
		try(Session session = sessionfactory.openSession()){
			Order order = session.get(Order.class, orderId);
			if(order != null) {
				order.getOrder_items().size();
			}
			return order;
		}
	}
	
	// Update order status (eg. PENDING , PAID , DELEVERED)
	public boolean updateOrderStatus(int orderId, Order.Status newStatus) {
		Transaction tx = null;
		try(Session session = sessionfactory.openSession()){
			tx = session.beginTransaction();
			Order order = session.get(Order.class, orderId);
			if(order == null) {
				return false;
			}
			order.setStatus(newStatus);
			session.update(order);
			tx.commit();
			return true;
		}catch (Exception exp) {
			if(tx != null) tx.rollback();
			throw exp;
		}
	}

}
