--1 Tuples from the CARMAKERS relation having ‘barcelona’ in the city attribute.
SELECT *
FROM carmakers
WHERE citycm='barcelona';

--2 Tuples from the CUSTOMERS relation for ‘madrid’ customers with ‘garcia’ surname. The same for customers having either one or the other condition.
SELECT *
FROM customers
WHERE city='madrid' AND surname='garcia';

SELECT *
FROM customers
WHERE city='madrid' OR surname='garcia';

--3 Get a relation having the values of the surname and city attributes from the CUSTOMERS relation
SELECT surname, city
FROM customers;

--4 Get a relation showing the surnames of the CUSTOMERS from ‘madrid’
SELECT surname
FROM customers
WHERE city='madrid';

--5 Names of car makers having ‘gtd’ models
SELECT DISTINCT M.namecm
FROM carmakers M, cmcars MC, cars C
WHERE M.cifcm=MC.cifcm AND MC.codecar=C.codecar AND C.model='gtd';

--6 Names of car makers that have sold red cars
SELECT DISTINCT M.namecm
FROM carmakers M, cmcars CM, cars C, sales S
WHERE M.cifcm=CM.cifcm AND CM.codecar=C.codecar AND C.codecar=S.codecar AND S.color='red';

--7 Names of cars having the same models as the car named ‘cordoba’.
SELECT DISTINCT namec
FROM cars
WHERE model IN (SELECT model FROM cars WHERE namec='cordoba');

--8 Names of cars NOT having a ‘gtd’ model.
SELECT DISTINCT namec
FROM cars
WHERE namec NOT IN (SELECT namec FROM cars WHERE model='gtd');

--9 Get all tuples from the DEALERS relation   
SELECT *
FROM dealers;

--10 Pairs of values: CIFC from the CARMAKERS relation, and DNI from the CUSTOMERS                REVISARRRRRRRRRRRRRRRRRR
--relation belonging to the same city. The same for the ones not belonging to the same city.
SELECT M.cifcm, C.dni
FROM carmakers m, customers c
WHERE c.city = m.citycm;

SELECT M.cifcm, CU.dni
FROM carmakers M, cmcars CM, cars C, sales S, customers CU, distribution D, dealers DE
WHERE M.cifcm=CM.cifcm AND CM.codecar=C.codecar AND C.codecar=S.codecar AND S.dni=CU.dni AND C.codecar=D.codecar 
AND D.cifd=DE.cifd AND DE.cifd=S.cifd;

--11 Codecar values for the cars stocked in any dealer in ‘barcelona’
SELECT DI.codecar
FROM distribution DI, dealers DE
WHERE DI.cifd=DE.cifd AND DE.cityd='barcelona';

SELECT DI.codecar 
FROM distribution DI
WHERE EXISTS (SELECT * FROM dealers DE WHERE DE.cityd='barcelona' AND DE.cifd=DI.cifd);

--12 Codecar values for cars bought by a ‘madrid’ customer in a ‘madrid’ dealer
SELECT C.codecar
FROM cars C, sales S, customers CU, dealers DE
WHERE C.codecar=S.codecar AND S.cifd=DE.cifd and DE.cityd='madrid' AND S.dni=CU.dni AND CU.city='madrid';

--13 Codecar values for cars sold in a dealer in the same city as the buying customer.
SELECT C.codecar
FROM cars C, sales S, customers CU, dealers DE
WHERE C.codecar=S.codecar AND S.cifd=DE.cifd AND DE.cityd=CU.city AND S.dni=CU.dni;

--14. Pairs of CARMAKERS (names) from the same city.
SELECT  M1.namecm, M2.namecm
FROM carmakers M1, carmakers M2
WHERE M1.citycm=M2.citycm AND M1.namecm<>M2.namecm

--15. Get all tuples from the CUSTOMERS relation belonging to ‘madrid’ customers.
SELECT *
FROM customers
WHERE city='madrid';

--16. DNI of the customers that have bought a car in a ‘madrid’ dealer.
SELECT CU.dni
FROM customers CU, cars C, sales S, dealers DE
WHERE DE.cityd='madrid' AND DE.cifd=S.cifd AND S.codecar=C.codecar;

--17. Colors of cars sold by the ‘acar’ dealer.
SELECT S.color
FROM cars C, sales S, dealers D
WHERE C.codecar=S.codecar AND S.cifd=D.cifd AND D.named='acar';

--18. Codecar of the cars sold by any ‘madrid’ dealer.
SELECT C.codecar
FROM cars C, sales S, dealers D
WHERE C.codecar=S.codecar AND S.cifd=D.cifd AND D.cityd='madrid';

--19. Names of customers that have bought any car in the ‘dcar’ dealer.
SELECT CU.name
FROM customers CU, sales S, dealers D, cars C
WHERE C.codecar=S.codecar AND S.cifd=D.cifd AND D.named='dcar' AND S.dni=CU.dni;

--20. Name and surname of the customers that have bought a ‘gti’ model with ‘white’ color.
SELECT  CU.name, CU.surname
FROM customers CU, sales S, cars C
WHERE C.model='gti' AND C.codecar=S.codecar AND S.dni=CU.dni AND S.color='white';

--21. Name and surname of customers that have bought a car in a ‘madrid’ dealer that has ‘gti’ cars.
SELECT DISTINCT CU.name, CU.surname
FROM customers CU, sales S, cars C, dealers D
WHERE C.model='gti' AND C.codecar=S.codecar AND S.dni=CU.dni AND D.cityd='madrid';

--22. Name and surname of customers that have bought (at least) a ‘white’ and a ‘red’ car.
SELECT C.name, C.surname
FROM customers C
WHERE C.dni IN (SELECT dni FROM sales WHERE color='white')
	AND C.dni IN (SELECT dni FROM sales WHERE color='red');


--23 DNI of customers that have only bought cars at the dealer with CIFD ‘1’.
(SELECT dni FROM sales) MINUS
(SELECT dni FROM sales WHERE cifd<>'1');

--24. Names of the customers that have NOT bought ‘red’ cars at ‘madrid’ dealers.
SELECT DISTINCT CU.name
FROM customers CU, sales S, dealers D
WHERE Cu.dni NOT IN(SELECT dni FROM sales S, dealers D
WHERE D.cityd='madrid' AND S.color='red' AND S.cifd=D.cifd)
AND CU.dni=S.dni;

--25 For each dealer (cifd) show the total amount of cars stocked.
SELECT SUM (stockage) AS total_stockage
FROM distribution
GROUP BY cifd;

--26 . Show the cifd of dealers with an average stockage of more than 10 units (show that average as well).
SELECT cifd, avg (stockage) AS avg_stockage
FROM distribution
GROUP BY cifd
HAVING avg(stockage)>10;

--27. CIFD of dealers with a stock between 10 and 18 units inclusive.
SELECT cifd, SUM(stockage)
FROM distribution 
GROUP BY cifd
HAVING SUM(stockage) <= 10 AND SUM(stockage)>=10;

--28. Total amount of car makers. Total amount of cities with car makers.
SELECT count(*) AS total_cm
FROM carmakers;

--29 Name and surname of customers that have bought a car in a ‘madrid’ dealer, and have a name
--starting with j
SELECT DISTINCT name, surname
FROM customers C, sales S, dealers D
WHERE C.dni=S.dni AND C.city=D.cityd AND D.cityd='madrid' AND C.name LIKE 'j%';

--30. List customers ordered by name (ascending).
SELECT dni, name, surname
FROM customers
ORDER BY name asc; --asc = ascending & desc = descending

--31. List customers that have bought a car in the same dealer as customer with dni ‘2’ (excluding
--the customer with dni ‘2’). Same with dni ‘1’.
SELECT DISTINCT name, surname
FROM customers C, sales S 
WHERE C.dni=S.dni 
	AND S.cifd IN (SELECT cifd FROM sales WHERE dni='2')
    	AND C.dni <> '2';

SELECT DISTINCT name, surname
FROM customers C, sales S
WHERE C.dni=S.dni
	AND S.cifd IN (SELECT cifd FROM sales WHERE dni='1')
	AND C.dni <> '1';

--32. Dealers having an average stockage greater than the average stockage of all dealers together.
SELECT de.cifd, named, cityd
FROM dealers de, distribution di
WHERE de.cifd=di.cifd
GROUP BY de.cifd, named, cityd
HAVING AVG(stockage)>(SELECT AVG(stockage) FROM distribution);