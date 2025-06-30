SHOW DATABASES;
USE LIBRARY_P2;

--LIBRARY MANAGEMENT SYSTEM PROJECT 2


--  CREATING BRANCH TABLE

CREATE TABLE BRANCH(
branch_id VARCHAR(20),
manager_id VARCHAR(20),
branch_address VARCHAR(100),
contact_no VARCHAR(20));

ALTER TABLE BRANCH ADD PRIMARY KEY (BRANCH_ID);

-- CREATING EMPLOYEES TABLE

CREATE TABLE EMPLOYEES(
emp_id VARCHAR(20) ,
emp_name VARCHAR (50),
position VARCHAR (50),
salary INT,
branch_id VARCHar(50));


ALTER TABLE EMPLOYEES ADD PRIMARY KEY (EMP_ID);


-- CREATING BOOKS TABLE

CREATE TABLE BOOKS(
isbn VARCHAR (50) PRIMARY KEY,
book_title VARCHAR (200),
category VARCHAR (50),
rental_price FLOAT,
status VARCHAR(20),
author VARCHAR(40),
publisher VARCHAR (60));

-- CREATING MEMBERS TABLE

CREATE TABLE MEMBERS(
member_id VARCHAR (30) PRIMARY KEY,
member_name VARCHAR (40),
member_address VARCHAR (80),
reg_date DATE);

-- CREATING ISSUED STATUS TABLE

CREATE TABLE ISSUED_STATUS(
issued_id VARCHAR(30) PRIMARY KEY,
issued_member_id VARCHAR (20),
issued_book_name VARCHAR (100),
issued_date DATE,
issued_book_isbn VARCHAR (30),
issued_emp_id VARCHAR(20));

-- CREATING RETURN STATUS TABLE

CREATE TABLE RETURN_STATUS(
return_id VARCHAR (20) PRIMARY KEY,
issued_id VARCHAR (20),
return_book_name VARCHAR (100),
return_date DATE,
return_book_isbn VARCHAR(20));




-- FOREIGN KEY

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT FK_MEMBERS
FOREIGN KEY (ISSUED_MEMBER_ID)
REFERENCES MEMBERS(MEMBER_ID);


ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT FK_BOOKS
FOREIGN KEY (ISSUED_BOOK_ISBN)
REFERENCES BOOKS(ISBN);

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT FK_EMPLOYEES
FOREIGN KEY (ISSUED_EMP_ID)
REFERENCES EMPLOYEES(EMP_ID);


ALTER TABLE EMPLOYEES
ADD CONSTRAINT FK_BRANCH
FOREIGN KEY (BRANCH_ID)
REFERENCES BRANCH(BRANCH_ID);

ALTER TABLE RETURN_STATUS
ADD CONSTRAINT FK_ISSUED_STATUS
FOREIGN KEY (ISSUED_ID)
REFERENCES ISSUED_STATUS(ISSUED_ID);

--CHECKING DATA IN EACH TABLE

SELECT * FROM BRANCH;

SELECT * FROM BOOKS;
SELECT * FROM EMPLOYEES;
SELECT * FROM ISSUED_STATUS;
SELECT * FROM MEMBERS;
SELECT * FROM RETURN_STATUS;



--- PROJECT TASKS

--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT
	INTO
	BOOKS(isbn , book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

--Task 2:Update an Existing Member's Address

UPDATE
	MEMBERS
SET
	MEMBER_ADDRESS = "125 Main St"
WHERE
	member_id = "C101";



-----Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.



DELETE
FROM
	ISSUED_STATUS
WHERE
	ISSUED_ID = 'IS121';




--Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT
	*
FROM
	ISSUED_STATUS
WHERE
	ISSUED_EMP_ID = 'E101';

---Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT
	ISSUED_EMP_ID ,
	COUNT(ISSUED_ID) AS TOTAL_BOOK_ISSUED
FROM
	ISSUED_STATUS
GROUP BY
	ISSUED_EMP_ID
HAVING COUNT(ISSUED_ID) > 1;

--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE BOOKS_CNTS 

AS

SELECT
	B.ISBN,
	B.BOOK_TITLE,
	COUNT(IST.ISSUED_ID) AS NO_ISSUED
FROM
	BOOKS AS B
JOIN
ISSUED_STATUS AS IST
ON
	IST.ISSUED_BOOK_ISBN = B.ISBN
GROUP BY
	1,
	2;

SELECT * FROM BOOKS_CNTS;


--Task 7. Retrieve All Books in a Specific Category:

SELECT
	*
FROM
	BOOKS
WHERE
	CATEGORY = 'CLASSIC';

--Task 8: Find Total Rental Income by Category:


 SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM 
Issued_status as ist
JOIN
Books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1;

-- Task 9 List Members Who Registered in the Last 180 Days:

SELECT
	*
FROM
	MEMBERS
WHERE
	REG_DATE >= CURRENT_DATE - INTERVAL '180 DAYS';

-- Task 10 List Employees with Their Branch Manager's Name and their branch details:


SELECT
	E1.*,
	E2.EMP_NAME AS MANAGER,
	B.MANAGER_ID
FROM
	EMPLOYEES AS E1
JOIN BRANCH AS B ON
	B.BRANCH_ID = E1.BRANCH_ID
JOIN EMPLOYEES AS E2 ON
	B.MANAGER_ID = E2.EMP_ID;

--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:



CREATE TABLE BOOKS_PRICE_GREATER_THAN_SEVEN
AS
SELECT
	*
FROM
	BOOKS
WHERE
	RENTAL _PRICE>7;





SELECT
	*
FROM
	BOOKS_PRICE_GREATER_THAN_SEVEN;



Task 12: Retrieve the List of Books Not Yet Returned


SELECT
	DISTINCT IST.ISSUED_BOOK_NAME
FROM
	ISSUED_STATUS AS IST
LEFT JOIN RETURN_STATUS AS RS ON
	IST.ISSUED_ID = RS.ISSUED_ID
WHERE
	RS.RETURN_ID IS NULL;



---Advanced SQL Operations

Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.



SELECT
	IST.issued_member_id,
	m.member_name,
	bk.book_title,
	ist.issued_date,
	rs.return_date,
	CURRENT_DATE  - IST.ISSUED_DATE AS OVER_DUES
FROM
	ISSUED_STATUS AS IST
JOIN MEMBERS AS M ON
	M.MEMBER_ID = IST.ISSUED_MEMBER_ID
JOIN BOOKS AS BK ON
	BK.ISBN = IST.ISSUED_BOOK_ISBN
LEFT JOIN RETURN_STATUS AS RS ON
	RS.ISSUED_ID = IST.ISSUED_ID
WHERE
	RS.RETURN_DATE IS NULL;
















































