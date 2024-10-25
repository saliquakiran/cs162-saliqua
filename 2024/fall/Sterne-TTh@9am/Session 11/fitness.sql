-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- 1. Classes Table
CREATE TABLE Classes (
    ClassID INTEGER PRIMARY KEY AUTOINCREMENT,
    ClassName TEXT NOT NULL,
    ClassDate DATETIME NOT NULL,
    Capacity INTEGER NOT NULL,
    TrainerID INTEGER NOT NULL,
    FOREIGN KEY (TrainerID) REFERENCES Trainers(TrainerID)
);

-- 2. Trainers Table
CREATE TABLE Trainers (
    TrainerID INTEGER PRIMARY KEY AUTOINCREMENT,
    TrainerName TEXT NOT NULL,
    Specialization TEXT
);

-- 3. Members Table
CREATE TABLE Members (
    MemberID INTEGER PRIMARY KEY AUTOINCREMENT,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    Email TEXT UNIQUE NOT NULL
);

-- 4. Bookings Table
CREATE TABLE Bookings (
    BookingID INTEGER PRIMARY KEY AUTOINCREMENT,
    ClassID INTEGER NOT NULL,
    MemberID INTEGER NOT NULL,
    BookingDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- 5. Attendance Table
CREATE TABLE Attendance (
    AttendanceID INTEGER PRIMARY KEY AUTOINCREMENT,
    BookingID INTEGER NOT NULL,
    AttendanceStatus TEXT CHECK(AttendanceStatus IN ('Present', 'Absent')),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

-- 6. Payments Table
CREATE TABLE Payments (
    PaymentID INTEGER PRIMARY KEY AUTOINCREMENT,
    MemberID INTEGER NOT NULL,
    AmountPaid NUMERIC(11, 2) NOT NULL,
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- Insert sample data into Trainers
INSERT INTO Trainers (TrainerName, Specialization) VALUES
('John Smith', 'Yoga'),
('Sara Lee', 'Pilates'),
('Mike Brown', 'Strength Training'),
('Emma Watson', 'CrossFit'),
('James Taylor', 'Cardio'),
('Lucy Liu', 'Dance Fitness');

-- Insert sample data into Classes
INSERT INTO Classes (ClassName, ClassDate, Capacity, TrainerID) VALUES
('Yoga Morning', '2024-10-20 08:00:00', 20, 1),
('Pilates Noon', '2024-10-20 12:00:00', 15, 2),
('Strength Training Evening', '2024-10-20 18:00:00', 25, 3),
('CrossFit Morning', '2024-10-21 08:00:00', 20, 4),
('Cardio Blast', '2024-10-21 10:00:00', 30, 5),
('Dance Fitness', '2024-10-21 14:00:00', 25, 6);

-- Insert sample data into Members
INSERT INTO Members (FirstName, LastName, Email) VALUES
('Alice', 'Green', 'alice.green@example.com'),
('Bob', 'White', 'bob.white@example.com'),
('Charlie', 'Black', 'charlie.black@example.com'),
('David', 'Brown', 'david.brown@example.com'),
('Eve', 'Blue', 'eve.blue@example.com'),
('Frank', 'Yellow', 'frank.yellow@example.com');

-- Insert sample data into Bookings
INSERT INTO Bookings (ClassID, MemberID) VALUES
(1, 1), -- Alice books Yoga Morning
(2, 2), -- Bob books Pilates Noon
(3, 3), -- Charlie books Strength Training Evening
(4, 4), -- David books CrossFit Morning
(5, 5), -- Eve books Cardio Blast
(6, 6); -- Frank books Dance Fitness

-- Insert sample data into Attendance
INSERT INTO Attendance (BookingID, AttendanceStatus) VALUES
(1, 'Present'), -- Alice attended Yoga Morning
(2, 'Absent'),  -- Bob missed Pilates Noon
(3, 'Present'), -- Charlie attended Strength Training
(4, 'Present'), -- David attended CrossFit Morning
(5, 'Absent'),  -- Eve missed Cardio Blast
(6, 'Present'); -- Frank attended Dance Fitness

-- Insert sample data into Payments
INSERT INTO Payments (MemberID, AmountPaid) VALUES
(1, 15.00), -- Alice paid for Yoga Morning
(2, 20.00), -- Bob paid for Pilates Noon
(3, 25.00), -- Charlie paid for Strength Training Evening
(4, 18.00), -- David paid for CrossFit Morning
(5, 22.00), -- Eve paid for Cardio Blast
(6, 20.00); -- Frank paid for Dance Fitness

-- Queries
-- 1. Which members attended a particular class?
SELECT m.FirstName || ' ' || m.LastName AS MemberName, a.AttendanceStatus
FROM Attendance a
JOIN Bookings b ON a.BookingID = b.BookingID
JOIN Members m ON b.MemberID = m.MemberID
JOIN Classes c ON b.ClassID = c.ClassID
WHERE c.ClassName = 'Yoga Morning';

-- 2. Which trainer conducted the class with the highest attendance?
SELECT t.TrainerName, c.ClassName, COUNT(a.AttendanceID) AS TotalAttendance
FROM Attendance a
JOIN Bookings b ON a.BookingID = b.BookingID
JOIN Classes c ON b.ClassID = c.ClassID
JOIN Trainers t ON c.TrainerID = t.TrainerID
WHERE a.AttendanceStatus = 'Present'
GROUP BY c.ClassID
ORDER BY TotalAttendance DESC
LIMIT 1;

-- 3. What is the total revenue from all class bookings?
SELECT SUM(p.AmountPaid) AS TotalRevenue
FROM Payments p;

-- 4. Which members haven't attended any of their booked classes?
SELECT m.FirstName || ' ' || m.LastName AS MemberName
FROM Attendance a
JOIN Bookings b ON a.BookingID = b.BookingID
JOIN Members m ON b.MemberID = m.MemberID
WHERE a.AttendanceStatus = 'Absent';

-- 5. What is the booking status for a specific member?
SELECT c.ClassName, b.BookingDate, a.AttendanceStatus
FROM Bookings b
JOIN Classes c ON b.ClassID = c.ClassID
LEFT JOIN Attendance a ON b.BookingID = a.BookingID
WHERE b.MemberID = 1;

-- Move to a lower normal form (Denormalization Example)
-- 1NF Example: Combining Bookings and Classes
CREATE TABLE BookingsCombined (
    BookingID INTEGER,
    ClassName TEXT,
    ClassDate DATETIME,
    MemberID INTEGER,
    BookingDate DATETIME,
    AttendanceStatus TEXT
);

-- Insert data by joining Bookings and Classes
INSERT INTO BookingsCombined (BookingID, ClassName, ClassDate, MemberID, BookingDate, AttendanceStatus)
SELECT b.BookingID, c.ClassName, c.ClassDate, b.MemberID, b.BookingDate, a.AttendanceStatus
FROM Bookings b
JOIN Classes c ON b.ClassID = c.ClassID
LEFT JOIN Attendance a ON b.BookingID = a.BookingID;
