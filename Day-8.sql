USE DA8;
SHOW TABLES;
DROP TABLE PRODUCTS;
CREATE TABLE Products (
 id INT,
 name VARCHAR(100),
 price DECIMAL(10,2),
 qty INT
 );

INSERT INTO Products VALUES
 (1, 'Pen', 10.00, 100),
 (2, 'Notebook', 25.00, 50),
 (3, 'Pencil', 5.00, 200),
 (4, 'Eraser', 3.00, 300),
 (5, 'Marker', 15.00, 80),
 (6, 'Scale', 20.00, 150),
 (7, 'Sharpener', 8.00, 120),
 (8, 'Geometry Box', 120.00, 40),
 (9, 'Sketch Pen', 60.00, 75),
 (10, 'Crayons', 90.00, 55);
 
 SELECT*FROM PRODUCTS;
 
-- 1. Calculate total value of each product adding tax of 12 percent 
SELECT NAME,PRICE,PRICE+(PRICE*0.12)AS PRICE_WITH_TAX FROM PRODUCTS; 
-- 2. Calculate discounted price by subtracting price with 5 rs
SELECT NAME,PRICE,PRICE-5 AS DISCOUNTED_PRICE FROM PRODUCTS;
-- 3. Total inventory value for each product
SELECT NAME,PRICE,QTY,PRICE*QTY AS TOTAL_INVENTORY FROM PRODUCTS;
-- 4. Calculate price per 10 units
SELECT NAME,PRICE,PRICE*10 AS PRICE_PER_10UNITS FROM PRODUCTS;
-- 5. Find products where quantity is not a multiple of 50
SELECT NAME,QTY%50!=0 AS PRICE_NOT_50 FROM PRODUCTS;
-- 1 . Add 2 units to all products
SET SQL_SAFE_UPDATES=0;
UPDATE PRODUCTS SET QTY=QTY+2 ;
SELECT*FROM PRODUCTS;
-- 2. Subtract 5 from price of each product
UPDATE PRODUCTS SET PRICE=PRICE-5 ;
SELECT*FROM PRODUCTS;
-- 3. Double the quantity of erasers
UPDATE PRODUCTS SET QTY=QTY*2 WHERE NAME='ERASER';
SELECT*FROM PRODUCTS;
-- 4. Halve the quantity of markers
UPDATE PRODUCTS SET QTY=QTY/2 WHERE NAME='MARKER';
-- 5. Delete products where quantity is less than 100
DELETE FROM PRODUCTS WHERE QTY<100;

CREATE TABLE StudentScores (
 id INT,
 name VARCHAR(100),
 subject VARCHAR(50),
 marks INT
 );


INSERT INTO StudentScores VALUES
 (1, 'Alice', 'Math', 95),
 (2, 'Bob', 'Math', 76),
 (3, 'Charlie', 'Math', 59),
 (4, 'Diana', 'Math', 88),
 (5, 'Eve', 'Math', 40),
 (6, 'Frank', 'Math', 95),
 (7, 'Grace', 'Science', 67),
 (8, 'Henry', 'Science', 82),
 (9, 'Ivy', 'English', 91),
 (10, 'Jack', 'English', 55),
 (11, 'Kevin', 'Math', 73),
 (12, 'Lily', 'Science', 48),
 (13, 'Mia', 'English', 100),
 (14, 'Noah', 'Math', 64),
 (15, 'Olivia', 'Science', 79);

SELECT*FROM STUDENTSCORES;

select*from studentscores where marks>80;
select*from studentscores where marks>=60;
select*from studentscores where marks<50;
select*from studentscores where marks=95;
select*from studentscores where marks!=95;
select*from studentscores where marks<>80;
select*from studentscores where marks<=60;


update studentscores set marks=marks+10 where marks<50;
select*from studentscores;

delete from studentscores where marks<50;

CREATE TABLE Employees (
   id INT,
   name VARCHAR(100),
   department VARCHAR(100),
   salary INT,
   isactive BOOLEAN
);
INSERT INTO EMPLOYEES VALUES
(1, 'Rahul Sharma', 'IT', 50000, TRUE),
(2, 'Priya Reddy', 'HR', 30000, TRUE),
(3, 'Amit Kumar', 'Finance', 45000, FALSE),
(4, 'Sneha Patel', 'IT', 35000, TRUE),
(5, 'Vikram Singh', 'Finance', 28000, TRUE),
(6, 'Anjali Mehta', 'HR', 32000, FALSE),
(7, 'Kiran Rao', 'IT', 60000, TRUE),
(8, 'Pooja Verma', 'Marketing', 27000, TRUE);

SELECT*FROM EMPLOYEES;


SELECT*FROM EMPLOYEES WHERE DEPARTMENT='IT' AND SALARY>40000;
