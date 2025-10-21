package model;

import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(name = "roles", uniqueConstraints = {
		@UniqueConstraint(columnNames = "name")
})
public class Roles {
	
	public enum Rolename{
		BUYER, SELLER, ADMIN, DONOR
	}
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	@Enumerated(EnumType.STRING)
	@Column(length = 20, nullable = false, unique = true)
	private Rolename name;
	
	@ManyToMany(mappedBy = "roles")
	private Set<User> users = new HashSet<>();
	
	public Set<User> getUsers() {
		return users;
	}
	public void setUsers(Set<User> users) {
		this.users = users;
	}
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Rolename getName() {
		return name;
	}
	public void setName(Rolename name) {
		this.name = name;
	}
	
}
