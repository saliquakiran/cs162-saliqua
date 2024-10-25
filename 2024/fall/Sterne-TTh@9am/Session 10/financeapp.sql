-- Database Schema
-- Create Users Table
CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY,
    username TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);

-- Create Accounts Table
CREATE TABLE Accounts (
    account_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    account_name TEXT NOT NULL,
    account_type TEXT CHECK(account_type IN ('Savings', 'Credit', 'Debit')),
    balance REAL DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create Categories Table
CREATE TABLE Categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

-- Create Transactions Table
CREATE TABLE Transactions (
    transaction_id INTEGER PRIMARY KEY,
    account_id INTEGER,
    category_id INTEGER,
    amount REAL NOT NULL,
    transaction_date DATE NOT NULL,
    transaction_type TEXT CHECK(transaction_type IN ('Income', 'Expense')),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Data Insertion
-- Insert data into Users Table
INSERT INTO Users (username, email, password) 
VALUES 
    ('johndoe', 'john@example.com', 'password123'),
    ('janedoe', 'jane@example.com', 'password456'),
    ('bobsmith', 'bob@example.com', 'password789'),
    ('alicesmith', 'alice@example.com', 'password1011');

-- Insert data into Accounts Table
INSERT INTO Accounts (user_id, account_name, account_type, balance)
VALUES 
    (1, 'Bank Account', 'Savings', 1500.00),
    (1, 'Credit Card', 'Credit', -500.00),
    (2, 'Debit Card', 'Debit', 800.00),
    (3, 'Savings Account', 'Savings', 2500.00);

-- Insert data into Categories Table
INSERT INTO Categories (category_name) 
VALUES 
    ('Rent'), 
    ('Groceries'), 
    ('Salary'), 
    ('Entertainment');

-- Insert data into Transactions Table
INSERT INTO Transactions (account_id, category_id, amount, transaction_date, transaction_type) 
VALUES 
    (1, 3, 2000.00, '2024-01-15', 'Income'),    -- Salary
    (1, 1, -800.00, '2024-01-20', 'Expense'),   -- Rent
    (2, 2, -150.00, '2024-01-21', 'Expense'),   -- Groceries
    (2, 4, -50.00, '2024-01-22', 'Expense'),    -- Entertainment
    (3, 3, 3000.00, '2024-01-10', 'Income'),    -- Salary
    (3, 1, -1000.00, '2024-01-15', 'Expense'),  -- Rent
    (4, 2, -200.00, '2024-01-18', 'Expense'),   -- Groceries
    (4, 4, -100.00, '2024-01-19', 'Expense');   -- Entertainment

-- Visualizing the tables
SELECT * FROM Users;
SELECT * FROM Accounts;
SELECT * FROM Categories;
SELECT * FROM Transactions;

-- Queries
-- 1. Query: What is the total balance for each account?
SELECT account_name, balance 
FROM Accounts 
WHERE user_id = 1;

-- 2. Query: How much has the user spent in each category?
SELECT c.category_name, SUM(t.amount) AS total_spent
FROM Transactions t
JOIN Categories c ON t.category_id = c.category_id
WHERE t.transaction_type = 'Expense' 
GROUP BY c.category_name;

-- 3. Query: What is the total income for the user in January 2024?
SELECT SUM(amount) AS total_income
FROM Transactions
WHERE transaction_type = 'Income' 
AND strftime('%Y-%m', transaction_date) = '2024-01';

-- 4. Query: What are the transactions for a specific account?
SELECT transaction_date, amount, transaction_type, c.category_name
FROM Transactions t
JOIN Categories c ON t.category_id = c.category_id
WHERE t.account_id = 1;

-- 5. Query: What is the total expenditure for the current month?
SELECT SUM(amount) AS total_expenditure
FROM Transactions
WHERE transaction_type = 'Expense' 
AND strftime('%Y-%m', transaction_date) = '2024-01';

-- Query Results
-- Query 1
Bank Account  | 1500.00
Credit Card   | -500.00

-- Query 2
Rent          | -1800.00
Groceries     | -350.00
Entertainment | -150.00

-- Query 3
Total Income  | 5000.00

-- Query 4
2024-01-15 | 2000.00  | Income  | Salary
2024-01-20 | -800.00   | Expense | Rent

-- Query 5
Total Expenditure | -1900.00


----- Side Note: Convert Python code cell to a SQL one; add your SQL code between line 3 and line 4, or replace line 3.

-- %%bash
-- sqlite3 <<EOF
-- SELECT "INSERT ALL YOUR BEAUTIFUL SQL HERE";
-- EOF