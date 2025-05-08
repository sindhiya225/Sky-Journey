-- Drop tables if they exist to avoid conflicts
DROP TABLE IF EXISTS SeatAllocation;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Fare;
DROP TABLE IF EXISTS BookingPassengers;
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS Passenger;
DROP TABLE IF EXISTS FlightCrew;
DROP TABLE IF EXISTS GroundEmployee;
DROP TABLE IF EXISTS Airport;
DROP TABLE IF EXISTS FlightSchedule;
DROP TABLE IF EXISTS Flight;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Agent;
DROP TABLE IF EXISTS Airline;

-- Step 1: Create Database
CREATE DATABASE IF NOT EXISTS Airline_Management;
USE Airline_Management;

-- Step 2: Create Parent Tables

-- Airline Table
CREATE TABLE Airline (
    Airline_ID INT PRIMARY KEY AUTO_INCREMENT,
    Airline_Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Contact VARCHAR(50) NOT NULL
);

-- Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Employee Table
CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY AUTO_INCREMENT,
    Employee_Name VARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    Date_Of_Joining DATE NOT NULL,
    Designation VARCHAR(50) NOT NULL,
    Contact VARCHAR(50) NOT NULL,
    Airline_ID INT,
    FOREIGN KEY (Airline_ID) REFERENCES Airline(Airline_ID) ON DELETE SET NULL
);

-- Agent Table
CREATE TABLE Agent (
    Agent_ID INT PRIMARY KEY AUTO_INCREMENT,
    Agent_Name VARCHAR(100) NOT NULL,
    Contact_Info VARCHAR(50) NOT NULL,
    Commission_Rate DECIMAL(5,2) DEFAULT 0
);

-- Flight Table
CREATE TABLE Flight (
    Flight_ID INT PRIMARY KEY AUTO_INCREMENT,
    Flight_Num VARCHAR(20) NOT NULL,
    Model VARCHAR(50) NOT NULL,
    Capacity INT NOT NULL,
    Airline_ID INT,
    FOREIGN KEY (Airline_ID) REFERENCES Airline(Airline_ID) ON DELETE CASCADE
);

-- Airport Table
CREATE TABLE Airport (
    Airport_ID INT PRIMARY KEY AUTO_INCREMENT,
    Airport_Name VARCHAR(100) NOT NULL,
    Airport_Code VARCHAR(10) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    No_Of_Terminals INT NOT NULL
);

-- Flight Schedule Table
CREATE TABLE FlightSchedule (
    Flight_Sched_ID INT PRIMARY KEY AUTO_INCREMENT,
    Flight_ID INT,
    Source VARCHAR(50) NOT NULL,
    Destination VARCHAR(50) NOT NULL,
    Date_Of_Departure DATE NOT NULL,
    Departure_Time TIME NOT NULL,
    Arrival_Time TIME NOT NULL,
    Source_Airport_ID INT NOT NULL,
    Destination_Airport_ID INT NOT NULL,
    Reason_Delay TEXT DEFAULT NULL,
    FOREIGN KEY (Flight_ID) REFERENCES Flight(Flight_ID) ON DELETE CASCADE,
    FOREIGN KEY (Source_Airport_ID) REFERENCES Airport(Airport_ID) ON DELETE CASCADE,
    FOREIGN KEY (Destination_Airport_ID) REFERENCES Airport(Airport_ID) ON DELETE CASCADE
);

-- Ground Employee Table
CREATE TABLE GroundEmployee (
    GEmployee_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    Contact VARCHAR(50) NOT NULL,
    Designation VARCHAR(50) NOT NULL,
    Date_Of_Joining DATE NOT NULL,
    Airport_ID INT,
    FOREIGN KEY (Airport_ID) REFERENCES Airport(Airport_ID) ON DELETE CASCADE
);

-- Passenger Table
CREATE TABLE Passenger (
    Passenger_ID INT PRIMARY KEY AUTO_INCREMENT,
    Passenger_Name VARCHAR(100) NOT NULL,
    Contact_Info VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    Meal_Preference VARCHAR(50) DEFAULT NULL,
    Seat_Preference VARCHAR(50) DEFAULT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F', 'O'))
);

-- Fare Table
CREATE TABLE Fare (
    Fare_ID INT PRIMARY KEY AUTO_INCREMENT,
    Class VARCHAR(20) NOT NULL,
    Day_Type VARCHAR(20) NOT NULL,
    Taxes DECIMAL(10,2) DEFAULT 0,
    Final_Price DECIMAL(10,2) NOT NULL,
    Flight_Sched_ID INT,
    FOREIGN KEY (Flight_Sched_ID) REFERENCES FlightSchedule(Flight_Sched_ID) ON DELETE CASCADE
);

-- Booking Table
CREATE TABLE Booking (
    Booking_ID INT PRIMARY KEY AUTO_INCREMENT,
    Passenger_ID INT,
    Agent_ID INT,
    Flight_Sched_ID INT,
    Fare_ID INT,
    Passenger_Count INT DEFAULT 1,
    Cancel_Date DATE DEFAULT NULL,
    Cancel_Status VARCHAR(20) DEFAULT 'Active',
    Cancel_Reason TEXT DEFAULT NULL,
    Cancel_Charge DECIMAL(10,2) DEFAULT 0,
    Payment_Status VARCHAR(20) DEFAULT 'Pending',
    Payment_Receipt VARCHAR(100) DEFAULT NULL,
    Payment_Mode VARCHAR(20) DEFAULT 'Cash',
    Payment_Date DATE DEFAULT NULL,
    Reviews TEXT DEFAULT NULL,
    FOREIGN KEY (Passenger_ID) REFERENCES Passenger(Passenger_ID) ON DELETE CASCADE,
    FOREIGN KEY (Agent_ID) REFERENCES Agent(Agent_ID) ON DELETE CASCADE,
    FOREIGN KEY (Flight_Sched_ID) REFERENCES FlightSchedule(Flight_Sched_ID) ON DELETE CASCADE,
    FOREIGN KEY (Fare_ID) REFERENCES Fare(Fare_ID) ON DELETE SET NULL
);

-- Payment Table
CREATE TABLE Payment (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Booking_ID INT NOT NULL,
    Payment_Method VARCHAR(50) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Transaction_ID VARCHAR(100) NOT NULL,
    Payment_Date DATETIME NOT NULL,
    Card_Last_Four VARCHAR(4) DEFAULT NULL,
    Cardholder_Name VARCHAR(100) DEFAULT NULL,
    FOREIGN KEY (Booking_ID) REFERENCES Booking(Booking_ID) ON DELETE CASCADE
);

-- Seat Allocation Table
CREATE TABLE SeatAllocation (
    Seat_ID INT PRIMARY KEY AUTO_INCREMENT,
    Row_Num INT NOT NULL,
    Seat_Number VARCHAR(5) NOT NULL,
    Seat_Type VARCHAR(50) NOT NULL,
    Booking_ID INT,
    FOREIGN KEY (Booking_ID) REFERENCES Booking(Booking_ID) ON DELETE CASCADE
);

-- Flight Crew Table
CREATE TABLE FlightCrew (
    Crew_ID INT PRIMARY KEY AUTO_INCREMENT,
    CabinCrew VARCHAR(100) NOT NULL,
    Pilot VARCHAR(100) NOT NULL,
    CoPilot VARCHAR(100) NOT NULL,
    Flight_Sched_ID INT,
    FOREIGN KEY (Flight_Sched_ID) REFERENCES FlightSchedule(Flight_Sched_ID) ON DELETE CASCADE
);

-- Booking Passengers Table
CREATE TABLE BookingPassengers (
    Booking_Passenger_ID INT PRIMARY KEY AUTO_INCREMENT,
    Booking_ID INT NOT NULL,
    Passenger_ID INT NOT NULL,
    Is_Primary_Booker BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (Booking_ID) REFERENCES Booking(Booking_ID) ON DELETE CASCADE,
    FOREIGN KEY (Passenger_ID) REFERENCES Passenger(Passenger_ID) ON DELETE CASCADE
);

-- Payment Options table
CREATE TABLE payment_options (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE
);

-- Insert common payment options
INSERT INTO payment_options (name, description) VALUES
('Credit Card', 'Pay with Visa, Mastercard, or American Express'),
('Debit Card', 'Pay directly from your bank account'),
('PayPal', 'Pay using your PayPal account'),
('Bank Transfer', 'Pay via direct bank transfer'),
('UPI', 'Pay using UPI apps like Google Pay, PhonePe, etc.'),
('Cash', 'Pay in cash at our offices');

-- Sample Data
USE Airline_Management;

-- Insert into Airline
INSERT INTO Airline (Airline_Name, Address, Contact) VALUES
('Air India', 'Mumbai, India', '+91-1234567890'),
('Emirates', 'Dubai, UAE', '+971-9876543210'),
('Qatar Airways', 'Doha, Qatar', '+974-1122334455'),
('Lufthansa', 'Berlin, Germany', '+49-2233445566'),
('American Airlines', 'Dallas, USA', '+1-5558889999');

-- Insert into Employee
INSERT INTO Employee (Employee_Name, DOB, Date_Of_Joining, Designation, Contact, Airline_ID) VALUES
('Rajesh Kumar', '1985-06-15', '2010-08-01', 'Pilot', '+91-9090909090', 1),
('Ahmed Ali', '1990-12-05', '2015-09-10', 'Cabin Crew', '+971-5050505050', 2),
('Sarah Johnson', '1988-03-22', '2012-04-15', 'Ground Staff', '+1-6060606060', 5),
('Michael Schmidt', '1992-09-10', '2017-11-20', 'Co-Pilot', '+49-7070707070', 4),
('Lisa Brown', '1987-07-30', '2011-01-25', 'Air Hostess', '+1-8080808080', 3);

-- Insert into Agent
INSERT INTO Agent (Agent_Name, Contact_Info, Commission_Rate) VALUES
('Sky Travels', '+91-9988776655', 5.5),
('Fly High Agency', '+971-6677889900', 6.0),
('AirLink Services', '+974-5566778899', 4.8),
('Globe Trotters', '+49-1122334455', 7.2),
('FastBook Travel', '+1-3344556677', 5.0);

-- Insert into Airport
INSERT INTO Airport (Airport_Name, Airport_Code, Location, No_Of_Terminals) VALUES
('Indira Gandhi Intl', 'DEL', 'Delhi, India', 3),
('Dubai Intl', 'DXB', 'Dubai, UAE', 5),
('Hamad Intl', 'DOH', 'Doha, Qatar', 4),
('Berlin Tegel', 'TXL', 'Berlin, Germany', 2),
('DFW Intl', 'DFW', 'Dallas, USA', 4);

-- Insert into Flight
INSERT INTO Flight (Flight_Num, Model, Capacity, Airline_ID) VALUES
('AI101', 'Boeing 777', 300, 1),
('EK202', 'Airbus A380', 500, 2),
('QR303', 'Boeing 737', 180, 3),
('LH404', 'Airbus A320', 200, 4),
('AA505', 'Boeing 787', 350, 5);

-- Insert into FlightSchedule
INSERT INTO FlightSchedule (Flight_ID, Source, Destination, Date_Of_Departure, Departure_Time, Arrival_Time, Source_Airport_ID, Destination_Airport_ID, Reason_Delay) VALUES
(1, 'Delhi', 'Dubai', '2025-04-10', '10:00:00', '13:00:00', 1, 2, NULL),
(2, 'Dubai', 'London', '2025-04-11', '15:30:00', '20:00:00', 2, 1, 'Weather Delay'),
(3, 'Doha', 'New York', '2025-04-12', '22:00:00', '07:00:00', 3, 4, NULL),
(4, 'Berlin', 'Los Angeles', '2025-04-13', '08:00:00', '16:00:00', 4, 5, 'Technical Issue'),
(5, 'Dallas', 'Tokyo', '2025-04-14', '23:30:00', '11:30:00', 5, 3, NULL);

-- Insert into GroundEmployee
INSERT INTO GroundEmployee (Name, DOB, Contact, Designation, Date_Of_Joining, Airport_ID) VALUES
('Anil Mehta', '1980-05-10', '+91-7896541230', 'Security', '2005-07-12', 1),
('Fatima Sheikh', '1995-03-20', '+971-4567891234', 'Check-in Staff', '2018-09-25', 2),
('Peter Gomez', '1982-07-14', '+974-3216549870', 'Baggage Handler', '2010-06-18', 3),
('Hans Muller', '1991-02-28', '+49-7418529630', 'Maintenance', '2016-12-05', 4),
('William Scott', '1984-09-22', '+1-8529637410', 'Air Traffic Controller', '2008-03-30', 5);

-- Insert into Passenger
INSERT INTO Passenger (Passenger_Name, Contact_Info, DOB, Meal_Preference, Seat_Preference, Gender) VALUES
('Rahul Sharma', '+91-9988771122', '1992-06-15', 'Vegetarian', 'Window', 'M'),
('Alice Brown', '+1-9090807070', '1988-05-21', 'Non-Veg', 'Aisle', 'F'),
('Mohammed Fahad', '+974-6677889900', '1995-11-12', 'Halal', 'Window', 'M'),
('Sophia Lee', '+49-7788990011', '1990-02-28', 'Vegetarian', 'Aisle', 'F'),
('Carlos Mendes', '+55-1122334455', '1987-09-30', 'Non-Veg', 'Middle', 'M');

-- Insert into Fare
INSERT INTO Fare (Class, Day_Type, Taxes, Final_Price, Flight_Sched_ID) VALUES
('Economy', 'Weekday', 50, 500, 1),
('Business', 'Weekend', 100, 1500, 2),
('First Class', 'Weekday', 200, 2500, 3),
('Economy', 'Weekend', 75, 600, 4),
('Business', 'Weekday', 120, 1700, 5);

-- Insert into Booking
INSERT INTO Booking (Passenger_ID, Agent_ID, Flight_Sched_ID, Fare_ID, Passenger_Count, Cancel_Date, Cancel_Status, Cancel_Reason, Cancel_Charge, Payment_Status, Payment_Receipt, Payment_Mode, Payment_Date, Reviews) VALUES
(1, 1, 1, 1, 1, NULL, 'Active', NULL, 0, 'Paid', 'RCP12345', 'Credit Card', '2025-04-01', 'Great service!'),
(2, 2, 2, 2, 2, '2025-03-30', 'Cancelled', 'Medical Emergency', 50, 'Refunded', 'RCP54321', 'Debit Card', '2025-04-02', 'Had to cancel last minute.'),
(3, 3, 3, 3, 1, NULL, 'Active', NULL, 0, 'Pending', NULL, 'Cash', NULL, NULL),
(4, 4, 4, 4, 3, NULL, 'Active', NULL, 0, 'Paid', 'RCP67890', 'UPI', '2025-04-03', 'On-time and smooth flight.'),
(5, 5, 5, 5, 2, NULL, 'Active', NULL, 0, 'Paid', 'RCP11223', 'Net Banking', '2025-04-04', 'Comfortable seating.');

-- Insert into Payment
INSERT INTO Payment (Booking_ID, Payment_Method, Amount, Transaction_ID, Payment_Date, Card_Last_Four, Cardholder_Name) VALUES
(1, 'Credit Card', 500, 'TXN123456', '2025-04-01 10:30:00', '4321', 'Rahul Sharma'),
(2, 'Debit Card', 1500, 'TXN234567', '2025-04-02 14:15:00', '7890', 'Alice Brown'),
(4, 'UPI', 600, 'TXN345678', '2025-04-03 09:45:00', NULL, NULL),
(5, 'Net Banking', 1700, 'TXN456789', '2025-04-04 16:20:00', NULL, NULL);

-- Insert into SeatAllocation
INSERT INTO SeatAllocation (Row_Num, Seat_Number, Seat_Type, Booking_ID) VALUES
(12, '12A', 'Window', 1),
(15, '15C', 'Aisle', 2),
(10, '10B', 'Middle', 3),
(20, '20A', 'Window', 4),
(8, '8C', 'Aisle', 5);

-- Insert into FlightCrew
INSERT INTO FlightCrew (CabinCrew, Pilot, CoPilot, Flight_Sched_ID) VALUES
('John Doe', 'Captain Smith', 'Officer Lee', 1),
('Jane Doe', 'Captain Brown', 'Officer Carter', 2),
('Robert White', 'Captain Jones', 'Officer Kim', 3),
('Emily Clark', 'Captain Taylor', 'Officer Wilson', 4),
('Michael Adams', 'Captain Harris', 'Officer Evans', 5);