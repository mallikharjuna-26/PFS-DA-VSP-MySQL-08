USE DA8;

SHOW TABLES;

DROP TABLE EMPLOYEES;

show tables;

CREATE TABLE EMPLOYEES(
EMPID CHAR(5),
FNAME VARCHAR(50),
LNAME VARCHAR(30),
AGE INT,
DOJ DATE,
ADDRESS TINYTEXT,
DEPT VARCHAR(20)
);

DESC EMPLOYEES;

ALTER TABLE EMPLOYEES MODIFY FNAME VARCHAR(30);

DESC EMPLOYEES;

ALTER TABLE EMPLOYEES ADD COMPANY_NAME TEXT FIRST;

ALTER TABLE EMPLOYEES CHANGE FNAME FIRST_NAME VARCHAR(40);

ALTER TABLE EMPLOYEES DROP COLUMN COMPANY_NAME;

alter table employees rename to codegnan_emp;


-- HOW TO ADD A COLUMN AFTER A PARTICULAR COLUMN
-- SYNTAX :- ALTER TABLE TABLE-NAME ADD COLUMN-NAME DATATYPE(SIZE) AFTER SPECIFIED-COLUMN-NAME
ALTER TABLE EMPLOYEES ADD PFID INT AFTER ADDRESS;

show tables;


ALTER TABLE EMPLOYEES ADD LOCATION TINYTEXT;

CREATE TABLE company_staff (
    emp_id INT primary key ,
    age TINYINT,
    experience SMALLINT,
    gender CHAR(1),
    emp_name VARCHAR(50),
    address TINYTEXT,
    salary DECIMAL(10,2),
    department ENUM('HR','IT','Sales','Finance','Support'),
    skills SET('Java','Python','SQL','Excel','Communication'),
    joining_date DATE
);




ALTER TABLE company_staff ADD email VARCHAR(100);

ALTER TABLE company_staff ADD phone_number BIGINT;

ALTER TABLE company_staff ADD bonus DECIMAL(8,2) AFTER salary;

ALTER TABLE company_staff ADD status VARCHAR(20) AFTER department;

ALTER TABLE company_staff ADD company_name VARCHAR(50) FIRST;

ALTER TABLE company_staff ADD qualification VARCHAR(50) AFTER emp_name;

ALTER TABLE company_staff MODIFY emp_name VARCHAR(100);

ALTER TABLE company_staff MODIFY salary DECIMAL(12,2);

ALTER TABLE company_staff RENAME COLUMN emp_name TO employee_name;

ALTER TABLE company_staff RENAME COLUMN joining_date TO date_of_joining;

ALTER TABLE company_staff DROP COLUMN bonus;

ALTER TABLE company_staff DROP COLUMN phone_number;

ALTER TABLE company_staff RENAME TO staff_records;

ALTER TABLE staff_records RENAME TO company_staff;

ALTER TABLE company_staff ADD last_updated DATE AFTER skills;

