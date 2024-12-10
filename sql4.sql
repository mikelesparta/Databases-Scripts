--1. Names of customers with both accounts and loans at Perryridge branch. Express the query in
--several different ways (using EXISTS, using IN, using join tables and using INTERSECT).
SELECT DISTINCT cus_name
FROM borrower, loan
WHERE borrower.lo_number=loan.lo_number AND br_name = 'Perryridge'
AND cus_name IN(SELECT cus_name FROM account, accountholder
WHERE account.acc_number=accountholder.acc_number AND br_name='Perryridge');

SELECT DISTINCT cus_name
FROM accountholder
WHERE account.acc_number=accountholder.acc_number AND account.br_name = 'Perryridge'
AND cus_name IN(SELECT cus_name FROM loan, borrower
WHERE borrower.lo_number=loan.lo_number AND loan.br._name = 'Perryridge');

SELECT cus_name FROM accountholder, account
WHERE account.acc_number = accountholder.acc_number and account.br_name = 'Perryridge'
and EXISTS (
SELECT * FROM loan, borrower
WHERE borrower.lo_number = loan.lo_number and borrower.cus_name=accountholder.cus_name
and loan.br_name = 'Perryridge');

SELECT DISTINCT cus_name
FROM borrower, loan
WHERE borrower.lo_number = loan.lo_number AND br_name = 'Perryridge'
INTERSECT
SELECT cus_name FROM account, accountholder
WHERE account.acc_number = accountholder.acc_number
AND br_name = 'Perryridge';

--2. Names of customers with an account but not a loan at Perryridge branch. Express the query in
--several different ways (using EXISTS/NOT EXISTS, using IN/NOT IN or using
--MINUS/EXCEPT).
SELECT DISTINCT cus_name
FROM account, accountholder
WHERE account.acc_number=accountholder.acc_number AND br_name='Perryridge'
AND cus_name NOT IN (SELECT cus_name FROM borrower, loan 
WHERE borrower.lo_number = loan.lo_number AND br_name = 'Perryridge');

(SELECT acho.cus_name
FROM ACCOUNTHOLDER acho, ACCOUNT acc
WHERE acho.acc_number=acc.acc_number AND acc.br_name='Perryridge')
MINUS
(SELECT b.cus_name
FROM BORROWER b, LOAN lo
WHERE b.lo_number=lo.lo_number AND lo.br_name='Perryridge'
);

--3. Names of customers with accounts at a branch where Hayes has an account.
SELECT DISTINCT D.cus_name 
FROM accountHolder D, account A
WHERE D.acc_number = A.acc_number AND D.cus_name<>'Hayes' AND br_name IN
(SELECT br_name FROM accountHolder Dh, account Ah WHERE Dh.acc_number = Ah.acc_number AND Dh.cus_name = 'Hayes');

SELECT DISTINCT accountholder.cus_name
FROM accountholder, account
WHERE accountholder.acc_number=account.acc_number
AND br_name IN (SELECT br_name FROM accountholder, account
WHERE accountholder.acc_number=account.acc_number AND accountholder.cus_name='Hayes');

SELECT DISTINCT d.cus_name
FROM accountholder d, account a
WHERE d.acc_number = a.acc_number AND d.cus_name <> 'Hayes' AND br_name IN
(SELECT br_name
FROM accountholder dh, account ah
WHERE dh.acc_number = ah.acc_number and dh.cus_name = 'Hayes');

--4. Names of branches whose banking assets are greater than the assets of SOME branch in
--Brooklyn.
SELECT br_name
FROM branch
WHERE asset > SOME (SELECT asset FROM branch WHERE br_city = 'Brooklyn');

SELECT T.br_name
FROM branch T, branch S
WHERE T.asset > ANY (SELECT asset FROM branch WHERE S.br_city = 'Brooklyn');

SELECT br_name
FROM branch
WHERE asset > ANY (SELECT asset FROM branch WHERE br_city = 'Brooklyn');

--5. Names of branches whose assets are greater than the assets of EVERY branch in Brooklyn.
SELECT br_name
FROM branch
WHERE asset > ALL (SELECT asset FROM branch WHERE br_city = 'Brooklyn');

SELECT br_name
FROM branch
WHERE asset > (SELECT max(asset) FROM branch WHERE br_city = 'Brooklyn');

--6. Names of customers at Perryridge branch, ordered by name.
(SELECT DISTINCT cus_name
FROM borrower, loan
WHERE borrower.lo_number = loan.lo_number AND br_name = 'Perryridge')
UNION
(SELECT DISTINCT cus_name FROM account, accountholder
WHERE account.acc_number=accountholder.acc_number AND br_name='Perryridge')
ORDER BY cus_name;

--7. Name of branch having largest average balance.
SELECT br_name, avg(balance)
FROM account
GROUP BY br_name
HAVING avg(balance) >= ALL(SELECT avg(balance) FROM account 
GROUP BY br_name); 

--8. Average balance of all customers in Harrison having at least 2 accounts.
SELECT avg(balance) as avg_balance
FROM account, accountholder, customer
WHERE account.acc_number=accountholder.acc_number AND 
accountholder.cus_name=customer.cus_name AND customer.cus_city='Harrison'
GROUP BY accountholder.cus_name HAVING count (*) >= 2;

