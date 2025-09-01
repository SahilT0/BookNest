System Requirements - Book Exchange Platform - BookNest 


## 1. Overview
A JSP/Servlet + Hibernate + MySQL web app for buying, selling, and donating books with Buyer/Seller/Admin roles.


## 2. Functional Requirements (FR)
### Authentication & Profile
- **FR-01**: User can register with name, email, password (bcrypt), and phone.
- **FR-02**: User can log in/log out; invalid credentials show error.
- **FR-03**: User can view/update profile.
- **FR-04**: Role switch via profile dropdown: Buyer / Seller / Admin (if permitted).

### Catalog & Search (Buyer)
- **FR-05**: View **New Books** catalog; filter by title/author/category.
- **FR-06**: View **Old Books** catalog; filter by condition/price.
- **FR-07**: View book detail with images and seller name (masked contact).
- **FR-08**: Add to cart; update quantity; remove from cart.

### Orders & Checkout
- **FR-09**: Checkout flow: select address → review order → place order.
- **FR-10**: (If enabled) Pay via gateway stub; mark order **PAID** on success.
- **FR-11**: Buyer can view order history & status (PENDING…DELIVERED).

### Listings (Seller)
- **FR-12**: Seller can create listing: **NEW** or **OLD**, price, quantity, condition (for OLD), images.
- **FR-13**: Seller can edit, pause, or delete own listings.
- **FR-14**: Quantity auto-decrements on successful order; status becomes **SOLD_OUT** at 0.

### Donations (Phase 1)
- **FR-15**: Any user can **donate** a book (listing_type=**DONATION**, price NULL).
- **FR-16**: Registered students can **request** a donated listing (queue).
- **FR-17**: Admin approves one request → create **DONATION** order (₹0), decrement quantity.

### Admin
- **FR-18**: Admin can view/manage users (activate/deactivate).
- **FR-19**: Admin can view/remove inappropriate listings.
- **FR-20**: Admin can approve/deny donation requests.
- **FR-21**: Admin can view basic reports (users count, active listings, orders, donations).

### Addresses & Delivery (basic)
- **FR-22**: User can manage multiple addresses; set default.
- **FR-23**: Seller/Admin can update order status (PACKED/SHIPPED/DELIVERED).


## 3. Non-Functional Requirements (NFR)
- **NFR-01 Security**: Passwords stored with **bcrypt**; session timeout ≥ 20 min; input validation via Hibernate Validator/JSP.
- **NFR-02 Authorization**: Role-based access (Buyer/Seller/Admin); server-side checks on every protected action.
- **NFR-03 Performance**: Search responds ≤ 2s for ≤ 10k listings; pagination 12–24 items/page.
- **NFR-04 Reliability/ACID**: Place-order & donation-approve flows run in a single DB transaction; no oversell.
- **NFR-05 Usability**: Mobile-responsive (Bootstrap); keyboard-accessible forms; clear error messages.
- **NFR-06 Maintainability**: Maven project with layered packages (servlet/dao/model); code documented; Git commits per feature.
- **NFR-07 Compatibility**: Works on Chrome/Firefox/Edge (latest); Tomcat 9; Java 17; MySQL 8.
- **NFR-08 Privacy**: Show limited seller info to buyers; no plain-text passwords/logs.
- **NFR-09 Availability**: App recovers from server restart without manual steps; DB backups weekly (dev note).
- **NFR-10 Localization (basic)**: UTF-8 everywhere; support English; allow Indian names & book titles.


## 4. Constraints & Assumptions
- Stack locked to: Java, JSP, Servlet, Hibernate, MySQL, Maven, Tomcat 9, Bootstrap, (jQuery optional).
- Payment is a **stub** in Phase 1 (no real money movement).
- Deliveries tracked as simple statuses; no courier API in Phase 1.


## 5. Acceptance Criteria (samples)
- Login with correct creds → redirects to dashboard within 2s (**FR-02**).
- Adding listing reduces inventory on paid order (**FR-14**, **NFR-04**).
- Donation approval creates a ₹0 order and marks request as FULFILLED (**FR-17**).

