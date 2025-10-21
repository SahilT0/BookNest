package util;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import DAO.ListingDao;
import model.Addresses;
import model.Listing;
import model.Order;
import model.OrderItem;
import model.User;

public class OrderService {
	private ListingDao listingDao = new ListingDao(hibernateUtil.getSessionFactory());
	
	public Order placeOrder(User buyer, List<OrderItem> items, int addressId, Order.OrderType orderType) {
		Session session = hibernateUtil.getSessionFactory().openSession();
		Transaction tx = null;
		Order order = null;
		
		try {
			tx = session.beginTransaction();
			
			for(OrderItem item : items) {
				Listing listing = listingDao.fetchById(item.getListing().getId());
				
				if(listing == null || !Listing.Status.ACTIVE.equals(listing.getStatus())) {
					throw new RuntimeException("Listing not Available" + item.getListing().getId());
				}
				
				if(listing.getQuantity() < item.getQuantity()) {
					throw new RuntimeException("Out of stock for listing: "+listing.getId());
				}
			}
			
			order = new Order();
			order.setBuyer(buyer);
			order.setOrderType(orderType);
			order.setStatus(Order.Status.PENDING);
			
			Addresses address = session.get(Addresses.class, addressId);
			if(address == null) {
				 throw new RuntimeException("Invalid address ID: " + addressId);
			}
			order.setAddress(address);
			order.setTotalAmount(0.0);
			
			session.save(order);
			
			Double total = 0.0;
			
			for(OrderItem item : items) {
				Listing listing = listingDao.fetchById(item.getListing().getId());
				
				int newQty = listing.getQuantity() - item.getQuantity();
				listing.setQuantity(newQty);
				
				if(newQty == 0) {
					listing.setStatus(Listing.Status.SOLD_OUT);
				}
				
				session.update(listing);
				
				
				OrderItem orderItem = new OrderItem();
				orderItem.setOrder(order);
				orderItem.setListing(listing);
				orderItem.setQuantity(item.getQuantity());
				
				total += listing.getPrice() * orderItem.getQuantity();
				session.save(orderItem);
			}
			
			order.setTotalAmount(total);
			order.setStatus(Order.Status.APPROVED);
			session.update(order);
			
			tx.commit();
			
		}catch(Exception e) {
			if(tx != null) tx.rollback();
			e.printStackTrace();
			order = null;
		} finally {
			session.close();
		}
		return order;
	}
}
