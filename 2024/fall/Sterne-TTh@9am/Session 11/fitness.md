# Fitness Class Booking and Attendance Tracking

## App Overview

The **Fitness Class Booking and Attendance Tracking** app is designed to manage bookings, attendance, and payments for fitness classes. The system tracks the available fitness classes, the trainers conducting them, member details, bookings made for classes, and whether members attended those classes.

The app follows a well-organized structure with the following key components:

1. **Classes**: Stores details about each fitness class, including its name, schedule, and capacity.
2. **Trainers**: Stores information about trainers who conduct the classes.
3. **Members**: Stores member information for booking and tracking attendance.
4. **Bookings**: Records member bookings for fitness classes.
5. **Attendance**: Tracks actual attendance for each booked class session.
6. **Payments**: Stores information on payments made by members for booked classes.

---

## Tables and Columns

### 1. **Classes Table**
The `Classes` table contains information about each fitness class, such as the class name, schedule, capacity, and trainer. This table holds the core information about the classes offered.

| Column Name  | Description                          |
|--------------|--------------------------------------|
| **ClassID**  | Primary key, unique identifier for each class. |
| ClassName    | Name of the fitness class.           |
| ClassDate    | Date and time when the class takes place. |
| Capacity     | Maximum number of participants allowed in the class. |
| TrainerID    | Foreign key to the `Trainers` table, identifying the trainer conducting the class. |

---

### 2. **Trainers Table**
The `Trainers` table stores information about the trainers who conduct fitness classes.

| Column Name  | Description                          |
|--------------|--------------------------------------|
| **TrainerID** | Primary key, unique identifier for each trainer. |
| TrainerName  | Name of the trainer.                 |
| Specialization | Area of expertise or focus for the trainer (e.g., Yoga, Pilates). |

---

### 3. **Members Table**
The `Members` table stores details about members who book fitness classes. It includes their basic information such as name and email.

| Column Name  | Description                          |
|--------------|--------------------------------------|
| **MemberID** | Primary key, unique identifier for each member. |
| FirstName    | First name of the member.            |
| LastName     | Last name of the member.             |
| Email        | Unique email address for the member. |

---

### 4. **Bookings Table**
The `Bookings` table records member bookings for fitness classes, including the class booked, the member who booked it, and the booking date. It references the `Classes` and `Members` tables.

| Column Name  | Description                          |
|--------------|--------------------------------------|
| **BookingID** | Primary key, unique identifier for each booking. |
| ClassID      | Foreign key to the `Classes` table, identifying the booked class. |
| MemberID     | Foreign key to the `Members` table, identifying the member who booked the class. |
| BookingDate  | Date and time when the booking was made. |

---

### 5. **Attendance Table**
The `Attendance` table tracks the attendance status for each member who booked a class, indicating whether they attended or were absent. It references the `Bookings` table.

| Column Name     | Description                          |
|-----------------|--------------------------------------|
| **AttendanceID** | Primary key, unique identifier for each attendance record. |
| BookingID       | Foreign key to the `Bookings` table, identifying the specific booking being tracked. |
| AttendanceStatus | Attendance status, either "Present" or "Absent". |

---

### 6. **Payments Table**
The `Payments` table stores details about payments made by members for booked fitness classes. It references the `Members` table.

| Column Name   | Description                          |
|---------------|--------------------------------------|
| **PaymentID** | Primary key, unique identifier for each payment. |
| MemberID      | Foreign key to the `Members` table, identifying the member making the payment. |
| AmountPaid    | The amount paid by the member for the class booking. |
| PaymentDate   | Date and time when the payment was made. |

---
