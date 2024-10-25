# Online Learning Management System

The Online Learning Management System is designed to manage students, instructors, courses, enrollments, grades, and the archiving of course information. It supports key operations like adding new students, enrolling them in courses, tracking their grades, and archiving inactive courses. Transactions are used to ensure data integrity during complex operations, such as archiving courses and managing student enrollments.

## Database Schema

### 1- Students
Stores the details of each student, including their name, email, and expected year of graduation. The columns for this table are:
StudentID (INTEGER, Primary Key)
FirstName (TEXT, Not Null)
LastName (TEXT, Not Null)
Email (TEXT, Unique, Not Null)
GraduationYear (INTEGER)

### 2- Instructors
Stores information about instructors, including their names and contact information. The columns for this table are:
InstructorID (INTEGER, Primary Key)
FirstName (TEXT, Not Null)
LastName (TEXT, Not Null)
Email (TEXT, Unique, Not Null)

### 3- Courses
Contains information about courses, such as the title, credits, and associated instructor. The Active column indicates whether the course is currently offered. The columns are listed below:
CourseID (INTEGER, Primary Key)
Title (TEXT, Not Null)
Credits (INTEGER, Not Null)
InstructorID (INTEGER, Foreign Key)
Active (BOOLEAN, Default 1)

### 4- Enrollments
Maps students to courses they are enrolled in, recording the date of enrollment. Teh columns are listed below:
EnrollmentID (INTEGER, Primary Key)
StudentID (INTEGER, Foreign Key)
CourseID (INTEGER, Foreign Key)
EnrollmentDate (DATE, Not Null)

### 5- Grades
Stores grades for students based on their enrollment in specific courses. Each grade is linked to a specific enrollment record. The columns are listed below:
GradeID (INTEGER, Primary Key)
EnrollmentID (INTEGER, Foreign Key)
Grade (TEXT)

### 6- CourseArchive
Used to store information about courses that are no longer active. Archiving moves courses from the active list to this table. The columns are listed below:
CourseID (INTEGER, Primary Key)
Title (TEXT, Not Null)
Credits (INTEGER, Not Null)
InstructorID (INTEGER, Foreign Key)
ArchivedDate (DATE)

## Transactions

### 1- Archiving Inactive Courses
Description: This transaction ensures that courses marked as inactive are properly archived in the CourseArchive table before being deleted from the active Courses table. If any part of the archiving or deletion fails, the transaction will roll back, preventing partial data loss.
Purpose: To maintain the integrity of historical course data and ensure that no courses are deleted without being archived.

### 2- Enrollment Update with Rollback
Description: Manages student enrollments in courses. The transaction adds a new enrollment and checks if the course capacity has been exceeded. If the capacity is exceeded, the transaction rolls back to prevent adding more students than the course can handle.
Purpose: To ensure that course enrollments stay within capacity limits and to avoid leaving the database in an inconsistent state if an error occurs.

## Queries

### 1- Retrieve All Students Enrolled in a Specific Course
Description: Retrieves the list of students enrolled in the course titled "Database Systems." This query is useful for instructors to see who is currently taking their class.

### 2- List All Courses Taught by a Specific Instructor
Description: Lists all courses taught by an instructor with the last name "Turing." This is relevant for both instructors (to see their teaching load) and administrators (to manage instructor assignments).

### 3- Get the Average Grade for a Course
Description: Calculates the average grade for the course "Machine Learning" using a grading scale (A = 4, B = 3, etc.). This query is useful for academic analysis and assessing course difficulty.

### 4- Find Students Nearing Graduation
Description: Lists students who are expected to graduate in 2024. This information is important for the administration to provide guidance and ensure all graduation requirements are met.

### 5- List All Archived Courses
Description: Retrieves a list of courses that have been archived, including their titles and the date they were archived. This query helps in maintaining a record of historical course data for reference.



