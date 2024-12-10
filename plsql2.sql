--PLSQL2
--1. Add a new attribute DataCaps to the PURCHASES table that stores the name and surname
--of customers in uppercase. Develop a trigger that keeps the value of that attribute updated.
ALTER TABLE purchases ADD DataCaps varchar2(100);
--insert into purchases(DNI, NAME, SURNAME, NCARSBOUGHT) VALUES (7, 'Pepe', 'Cobo', 7); --> datacaps = pepecobo

CREATE OR REPLACE TRIGGER KEEPDATACAPS
    BEFORE INSERT OR UPDATE OF name, surname ON purchases
    FOR EACH ROW
BEGIN
    :NEW.datacaps := UPPER(CONCAT(:new.name, :new.surname));
END;

--2. Create a trigger on table SALES (in own schema). Each time a sale is recorded, the trigger
--should increment in 1 the number of cars (quantity) in table PURCHASES.
CREATE OR REPLACE TRIGGER INCREMENTPURCHASES
    AFTER INSERT ON sales
    FOR EACH ROW
BEGIN
    UPDATE purchases SET  ncarsbought = ncarsbought + 1 where DNI =: NEW.dni;

END;

CREATE OR REPLACE TRIGGER INCREMENTPURCHASESEXTENDED
    AFTER INSERT ON sales
    FOR EACH ROW
DECLARE
    n NUMBER;
    namec customers.name%type;
    surnamec customers.surname%type;

BEGIN
    SELECT COUNT(*) FROM purchases WHERE dni = :NEW.dni;
    IF n = 0 THEN               --ADD IT TO THE PURCHASES TABLE
        select namec, surnamec INTO  namec, surnamec from customers WHERE DNI =: NEW.DNI;
        insert into purchases VALUES(:NEW.DNI, namec, surnamec, 1, NULL);
    ELSE                         --UPDATE IT IN THE PURCHASES TABLE
        UPDATE purchases set ncarsbought = ncarsbought +1
        where dni =: new.dni;
    END IF;
END;
    
    
CREATE OR REPLACE TRIGGER INCREMENTSPURCHASES3
    AFTER INSERT OR DELETE ON sales
    FOR EACH ROW
BEGIN
    IF inserting THEN
        UPDATE purchases SET ncarsbought = ncarsbought +1
        where dni =: new.dni;
    END IF;
    IF deleting THEN
        UPDATE purchases SET ncarsbought = ncarsbought +1
        where dni =: new.dni;
    END IF;
END;

--3. Expand the above trigger so that when a customer deletes a sale, the number of cars in table
--PURCHASESS is updated correspondingly.
CREATE OR REPLACE TRIGGER INCREMENTDECREMENTPURCHASESEXT
    AFTER INSERT OR DELETE ON sales
    FOR EACH ROW
DECLARE
    n number;
    C_NAME customer.name%type;
    C_SURNAME customer.surname%type;
BEGIN
    IF inserting THEN
        SELECT COUNT(*) INTO n FROM purchases WHERE dni =: new.dni;
        IF n = 0 THEN
            SELECT name, surname INTO c_name, c_surname FROM customers WHERE dni =: new.dni;
            INSERT INTO purchases VALUES (:NEW.DNI, C_NAME, C_SURNAME, 1, NULL);
        ELSE
            UPDATE purchases SET ncarsbought = ncarsbought +1 WHERE dni =: new.dni;
        END IF;
    END IF;
    IF deleting THEN 
        SELECT ncarsbought INTO n FROM purchases WHERE dni =:old.dni;
        if n = 1 THEN                 --  REMOVE IT FROM TABLE PURCHASES
            DELETE FROM purchases WHERE dni =: old.dni;
        ELSE                        -- UPDATE IT FROM TABLE PURCHASES
            UPDATE purchases  SET ncarsbought = ncarsbought +1;
        END IF;
    END IF;
END;

--4. Create a table CUSTOMERS_LOG with the following attributes: DniPrev, NamePrev,
--SurnamePrev, CityPrev, DniCur, NameCur, SurnameCur, CityCur,
--DateTime. Develop a trigger that manages this table logging every update done on the CUSTOMER
CREATE TABLE customers_log (
    dniprev VARCHAR2(9),
    nameprev VARCHAR2(40),
    surnameprev VARCHAR2(40),
    cityprev VARCHAR2(25),
    dnicur VARCHAR2(9),
    namecur VARCHAR2(40),
    surnamecur VARCHAR2(40),
    citycur VARCHAR2(25),
    datetime DATE
);

CREATE OR REPLACE TRIGGER KEEPCUSTOMERLGUP
    AFTER INSERT OR DELETE OR UPDATE ON  customers
    FOR EACH ROW
BEGIN
    IF inserting THEN
        INSERT INTO customers_log VALUES(NULL, NULL, NULL, NULL, :new.dni, :new.name, :new.surname, :new.city, sysdate);
    ELSIF deleting THEN
        INSERT INTO customers_log VALUES(:old.dni, :old.name, :old.surname, :old.city, NULL, NULL, NULL, NULL, sysdate);
    ELSE 
        INSERT INTO customers_log VALUES(:OLD.DNI, :OLD.NAME, :old.surname, :old.city, :new.dni, :new.name, :new.surname, :new.city, sysdate);   
    END IF;
END;

--5. Develop a trigger that decrements the number of cars stocked in a dealer whenever a car is
--sold, but only in the case that the number of cars stocked in the dealer is greater than 1.


--6. Develop a trigger so that table PURCHASES can be deleted only by the owner of the schema
--between 11:00 and 13:00.
CREATE OR REPLACE TRIGGER DELETETABLEPURCHASES
    BEFORE DELETE ON purchases
DECLARE

BEGIN
    SELECT table_owner INTO FROM user_triggers WHERE trigger_name = 'DELETETABLEPURCHASES';

    
END;

--7. Develop a trigger that stores in a PURCHASES_LOG table the operation performed (insert,
--delete, update), the date of the operation, and the user initiating the operation.


--8. Yellow color has been discontinued, so yellow cars cannot be sold anymore.


--9. No dealer can stock more than 40 cars.


--10. Dealer 1 closed its doors yesterday. Therefore, this dealer cannot sell from now on.


--11. We have detected a possible toxic substance in the paint used to paint red cars. Fortunately, no
--cars were sold with that toxic before, but from now on, we want to log information about the
--cars that are sold. The log should record the cif and name of the dealer, the dni and name of
--the customer, the code, name and model of the car, and the date and time of the sale.


--12. Circulation of gray cars has been banned by the government. Therefore, gray cars that are sold
--must be painted in another color: white if the car model is ‘gtd’, and black if not.