package model;

import java.time.LocalDateTime;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

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
	private Long id;
	
	@ManyToOne(optional = false)
	@JoinColumn(name = "book_id", referencedColumnName = "id", foreignKey = @ForeignKey(name = "fk_listing_book"))
	private Book book;
	
	@Transient
	List<String> imageUrls;
	
	@Transient
	List<Listing> otherListings;
	
	@ManyToOne(optional = false)
	@JoinColumn(name = "seller_id", referencedColumnName = "id" ,
	            foreignKey = @ForeignKey(name = "fk_listing_user"))
	private User seller;
	
	@Enumerated(EnumType.STRING)
	@Column(name = "listing_type", length = 10)
	private ListingType listingType;
	
	@Enumerated(EnumType.STRING)
	@Column(name = "condition_grade", length = 10)
	private ConditionGrade conditionGrade;
	
	@Column(name="price")
	private Double price;	
	
	@Column(nullable = false)
	private Integer quantity;
	
	@Enumerated(EnumType.STRING)
	@Column(nullable = false, length = 12)
	private Status status = Status.ACTIVE;
	
	@CreationTimestamp
	@Column(name = "created_at", nullable = false, updatable = false)
	private LocalDateTime createdAt;
	
	@UpdateTimestamp 
	@Column(name = "updated_at", nullable = false)
	private LocalDateTime updatedAt;
	
	private double averageRating;
	
	private int reviewCount;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Book getBook() {
		return book;
	}

	public void setBook(Book book) {
		this.book = book;
	}

	public List<String> getImageUrls() {
		return imageUrls;
	}

	public void setImageUrls(List<String> imageUrls) {
		this.imageUrls = imageUrls;
	}

	public User getSeller() {
		return seller;
	}

	public void setSeller(User seller) {
		this.seller = seller;
	}
    
	public ListingType getListingType() {
		return listingType;
	}

	public void setListingType(ListingType listingType) {
		this.listingType = listingType;
	}

	public ConditionGrade getConditionGrade() {
		return conditionGrade;
	}

	public void setConditionGrade(ConditionGrade conditionGrade) {
		this.conditionGrade = conditionGrade;
	}

	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
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

	public List<Listing> getOtherListings() {
		return otherListings;
	}

	public void setOtherListings(List<Listing> otherListings) {
		this.otherListings = otherListings;
	}
	
	public double getAverageRating() {
		return averageRating;
	}

	public void setAverageRating(double averageRating) {
		this.averageRating = averageRating;
	}

	public int getReviewCount() {
		return reviewCount;
	}

	public void setReviewCount(int reviewCount) {
		this.reviewCount = reviewCount;
	}
}
