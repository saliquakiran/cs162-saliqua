# Data Normalization Definitions

Data normalization refers to the degree to which shared information is moved into separate tables to reduce redundancy, improve data integrity, and optimize database performance.

---

## 1. First Normal Form (1NF)
**Definition**: A table is in **first normal form (1NF)** if it only contains atomic (indivisible) values, and each entry is unique in its column. It eliminates repeating groups and ensures that each piece of data is stored in its smallest possible form.

- **Key Rule**: No repeating groups or arrays in the columns.
  
**Example**:  
Before normalization:
| EmployeeID | Name       | Address          | Phone Numbers           |
|------------|------------|------------------|-------------------------|
| 101        | John Doe   | 123 Main St      | 555-1234, 555-5678      |

After applying 1NF:
| EmployeeID | Name       | Address          | PhoneNumber  |
|------------|------------|------------------|--------------|
| 101        | John Doe   | 123 Main St      | 555-1234     |
| 101        | John Doe   | 123 Main St      | 555-5678     |

---

## 2. Second Normal Form (2NF)
**Definition**: A table is in **second normal form (2NF)** if it is in 1NF, and all non-key attributes are fully dependent on the primary key. This form eliminates partial dependencies, meaning that no column should depend on just part of a composite primary key.

- **Key Rule**: Eliminate partial dependencies (where a non-key column is dependent on only part of a composite primary key).
  
**Example**:  
Before normalization (Composite key: `EmployeeID` + `ProjectID`):
| EmployeeID | ProjectID | EmployeeName | ProjectName |
|------------|-----------|--------------|-------------|
| 101        | P1        | John Doe     | Project X   |
| 101        | P2        | John Doe     | Project Y   |

After applying 2NF:
**Employee Table**:
| EmployeeID | EmployeeName |
|------------|--------------|
| 101        | John Doe     |

**Project Table**:
| ProjectID  | ProjectName |
|------------|-------------|
| P1         | Project X   |
| P2         | Project Y   |

**EmployeeProject Table** (Many-to-many relationship):
| EmployeeID | ProjectID |
|------------|-----------|
| 101        | P1        |
| 101        | P2        |

---

## 3. Third Normal Form (3NF)
**Definition**: A table is in **third normal form (3NF)** if it is in 2NF and all the attributes are only dependent on the primary key. There should be no transitive dependencies, meaning that non-key columns should not depend on other non-key columns.

- **Key Rule**: Eliminate transitive dependencies (non-key column dependent on another non-key column).
  
**Example**:  
Before normalization:
| EmployeeID | Name       | Department | DepartmentHead |
|------------|------------|------------|----------------|
| 101        | John Doe   | Sales      | Jane Smith     |
| 102        | Alice King | Marketing  | Bob Taylor     |

After applying 3NF:
**Employee Table**:
| EmployeeID | Name       | DepartmentID |
|------------|------------|--------------|
| 101        | John Doe   | 1            |
| 102        | Alice King | 2            |

**Department Table**:
| DepartmentID | Department   | DepartmentHead |
|--------------|--------------|----------------|
| 1            | Sales        | Jane Smith     |
| 2            | Marketing    | Bob Taylor     |

---

## 4. Denormalization
**Definition**: **Denormalization** is the process of combining normalized tables into fewer tables to improve database performance. This often reintroduces redundancy and can make some anomalies possible, but it can improve the speed of query retrieval for complex databases.

- **Key Rule**: Balance between query performance and data integrity by selectively combining tables.
  
**Example**:  
In a fully normalized database, `Customer` and `Order` information might be split into two separate tables. During denormalization, these can be combined for quicker retrieval:

Before denormalization:
**Customer Table**:
| CustomerID | CustomerName |
|------------|--------------|
| 1          | John Doe     |

**Order Table**:
| OrderID | CustomerID | OrderDate |
|---------|------------|-----------|
| 1001    | 1          | 2023-10-15|

After denormalization:
| CustomerID | CustomerName | OrderID | OrderDate  |
|------------|--------------|---------|------------|
| 1          | John Doe     | 1001    | 2023-10-15 |

---

## 5. Composite Key
**Definition**: A **composite key** is a combination of two or more columns in a table that together uniquely identify a row. These keys are used when a single column is insufficient to create a unique identifier.

**Example**:  
Consider a table that records student enrollments in courses:
| StudentID | CourseID | EnrollmentDate |
|-----------|----------|----------------|
| 1         | 101      | 2023-09-01     |
| 1         | 102      | 2023-09-02     |

Here, neither `StudentID` nor `CourseID` alone is sufficient to identify a unique row, but together they form a **composite key**.


