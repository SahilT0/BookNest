Module Description – User Management

You’ll write theory like this in your report:

Overview:
The User Management module is responsible for handling student/guest/admin registration and login. It ensures only authorized users can access specific functionalities of the system.

Features Implemented in Registration:

User can create an account by providing name, email, and password.

System validates email uniqueness.

Data is securely stored in MySQL database using Hibernate ORM.

Proper error handling and feedback are provided to users.

Why Hibernate:
Hibernate is used to map Java objects to database tables, eliminating the need for manual SQL queries and reducing boilerplate code.

Flow:

User submits form on register.jsp.

RegisterServlet processes the request.

Hibernate DAO layer saves user into users table.

On success → redirect to login.

On failure → show error message.