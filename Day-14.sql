USE PFS8;

CREATE TABLE Customers (
  customer_id	INT PRIMARY KEY,
  customer_name  VARCHAR(50),
  city       	VARCHAR(50),
  customer_type  VARCHAR(20)
);
 
CREATE TABLE Products (
  product_id 	INT PRIMARY KEY,
  product_name   VARCHAR(50),
  category   	VARCHAR(30),
  price      	DECIMAL(10,2)
);
 
CREATE TABLE Orders (
  order_id   	INT PRIMARY KEY,
  customer_id	INT REFERENCES Customers(customer_id),
  product_id 	INT REFERENCES Products(product_id),
  quantity   	INT,
  order_date 	DATE,
  amount     	DECIMAL(10,2)
);


INSERT INTO Customers (customer_id, customer_name, city, customer_type) VALUES (1, 'Rahul', 'Delhi', 'Premium');
INSERT INTO Customers (customer_id, customer_name, city, customer_type) VALUES (2, 'Meena', 'Mumbai', 'Regular');
INSERT INTO Customers (customer_id, customer_name, city, customer_type) VALUES (3, 'Arjun', 'Bangalore', 'Premium');
INSERT INTO Customers (customer_id, customer_name, city, customer_type) VALUES (4, 'Kavya', 'Delhi', 'Regular');
INSERT INTO Customers (customer_id, customer_name, city, customer_type) VALUES (5, 'Suresh', 'Chennai', 'Premium');
INSERT INTO Customers (customer_id, customer_name, city, customer_type) VALUES (6, 'Anjali', 'Mumbai', 'Regular');
INSERT INTO Customers (customer_id, customer_name, city, customer_type) VALUES (7, 'Vikram', 'Delhi', 'Regular');
INSERT INTO Customers (customer_id, customer_name, city, customer_type) VALUES (8, 'Pooja', 'Bangalore', 'Premium');
INSERT INTO Customers (customer_id, customer_name, city, customer_type) VALUES (9, 'Devi', 'Chennai', 'Regular');



INSERT INTO Products (product_id, product_name, category, price) VALUES (1, 'Laptop', 'Electronics', 55000);
INSERT INTO Products (product_id, product_name, category, price) VALUES (2, 'Mobile', 'Electronics', 25000);
INSERT INTO Products (product_id, product_name, category, price) VALUES (3, 'Chair', 'Furniture', 7000);
INSERT INTO Products (product_id, product_name, category, price) VALUES (4, 'Table', 'Furniture', 9000);
INSERT INTO Products (product_id, product_name, category, price) VALUES (5, 'Headphones', 'Electronics', 3000);
INSERT INTO Products (product_id, product_name, category, price) VALUES (6, 'Bookshelf', 'Furniture', 6000);


INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date, amount) VALUES (1, 1, 1, 1, '2023-01-05', 55000);
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date, amount) VALUES (2, 2, 2, 1, '2023-01-10', 25000);
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date, amount) VALUES (3, 3, 3, 2, '2023-02-01', 14000);
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date, amount) VALUES (4, 1, 5, 2, '2023-02-15', 6000);
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date, amount) VALUES (5, 4, 4, 1, '2023-03-03', 9000);
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date, amount) VALUES (6, 5, 2, 2, '2023-03-20', 50000);
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date, amount) VALUES (7, 6, 4, 3, '2023-04-02', 18000);
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date, amount) VALUES (8, 3, 5, 1, '2023-04-15', 3000);
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date, amount) VALUES (9, 7, 3, 1, '2023-05-01', 7000);
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date, amount) VALUES (10, 8, 1, 1, '2023-05-20', 54000);
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date, amount) VALUES (11, 2, 3, 2, '2023-06-02', 12000);
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date, amount) VALUES (12, 5, 4, 1, '2023-06-15', 8500);


select*from customers;
select*from products;
select*from orders;

-- Q1. Find the name and price of the most expensive product.
SELECT PRODUCT_NAME,PRICE FROM PRODUCTS WHERE PRICE=(SELECT MAX(PRICE)FROM PRODUCTS);

-- Q2. Find the order (order_id, customer_id, amount) with the smallest order amount.
SELECT ORDER_ID,CUSTOMER_ID,AMOUNT FROM ORDERS WHERE AMOUNT=(SELECT MIN(AMOUNT)FROM ORDERS);

-- Find the name of the customer who placed order number 5.
SELECT CUSTOMER_NAME FROM CUSTOMERS WHERE CUSTOMER_ID=(SELECT CUSTOMER_ID FROM ORDERS WHERE ORDER_ID=5);

-- Q4. Find the category of the product that was purchased in order number 1.
select category from products where product_id=(select product_id from orders where order_id=1);


-- find the names of customers who live in delhi or mumbai
SELECT CUSTOMER_NAME,CITY FROM CUSTOMERS WHERE CITY IN('MUMBAI','DELHI');

-- Q2. Find the names of products that have been ordered at least once.
select product_name from products
where product_id NOT in(select product_id from orders);

--   Q3. Find the names of customers who have placed at least one order.
SELECT CUSTOMER_NAME FROM CUSTOMERS 
WHERE CUSTOMER_ID NOT  IN(SELECT CUSTOMER_ID FROM ORDERS);

-- Q1. Find products priced greater than ANY product in the 'Furniture' category.
SELECT PRODUCT_NAME,PRICE FROM PRODUCTS
WHERE PRICE<ANY(SELECT PRICE FROM PRODUCTS WHERE CATEGORY='FURNITURE'); -- 6K,7K,9K

SELECT PRODUCT_NAME,PRICE FROM PRODUCTS
WHERE PRICE<ALL(SELECT PRICE FROM PRODUCTS WHERE CATEGORY='FURNITURE'); -- 6K,7K,9K

SELECT MAX(PRICE)AS THIRD_PRICE FROM PRODUCTS WHERE PRICE<(
SELECT MAX(PRICE) FROM PRODUCTS WHERE PRICE<(SELECT MAX(PRICE)FROM PRODUCTS)); -- 55K

-- Q1. Find the name(s) of the customer(s) who ordered the most expensive product.
SELECT CUSTOMER_NAME FROM CUSTOMERS
WHERE CUSTOMER_ID IN(SELECT CUSTOMER_ID FROM ORDERS -- 1,8
WHERE PRODUCT_ID=(SELECT PRODUCT_ID FROM PRODUCTS -- 1
                    WHERE PRICE=(SELECT MAX(PRICE) FROM PRODUCTS) -- 55K
                    )
                    );







