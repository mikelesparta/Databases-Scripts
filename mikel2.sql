create or replace PROCEDURE Entrega2_Ejercicio4 AS
BEGIN
    FOR k IN (SELECT i.numb, i.in_date, i.amount
    FROM tinvoice i, tcharge c, tpaymentmean p
    WHERE i.numb = c.INVOICE_NUMB AND c.PAYMENTMEAN_ID = p.id AND p.type = 'Voucher'
    ORDER BY i.in_date DESC, amount DESC) LOOP
        DBMS_OUTPUT.PUT_LINE('INVOICE: ' || k.numb || ' - ' || k.in_date || ' - ' || k.amount);
    END LOOP;
END Entrega2_Ejercicio4;


create or replace FUNCTION FUNCTION10 (dea dealers.cifd%TYPE) RETURN number AS
nsales number;
BEGIN
    SELECT count(*) INTO nsales
    FROM sales
    WHERE cifd=dea;
    RETURN nsales;
END FUNCTION10;

--(VARCHAR AS type tpaymentmean.type%TYPE, number AS nsales number);
create or replace FUNCTION Entrega2_Ejercicio3 (n NUMBER) RETURN ret TABLE
(type tpaymentmean.type%TYPE,
amount NUMBER) AS
BEGIN
    SELECT count(*) INTO nsales
    FROM sales
    WHERE cifd=dea;
    RETURN nsales;
END Entrega2_Ejercicio3;

CREATE OR REPLACE FUNCTION F11 (cc customers.city%TYPE) RETURN NUMBER AS NCUSTOMERS number;
BEGIN
    SELECT COUNT(*) INTO NCUSTOMERS
    FROM CUSTOMERS
    WHERE city = cc;
    RETURN NCUSTOMERS;
END F11;