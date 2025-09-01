## Primary Use Cases


### UC-01 Register
**Actor**: Guest  
**Goal**: Create account.  
**Pre**: Guest not logged in.  
**Main Flow**: Fill form → validate → create user → success screen.  
**Post**: User exists with BUYER role by default.


### UC-02 Login / Logout
**Actor**: Registered User  
**Goal**: Start/End session.  
**Post**: Session created/destroyed.


### UC-03 Switch Role
**Actor**: Registered User  
**Goal**: Switch portal: Buyer/Seller/Admin (if permitted).


### UC-04 Browse New Books
**Actor**: Buyer  
**Goal**: View/filter new book listings.


### UC-05 Browse Old Books
**Actor**: Buyer  
**Goal**: View/filter old book listings by condition/price.


### UC-06 View Book Details
**Actor**: Buyer  
**Goal**: See details & images.


### UC-07 Add to Cart / Update Cart
**Actor**: Buyer  
**Goal**: Manage cart.


### UC-08 Checkout & Place Order
**Actor**: Buyer  
**Includes**: Select Address, Calculate Total, Confirm Order  
**Extends**: Make Payment (stub)  
**Post**: Order created; inventory reserved/updated.


### UC-09 Manage Addresses
**Actor**: Buyer  
**Goal**: Add/edit/delete addresses; set default.


### UC-10 Create Listing (New/Old)
**Actor**: Seller  
**Goal**: Post listing with price/qty/(condition for Old).  
**Post**: Listing visible if ACTIVE.


### UC-11 Manage Listings
**Actor**: Seller  
**Goal**: Edit/pause/delete listings.


### UC-12 Donate Book
**Actor**: Registered User  
**Goal**: Create DONATION listing (price NULL).


### UC-13 Request Donated Book
**Actor**: Buyer  
**Goal**: Join queue for a donation listing.


### UC-14 Approve Donation
**Actor**: Admin  
**Goal**: Approve one requester → create ₹0 order; decrement qty.


### UC-15 Manage Users/Listings
**Actor**: Admin  
**Goal**: Activate/deactivate users; remove listings.


### UC-16 View Orders / Update Status
**Actor**: Seller/Admin  
**Goal**: Mark PACKED/SHIPPED/DELIVERED.


### UC-17 View Reports
**Actor**: Admin  
**Goal**: Basic metrics (users, listings, orders, donations).
