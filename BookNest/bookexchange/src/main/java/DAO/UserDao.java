package DAO;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;

import model.User;
import util.hibernateUtil;

public class UserDao {
	private SessionFactory sessionFactory;
	
	public UserDao() {
		this.sessionFactory = hibernateUtil.getSessionFactory();
	}
	
	public boolean emailExists(String email) {
		try (Session session = sessionFactory.openSession()) {
			Query <User> query = session.createQuery("from User where email = :email", User.class);
			query.setParameter("email", email);
			return query.uniqueResult() != null;
		}
	}
	
	public void saveUser(User user) {
		try (Session session = sessionFactory.openSession()){
			session.beginTransaction();
			session.save(user);
			session.getTransaction().commit();
		}
	}
	
	public User findByEmail(String email) {
		try(Session session = sessionFactory.openSession()){
			Query <User> query = session.createQuery("from User where email = :email", User.class);
			query.setParameter("email", email);
			return query.uniqueResult();
		}
	}

}
