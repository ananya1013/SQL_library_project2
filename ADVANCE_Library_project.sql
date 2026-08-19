--SQL Project - Library Management System N2 



12.  --Identify Members with Overdue Books
--Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.


--issued_status

select m.member_id,
	m.member_name, b.book_title,
	isd.issued_date,
	CURRENT_DATE - isd.issued_date as over_dues
	from 
issued_status as isd 
join 
members as m
on isd.issued_member_id = m.member_id

join
books as b 
on isd.issued_book_isbn = b.isbn

left join 
return_status as rtn
on isd.issued_id = rtn.issued_id
where 
	rtn.return_date is null
and 
    (CURRENT_DATE - isd.issued_date) >30
order by 1




 14.--Update Book Status on Return
--Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).

select * from issued_status
where  issued_book_isbn = '978-0-330-25864-8'


select * from books
where isbn = '978-0-330-25864-8'

UPDATE books
SET status = 'no'
where isbn = '978-0-330-25864-8';

select * from return_status

where issued_id = 'IS106';

INSERT INTO return_status( return_id , issued_id,return_date)
values
('RS123','IS106',current_date );

select * from return_status
where issued_id = 'IS106';

--manually we have updated , inserted the issue and return of the books

CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(20),p_issued_id VARCHAR(20), p_book_quality VARCHAR(15))
LANGUAGE plpgsql
AS $$

DECLARE

	v_isbn VARCHAR(30);
v_book_name VARCHAR(70);

BEGIN 
	--LOGIC
-- inserting into returns based on users input
	INSERT INTO return_status( return_id , issued_id,return_date,book_quality)
values
(p_return_id,p_issued_id, CURRENT_DATE,p_book_quality);


select 
	issued_book_isbn ,
    issued_book_name
INTO 
	v_isbn,  -- store this isbn in a variable teporary table so that we can call during an update
	v_book_name
	from issued_status
where issued_id = p_issued_id;


UPDATE books
SET status = 'yes'
where isbn = v_isbn; 
-- we have to get the isbn now 
-- we have to also tell what datatype we are expecting from the above table


RAISE NOTICE 'THANK YOU FOR RETURNING THE BOOK % ', v_book_name;

	


END;
$$


CALL add_return_records();




select * from issued_status
where issued_id = 'IS135'

select * from return_status
	DELETE FROM return_status
where issued_id = 'IS135'
	

select * from books
where isbn='978-0-307-58837-1'

-- CALLING FUNCTION 
CALL add_return_records
 ('RS139' , 'IS135', 'good');



-- 15.  Branch Performance Report
--Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

select * from branch 
select * from employee
select * from books
select * from issued_status
	select * from return_status

CREATE TABLE branch_reports
AS
select 
	br.branch_id,
	br.manager_id,
	COUNT(isd.issued_id)as number_of_books_issued,
	COUNT(rs.return_id)as number_of_books_returned,
	SUM (bk.rental_price)as total_revenue
	from employee as emp
JOIN issued_status as isd
ON emp.emp_id = isd.issued_emp_id
JOIN branch as br 
ON br.branch_id = emp.branch_id
	JOIN books as bk 
	ON isd.issued_book_isbn = bk.isbn
LEFT JOIN return_status as rs 
ON isd.issued_id = rs.issued_id
group by 1;

select * from branch_reports



---16. CTAS: Create a Table of Active Members
--Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

CREATE TABLE active_members
	AS
select * from members 
	where member_id in
	
(select DISTINCT issued_member_id
	from issued_status where
	issued_date >= CURRENT_DATE - INTERVAL '2 month')

;
select * from active_members


--17 Find Employees with the Most Book Issues Processed
--Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.


select 
    issued_emp_id, e.emp_name,
	e.branch_id, 
	COUNT(issued_id) as number_of_books_processed
	from issued_status as isd 
JOIN employee as e 
ON e.emp_id = isd.issued_emp_id
GROUP BY 1,2,3
ORDER BY COUNT(issued_id) desc
limit  3;




 --19.Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. Description: Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows: The stored procedure should take the book_id as an input parameter. The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.


select * from branch 
select * from employee
select * from books
select * from issued_status
	
CREATE OR REPLACE PROCEDURE issue_book 
(p_issued_id VARCHAR (20),p_issued_member_id VARCHAR(15), p_issued_book_isbn VARCHAR (30),  p_issued_emp_id VARCHAR (10)) 

	-- parameters that we need as an input by the user 
LANGUAGE plpgsql
AS $$


DECLARE 
-- all the variable
-- checking if book is available 'yes'
	v_status VARCHAR(5);
BEGIN 
-- all code 
select status
	into v_status
	from books
	where isbn = p_issued_book_isbn;

if v_status = 'yes' then 
	insert into issued_status (issued_id, issued_member_id,issued_date, issued_book_isbn, issued_emp_id) 
values (p_issued_id,p_issued_member_id ,current_date ,p_issued_book_isbn , p_issued_emp_id );

UPDATE books 
	SET status = 'no'
	WHERE isbn = p_issued_book_isbn;


RAISE NOTICE 'book records added successfully for book isbn :%', p_issued_book_isbn;
	else
		
RAISE NOTICE 'Sorry to inform you the book is unavailable book_isbn:%', p_issued_book_isbn;


	end if;

END;
$$;


select * from books; 
--978-0-14-118776-1--yes
--978-0-375-41398-8 --no
 select * from issued_status;

CALL issue_book ('IS155' , 'C107' , '978-0-14-118776-1'   , 'E104');


CALL issue_book ('IS158' , 'C107' , '978-0-375-41398-8'   , 'E104');

























