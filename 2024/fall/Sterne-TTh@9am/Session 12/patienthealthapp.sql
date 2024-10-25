-- Create the Patients table to store patient details.
CREATE TABLE Patients (
    PatientID INTEGER PRIMARY KEY,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    DateOfBirth DATE NOT NULL,
    ContactNumber TEXT,
    Email TEXT UNIQUE
);

-- Create the Doctors table to store doctor information.
CREATE TABLE Doctors (
    DoctorID INTEGER PRIMARY KEY,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    Specialization TEXT NOT NULL,
    Email TEXT UNIQUE NOT NULL
);

-- Create the Appointments table to record appointments between patients and doctors.
CREATE TABLE Appointments (
    AppointmentID INTEGER PRIMARY KEY,
    PatientID INTEGER,
    DoctorID INTEGER,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Notes TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Create the Diagnoses table to store diagnoses made during appointments.
CREATE TABLE Diagnoses (
    DiagnosisID INTEGER PRIMARY KEY,
    AppointmentID INTEGER,
    Diagnosis TEXT NOT NULL,
    Treatment TEXT,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

-- Create the MedicalHistory table to archive old diagnoses.
CREATE TABLE MedicalHistory (
    HistoryID INTEGER PRIMARY KEY,
    PatientID INTEGER,
    Diagnosis TEXT NOT NULL,
    Treatment TEXT,
    RecordedDate DATE,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Create the DoctorArchive table to store details of retired or inactive doctors.
CREATE TABLE DoctorArchive (
    DoctorID INTEGER PRIMARY KEY,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    Specialization TEXT NOT NULL,
    RetirementDate DATE
);

-- Insert sample data into the Patients table.
INSERT INTO Patients (FirstName, LastName, DateOfBirth, ContactNumber, Email)
VALUES 
    ('John', 'Doe', '1980-01-15', '123-456-7890', 'john.doe@example.com'),
    ('Jane', 'Smith', '1975-05-20', '234-567-8901', 'jane.smith@example.com'),
    ('Alex', 'Johnson', '1990-11-30', '345-678-9012', 'alex.johnson@example.com'),
    ('Emily', 'Davis', '1988-08-15', '456-789-0123', 'emily.davis@example.com'),
    ('Michael', 'Brown', '1982-03-25', '567-890-1234', 'michael.brown@example.com');

-- Insert sample data into the Doctors table.
INSERT INTO Doctors (FirstName, LastName, Specialization, Email)
VALUES 
    ('Dr. Alan', 'Turing', 'Cardiology', 'alan.turing@example.com'),
    ('Dr. Ada', 'Lovelace', 'Neurology', 'ada.lovelace@example.com'),
    ('Dr. Grace', 'Hopper', 'Dermatology', 'grace.hopper@example.com'),
    ('Dr. Claude', 'Shannon', 'Orthopedics', 'claude.shannon@example.com'),
    ('Dr. George', 'Boole', 'General Practice', 'george.boole@example.com');

-- Insert sample data into the Appointments table.
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Notes)
VALUES 
    (1, 1, '2024-01-15', '09:00', 'Regular check-up'),
    (2, 2, '2024-01-16', '10:30', 'Neurological assessment'),
    (3, 3, '2024-01-20', '14:00', 'Skin allergy consultation'),
    (4, 4, '2024-01-22', '11:00', 'Knee pain examination'),
    (5, 5, '2024-02-10', '13:00', 'General check-up');

-- Insert sample data into the Diagnoses table.
INSERT INTO Diagnoses (AppointmentID, Diagnosis, Treatment)
VALUES 
    (1, 'Hypertension', 'Prescribed medication and lifestyle changes'),
    (2, 'Migraine', 'Prescribed pain relief medication'),
    (3, 'Eczema', 'Prescribed topical cream'),
    (4, 'Arthritis', 'Recommended physiotherapy'),
    (5, 'Seasonal Flu', 'Prescribed antiviral medication');

-- Transaction 1: Archive diagnoses older than a certain date.
-- This transaction ensures that diagnoses older than 2024-01-31 are archived.
-- It inserts these diagnoses into the MedicalHistory table before deleting them from the Diagnoses table.
BEGIN TRANSACTION;
    INSERT INTO MedicalHistory (PatientID, Diagnosis, Treatment, RecordedDate)
    SELECT a.PatientID, d.Diagnosis, d.Treatment, a.AppointmentDate
    FROM Diagnoses d
    JOIN Appointments a ON d.AppointmentID = a.AppointmentID
    WHERE a.AppointmentDate < '2024-01-31';

    DELETE FROM Diagnoses
    WHERE DiagnosisID IN (
        SELECT d.DiagnosisID
        FROM Diagnoses d
        JOIN Appointments a ON d.AppointmentID = a.AppointmentID
        WHERE a.AppointmentDate < '2024-01-31'
    );
COMMIT;

-- Explanation: This transaction ensures that all diagnoses before the specified date are properly 
-- archived before being removed from active records, maintaining the integrity of historical data.

-- Transaction 2: Add a new appointment with a rollback condition.
-- This transaction checks if a doctor is available at the given date and time before adding a new appointment.
-- If the doctor already has an appointment at the same time, the transaction rolls back.
BEGIN TRANSACTION;
    -- Check for scheduling conflicts before inserting.
    SELECT COUNT(*) AS ConflictCount
    FROM Appointments
    WHERE DoctorID = 2
    AND AppointmentDate = '2024-02-15'
    AND AppointmentTime = '10:30';

    -- Insert the appointment if there are no conflicts.
    INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime, Notes)
    SELECT 1, 2, '2024-02-15', '10:30', 'Follow-up visit'
    WHERE (SELECT COUNT(*) 
           FROM Appointments 
           WHERE DoctorID = 2 
           AND AppointmentDate = '2024-02-15' 
           AND AppointmentTime = '10:30') = 0;
COMMIT;

-- Explanation: This transaction ensures that the appointment scheduling respects a doctor's availability.
-- If a conflict is found, the new appointment is not added, preventing double-booking.

-- Queries for common user needs:
-- Query 1: Retrieve all appointments for a specific patient.
SELECT p.FirstName, p.LastName, d.FirstName AS DoctorFirstName, d.LastName AS DoctorLastName, 
       a.AppointmentDate, a.AppointmentTime, a.Notes
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE p.FirstName = 'John' AND p.LastName = 'Doe';

-- Explanation: This query retrieves all appointments for John Doe, including details about the doctor 
-- and appointment specifics. This is helpful for reviewing past and upcoming medical visits.

-- Query 2: List all diagnoses made by a specific doctor.
SELECT d.Diagnosis, d.Treatment, p.FirstName AS PatientFirstName, p.LastName AS PatientLastName
FROM Diagnoses d
JOIN Appointments a ON d.AppointmentID = a.AppointmentID
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors doc ON a.DoctorID = doc.DoctorID
WHERE doc.LastName = 'Lovelace';

-- Explanation: This query lists all diagnoses made by Dr. Ada Lovelace, including patient names.
-- It helps analyze the types of cases handled by a particular doctor.

-- Query 3: Find patients with multiple visits in the last month.
SELECT p.FirstName, p.LastName, COUNT(a.AppointmentID) AS VisitCount
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
WHERE a.AppointmentDate >= DATE('now', '-1 month')
GROUP BY p.PatientID
HAVING COUNT(a.AppointmentID) > 1;

-- Explanation: This query identifies patients who have had more than one appointment in the last month,
-- useful for monitoring patients who require frequent medical attention.

-- Query 4: Get all active doctors and their specializations.
SELECT FirstName, LastName, Specialization
FROM Doctors;

-- Explanation: This query lists all active doctors along with their specializations,
-- which is helpful for patients searching for doctors with specific expertise.

-- Query 5: List all archived medical history for a specific patient.
SELECT mh.Diagnosis, mh.Treatment, mh.RecordedDate
FROM MedicalHistory mh
JOIN Patients p ON mh.PatientID = p.PatientID
WHERE p.FirstName = 'Jane' AND p.LastName = 'Smith';

-- Explanation: This query retrieves all archived diagnoses for Jane Smith, 
-- helping doctors access her complete medical history.
