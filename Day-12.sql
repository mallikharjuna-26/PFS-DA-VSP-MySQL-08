use DA8;
SHOW TABLES;
DROP TABLE STUDENTS;
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    course VARCHAR(50)
);

INSERT INTO Students VALUES
(101,'Rahul','Java Full Stack'),
(102,'Priya','Python Full Stack'),
(103,'Kiran','Data Science'),
(104,'Sneha','Java Full Stack'),
(105,'Ajay','Testing');

select*from students;

CREATE TABLE Placed_Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    company_name VARCHAR(50)
);
INSERT INTO Placed_Students VALUES
(103,'Kiran','TCS'),
(104,'Sneha','Infosys'),
(105,'Ajay','Wipro'),
(106,'Pooja','Accenture'),
(107,'Ramesh','Capgemini');

select*from placed_students;
