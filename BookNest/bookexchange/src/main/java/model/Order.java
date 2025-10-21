package model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "orders")
public class Order {
	
	public enum OrderType {
		PURCHASE, DONATION
	}
	
	public enum Status{
		PENDING, APPROVED, PAID, PACKED, SHIPPED, DELIVERED, CANCELLED
	}
	
	public enum PaymentMethod{
		COD, UPI
	}
	
	public enum DeliveryMethod{
		STANDARD, EXPRESS
	}
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@ManyToOne(optional = false)
	@JoinColumn(name = "buyer_id", nullable = false, foreignKey = @ForeignKey(name = "fk_order_users"))
	private User buyer;
	
	@Enumerated(EnumType.STRING)
	@Column(name = "order_type", nullable = false, length = 10)
	private OrderType orderType;
	
	@Enumerated(EnumType.STRING)
	@Column(length = 15, nullable = false)
	private Status status = Status.PENDING;
	
	@Column(name = "total_amount", nullable = false, precision = 10)
	private Double totalAmount;
	
	@Enumerated(EnumType.STRING)
	@Column(length = 20, nullable = false)
	private PaymentMethod paymentMethod;
	
	@Enumerated(EnumType.STRING)
	@Column(length = 15, nullable = false)
	private DeliveryMethod deliveryMethod;
	
	@ManyToOne
	@JoinColumn(name = "shipping_address_id", foreignKey = @ForeignKey(name = "fk_orders_addresses"))
	private Addresses address;
	
	@OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
	private List<OrderItem> order_items = new ArrayList<>();
	
	@Column(length = 255)
	private String notes;
	
	@Column(name = "created_at", nullable = false, updatable = false,
            columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private LocalDateTime created_At;
	
	@Column(name = "updated_at", nullable = false,
            columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP")
	private LocalDateTime updated_At;
	
	@Column(name = "razorpay_order_id", unique = true)
	private String razorpayOrderId;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public User getBuyer() {
		return buyer;
	}

	public void setBuyer(User buyer) {
		this.buyer = buyer;
	}

	public OrderType getOrderType() {
		return orderType;
	}

	public void setOrderType(OrderType orderType) {
		this.orderType = orderType;
	}

	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}

	public Double getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(Double total) {
		this.totalAmount = total;
	}
	
	public Addresses getAddress() {
		return address;
	}

	public void setAddress(Addresses address) {
		this.address = address;
	}

	public List<OrderItem> getOrder_items() {
		return order_items;
	}

	public void setOrder_items(List<OrderItem> order_items) {
		this.order_items = order_items;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public LocalDateTime getCreated_At() {
		return created_At;
	}

	public void setCreated_At(LocalDateTime created_At) {
		this.created_At = created_At;
	}

	public LocalDateTime getUpdated_At() {
		return updated_At;
	}

	public void setUpdated_At(LocalDateTime updated_At) {
		this.updated_At = updated_At;
	}

	public PaymentMethod getPaymentMethod() {
		return paymentMethod;
	}

	public void setPaymentMethod(PaymentMethod paymentMethod) {
		this.paymentMethod = paymentMethod;
	}

	public DeliveryMethod getDeliveryMethod() {
		return deliveryMethod;
	}

	public void setDeliveryMethod(DeliveryMethod deliveryMethod) {
		this.deliveryMethod = deliveryMethod;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getRazorpayOrderId() {
		return razorpayOrderId;
	}

	public void setRazorpayOrderId(String razorpayOrderId) {
		this.razorpayOrderId = razorpayOrderId;
	}
}
