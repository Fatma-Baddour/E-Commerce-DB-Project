/*===========================================================
                1) CREATE DATABASE
===========================================================*/
DROP DATABASE IF EXISTS E__Commerce;
GO

CREATE DATABASE E__Commerce;
GO

USE E__Commerce;
GO


/*===========================================================
                2) CREATE TABLES
===========================================================*/
CREATE TABLE Customer (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName VARCHAR(100),
    Phone VARCHAR(20)
);

CREATE TABLE Cart (
    CartID INT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2),
    Description_ VARCHAR(50),
    Availability_ INT,
    Image_name VARCHAR(50)
);

CREATE TABLE Cart_Item (
    CartItemID INT PRIMARY KEY,
    CartID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (CartID) REFERENCES Cart(CartID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Orders(
    OrderID INT PRIMARY KEY,
    Total_price INT,
    Created_at DATE,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Order_item (
    Order_itemID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT DEFAULT 1,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);


/*===========================================================
                3) STORED PROCEDURES
===========================================================*/

------------------ INSERTS ------------------

-- Insert Customer
DROP PROCEDURE IF EXISTS InsertCustomer;
GO
CREATE PROCEDURE InsertCustomer
@P_CustomerName VARCHAR(100),
@P_Phone VARCHAR(20)
AS
BEGIN
    INSERT INTO Customer(CustomerName, Phone)
    VALUES (@P_CustomerName, @P_Phone);
END;
GO

-- Insert Product
DROP PROCEDURE IF EXISTS InsertProduct;
GO
CREATE PROCEDURE InsertProduct
@P_ProductID INT,
@P_ProductName VARCHAR(100),
@P_Price DECIMAL(10,2),
@P_Description VARCHAR(50),
@P_Availability INT,
@P_Image VARCHAR(50)
AS
BEGIN
    INSERT INTO Product(ProductID, ProductName, Price, Description_, Availability_, Image_name)
    VALUES (@P_ProductID, @P_ProductName, @P_Price, @P_Description, @P_Availability, @P_Image);
END;
GO

-- Insert Cart
DROP PROCEDURE IF EXISTS InsertCart;
GO
CREATE PROCEDURE InsertCart
@P_CartID INT,
@P_CustomerID INT
AS
BEGIN
    INSERT INTO Cart(CartID, CustomerID)
    VALUES (@P_CartID, @P_CustomerID);
END;
GO

-- Insert Cart Item
DROP PROCEDURE IF EXISTS InsertCartItem;
GO
CREATE PROCEDURE InsertCartItem
@P_CartItemID INT,
@P_CartID INT,
@P_ProductID INT,
@P_Quantity INT
AS
BEGIN
    INSERT INTO Cart_Item(CartItemID, CartID, ProductID, Quantity)
    VALUES (@P_CartItemID, @P_CartID, @P_ProductID, @P_Quantity);
END;
GO

-- Insert Order
DROP PROCEDURE IF EXISTS InsertOrder;
GO
CREATE PROCEDURE InsertOrder
@P_OrderID INT,
@P_TotalPrice INT,
@P_CreatedAt DATE,
@P_CustomerID INT
AS
BEGIN
    INSERT INTO Orders(OrderID, Total_price, Created_at, CustomerID)
    VALUES (@P_OrderID, @P_TotalPrice, @P_CreatedAt, @P_CustomerID);
END;
GO

-- Insert Order Item
DROP PROCEDURE IF EXISTS InsertOrderItem;
GO
CREATE PROCEDURE InsertOrderItem
@P_OrderItemID INT,
@P_OrderID INT,
@P_ProductID INT,
@P_Quantity INT
AS
BEGIN
    INSERT INTO Order_item(Order_itemID, OrderID, ProductID, Quantity)
    VALUES (@P_OrderItemID, @P_OrderID, @P_ProductID, @P_Quantity);
END;
GO


------------------ UPDATES ------------------

-- Update Customer
DROP PROCEDURE IF EXISTS UpdateCustomer;
GO
CREATE PROCEDURE UpdateCustomer
@P_CustomerID INT,
@P_Name VARCHAR(100),
@P_Phone VARCHAR(20)
AS
BEGIN
    UPDATE Customer
    SET CustomerName = @P_Name,
        Phone = @P_Phone
    WHERE CustomerID = @P_CustomerID;
END;
GO


------------------ DELETES ------------------

-- Delete Customer
DROP PROCEDURE IF EXISTS DeleteCustomer;
GO
CREATE PROCEDURE DeleteCustomer
@P_CustomerID INT
AS
BEGIN
    DELETE FROM Customer WHERE CustomerID = @P_CustomerID;
END;
GO



/*===========================================================
                4) CREATE VIEWS
===========================================================*/

-- Customer Orders
CREATE VIEW View_CustomerOrders AS
SELECT 
    C.CustomerName,
    O.OrderID,
    O.Total_price,
    O.Created_at
FROM Customer C
JOIN Orders O ON C.CustomerID = O.CustomerID;
GO

-- Cart Summary
CREATE VIEW View_CartSummary AS
SELECT 
    CartID,
    COUNT(ProductID) AS TotalProducts,
    SUM(Quantity) AS TotalQuantity
FROM Cart_Item
GROUP BY CartID;
GO

-- Available Products
CREATE VIEW View_AvailableProducts AS
SELECT *
FROM Product
WHERE Availability_ > 0;
GO

-- DISTINCT Product Names
CREATE VIEW View_DistinctProducts AS
SELECT DISTINCT ProductName
FROM Product;
GO

-- Orders that contain items
CREATE VIEW View_OrdersWithItems AS
SELECT *
FROM Orders O
WHERE EXISTS (SELECT 1 FROM Order_item OI WHERE OI.OrderID = O.OrderID);
GO

-- UNION Example
CREATE VIEW View_AllIDs AS
SELECT CustomerID AS ID FROM Customer
UNION
SELECT ProductID FROM Product;
GO

-- Top Customer by Spending
CREATE VIEW View_TopCustomer AS
SELECT CustomerName, CustomerID
FROM Customer
WHERE CustomerID = (
    SELECT TOP 1 CustomerID FROM Orders ORDER BY Total_price DESC
);
GO


/*===========================================================
                5) INSERT TEST DATA
===========================================================*/

EXEC InsertCustomer 'Omar', '0122326225';
EXEC InsertCustomer 'Sara', '0101234567';

EXEC InsertProduct 1, 'Laptop', 15500.50, 'Gaming Laptop', 5, 'lap.jpg';
EXEC InsertProduct 2, 'Mouse', 200, 'Wireless Mouse', 10, 'mouse.jpg';

EXEC InsertCart 101, 1;

EXEC InsertCartItem 5001, 101, 1, 2;
EXEC InsertCartItem 5002, 101, 2, 1;

EXEC InsertOrder 2001, 16000, '2024-12-01', 1;

EXEC InsertOrderItem 9001, 2001, 1, 1;
EXEC InsertOrderItem 9002, 2001, 2, 1;


/*===========================================================
                6) TEST ALL VIEWS
===========================================================*/
SELECT * FROM View_CustomerOrders;
SELECT * FROM View_CartSummary;
SELECT * FROM View_AvailableProducts;
SELECT * FROM View_DistinctProducts;
SELECT * FROM View_OrdersWithItems;
SELECT * FROM View_AllIDs;
SELECT * FROM View_TopCustomer;
