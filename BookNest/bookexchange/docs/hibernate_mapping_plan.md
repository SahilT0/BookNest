
we have 10 entities :
    1. Users
    2. Roles
    3. User_roles
    4. Addresses
    5. Books
    6. Book_Images
    7. Listings
    8. Orders
    9. Order_items
    10. Doantion requests
    
-> use @Enumerated(EnumType.STRING) for orderType , status, Listing Type , conditional Grade
-> Many to one - Listings.book, listings.seller, Orders.book, OrderItem.listings
-> One to many - Books Images, Order Items 

    