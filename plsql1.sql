--2. Code a stored procedure that prints “Hello World”.
CREATE OR REPLACE PROCEDURE HELLOWORLD_INITIAL AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello world');
END HELLOWORLD_INITIAL;

--3. Code a stored procedure that takes a name as a parameter, and then prints “Hello” + name.
CREATE OR REPLACE PROCEDURE HELLOWORLD_NAME (NAME IN VARCHAR2) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello ' || NAME);
END HELLOWORLD_NAME;

CREATE OR REPLACE PROCEDURE HELLOWORLD_NAME(name IN VARCHAR := 'Jose') AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello ' || name);
END HELLOWORLD_NAME;

--4. Code a stored procedure that shows the maximum value for the stockage attribute in table
--distribution.
CREATE OR REPLACE PROCEDURE MAXIMUM_STOCK AS
    maxstock distribution.stockage%type;
BEGIN
    SELECT max(stockage) into maxstock FROM distribution; 
    DBMS_OUTPUT.PUT_LINE('The maximum stockage is ' || maxstock);
END MAXIMUM_STOCK;

--5. Code a stored procedure that, given a specific dealer, shows the total number of cars stocked.
CREATE OR REPLACE PROCEDURE PL5(dealer IN VARCHAR) as
    totalstock distribution.stockage%TYPE;
BEGIN
    SELECT sum(stockage) into totalstock from distribution where cifd = dealer;
    DBMS_OUTPUT.PUT_LINE('The dealer ' || dealer || ' has ' || totalstock || ' cars');
END PL5;

--6. Create a table with these attributes: total number of sales, total number of cars, total number
--of car makers, total number of customers, total number of dealers. Create a stored procedure
--that queries the database to compute each of those values, stores them in variables, and then
--inserts them into the table. Check that the insertion has been performed correctly.
--maaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaallllllllllllllllllllllllllllllllllllll
CREATE TABLE totals (
  tsales NUMBER,
  tcars NUMBER,
  tcarmakers NUMBER,
  tcustomers NUMBER,
  tdealers NUMBER
);

CREATE OR REPLACE PROCEDURE PLSQL1_6 AS
    nsales NUMBER;
    ncars NUMBER;
    ncarmakers NUMBER;
    ncustomers NUMBER;
    ndealers NUMBER;
BEGIN
    SELECT count(*) INTO nsales FROM sales;
    SELECT count(*) INTO ncars FROM cars;
    SELECT count(*) INTO ncarmakers FROM carmakers;
    SELECT count(*) INTO ncustomers FROM customers;
    SELECT count(*) INTO ndealers FROM dealers;
    INSERT INTO totals VALUES (nsales, ncars, ncarmakers, ncustomers, ndealers); 
    COMMIT;
END PLSQL1_6;

--7. Create a new table CustomersLog using dni as primary key. Develop a stored procedure that
--copies the contents from the Customers table into that table. Run the procedure twice.
 CREATE TABLE CUSTOMERSLOG (
    dni VARCHAR2(9) PRIMARY KEY,
    name VARCHAR2(40),
    surname VARCHAR2(40),
    city VARCHAR2(25)
);

CREATE OR REPLACE PROCEDURE PROCEDURE7 AS
BEGIN
    INSERT INTO CustomersLog SELECT * FROM customers;
    COMMIT;
END PROCEDURE7;

CREATE OR REPLACE PROCEDURE PROCEDURE7 AS 
    CURSOR listcustomers IS
        SELECT * FROM customers;
    onecust listcustomers%rowtype;
BEGIN
    OPEN listcustomers;
    FETCH listcustomers INTO onecust;
    WHILE listcustomers%found LOOP
    BEGIN
        INSERT INTO CustomersLog VALUES (onecust.dni, onecust.name, onecust.surname, onecust.city);
    EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        UPDATE CustomersLog
        SET name=onecust.name, surname=onecust.surname, city=onecust.city
        WHERE dni=onecust.dni;
    END;
    	FETCH listcustomers INTO onecust;
    END LOOP;
    CLOSE listcustomers;
    COMMIT;
END PROCEDURE7;

create or replace PROCEDURE EX7 AS
CURSOR listcustomers IS
SELECT * FROM customers;
onecust listcustomers%rowtype;
BEGIN
OPEN listcustomers;
FETCH listcustomers INTO onecust;
WHILE listcustomers%found LOOP
BEGIN
INSERT INTO CustomersLog VALUES (onecust.dni, onecust.name, onecust.surname, onecust.city);
exception
WHEN DUP_VAL_ON_INDEX THEN
UPDATE customerslog set name=onecust.name, surname= onecust.surname, city=onecust.city where dni=onecust.dni;
end;
FETCH listcustomers INTO onecust;
END LOOP;
close listcustomers;
commit;
END EX7;

--THIS WOULDNT WORK WE HAVE TO DO IT ONE BY ONE
CREATE OR REPLACE PROCEDURE PROCEDURE7_with_Exception AS
BEGIN
    INSERT INTO CustomersLog (SELECT * FROM customers);
    COMMIT;
END PROCEDURE7_with_Exception;


--8. Develop a stored procedure that prints the objects created by the user.
CREATE OR REPLACE PROCEDURE PROCEDURE8_imp AS
BEGIN
    for i in (SELECT object_name, object_type from USER_OBJECTS) LOOP
        DBMS_OUTPUT.PUT_LINE('Object: ' || i.object_name || ' Type: ' || i.object_type);
    end loop;
END PROCEDURE8_imp;


CREATE OR REPLACE PROCEDURE PL1_8 AS
CURSOR user IS SELECT object_name, object_type FROM user_objects;
BEGIN
    FOR i in user LOOP
    DBMS_OUTPUT.PUT_LINE('Object: ' || i.object_name || ' Type: ' || i.object_type);
    END LOOP;
END PL1_8;

CREATE OR REPLACE PROCEDURE PROCEDURE8_IMPLICIT AS
BEGIN
    FOR obj IN (SELECT object_name, object_type FROM USER_OBJECTS) LOOP
        DBMS_OUTPUT.PUT_LINE('Object: '||obj.object_name||' Type: '||obj.object_type);
    END LOOP;
END PROCEDURE8_IMPLICIT;

--With explicit cursor
CREATE OR REPLACE PROCEDURE PROCEDURE8_EXPLICIT AS 
    CURSOR obj IS
        SELECT object_name, object_type
        FROM USER_OBJECTS;
    obj_name USER_OBJECTS.object_name%TYPE;
    obj_type USER_OBJECTS.object_type%TYPE;
BEGIN
    OPEN obj;
    LOOP 
        FETCH obj INTO obj_name, obj_type;
        EXIT WHEN obj%NOTFOUND;     
        DBMS_OUTPUT.PUT_LINE('Object: '||obj_name||' Type: '||obj_type);   
    END LOOP;
    CLOSE obj;
END PROCEDURE8_EXPLICIT;

--9. Create a new table Purchases with the following information: dni, name, surname, number of
--cars bought (per customer). Develop a PL/SQL procedure that uses a read cursor to insert the
--information into the new table.
 CREATE TABLE PURCHASES (
    dni VARCHAR2(9),
    name VARCHAR2(40),
    surname VARCHAR2(40),
    cars NUMBER(3)
);

CREATE OR REPLACE PROCEDURE PROCEDURE9 AS
    CURSOR carspercustomer IS 
        SELECT c.dni, c.name, c.surname, count(*) as numcars
        FROM sales s, customers c
        WHERE s.dni=c.dni  
        GROUP BY c.dni, c.name, c.surname;
    onecust carspercustomer%ROWTYPE;
BEGIN
    OPEN carspercustomer;  
    FETCH carspercustomer INTO onecust;  
    WHILE carspercustomer%FOUND LOOP
        INSERT INTO purchases VALUES (onecust.dni, onecust.name, onecust.surname, onecust.numcars);
        FETCH carspercustomer INTO onecust;  
    END LOOP; 
    COMMIT;  
    CLOSE carspercustomer;
END PROCEDURE9;

CREATE OR REPLACE PROCEDURE PROCEDURE9_2 AS
BEGIN
    INSERT INTO purchases
        SELECT c.dni, name, surname, count(*) as numcars
        FROM sales s, customers c
        WHERE s.dni=c.dni
        GROUP BY c.dni, name, surname;
    COMMIT;
END PROCEDURE9_2;

--10. Develop a stored procedure that takes a dealer id, and then returns the number of sales that were
--made in that dealer. Develop a function with the same functionality.
create or replace PROCEDURE PL1_10 (d_id sales.cifd%TYPE) AS
BEGIN
    FOR i IN (SELECT COUNT(*) as n_sales FROM sales WHERE cifd = d_id GROUP BY cifd) LOOP
        DBMS_OUTPUT.PUT_LINE('Dealer: ' || d_id || ' Sales: ' || i.n_sales);
    END LOOP;
END PL1_10;

create or replace FUNCTION FUNCTION10 (dea dealers.cifd%TYPE) RETURN number AS
nsales number;
BEGIN
    SELECT count(*) INTO nsales
    FROM sales
    WHERE cifd=dea;
    RETURN nsales;
END FUNCTION10;

--11. Develop a PL/SQL function that takes a city and then returns the number of customers in that
--city. Develop a stored procedure with the same functionality.
CREATE OR REPLACE FUNCTION F11 (cc customers.city%TYPE) RETURN NUMBER AS NCUSTOMERS number;
BEGIN
    SELECT COUNT(*) INTO NCUSTOMERS
    FROM CUSTOMERS
    WHERE city = cc;
    RETURN NCUSTOMERS;
END F11;

create or replace PROCEDURE PROCEDURE11(ci IN customers.city%Type,ncust OUT NUMBER) AS
BEGIN
    SELECT count(*) into ncust
    from customers
    where city = ci;
END PROCEDURE11;

--12. Develop a stored procedure called ListCarsByCustomer. The procedure should generate a
--report with the cars that have been bought by each customer with this template:
PROCEDURE LISTCARSBYCUSTOMER AS 
    CURSOR allcustomers IS
        SELECT DISTINCT name, surname, c.dni
        FROM customers c, sales s
        WHERE s.dni=c.dni;
    CURSOR carsbycust (onedni sales.dni%TYPE) IS
        SELECT c.codecar, namec, model, color
        FROM cars c, sales s
        WHERE s.dni=onedni AND s.codecar=c.codecar;
    numcars NUMBER;
    numdealers NUMBER;  
BEGIN
    FOR cust IN allcustomers LOOP
        SELECT COUNT(*), COUNT(DISTINCT cifd) INTO numcars, numdealers
        FROM sales
        WHERE dni=cust.dni;
        DBMS_OUTPUT.PUT_LINE('- Customer: '||cust.name||' '||cust.surname||' '||numcars||' '||numdealers);
        FOR car IN carsbycust (cust.dni) LOOP
            DBMS_OUTPUT.PUT_LINE('---> Car: '||car.codecar||' '||car.namec||' '||car.model||' '||car.color);
        END LOOP;
    END LOOP;
END LISTCARSBYCUSTOMER;

--13. Develop a stored procedure ListCarsOneCustomer that does the same as the previous
--one, but just for one customer. The dni of that customer should be passed as an in parameter of the procedure.
CREATE OR REPLACE PROCEDURE LISTCARSONECUSTOMER2 (custdni customers.dni%type DEFAULT 1) AS 
    cust customers%ROWTYPE;
    CURSOR carsonecust IS
        SELECT c.codecar, namec, model, color
            FROM cars c, sales s
            WHERE s.dni=custdni AND s.codecar=c.codecar;
    numcars NUMBER;
    numdealers NUMBER;
BEGIN
    SELECT * INTO cust FROM customers  WHERE dni=custdni;
    SELECT count(*), count(distinct cifd) INTO numcars, numdealers FROM  sales WHERE dni=custdni;
    DBMS_OUTPUT.PUT_LINE('- Customer: '|| cust.name ||' '|| cust.surname || ' ' || numcars || ' ' || numdealers);
    FOR car in carsonecust LOOP
        DBMS_OUTPUT.PUT_LINE('---> Car: '|| car.codecar ||' '|| car.namec||' '|| car.model||' '|| car.color);
    END LOOP;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('CHANGE THE DNI, THIS USER DOES NOT EXIST');
        RAISE_APPLICATION_ERROR(-20001, 'No data for this customer try it again');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002,'Error' || sqlcode || ' ' || sqlerrm);
END LISTCARSONECUSTOMER2;



--CREAR PAQUETES
CREATE OR REPLACE PACKAGE PACKAGE_LABPL1 AS
    PROCEDURE HELLOWORLD_NAME;
    PROCEDURE MAXIMUM_STOCK;
    PROCEDURE PL5(dealer IN VARCHAR);
    PROCEDURE PROCEDURE9;
    PROCEDURE TOTAL_STOCK_DEALER(dealer IN VARCHAR);
    PROCEDURE PROCEDURE11(ci IN customers.city%Type,ncust OUT NUMBER);
    PROCEDURE PL1_10(d_id sales.cifd%TYPE);
END PACKAGE_LABPL1;