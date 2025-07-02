SELECT * FROM Employee
SELECT * FROM Resident

SELECT
	E.ID,
    E.FirstName,
    E.LastName,
    R.Nickname,
    R.Occupation,
    E.Salary,
    E.Age

FROM Employee as E
INNER JOIN Resident as R
on E.ID = R.ID

SELECT * FROM Employee
SELECT * FROM Resident

SELECT MIN(salary) AS MinimumSalary
FROM Employee;

SELECT MAX(height) AS MaximumHeight
FROM Resident;

SELECT COUNT(ID) AS TotalResidents
FROM Resident;

SELECT AVG(salary) AS AverageSalary
FROM Employee;

SELECT SUM(salary) AS TotalSalary
FROM Employee;

SELECT
	Gender, 
    AVG(Salary) AS AverageSalary
FROM Employee
GROUP BY Gender;

SELECT 
    CONCAT(FirstName, " ", LastName) AS FullName,
    Age,
    CASE 
        WHEN Age < 18 THEN 'Minor'
        WHEN Age BETWEEN 18 AND 25 THEN 'Young Adult'
        WHEN Age BETWEEN 26 AND 40 THEN 'Adult'
		WHEN Age BETWEEN 41 AND 59 THEN 'Middle-Age'
        ELSE 'Senior'
    END AS AgeGroup
FROM Employee;
