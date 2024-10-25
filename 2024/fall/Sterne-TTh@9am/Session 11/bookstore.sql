-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- 6. Suppliers Table
CREATE TABLE Suppliers (
    SupplierID INTEGER PRIMARY KEY AUTOINCREMENT,
    SupplierName TEXT NOT NULL,
    ContactEmail TEXT NOT NULL
);

-- 1. Books Table
CREATE TABLE Books (
    BookID INTEGER PRIMARY KEY AUTOINCREMENT,
    Title TEXT NOT NULL,
    Author TEXT NOT NULL,
    ISBN TEXT UNIQUE NOT NULL,
    Price NUMERIC(11, 2) NOT NULL,
    SupplierID INTEGER,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- 2. Inventory Table
CREATE TABLE Inventory (
    BookID INTEGER PRIMARY KEY,
    Stock INTEGER NOT NULL,
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- 3. Customers Table
CREATE TABLE Customers (
    CustomerID INTEGER PRIMARY KEY AUTOINCREMENT,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    Email TEXT UNIQUE NOT NULL
);

-- 4. Orders Table
CREATE TABLE Orders (
    OrderID INTEGER PRIMARY KEY AUTOINCREMENT,
    CustomerID INTEGER NOT NULL,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount NUMERIC(11, 2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 5. OrderItems Table
CREATE TABLE OrderItems (
    OrderItemID INTEGER PRIMARY KEY AUTOINCREMENT,
    OrderID INTEGER NOT NULL,
    BookID INTEGER NOT NULL,
    Quantity INTEGER NOT NULL,
    PriceAtPurchase NUMERIC(11, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- 7. Shipments Table
CREATE TABLE Shipments (
    ShipmentID INTEGER PRIMARY KEY AUTOINCREMENT,
    SupplierID INTEGER NOT NULL,
    BookID INTEGER NOT NULL,
    ShipmentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Quantity INTEGER NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Insert sample data into Suppliers
INSERT INTO Suppliers (SupplierName, ContactEmail) VALUES 
('Penguin Random House', 'contact@penguinrandomhouse.com'),
('HarperCollins', 'info@harpercollins.com'),
('Simon & Schuster', 'contact@simonandschuster.com'),
('Macmillan', 'info@macmillan.com'),
('Hachette Book Group', 'contact@hachette.com');

-- Insert sample data into Books
INSERT INTO Books (Title, Author, ISBN, Price, SupplierID) VALUES 
('The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 10.99, 1),
('1984', 'George Orwell', '9780451524935', 9.99, 2),
('To Kill a Mockingbird', 'Harper Lee', '9780061120084', 12.99, 1),
('Moby Dick', 'Herman Melville', '9781503280786', 11.50, 3),
('Pride and Prejudice', 'Jane Austen', '9781503290563', 8.99, 2);

-- Insert sample data into Inventory
INSERT INTO Inventory (BookID, Stock) VALUES 
(1, 100),
(2, 50),
(3, 80),
(4, 60),
(5, 90);

-- Insert sample data into Customers
INSERT INTO Customers (FirstName, LastName, Email) VALUES 
('John', 'Doe', 'john.doe@example.com'),
('Jane', 'Smith', 'jane.smith@example.com'),
('Alice', 'Johnson', 'alice.johnson@example.com'),
('Bob', 'Brown', 'bob.brown@example.com'),
('Charlie', 'Davis', 'charlie.davis@example.com');

-- Insert sample data into Orders
INSERT INTO Orders (CustomerID, TotalAmount) VALUES 
(1, 30.98),
(2, 19.99),
(3, 25.48),
(4, 50.97),
(5, 41.97);

-- Insert sample data into OrderItems
INSERT INTO OrderItems (OrderID, BookID, Quantity, PriceAtPurchase) VALUES 
(1, 1, 2, 10.99),
(1, 2, 1, 9.99),
(2, 3, 1, 12.99),
(3, 4, 2, 11.50),
(3, 5, 1, 8.99),
(4, 1, 4, 10.99),
(4, 3, 2, 12.99),
(5, 2, 3, 9.99),
(5, 5, 2, 8.99);

-- Insert sample data into Shipments
INSERT INTO Shipments (SupplierID, BookID, Quantity) VALUES 
(1, 1, 200),
(2, 2, 150),
(1, 3, 100),
(3, 4, 120),
(2, 5, 90),
(5, 1, 50),
(4, 3, 80);

-- SQL Queries
-- 1. What are the total sales for a particular book?
SELECT b.Title, SUM(oi.Quantity * oi.PriceAtPurchase) AS TotalSales
FROM OrderItems oi
JOIN Books b ON oi.BookID = b.BookID
WHERE b.Title = 'The Great Gatsby'
GROUP BY b.Title;

--2. Which customer has placed the largest order by total amount?
SELECT c.FirstName || ' ' || c.LastName AS CustomerName, MAX(o.TotalAmount) AS LargestOrder
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

--3. What is the current stock of each book?
SELECT b.Title, i.Stock
FROM Inventory i
JOIN Books b ON i.BookID = b.BookID;

--4. How many books were ordered by each customer?
SELECT c.FirstName || ' ' || c.LastName AS CustomerName, SUM(oi.Quantity) AS TotalBooksOrdered
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY c.CustomerID;

--5. What are the total quantities of books supplied by each supplier?
SELECT s.SupplierName, SUM(sh.Quantity) AS TotalSupplied
FROM Shipments sh
JOIN Suppliers s ON sh.SupplierID = s.SupplierID
GROUP BY s.SupplierID;

-- Create a de-normalized table that combines book details and order items
CREATE TABLE OrdersCombined (
    OrderID INTEGER,
    BookTitle TEXT,
    Author TEXT,
    Quantity INTEGER,
    PriceAtPurchase NUMERIC(11, 2),
    OrderDate DATETIME
);

-- Insert data by joining Orders, OrderItems, and Books tables into OrdersCombined
INSERT INTO OrdersCombined (OrderID, BookTitle, Author, Quantity, PriceAtPurchase, OrderDate)
SELECT o.OrderID, b.Title, b.Author, oi.Quantity, oi.PriceAtPurchase, o.OrderDate
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Books b ON oi.BookID = b.BookID;

-- Query the de-normalized table
SELECT * FROM OrdersCombined;

