-- 1.Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"


	insert into books (isbn, book_title, category, rental_price, status, author, publisher)
    values	
	(' 978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
    select *from books;

--2.Update an Existing Member's Address


UPDATE members
SET member_address ='199 Main St'
WHERE member_id = 'C101';

select * from members

--3. Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
where issued_id = 'IS121';

SELECT * FROM issued_status

--4.Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

select * from issued_status
where issued_emp_id =  'E101';

--5. List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

select issued_emp_id,
	count(*) as total_book_issued
	from issued_status

	group by 1 
having count(*) > 1


--6.Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt

CREATE TABLE book_counts
as
	
select 
	b.isbn,
	ist.issued_book_name,
	count (ist.issued_id) as no_issued
	from books as b
JOIN 
issued_status as ist
ON ist.issued_book_isbn = b.isbn
group by 1,2


--7. Retrieve All Books in a Specific Category:

select 
	*
	from books
where category = 'History'

--8.Find Total Rental Income by Category:

select 
category,
sum	(rental_price) as total_rental_income
	from books as b
	JOIN 
	issued_status as ist 
	ON
	 b.isbn = ist.issued_book_isbn
group by 1


--9.List Members Who Registered in the Last 180 Days:

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';


--10 List Employees with Their Branch Manager's Name and their branch details


SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employee as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employee as e2
ON e2.emp_id = b.manager_id


--11 Create a Table of Books with Rental Price Above a Certain Threshold

CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;



--12 Retrieve the List of Books Not Yet Returned

SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;















