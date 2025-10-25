package servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import org.hibernate.SessionFactory;

import DAO.BookDao;
import DAO.ListingDao;
import model.Book;
import model.BookImage;
import model.Listing;
import model.Roles;
import model.User;
import util.hibernateUtil;

@WebServlet("/CreateListingServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class createListing extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private SessionFactory sessionFactory;
    private BookDao bookDao;
    private ListingDao listingDao;
    
    // Upload directory path
    private static final String UPLOAD_DIR = "uploads/books";
    
    @Override
    public void init() throws ServletException {
        bookDao = new BookDao(hibernateUtil.getSessionFactory());
        listingDao = new ListingDao(hibernateUtil.getSessionFactory());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in and has SELLER role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Verify user has SELLER role
        boolean isSeller = user.getRoles().stream()
                .anyMatch(role -> role.getName().equals(Roles.Rolename.SELLER));
        
        if (!isSeller) {
            response.sendRedirect("accessDenied.jsp");
            return;
        }
        
        // Forward to createListing.jsp
        request.getRequestDispatcher("createListing.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check session and user authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User seller = (User) session.getAttribute("user");
        
        try {
            // 1. Extract form parameters
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String isbn = request.getParameter("isbn");
            String edition = request.getParameter("edition");
            String listingType = request.getParameter("listingType");
            String condition = request.getParameter("condition");
            String priceStr = request.getParameter("price");
            String quantityStr = request.getParameter("quantity");
            String description = request.getParameter("description");
            String category = request.getParameter("category");
            
            // 2. Validate required fields
            if (title == null || title.trim().isEmpty() || 
                author == null || author.trim().isEmpty() ||
                listingType == null || condition == null || 
                quantityStr == null || category == null) {
                
                request.setAttribute("error", "Please fill all required fields.");
                request.getRequestDispatcher("createListing.jsp").forward(request, response);
                return;
            }
            
            // 3. Parse numeric fields
            double price = 0.0;
            int quantity = 0;
            
            try {
                quantity = Integer.parseInt(quantityStr);
                if (quantity <= 0) {
                    throw new NumberFormatException("Quantity must be positive");
                }
                
                // For DONATION type, price is 0
                if ("DONATION".equals(listingType)) {
                    price = 0.0;
                } else {
                    price = Double.parseDouble(priceStr);
                    if (price <= 0) {
                        throw new NumberFormatException("Price must be positive");
                    }
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid price or quantity: " + e.getMessage());
                request.getRequestDispatcher("createListing.jsp").forward(request, response);
                return;
            }
            
            // 4. Check if book already exists (by ISBN or title+author)
            Book book = null;
            
            if (isbn != null && !isbn.trim().isEmpty()) {
                book = bookDao.fetchBooksByISBN(isbn);
            }
            
            if (book == null) {
                // Check by title and author
                book = bookDao.findBookByTitleAndAuthor(title, author);
            }
            
            // 5. Create new book if not exists
            if (book == null) {
                book = new Book();
                book.setTitle(title.trim());
                book.setAuthor(author.trim());
                book.setIsbn(isbn != null ? isbn.trim() : null);
                book.setEdition(edition != null ? edition.trim() : null);
                book.setCategory(category);
                book.setDescription(description != null ? description.trim() : ""); 
               
                // Save book to database
                bookDao.saveOrUpdate(book);
            }
            
            // 6. Create new Listing
            Listing listing = new Listing();
            listing.setBook(book);
            listing.setSeller(seller);
            listing.setListingType(Listing.ListingType.valueOf(listingType));
            listing.setConditionGrade(Listing.ConditionGrade.valueOf(condition));
            listing.setPrice(price);
            listing.setQuantity(quantity);
            listing.setStatus(Listing.Status.ACTIVE);
            listing.setCreatedAt(LocalDateTime.now());
            listing.setUpdatedAt(LocalDateTime.now());
            
            // 7. Save listing to database
            listingDao.insertListing(listing);
            
            // 8. Handle image uploads
            List<String> imageUrls = handleImageUploads(request, listing.getId());
            
            // 9. Save images to database
            if (!imageUrls.isEmpty()) {
                for (String imageUrl : imageUrls) {
                    BookImage bookImage = new BookImage();
                    bookImage.setBook(book);
                    bookImage.setImageUrl(imageUrl);
                    
                    bookDao.saveBookImage(bookImage);
                }
            }
            
            // 10. Redirect to myListings page with success message
            response.sendRedirect("myListings.jsp?success=true");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error creating listing: " + e.getMessage());
            request.getRequestDispatcher("createListing.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle multiple image uploads
     */
    private List<String> handleImageUploads(HttpServletRequest request, long listingId) 
            throws IOException, ServletException {
        
        List<String> imageUrls = new ArrayList<>();
        
        // Get the absolute path of the upload directory
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
        
        // Create the upload directory if it doesn't exist
        File uploadDir = new File(uploadFilePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Get all uploaded file parts
        for (Part part : request.getParts()) {
            // Check if this part is a file upload (name = "images")
            if (part.getName().equals("images") && part.getSize() > 0) {
                String fileName = extractFileName(part);
                
                // Generate unique filename to prevent conflicts
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = "listing_" + listingId + "_" + 
                                      UUID.randomUUID().toString() + fileExtension;
                
                // Save file to disk
                Path filePath = Paths.get(uploadFilePath, uniqueFileName);
                Files.copy(part.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                
                // Store relative URL for database
                String imageUrl = UPLOAD_DIR + "/" + uniqueFileName;
                imageUrls.add(imageUrl);
                
                // Limit to 5 images
                if (imageUrls.size() >= 5) {
                    break;
                }
            }
        }
        
        return imageUrls;
    }
    
    /**
     * Extract filename from Part header
     */
    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");
        
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        
        return "";
    }
    
    @Override
    public void destroy() {
        if (sessionFactory != null) {
            sessionFactory.close();
        }
    }
}
