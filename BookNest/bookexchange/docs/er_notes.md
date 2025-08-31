

 ------- Design Goal -----
 -> Separate Book metadata (title / author/ ISBN) from listings (who sells/donates , price, quantity, condition.
 -> Supports role (buyer / seller / admin) and role switching per user.
 -> Handles NEW / OLD / DONATION flows.
 -> Keep orders and order items generic (donations are orders with zero price and approval).
 -> Track inventory via listings quantity.
 
 
 ------ Entities ------
 -> users (1) --< user role (N) >-- roles (1).
 -> books (1) --< listings (N) --(seller id -> users).
 -> orders (1) --< order items (N) --(listing id -> listings).
 -> donation request (N) -> listings (1, type=Donation )
 -> addresses (N) -> users (1)
 -> book images (N) -> books (1)
 
 
 --------- Naming & Conventions --------
 -> Snake case table names ; singular nouns 
 -> id BIGINT PK auto inc
 -> created at , updated at Time stamp.
 -> Foreign keys with ON UPDATE CASCADE ON DELETE RESTRICT (or SET NULL where noted).
 -> Enums stored as VARCHAR with CHECK constraints
 
 
 
 ------- we seperated books and listings ---------
 -> a book equals metadata (title, author, ISBN).
 -> a listing = instance being sold/ donated by some user (condition, price , availability).
 -> This separation avoids duplicating book details every time someone lists the same book.
 -> Likely describes whether you track stock per listing, how many copies exist, and what happens when a book is donated or sold.