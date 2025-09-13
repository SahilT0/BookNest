package DAO;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import model.Book;

public class BookDao {
	
	private final SessionFactory sessionfactory;
	
	public BookDao(SessionFactory sessionfactory) {
		this.sessionfactory = sessionfactory;
	}
	
    // Save or update a book
	public void saveOrUpdate(Book book) {
		Transaction tx = null;
		try(Session session = sessionfactory.openSession()){
			tx = session.beginTransaction();
			session.saveOrUpdate(book);
			tx.commit();
		}catch (Exception e) {
			if(tx != null) {
				tx.rollback();
			}
			throw e;
		}
	}
	
	public Book findById(int id) {
		try(Session session = sessionfactory.openSession()){
			return session.get(Book.class, id);
		}
	}
	
	public List<Book> findAll(){
		try(Session session = sessionfactory.openSession()){
			Query<Book> query = session.createQuery("from book", Book.class);
			return query.list();
		}
	}
	
	// Fetch books by Category
	public List<Book> fetchBooksByCategory(String category){
		try (Session session = sessionfactory.openSession()) {
            String hql = "FROM Book WHERE category = :category";
            Query<Book> query = session.createQuery(hql, Book.class);
            query.setParameter("category", category);
            return query.list();
        }
	}
	
	// Fetch books by author
	public List<Book> fetchBooksByAuthor(String author){
		try(Session session = sessionfactory.openSession()){
			String hql = "From Book where author = :author";
			Query<Book> query = session.createQuery(hql, Book.class);
			query.setParameter("author", author);
			return query.list();
		}
	}
	
	public Book fetchBooksByISBN(String isbn){
		try(Session session = sessionfactory.openSession()){
			String hql = "From Book where isbn = :isbn";
			Query<Book> query = session.createQuery(hql, Book.class);
			query.setParameter("isbn", isbn);
			return query.uniqueResult();
		}
	}
	
	public boolean addNewBook(Book book) {
		Transaction tx = null;
		try(Session session = sessionfactory.openSession()){
			Query<Book> query = session.createQuery("From Book where isbn = :isbn", Book.class);
			query.setParameter("isbn", book.getIsbn());
			if(query.uniqueResult() != null) {
					return false;
			}
			tx = session.beginTransaction();
			session.save(book);
			tx.commit();
			return true;
		}catch (Exception e) {
			if(tx != null) {
				tx.rollback();
			}
			throw e;
		}
	}
	
	public void deleteById(int id) {
		Transaction tx = null;
		try(Session session = sessionfactory.openSession()){
			tx = session.beginTransaction();
			Book book = session.get(Book.class, id);
			if(book != null) {
				session.delete(book);
			}
			tx.commit();
		}catch (Exception e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		}
	}
	
	public void deleteByISBN(String isbn) {
		Transaction tx = null;
		try(Session session = sessionfactory.openSession()){
			tx = session.beginTransaction();
			Book book = session.get(Book.class, isbn);
			if(book != null) {
				session.delete(book);
			}
			tx.commit();
		}catch(Exception exp) {
			if(tx != null) {
				tx.rollback();
			}
			throw exp;
		}
	}
	
}
