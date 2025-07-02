CREATE DATABASE EXERCISE1

CREATE TABLE Employee (
	ID INT AUTO_INCREMENT PRIMARY KEY,
	FirstName VARCHAR(50),
	MiddleName VARCHAR(50),
    LastName VARCHAR(50),
    Age INT NOT NULL,
    Gender VARCHAR(6),
    Email VARCHAR(50),
    Salary INT NOT NULL
);

INSERT INTO Employee (FirstName, MiddleName, LastName, Age, Gender, Email, Salary) VALUES
	('John','Medina','Ramos', 25,'Male','jjramos00@gmail.com',120000),
    ('Anizah','Mae','Atog', 25,'Female','anzhmae@gmail.com',170000),
    ('Allan','Medina','Ramos', 28,'Male','allanramos@gmail.com',100000),
    ('Paul','Lester','Hamilton', 43,'Male','paulhamil@gmail.com',80000),
    ('Newton','Bullock','McKenzie', 22,'Male','newtonmc@gmail.com',25000);


CREATE TABLE Resident (
	ID INT AUTO_INCREMENT PRIMARY KEY,
	Nickname VARCHAR(50),
	Occupation VARCHAR(50),
    MaritalStatus VARCHAR(10),
    Parent VARCHAR(3),
    EyeColor VARCHAR(50),
    Height INT NOT NULL,
    Weight INT NOT NULL
);

INSERT INTO Resident (Nickname, Occupation, MaritalStatus, Parent, EyeColor, Height, Weight) VALUES
	('Jay-Jay','Engineer','Single', 'No','Brown',160,52),
    ('Anzhmae','Engineer','Single', 'No','Brown',163,54),
    ('Topher','Dentist','Married', 'Yes','Black',152,50),
    ('Paul','Agent','Single', 'Yes','Blue',185,74),
    ('Newt','Manager','Married', 'No','Blue',221,110);

SELECT * FROM Employee
SELECT * FROM Resident