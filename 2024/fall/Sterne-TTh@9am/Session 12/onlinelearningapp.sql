-- Create the Students table to store student information.
CREATE TABLE Students (
    StudentID INTEGER PRIMARY KEY,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    Email TEXT UNIQUE NOT NULL,
    GraduationYear INTEGER
);

-- Create the Instructors table to store instructor details.
CREATE TABLE Instructors (
    InstructorID INTEGER PRIMARY KEY,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    Email TEXT UNIQUE NOT NULL
);

-- Create the Courses table to store course information.
CREATE TABLE Courses (
    CourseID INTEGER PRIMARY KEY,
    Title TEXT NOT NULL,
    Credits INTEGER NOT NULL,
    InstructorID INTEGER,
    Active BOOLEAN DEFAULT 1,
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);

-- Create the Enrollments table to record students' enrollments in courses.
CREATE TABLE Enrollments (
    EnrollmentID INTEGER PRIMARY KEY,
    StudentID INTEGER,
    CourseID INTEGER,
    EnrollmentDate DATE NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Create the Grades table to store the grades assigned to students.
CREATE TABLE Grades (
    GradeID INTEGER PRIMARY KEY,
    EnrollmentID INTEGER,
    Grade TEXT,
    FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID)
);

-- Create the CourseArchive table to store archived course details.
CREATE TABLE CourseArchive (
    CourseID INTEGER PRIMARY KEY,
    Title TEXT NOT NULL,
    Credits INTEGER NOT NULL,
    InstructorID INTEGER,
    ArchivedDate DATE,
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);

-- Insert sample data into the Students table.
INSERT INTO Students (FirstName, LastName, Email, GraduationYear)
VALUES 
    ('John', 'Doe', 'john.doe@example.com', 2025),
    ('Jane', 'Smith', 'jane.smith@example.com', 2024),
    ('Alex', 'Johnson', 'alex.johnson@example.com', 2023),
    ('Emily', 'Davis', 'emily.davis@example.com', 2025),
    ('Michael', 'Brown', 'michael.brown@example.com', 2024);

-- Insert sample data into the Instructors table.
INSERT INTO Instructors (FirstName, LastName, Email)
VALUES 
    ('Dr. Alan', 'Turing', 'alan.turing@example.com'),
    ('Dr. Ada', 'Lovelace', 'ada.lovelace@example.com'),
    ('Dr. Grace', 'Hopper', 'grace.hopper@example.com'),
    ('Dr. Claude', 'Shannon', 'claude.shannon@example.com'),
    ('Dr. George', 'Boole', 'george.boole@example.com');

-- Insert sample data into the Courses table.
INSERT INTO Courses (Title, Credits, InstructorID, Active)
VALUES 
    ('Database Systems', 3, 1, 1),
    ('Machine Learning', 4, 2, 1),
    ('Algorithms', 3, 3, 1),
    ('Linear Algebra', 4, 4, 0), -- Marked as inactive for testing archiving
    ('Cryptography', 3, 5, 1);

-- Insert sample data into the Enrollments table.
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate)
VALUES 
    (1, 1, '2024-01-15'),
    (2, 2, '2024-01-16'),
    (3, 3, '2023-09-10'),
    (4, 1, '2024-02-20'),
    (5, 5, '2024-03-05');

-- Insert sample data into the Grades table.
INSERT INTO Grades (EnrollmentID, Grade)
VALUES 
    (1, 'A'),
    (2, 'B'),
    (3, 'A'),
    (4, 'C'),
    (5, 'B');

-- Transaction 1: Archive inactive courses.
-- This transaction ensures that courses that are no longer active 
-- are moved to the CourseArchive table and then removed from the Courses table.
BEGIN TRANSACTION;
    INSERT INTO CourseArchive (CourseID, Title, Credits, InstructorID, ArchivedDate)
    SELECT CourseID, Title, Credits, InstructorID, DATE('now')
    FROM Courses
    WHERE Active = 0;

    DELETE FROM Courses WHERE Active = 0;
COMMIT;

-- Explanation: The transaction ensures that data is not lost during the process of archiving.
-- It first copies the inactive courses into the CourseArchive and only then deletes them 
-- from the active Courses table. If any step fails, the entire transaction is rolled back.

-- Transaction 2: Add a new enrollment with a rollback condition.
-- This transaction adds a new enrollment and checks a simulated condition for over-capacity.
BEGIN TRANSACTION;

    -- Check the number of enrollments for the course before proceeding.
    -- This SELECT will only return a count, which you should check in your application.
    SELECT COUNT(*) AS EnrollmentCount FROM Enrollments WHERE CourseID = 3;

    -- If EnrollmentCount is <= 30, proceed with this INSERT. 
    -- Note: This decision should be made by the application interacting with the SQLite database.
    INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate)
    VALUES (2, 3, '2024-04-01');

COMMIT;

-- Explanation: This transaction ensures that enrollments remain valid and the course capacity 
-- isn't exceeded. The rollback prevents adding the enrollment if the course is already full.

-- Queries for common user needs:
-- Query 1: Retrieve all students enrolled in a specific course.
SELECT s.FirstName, s.LastName, c.Title
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.Title = 'Database Systems';

-- Explanation: This query lists students enrolled in the "Database Systems" course. 
-- It helps instructors manage their class rosters.

-- Query 2: List all courses taught by a specific instructor.
SELECT c.Title, c.Credits
FROM Courses c
JOIN Instructors i ON c.InstructorID = i.InstructorID
WHERE i.LastName = 'Turing';

-- Explanation: Shows the courses that Dr. Turing teaches, which is useful for instructors 
-- and administrators when managing course assignments.

-- Query 3: Get the average grade for a course.
SELECT c.Title, AVG(CASE
    WHEN g.Grade = 'A' THEN 4
    WHEN g.Grade = 'B' THEN 3
    WHEN g.Grade = 'C' THEN 2
    ELSE 0
END) AS AverageGrade
FROM Grades g
JOIN Enrollments e ON g.EnrollmentID = e.EnrollmentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.Title = 'Machine Learning';

-- Explanation: Converts letter grades to GPA equivalents and calculates the average GPA 
-- for students in "Machine Learning." This is useful for understanding course performance.

-- Query 4: Find students nearing graduation.
SELECT FirstName, LastName, GraduationYear
FROM Students
WHERE GraduationYear = 2024;

-- Explanation: Lists students who are expected to graduate in 2024, helping the 
-- administration provide appropriate support for their transition.

-- Query 5: List all archived courses.
SELECT Title, ArchivedDate
FROM CourseArchive;

-- Explanation: Retrieves all courses that have been archived, including their titles 
-- and the date they were archived, useful for maintaining historical records.
