package model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "addresses")
public class Addresses {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	@Column(unique = true, nullable = false)
	@ManyToOne
	@JoinColumn(name = "user_id")
	private User user_id;
	
	@Column(name = "line1", length = 150, nullable = false)
	private String line1;
	
	@Column(name = "line2", length = 150)
	private String line2;
	
	@Column(length = 80, nullable = false)	
	private String city;
	
	@Column(length = 80, nullable = false)
	private String state;
	
	@Column(name = "postal_code", length = 20, nullable = false)
	private String postal_code;
	
	@Column(length = 80, nullable = false, columnDefinition = "varchar(80) default 'India'")
	private String country;
	
	@Column(name = "is_default", nullable = false, columnDefinition = "boolean default false")
	private boolean is_default;
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public User getUser_id() {
		return user_id;
	}

	public void setUser_id(User user_id) {
		this.user_id = user_id;
	}

	public String getLine1() {
		return line1;
	}

	public void setLine1(String line1) {
		this.line1 = line1;
	}

	public String getLine2() {
		return line2;
	}

	public void setLine2(String line2) {
		this.line2 = line2;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getPostal_code() {
		return postal_code;
	}

	public void setPostal_code(String postal_code) {
		this.postal_code = postal_code;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public boolean isIs_default() {
		return is_default;
	}

	public void setIs_default(boolean is_default) {
		this.is_default = is_default;
	}
	
}
