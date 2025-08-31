---- INVENTORY LOGIC -----

On Order Placement (in one DB transaction)
   1. lock listing row (select ____ for update) via hibernate.
   2.  check quantity >= requested.
   3. insert order + order items 
   4. decrement listings.quantity
   5. if quantity == 0 , set status sold out.
   
On Donation Approval:
   1. create orders.orderType = 'Donation' with 0 pricing and one order now referencing the donated list.
   2. mark donationrequest.status = 'fulfilled' and reduce listings.quantity.
   