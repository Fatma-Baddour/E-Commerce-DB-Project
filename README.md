# E-Commerce Database Management System

This project is a database management system for an e-commerce platform.  
It provides a complete SQL script that builds the database from scratch, including tables, relationships, stored procedures, views, and sample test data.

## Team Members
- Fatma Bahaa Baddour (324243085) - Section 8  
- Shahd Nashat Salah (324243152) - Section 5  
- Omar Ahmed Fouad (324243580) - Section 8  
- Shahd Mostafa Gadallah (323240209) - Section 5  
- Omar Gamal Mahmoud (324243631) - Section 8  

## Project Description
The system allows customers to browse products, add items to their shopping cart, place orders, and complete purchases.  
It manages essential operations such as:
- Customer registration  
- Shopping cart management  
- Adding products to cart  
- Creating orders  
- Tracking order items  
- Product management  

## Technologies Used
- SQL Server  
- SQL (T-SQL)  

## Database Features
- Relational database design  
- Primary and foreign key constraints  
- Stored procedures for insert, update, and delete operations  
- Views for reporting and data retrieval  
- Sample data for testing  

## Entities
- Customer  
- Cart  
- Cart_Item  
- Product  
- Orders  
- Order_item  

## How to Run
1. Open **SQL Server Management Studio**  
2. Create a new query  
3. Copy and paste the SQL script  
4. Execute the script  
5. The database `E__Commerce` will be created automatically  

## Sample Outputs
After running the script, you can test using:

```sql
SELECT * FROM View_CustomerOrders;
SELECT * FROM View_CartSummary;
SELECT * FROM View_AvailableProducts;
SELECT * FROM View_DistinctProducts;
SELECT * FROM View_OrdersWithItems;
SELECT * FROM View_AllIDs;
SELECT * FROM View_TopCustomer;
