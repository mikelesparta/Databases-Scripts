--1. Offers of travel agencies that work with wholesale travel agencies that offer the type of travel
--‘hotels’. Show the price of the offer as well.
SELECT DISTINCT o.of_code, o.origin, o.destination, i.price
FROM offer O, isdone I, agency A, wholesaler W
WHERE O.of_code=I.of_code AND I.ag_code=A.ag_code AND A.who_code=W.who_code AND W.type='hotels';

--2. Total number of sales per agency (number_sales) for each type of wholesaler when that
--quantity is greater than 1.
SELECT type, sum(number_sales) AS total_sales 
FROM agency A, wholesaler W
WHERE A.who_code=W.who_code
GROUP BY type
HAVING sum(number_sales)>1;

--3. Find the greatest discount percentage applied to customers that have bought offers with origin
--‘Madrid’.
SELECT max(percentage)
FROM discount D, has H, sale S, offer O
WHERE O.origin='Madrid' AND O.of_code=S.of_code AND S.dni=H.dni AND H.dis_code=D.dis_code;

--4. Customers that have not bought anything with payment in instalments in agencies whose
--wholesaler is of type ‘packages’.
select name
    from customer
    where dni in 
	(select dni from customer
	MINUS
	select dni from sale S, agency A, wholesaler W
	 	where S.ag_code=A.ag_code and A.who_code=W.who_code and type='packages' and pay_instalments='Y');


--5. For each sale, find the name of the wholesaler that is the partner for the agency selling the
--offer. Show the name of the wholesaler, the destination of the offer, the final amount, the
--name of the customer buying the offer, and the percentage of discount applied.
select who_name, ag_name, destination, final_amount, name, percentage
	from offer O, agency A, sale S, wholesaler W, customer C, has H, discount D
	where O.of_code=S.of_code and S.ag_code=A.ag_code and A.who_code=W.who_code
	    and S.dni=C.dni and S.dni=H.dni and H.dis_code=D.dis_code;


--6. Name of the agency that has the cheapest offer that still has seats available
select of_code, A.ag_code, ag_name
	from isdone I, agency A
	where I.ag_code =A.ag_code and seats_available>0
		and price = (select min(price)
        		from isdone
        		where seats_available>0);