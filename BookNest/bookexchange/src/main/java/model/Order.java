package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.ForeignKey;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "orders")
public class Order {
	
	public enum OrderType {
		PURCHASE, DONATION
	}
	
	public enum Status{
		PENDING, APPROVED, PAID, PACKED, SHIPPED, DELIVERED, CANCELLED
	}
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;
	
	@ManyToOne(optional = false)
	@JoinColumn(name = "buyer_id", nullable = false, foreignKey = @ForeignKey(name = "fk_order_users"))
	private User buyer;
	
	@Enumerated(EnumType.STRING)
	@Column(name = "order_type", nullable = false, length = 10)
	private OrderType orderType;
	
	@Enumerated(EnumType.STRING)
	@Column(length = 15, nullable = false)
	private Status status = Status.PENDING;
	
	@Column(name = "total_amount", nullable = false, precision = 10, scale = 2)
	private BigDecimal totalAmount = BigDecimal.valueOf(0.00);
	
	@ManyToOne
	@JoinColumn(name = "shipping_address_id", foreignKey = @ForeignKey(name = "fk_orders_addresses"))
	private Addresses address;
	
	@OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
	private List<Order_items> order_items = new ArrayList<>();
	
	@Column(length = 255)
	private String notes;
	
	@Column(name = "created_at", nullable = false, updatable = false,
            columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private LocalDateTime created_At;
	
	@Column(name = "updated_at", nullable = false,
            columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP")
	private LocalDateTime updated_At;

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

	public BigDecimal getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
	}

	public Addresses getAddress() {
		return address;
	}

	public void setAddress(Addresses address) {
		this.address = address;
	}

	public List<Order_items> getOrder_items() {
		return order_items;
	}

	public void setOrder_items(List<Order_items> order_items) {
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
}
