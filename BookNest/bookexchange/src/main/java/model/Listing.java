package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.ForeignKey;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "listings")
public class Listing {
	
	public enum ListingType {
		NEW, OLD, DONATION
	}
	
	public enum ConditionGrade {
		NEW, LIKE_NEW, FAIR, GOOD, POOR
	}
	
	public enum Status {
		ACTIVE, PAUSED, SOLD_OUT, REMOVED
	}
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	@ManyToOne(optional = false)
	@JoinColumn(name = "book_id", referencedColumnName = "id", foreignKey = @ForeignKey(name = "fk_listing_user"))
	private Book book_id;
	
	@ManyToOne(optional = false)
	@JoinColumn(name = "seller_id", referencedColumnName = "id" ,
	            foreignKey = @ForeignKey(name = "fk_listing_user"))
	private User seller_id;
	
	@Enumerated(EnumType.STRING)
	@Column(name = "listing_type", length = 10)
	private ListingType listing_type;
	
	@Enumerated(EnumType.STRING)
	@Column(name = "condition_grade", length = 10)
	private ConditionGrade conditionGrade;
	
	@Column(precision = 10, scale = 2)
	private BigDecimal price;	
	
	@Column(nullable = false)
	private Integer quantity;
	
	@Enumerated(EnumType.STRING)
	@Column(nullable = false, length = 12)
	private Status status = Status.ACTIVE;
	
	@Column(name = "created_at", nullable = false, updatable = false,
            columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
	private LocalDateTime createdAt;
	
	@Column(name = "updated_at", nullable = false,
            columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP")
	private LocalDateTime updatedAt;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Book getBook_id() {
		return book_id;
	}

	public void setBook_id(Book book_id) {
		this.book_id = book_id;
	}

	public User getSeller_id() {
		return seller_id;
	}

	public void setSeller_id(User seller_id) {
		this.seller_id = seller_id;
	}

	public ListingType getListing_type() {
		return listing_type;
	}

	public void setListing_type(ListingType listing_type) {
		this.listing_type = listing_type;
	}

	public ConditionGrade getConditionGrade() {
		return conditionGrade;
	}

	public void setConditionGrade(ConditionGrade conditionGrade) {
		this.conditionGrade = conditionGrade;
	}

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public LocalDateTime getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(LocalDateTime updatedAt) {
		this.updatedAt = updatedAt;
	}
	
	
}
