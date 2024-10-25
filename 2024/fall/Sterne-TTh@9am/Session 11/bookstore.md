# Online Bookstore and Inventory Management

## App Overview

The **Online Bookstore and Inventory Management** app is designed to manage book inventory, customer orders, and supplier information for a bookstore. The system keeps track of available books, customer details, placed orders, and shipments from suppliers.

The app follows a well-organized structure with the following key components:

1. **Books**: Stores details about each book sold in the bookstore.
2. **Inventory**: Keeps track of how many copies of each book are available in stock.
3. **Customers**: Stores customer information for placing and tracking orders.
4. **Orders**: Records customer orders and the total amounts.
5. **OrderItems**: Tracks the books and quantities purchased in each order.
6. **Suppliers**: Keeps information about the suppliers who provide the books.
7. **Shipments**: Tracks shipments of books received from suppliers for restocking.

---

## Tables and Columns

### 1. **Books Table**
The `Books` table contains information about each book, such as title, author, ISBN, price, and supplier. This table holds the core information about the books being sold.

| Column Name  | Description                          |
|--------------|--------------------------------------|
| **BookID**   | Primary key, unique identifier for each book. |
| Title        | The title of the book.               |
| Author       | The author of the book.              |
| ISBN         | Unique ISBN number for the book.     |
| Price        | Price of the book.                   |
| SupplierID   | Foreign key to the `Suppliers` table, identifying the supplier of the book. |

---

### 2. **Inventory Table**
The `Inventory` table keeps track of the stock level for each book in the bookstore. It references the `Books` table using a foreign key.

| Column Name  | Description                          |
|--------------|--------------------------------------|
| **BookID**   | Primary key and foreign key to the `Books` table, uniquely identifying the book. |
| Stock        | Number of copies available in stock. |

---

### 3. **Customers Table**
The `Customers` table stores details about customers who place orders in the bookstore. It includes basic information such as name and email.

| Column Name  | Description                          |
|--------------|--------------------------------------|
| **CustomerID** | Primary key, unique identifier for each customer. |
| FirstName      | First name of the customer.        |
| LastName       | Last name of the customer.         |
| Email          | Unique email address for the customer. |

---

### 4. **Orders Table**
The `Orders` table records customer orders, including the total amount and the customer who placed the order. It references the `Customers` table.

| Column Name  | Description                          |
|--------------|--------------------------------------|
| **OrderID**   | Primary key, unique identifier for each order. |
| CustomerID    | Foreign key to the `Customers` table, identifying the customer who placed the order. |
| OrderDate     | Date and time when the order was placed. |
| TotalAmount   | Total amount for the order.         |

---

### 5. **OrderItems Table**
The `OrderItems` table tracks which books were purchased in each order, including the quantity of each book and the price at the time of purchase. It references both the `Orders` and `Books` tables.

| Column Name     | Description                          |
|-----------------|--------------------------------------|
| **OrderItemID**  | Primary key, unique identifier for each order item. |
| OrderID         | Foreign key to the `Orders` table, identifying the order this item belongs to. |
| BookID          | Foreign key to the `Books` table, identifying the book that was ordered. |
| Quantity        | Quantity of the book purchased.      |
| PriceAtPurchase | Price of the book at the time of the order. |

---

### 6. **Suppliers Table**
The `Suppliers` table contains details about the suppliers who provide books to the bookstore. It is referenced by the `Books` table.

| Column Name    | Description                          |
|----------------|--------------------------------------|
| **SupplierID** | Primary key, unique identifier for each supplier. |
| SupplierName   | Name of the supplier.                |
| ContactEmail   | Contact email address for the supplier. |

---

### 7. **Shipments Table**
The `Shipments` table tracks the shipments of books received from suppliers for restocking purposes. It references both the `Suppliers` and `Books` tables.

| Column Name    | Description                          |
|----------------|--------------------------------------|
| **ShipmentID** | Primary key, unique identifier for each shipment. |
| SupplierID     | Foreign key to the `Suppliers` table, identifying the supplier that sent the shipment. |
| BookID         | Foreign key to the `Books` table, identifying the book being restocked. |
| ShipmentDate   | Date the shipment was received.      |
| Quantity       | Quantity of books received in the shipment. |

---