package DAO;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import model.Addresses;

public class AddressesDao {

    private final SessionFactory sessionFactory;

    public AddressesDao(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    // Add new address
    public boolean addAddress(Addresses address) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            session.persist(address);
            transaction.commit();
            return true;
        } catch(Exception ex) {
            if(transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            System.out.println("Error adding address: " + ex.getMessage());
            ex.printStackTrace();
            throw ex;
        }
    }


    // Update address
    public boolean updateAddress(Addresses address) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            session.merge(address);
            transaction.commit();
            return true;
        } catch(Exception ex) {
            if(transaction != null) transaction.rollback();
            throw ex;
        }
    }

    // Delete address
    public boolean deleteAddress(Long addressId) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            Addresses address = session.get(Addresses.class, addressId);
            if(address != null) session.remove(address);
            transaction.commit();
            return address != null;
        } catch(Exception ex) {
            if(transaction != null) transaction.rollback();
            throw ex;
        }
    }

    // Fetch addresses by user
    public List<Addresses> getAddressesByUserId(Long userId) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "FROM Addresses a WHERE a.user_id.id = :userId";
            Query<Addresses> query = session.createQuery(hql, Addresses.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        }
    }

    // Get address by ID
    public Addresses getAddressById(Long addressId) {
        try (Session session = sessionFactory.openSession()) {
            return session.get(Addresses.class, addressId);
        }
    }

    // Get default address for user
    public Addresses getDefaultAddress(Long userId) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "FROM Addresses a WHERE a.user_id.id = :userId AND a.is_default = true";
            Query<Addresses> query = session.createQuery(hql, Addresses.class);
            query.setParameter("userId", userId);
            List<Addresses> addresses = query.getResultList();
            return addresses.isEmpty() ? null : addresses.get(0);
        }
    }

    // Set specified address as default for user
    public void setDefaultAddress(Long userId, Long addressId) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();

            String hql = "FROM Addresses a WHERE a.user_id.id = :userId";
            Query<Addresses> query = session.createQuery(hql, Addresses.class);
            query.setParameter("userId", userId);

            for (Addresses addr : query.getResultList()) {
                addr.setIs_default(addr.getId().equals(addressId));
                session.merge(addr);
            }

            transaction.commit();
        } catch(Exception ex) {
            if(transaction != null) transaction.rollback();
            throw ex;
        }
    }
}
