package DAO;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import jakarta.persistence.NoResultException;
import model.Book;
import model.BookImage;

public class BookDao {

    private final SessionFactory sessionFactory;

    public BookDao(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }


    // Save or update a book
    public void saveOrUpdate(Book book) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            // MODERNIZED: merge() is the modern equivalent of saveOrUpdate()
            session.merge(book);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw e;
        }
    }

    public boolean addNewBook(Book book) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            // First, check if a book with this ISBN already exists
            Book existingBook = fetchBooksByISBN(book.getIsbn());
            if (existingBook != null) {
                return false; // Book already exists
            }
            
            transaction = session.beginTransaction();
            // MODERNIZED: persist() is the modern equivalent of save()
            session.persist(book);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw e;
        }
    }

    public void deleteById(int id) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            Book book = session.get(Book.class, id);
            if (book != null) {
                // MODERNIZED: remove() is the modern equivalent of delete()
                session.remove(book);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw e;
        }
    }

    public void deleteByISBN(String isbn) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            // FIX: You must first find the book by ISBN, then delete it.
            Book book = fetchBooksByISBN(isbn);
            if (book != null) {
                session.remove(book);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            throw e;
        }
    }

    // --- READ-ONLY METHODS ---

    public Book findById(int id) {
        try (Session session = sessionFactory.openSession()) {
            return session.get(Book.class, id);
        }
    }

    public List<Book> findAll() {
        try (Session session = sessionFactory.openSession()) {
            Query<Book> query = session.createQuery("FROM Book", Book.class);
            // MODERNIZED: Use getResultList() instead of list()
            return query.getResultList();
        }
    }

    public List<Book> fetchBooksByCategory(String category) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "FROM Book WHERE category = :category";
            Query<Book> query = session.createQuery(hql, Book.class);
            query.setParameter("category", category);
            return query.getResultList();
        }
    }

    public List<Book> fetchBooksByAuthor(String author) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "FROM Book WHERE author = :author";
            Query<Book> query = session.createQuery(hql, Book.class);
            query.setParameter("author", author);
            return query.getResultList();
        }
    }

    public Book fetchBooksByISBN(String isbn) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "FROM Book WHERE isbn = :isbn";
            Query<Book> query = session.createQuery(hql, Book.class);
            query.setParameter("isbn", isbn);
            // MODERNIZED: Use getSingleResult() for one expected result.
            try {
                return query.getSingleResult();
            } catch (NoResultException e) {
                return null; // Return null if no book is found
            }
        }
    }

    // This method is used by your servlet to get image URLs for a specific book.
    public List<String> findImageUrlsByBook(Book book) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "SELECT bi.imageUrl FROM BookImage bi WHERE bi.book.id = :bookId";
            Query<String> query = session.createQuery(hql, String.class);
            query.setParameter("bookId", book.getId());
            return query.getResultList();
        }
    }
    
    public Book findBookByTitleAndAuthor(String title, String author) {
        try (Session session = sessionFactory.openSession()) {
            String hql = "FROM Book WHERE title = :title AND author = :author";
            Query<Book> query = session.createQuery(hql, Book.class);
            query.setParameter("title", title);
            query.setParameter("author", author);
            try {
                return query.getSingleResult();
            } catch (NoResultException e) {
                return null;
            }
        }
    }
    
    public void saveBookImage(BookImage bookImage) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();
            session.persist(bookImage); // Use persist() for new entities
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("Error saving book image: " + e.getMessage(), e);
        }
    }
}