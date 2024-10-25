# Patient Health Record and Medical History Tracker

The Patient Health Record and Medical History Tracker is designed to store and manage information about patients, their medical history, doctor visits, diagnoses, and treatments. This application allows healthcare providers to keep track of patient information, manage records of doctor consultations, and archive older records for future reference. The use of transactions ensures data integrity during complex operations like archiving records and managing medical appointments.

## Database Schema

### 1- Patients
Stores the personal details of each patient, such as their name, contact information, and date of birth. The columns for this table are:
PatientID (INTEGER, Primary Key)
FirstName (TEXT, Not Null)
LastName (TEXT, Not Null)
DateOfBirth (DATE, Not Null)
ContactNumber (TEXT)
Email (TEXT, Unique)

### 2- Doctors
Stores information about doctors, including their names and specializations. The columns for this table are:
DoctorID (INTEGER, Primary Key)
FirstName (TEXT, Not Null)
LastName (TEXT, Not Null)
Specialization (TEXT, Not Null)
Email (TEXT, Unique, Not Null)

### 3- Appointments
Records each appointment between a patient and a doctor, including the date and time of the visit. The columns are:
AppointmentID (INTEGER, Primary Key)
PatientID (INTEGER, Foreign Key)
DoctorID (INTEGER, Foreign Key)
AppointmentDate (DATE, Not Null)
AppointmentTime (TIME, Not Null)
Notes (TEXT)

### 4- Diagnoses
Stores diagnoses made by doctors during appointments, along with related treatment plans. The columns are:
DiagnosisID (INTEGER, Primary Key)
AppointmentID (INTEGER, Foreign Key)
Diagnosis (TEXT, Not Null)
Treatment (TEXT)

### 5- MedicalHistory
Contains historical records of a patient's previous medical conditions and treatments. This table is used to archive diagnoses older than a certain date. The columns are:
HistoryID (INTEGER, Primary Key)
PatientID (INTEGER, Foreign Key)
Diagnosis (TEXT, Not Null)
Treatment (TEXT)
RecordedDate (DATE)

### 6- DoctorArchive
Stores details of retired or inactive doctors for record-keeping purposes. The columns are:
DoctorID (INTEGER, Primary Key)
FirstName (TEXT, Not Null)
LastName (TEXT, Not Null)
Specialization (TEXT, Not Null)
RetirementDate (DATE)

## Transactions

### 1- Archiving Old Diagnoses
Description: This transaction archives diagnoses older than a specified date into the MedicalHistory table and removes them from the Diagnoses table. The transaction ensures that no diagnosis is deleted without being recorded in the archive, preventing data loss.
Purpose: To maintain the integrity of patient medical history by ensuring that all old diagnoses are properly archived before deletion from the active record.

### 2- Managing Appointments with Rollback
Description: This transaction handles the addition of new appointments and checks if a doctor already has another appointment scheduled at the same time. If a scheduling conflict is detected, the transaction rolls back to prevent overlapping appointments.
Purpose: To ensure that doctors' schedules remain accurate and that no double-booking occurs, maintaining consistency in appointment records.

## Queries

### 1- Retrieve All Appointments for a Specific Patient
Description: Retrieves a list of all appointments for a specific patient by their name, including details about the doctor and the date of each appointment. This is useful for patients to review their medical visits or for doctors to track a patient's recent visits.

### 2- List All Diagnoses for a Specific Doctor
Description: Lists all diagnoses made by a specific doctor, including the patient's name and the diagnosis details. This is relevant for analyzing a doctor's case history and understanding the kinds of cases they frequently handle.

### 3- Find Patients with Multiple Visits in the Last Month
Description: Identifies patients who have had more than one visit in the last month. This helps in monitoring patients who require frequent medical attention and ensuring that their health is closely tracked.

### 4- Get All Active Doctors and Their Specializations
Description: Lists all active doctors, their specializations, and contact details. This is useful for patients looking for doctors in a specific field or for hospital administration to manage their active medical staff.

### 5- List All Archived Medical History for a Patient
Description: Retrieves the archived medical history of a specific patient, including all diagnoses and treatments that have been moved to the MedicalHistory table. This helps in accessing older records that are no longer in the active list but are important for long-term patient care.