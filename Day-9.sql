USE DA8;
CREATE TABLE Projects (
 id INT,
 name VARCHAR(100),
 assignedto VARCHAR(100),
 start DATE,
 end DATE
 );

INSERT INTO Projects VALUES
 (1, 'Website Revamp', 'Alice', '2024-01-15', '2024-03-01'),
 (2, 'Mobile App', 'Bob', '2024-02-01', NULL),
 (3, 'Data Migration', NULL, NULL, NULL),
 (4, 'SEO Optimization', 'Eve', '2024-03-10', '2024-04-20'),
 (5, 'Cloud Migration', NULL, '2024-03-15', NULL),
 (6, 'ERP Development', 'John', '2024-04-01', NULL),
 (7, 'CRM Upgrade', NULL, NULL, NULL),
 (8, 'Inventory System', 'David', '2024-05-10', '2024-06-25'),
 (9, 'Online Portal', 'Sophia', '2024-06-15', NULL),
 (10, 'Security Audit', NULL, '2024-07-01', NULL),
 (11, 'AI Chatbot', 'James', NULL, NULL),
 (12, 'Payroll System', 'Emma', '2024-08-01', '2024-09-10'),
 (13, 'Hospital Management', NULL, NULL, NULL),
 (14, 'Student Portal', 'Michael', '2024-09-05', NULL),
 (15, 'Banking Application', NULL, '2024-10-01', NULL);

select*from projects;

SELECT*FROM PROJECTS WHERE ASSIGNEDTO IS NULL;

-- 2. Get projects that have not started yet:
SELECT*FROM PROJECTS WHERE START IS NULL;
-- 3. Get all projects that have been completed
SELECT*FROM PROJECTS WHERE END IS NOT NULL;
-- 4. Get all projects with an assigned team member
SELECT*FROM PROJECTS WHERE ASSIGNEDTO IS NOT NULL;
-- 1. Assign unassigned projects to a default person ( Eg: Frank )
-- 2. Update start date to today for projects that haven't started
UPDATE PROJECTS SET START=CURDATE() WHERE START IS NULL;
-- 3. Update the project name of all completed projects to “completed” instead of the existing name.
UPDATE PROJECTS SET NAME='COMPLETED' WHERE END IS NOT NULL;
SET SQL_SAFE_UPDATES=0;
UPDATE PROJECTS SET ASSIGNEDTO='FRANK' WHERE ASSIGNEDTO IS NULL;
SELECT*FROM PROJECTS;

CREATE TABLE Orders (
 id INT,
 customer_name VARCHAR(100),
 order_date DATE,
 total_amount DECIMAL(10,2)
 );

INSERT INTO Orders VALUES
 (1, 'Alice', '2024-03-01', 1500.00),
 (2, 'Bob', '2024-03-05', 450.00),
 (3, 'Charlie', '2024-03-10', 2500.00),
 (4, 'Diana', '2024-03-15', 800.00),
 (5, 'Eve', '2024-03-20', 1200.00),
 (6, 'Frank', '2024-03-25', 3000.00),
 (7, 'Grace', '2024-04-02', 1800.00),
 (8, 'Henry', '2024-04-08', 950.00),
 (9, 'Ivy', '2024-04-12', 2750.00),
 (10, 'Jack', '2024-04-18', 650.00),
 (11, 'Kevin', '2024-04-22', 4200.00),
 (12, 'Lily', '2024-05-01', 1350.00),
 (13, 'Michael', '2024-05-08', 5000.00),
 (14, 'Nancy', '2024-05-15', 2250.00),
 (15, 'Oliver', '2024-05-25', 900.00);

SELECT*FROM ORDERS;
-- 1. Select order details in between “2024-3-3” to “2024-3-10”
     select*from orders where order_date between '2024-03-03' AND '2024-03-10';
-- 2. Display orders placed between '2024-04-01' and '2024-04-30’.
 select*from orders where order_date between '2024-04-01' AND '2024-04-30';
-- 3. Display orders whose total amount is between 500 and 1500
 select*from orders where total_amount between 500 AND 1500;
-- 4. Increase price of the products ordered in between “2024-3-4” to “2024-3-10” with 1000.
update orders set total_amount=total_amount+1000 where order_date between 
'2024-03-04' AND '2024-03-10';
-- 5. Reduce the total amount by 200 for orders between 1000 and 2000.
update orders set total_amount=total_amount-200 where total_amount between 
1000 and 2000;

-- 6. Increase the total amount by 10% for orders between 2500 and 5000.
update orders set total_amount=total_amount+(total_amount*0.10) where 
total_amount BETWEEN 2500 AND 5000;
-- 7. Remove products from orders placed in between “2024-3-10” to “2024-3-20”
delete from orders where order_date between '2024-03-10' and '2024-03-20';
-- 8. Delete orders whose total amount is between 2500 and 5000.
delete from orders where total_amount between 2500 and 5000;

CREATE TABLE Emp (
 id INT,
 name VARCHAR(100),
 dept VARCHAR(20),
 salary INT
 );


INSERT INTO Emp VALUES
 (1, 'Rahul', 'IT', 50000),
 (2, 'Ramesh', 'HR', 35000),
 (3, 'Karan', 'Finance', 45000),
 (4, 'Mahesh', 'Marketing', 40000),
 (5, 'Suresh', 'IT', 55000),
 (6, 'Arjun', 'Sales', 38000),
 (7, 'Manish', 'Admin', 42000),
 (8, 'Ganesh', 'Finance', 47000),
 (9, 'Naresh', 'HR', 39000),
 (10, 'Rohan', 'IT', 52000),
 (11, 'Mohan', 'Sales', 41000),
 (12, 'Kishan', 'Marketing', 43000),
 (13, 'Dinesh', 'Admin', 46000),
 (14, 'Rajesh', 'Finance', 51000),
 (15, 'Kiran', 'IT', 48000);

select*from emp;

-- 1. Get employees from IT and Finance departments
SELECT*FROM EMP WHERE DEPT IN('IT','FINANCE');
-- 2. Display employees from the HR and Sales departments.
SELECT*FROM EMP WHERE DEPT IN('HR','SALES');
-- 3.Display employees whose salary is 35000, 42000, or 60000.
SELECT*FROM EMP WHERE SALARY IN(35000,42000,60000);
-- 4. Increase salary by 2000 for employees in HR or Marketing
UPDATE EMP SET SALARY=SALARY+2000 WHERE DEPT IN('HR','MARKETING');
-- 5. Increase salary by 5000 for employees earning 35000, 39000, or 43000.
UPDATE EMP SET SALARY=SALARY+5000 WHERE SALARY IN(35000,39000,43000);
-- 6. Increase salary by 1500 for employees in the Sales and Admin departments.
UPDATE EMP SET SALARY=SALARY+1500 WHERE DEPT IN('SALES','ADMIN');
-- 7. Remove employees from the Finance or Marketing department
delete from emp where dept in ('finance','marketing');
-- 8.Delete employees from the HR department.
DELETE FROM EMP WHERE DEPT IN('HR');
-- 9. Delete employees whose salary is 35000, 39000, or 43000.
DELETE FROM EMP WHERE SALARY IN(35000,39000,43000);

drop table employees;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary DECIMAL(10,2),
    experience INT,
    age INT
);

INSERT INTO employees VALUES
(101,'Ravi','IT',65000,5,28),
(102,'Priya','HR',45000,2,24),
(103,'Amit','Finance',75000,8,35),
(104,'Sneha','IT',55000,3,27),
(105,'Rahul','Sales',40000,1,22),
(106,'Kiran','Finance',90000,12,40),
(107,'Anjali','HR',52000,4,29),
(108,'Suresh','Sales',68000,7,33);

SELECT*FROM EMPLOYEES;

SELECT EMP_NAME,SALARY,
CASE
WHEN SALARY>=80000 THEN 'HIGH SALARY'
WHEN SALARY>=60000 THEN 'MEDIUM SALARY'
ELSE 'LOW SALARY'
END AS SALARY_CATEGORY
FROM EMPLOYEES;
-- EXP>=10 EXPERT,>=5 THEN SENIOR EXP>=2 THEN JUNIOR FRESHER
SELECT EMP_NAME,EXPERIENCE,
CASE
WHEN EXPERIENCE>=10 THEN 'EXPERT'
WHEN EXPERIENCE>=5 THEN 'SENIOR'
WHEN EXPERIENCE>=2 THEN 'JUNIOR'
ELSE 'FRESHER'
END AS EXPERIENCE_CATEGORY
FROM EMPLOYEES;

SELECT *FROM EMPLOYEES WHERE EMP_NAME LIKE '%H';
SELECT *FROM EMPLOYEES WHERE EMP_NAME LIKE 'A%I';
SELECT *FROM EMPLOYEES WHERE EMP_NAME LIKE '%J%';
SELECT *FROM EMPLOYEES WHERE EMP_NAME LIKE '____';
SELECT *FROM EMPLOYEES WHERE EMP_NAME LIKE '_A%';
SELECT *FROM EMPLOYEES WHERE EMP_NAME LIKE '__H__';


