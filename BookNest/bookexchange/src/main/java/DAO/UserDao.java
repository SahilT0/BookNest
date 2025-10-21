package DAO;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import jakarta.persistence.NoResultException;
import model.Roles;
import model.User;

public class UserDao {
    
    private final SessionFactory sessionFactory;

    // MODERNIZED: Use constructor dependency injection for better testability.
    public UserDao(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }
    
    public User getUserById(long id) {
    	try(Session session = sessionFactory.openSession()){
    		Query<User> query = session.createQuery("from User u where u.id = :id", User.class);
    		query.setParameter("id", id);
    		return query.getSingleResult();
    	}
    }

    public boolean emailExists(String email) {
        try (Session session = sessionFactory.openSession()) {
            // MODERNIZED: A 'count' query is more efficient for checking existence.
            Query<Long> query = session.createQuery(
                "SELECT count(u.id) FROM User u WHERE u.email = :email", Long.class
            );
            query.setParameter("email", email);
            return query.getSingleResult() > 0;
        }
    }

    public boolean phoneExists(String phone) {
        try (Session session = sessionFactory.openSession()) {
            Query<Long> query = session.createQuery(
                "SELECT count(u.id) FROM User u WHERE u.phone = :phone", Long.class
            );
            query.setParameter("phone", phone);
            return query.getSingleResult() > 0;
        }
    }

    public void saveUser(User user) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            // MODERNIZED: Use the standard, safe transaction pattern.
            transaction = session.beginTransaction();
            
            // MODERNIZED: Use persist() for new objects.
            session.persist(user);

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw e; // Re-throw the exception after rolling back
        }
    }

    public User findByEmail(String email) {
        try (Session session = sessionFactory.openSession()) {
            Query<User> query = session.createQuery("FROM User u WHERE u.email = :email", User.class);
            query.setParameter("email", email);
            
            // MODERNIZED: Use getSingleResult() to get one result or throw an exception.
            try {
                return query.getSingleResult();
            } catch (NoResultException e) {
                return null; // Return null if no user is found
            }
        }
    }

    public Roles getRoleByName(Roles.Rolename name) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "FROM Roles r WHERE r.name = :name";
            Query<Roles> query = session.createQuery(hql, Roles.class);
            query.setParameter("name", name);
            
            try {
                return query.getSingleResult();
            } catch (NoResultException e) {
                return null; // Return null if no role is found
            }
        }
    }
}