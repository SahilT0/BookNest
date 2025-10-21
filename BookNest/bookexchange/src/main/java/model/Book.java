package model;

import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(name = "books", uniqueConstraints = {
		@UniqueConstraint(columnNames = "isbn")
})
public class Book {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column(length = 200, nullable = false)
	private String title;
	
	@Transient
	private List<String> ImageUrls;
	
	@Column(length = 150)
	private String author;
	
	@Column(unique = true, nullable = false)
	private String isbn;
	
	@Column(length = 120)
	private String publisher;
	
	@Column(length = 20)
	private String publishingYear;
	
	@Column(length = 50)
	private String edition;
	
	@Column(length = 50)
	private String language;
	
	@Column(length = 50)
	private String category;
	
	@Column(columnDefinition = "TEXT")
	private String description;
	
	private int pages;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getAuthor() {
		return author;
	}
	public void setAuthor(String author) {
		this.author = author;
	}
	public String getIsbn() {
		return isbn;
	}
	public void setIsbn(String isbn) {
		this.isbn = isbn;
	}
	public String getPublisher() {
		return publisher;
	}
	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}
	public String getPublishingYear() {
		return publishingYear;
	}
	public void setPublishingYear(String publishingYear) {
		this.publishingYear = publishingYear;
	}
	public String getEdition() {
		return edition;
	}
	public void setEdition(String edition) {
		this.edition = edition;
	}
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public List<String> getImageUrls() {
		return ImageUrls;
	}
	public void setImageUrls(List<String> imageUrls) {
		ImageUrls = imageUrls;
	}
	public int getPages() {
		return pages;
	}
	public void setPages(int pages) {
		this.pages = pages;
	}
}
