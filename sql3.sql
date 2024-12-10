-- 1 Retrieve a relation with the name and surname taken from the AUTHORS relation
SELECT  au_name, au_surname
FROM authors;

--2 Retrieve a relation with two columns, one for the titles and one for the expected revenue for each
--title. The revenue is calculated as expected sales times price of the title. 
SELECT title, expected_sales*price as revenue
FROM titles;

--3 Show the titles with expected sales between 200 and 5000 units (copies).
SELECT title, expected_sales
FROM Titles
WHERE expected_sales BETWEEN 200 AND 5000;

--4 Show the name, surname and telephone number for all the authors.
SELECT  au_name, au_surname, au_telephone
FROM authors;

--5 Show the name and surname of the authors that do not have telephone number (i.e. it is null).
SELECT au_name, au_surname
FROM authors
WHERE au_telephone IS NULL;

--6 Show the name, surname and telephone number of all the authors, denoting “no telephone” for those
--that do not have telephone number. Express the query using the function NVL. nvl replaces null values
SELECT au_name, au_surname, NVL(au_telephone, 'no telephone')
FROM authors;

--7 Show the title id, title and expected sales for titles with type database (BD) or programming (PROG).
--Order them descendingly by price. Express the query in two different ways.
SELECT title_id, title, expected_sales
FROM titles
WHERE type='DB' OR type='PROG'
ORDER BY price DESC;

SELECT title_id, title, expected_sales
FROM titles
WHERE type IN ('DB','PROG')
ORDER BY price DESC;

--8 Show the authors with a telephone number starting with ‘456’.
SELECT *
FROM authors
WHERE au_telephone IS NOT NULL AND au_telephone LIKE '456%';

--9 Show the average price for titles in the relation TITLES. Show average price for titles with BD type.
--Express the query in two different ways.
SELECT avg(price) AS avergage_price
FROM titles
WHERE type='BD';

--10. Show the number of titles of each publisher. Number of titles belonging to each type, per publisher.
SELECT pub_id, count(title_id) as number_of_titles
FROM titles
GROUP BY pub_id;

SELECT pub_id, type, count(title_id) as total
FROM titles
GROUP BY pub_id, type ORDER BY pub_id;

--11. Show the number of copies in stock for each type of title. Ignore null values.
SELECT type, count(*)
from titles
WHERE type IS NOT NULL
GROUP BY type;

--12. Show the average price for each type of title with a publishing date later than year 2000.
SELECT type, d_publishing, avg(price) as avg_price
FROM titles
WHERE d_publishing > '01-01-2000'
GROUP BY type, d_publishing;

--13. Show the number of copies in stock for each type of title, but only if it is greater than 1.
SELECT type, COUNT(pub_id) AS stock
FROM titles
GROUP BY type
HAVING COUNT(pub_id) > 1;

--14 Show the average price for each type of title, but only if it is greater than 35.


--15. Show the average price for the titles of each publisher, but only if its identifier is greater than 2 and
--the average price is greater than 60. The result should be ordered ascendingly by publisher id.
SELECT pub_id, AVG(price) AS average
FROM titles
WHERE pub_id > 2
GROUP BY pub_id
HAVING AVG(price) > 60
ORDER BY pub_id ASC;

--16. Show the name, surname and editor_order for the title with ‘1’ as identifier.


--17. Show the names of the editors and publishers that are in the same city.


--18. Show the titles of BD type books, with the names of the authors and author_order.
SELECT T.title, A.au_name, A.au_surname, TA.author_order
FROM titles T, titlesAuthors TA, authors A
WHERE T.type='BD' AND T.title_id=TA.title_id AND TA.au_id=A.au_id;

--19. Show the name and surname of editors with the name of his chief editor
SELECT E1.ed_name, E1.ed_surname, E2.ed_name as chief_editor
FROM editors E1, editors E2
WHERE E1.ed_chief=E2.ed_id;

--20. Show the data from authors (au_id, au_name and au_surname) that have the same surname.


--21. Show the names of publishers that publish PROG titles. Express the query in two different ways.


--22. Show the title and price of books having the same price as the cheapest book. Same with the most
--expensive one.
SELECT title, price
FROM titles
WHERE price <= ALL(SELECT price FROM titles);

SELECT title, price
FROM titles
WHERE price<=ALL(SELECT price FROM titles);

SELECT title, price
FROM titles
WHERE price = (select min(price) from titles);

--23. Show the name and city of authors that live in the same city as ‘Abraham Silberschatz’.
SELECT au_name, au_city
FROM authors
WHERE au_city=(SELECT au_city FROM authors WHERE au_name='Abraham' AND au_surname='Silberschatz'); 

SELECT au_name, au_city
FROM authors 
WHERE au_city IN (SELECT au_city FROM authors WHERE au_name='Abraham' AND au_surname='Silberschatz'); 

--24. Show the name and surname of authors that are both individual authors and co-authors.
SELECt au_name
FROM authors A, titlesAuthors T
WHERE A.au_id= T.au_id AND percentage_participation<1.0
    AND A.au_id IN (SELECT DISTINCT TA.au_id
    FROM titlesAuthors TA WHERE percentage_participation=1.0);

SELECT A.au_name
FROM authors A, titlesauthors TA1, titlesauthors TA2
WHERE TA1.percentage_participation < 1 AND TA2.percentage_participation = 1 
    AND A.au_id = TA1.au_id AND A.au_id = TA2.au_id;

--25. Show the types of books that are in common for more than one publisher. Express the query in two
--different ways.
--SELECT DISTINCT T1.type
--FROM titles T1
--WHERE T1.type IN ();

--26. Show the types of books with a maximum price at least twice the average price of that type.
--NO  HACER

--27. Show the books that have a greater pre-publishing than the greatest pre-publishing of ‘Prentice Hall’
--publisher.
SELECT title
FROM titles 
WHERE pre_publishing > ALL (SELECT pre_publishing FROM titles T, publishers P
    WHERE T.pub_id=P.pub_id AND P.pub_name='PrenticeHall'); 

--28. Show the titles of the books published by a publisher established in a city starting with ‘B’.
--SELECT T.title
--FROM titles  T, publishers P
--WHERE P.pub_id=

--29. Show the names of publishers that do not publish BD type books. Express the query in two different ways.
SELECT P.pub_name
FROM publishers P WHERE P.pub_id NOT IN 
(SELECT pub_id FROM titles WHERE type='BD');