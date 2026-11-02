USE DA8;
SHOW TABLES;
SELECT*FROM EMPLOYEES;
SELECT COUNT(EMP_NAME) AS TOTAL_EMPLOYEES FROM EMPLOYEES;
INSERT INTO EMPLOYEES(EMP_ID)VALUES(109);
SELECT MIN(EMP_NAME)AS LOW_SALARY FROM EMPLOYEES;
SELECT MAX(EXPERIENCE)AS EXPERIENCE_EMPLOYEE FROM EMPLOYEES;
SELECT AVG(SALARY)AS AVERAGE_SALARY FROM EMPLOYEES;
SELECT SUM(SALARY)AS TOTAL_SALARY FROM EMPLOYEES;

drop table students;
CREATE TABLE STUDENTS (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Department VARCHAR(30),
    Marks INT,
    City VARCHAR(30)
);


INSERT INTO STUDENTS (Name, Age, Department, Marks, City) VALUES
('Anil', 20, 'CSE', 85, 'Hyderabad'),
('Sneha', 22, 'ECE', 75, 'Mumbai'),
('Ravi', 20, 'CSE', NULL, 'Hyderabad'),
('Divya', 23, 'MECH', 65, NULL),
('Kiran', 22, 'ECE', 75, 'Pune'),
('Varun', 21, 'CSE', 92, 'Chennai'),
('Priya', 20, 'EEE', 88, 'Delhi'),
('John', 22, 'MECH', 55, 'Mumbai'),
('Rekha', 21, 'ECE', 75, 'Pune'),
('Ramesh', 23, 'EEE', NULL, 'Delhi');

select*from students;

-- Display all students who belong to the CSE department.
select*from students where department='cse';
-- Display all students whose marks are greater than 80.
select*from students where marks>80;
-- Display all students who are 22 years old.
 select*from students where age=22;
-- Display all students whose marks are between 70 and 90.
select*from students where MARKS BETWEEN 70 AND 90;
-- Display all students who belong to CSE and have marks greater than 80.
select*from students where department='CSE' AND MARKS>80;

-- GROUP BY
-- DISPLAY THE TOTAL NUMBER OF STUDENTS IN EACH DEPARTMENT.
SELECT DEPARTMENT,COUNT(*)AS TOTAL_STUDENTS
FROM STUDENTS
GROUP BY DEPARTMENT
HAVING total_students>3;

-- DISPLAY THE AVERAGE MARKS OF STUDENT IN EACH DEPARTMENT.
SELECT DEPARTMENT,AVG(MARKS)AS AVERAGE_MARKS
FROM STUDENTS
GROUP BY DEPARTMENT
having average_marks>80;

-- DISPLAY THE TOTAL MARKS OF STUDENTS IN EACH DEPARTMENT
SELECT DEPARTMENT,SUM(MARKS)AS TOTAL_MARKS
FROM STUDENTS
GROUP BY DEPARTMENT
having total_marks>200;

SELECT DEPARTMENT,MAX(MARKS)AS MAXIMUM_MARKS
FROM STUDENTS
GROUP BY DEPARTMENT;

SELECT DEPARTMENT,MIN(MARKS)AS MINIMUM_MARKS
FROM STUDENTS
GROUP BY DEPARTMENT;

SELECT CITY,COUNT(*)AS TOTAL_STUDENTS
FROM STUDENTS
GROUP BY CITY;

select*from students order by studentid desc;
select*from students order by name desc limit 5;

SELECT DEPARTMENT,AVG(MARKS)AS AVERAGE_MARKS
FROM STUDENTS
WHERE AGE>20
GROUP BY DEPARTMENT
HAVING AVERAGE_MARKS>70
ORDER BY AVERAGE_MARKS DESC;




