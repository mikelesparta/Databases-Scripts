CREATE OR REPLACE PROCEDURE DELIVERY2_EXERCISE1 AS
    
    --Variable with the code of an order
    orderCode torder.code%type;
    
    --Cursor with every order
    CURSOR orders IS SELECT * FROM torder;

    --Cursor with the spareparts given the code of an order
    CURSOR spareparts(orderCode torder.code%TYPE) IS  
    SELECT sparepart_code, quantity, price FROM tis_in i WHERE i.order_code = ordercode;
    
    --Cursor with the spareparts that will appear in an order (if the stock is the less than the minimum)
    CURSOR sparepartsMinStock IS 
    SELECT t.code, t.maxstock FROM tsparepart t WHERE t.stock < t.minstock AND t.code IN (SELECT sparepart_code FROM tsupply );
    
    --Cursor with the provider of a given sparepart given its code
    CURSOR provider2(sparepartcode tsparepart.code%type) IS 
    SELECT * FROM (SELECT * FROM tsupply WHERE sparepart_code = sparepartcode)
    WHERE ROWNUM = 1; 

BEGIN

    FOR sparepart IN sparepartsMinStock LOOP
        FOR provider IN provider2(sparepart.code) LOOP
            --We select the code from the order for each provider and sparepart and initialize the orderCode
            SELECT code INTO orderCode FROM torder WHERE provider_nif = provider.nif;
            INSERT INTO torder VALUES( orderCode, sparepart.stock, trunc(SYSDATE), null, 'PENDING', provider.nif );    
            INSERT INTO tis_in VALUES( orderCode, sparepart.code, provider.price, sparepart.stock );
        END LOOP;
    END LOOP;
    
    --We print the necessary information
    FOR o in orders LOOP   
        DBMS_OUTPUT.PUT_LINE('Order: '|| o.code || ' -- ' || o.ordered_date || ' -- ' || o.provider_nif );
        FOR s IN spareparts(ord.code) LOOP
            DBMS_OUTPUT.PUT_LINE(' - Sparepart: ' || s.sparepart_code  ||' -- ' || s.quantity || ' -- ' || s.price);
        END LOOP;
    END LOOP;

END DELIVERY2_EXERCISE1;



CREATE OR REPLACE PROCEDURE DELIVERY2_EXERCISE2(dni IN tclient.dni%type) AS 

    --We declare two attributes representing then number of invices paid and not paid
    paid NUMBER;
    notPaid NUMBER;

    --We create a cursor of the invoices passing by parameter the status of that invoice (PAID / NOT_YET_PAID)
    CURSOR invoices(status2 tinvoice.status%type) IS 
    SELECT * FROM tinvoice WHERE status = status2 and numb in (
        SELECT DISTINCT invoice_numb 
        FROM tworkorder wo , tvehicle v 
        WHERE wo.vehicle_pn=v.platenumber and v.client_dni= dni)
    ORDER BY in_date ASC;
    
    --We create another cursor in order to obtain the vehicles given the numb parameter from the invoice and
    --select the plate number, brand, the number of work orders and the sum of the amount
    CURSOR vehicles(invoiceNumb tinvoice.numb%type) IS
    SELECT platenumber, brand, COUNT(invoice_numb) AS num_workorders, SUM(amount) AS tot_amount 
    FROM tvehicle v, tworkorder w WHERE v.platenumber=w.vehicle_pn AND w.invoice_numb=invoiceNumb
    GROUP BY platenumber, brand;

    BEGIN      
    
        --We initialize them to zero
        paid:=0;
        notPaid:=0;
    
        --We print the neccesary information and for each invoice we sum the amount to the previous variables
        FOR i IN invoices('PAID') LOOP
            DBMS_OUTPUT.PUT_LINE('*INVOICE: -' || i.numb || ' -- ' || i.in_date || ' -- ' || i.amount || ' -- ' || i.vat || ' -- ' || i.status  );
            paid := paid + i.amount; 
            for p in vehicles(i.numb) LOOP
                DBMS_OUTPUT.PUT_LINE('  -VEHICLE: ' || p.platenumber || ' -- ' || p.brand || ' -- ' || p.num_workorders || ' -- ' || p.tot_amount);    
            END LOOP;
        END LOOP;
    
        FOR i IN invoices('NOT_YET_PAID') LOOP
            DBMS_OUTPUT.PUT_LINE('*INVOICE: -' || i.numb || ' -- ' || i.in_date || ' -- ' || i.amount || ' -- ' || i.vat || ' -- ' || i.status  );
            notPaid := notPaid + i.amount;
            for p in vehicles(i.numb) LOOP
                DBMS_OUTPUT.PUT_LINE('  -VEHICLE: ' || p.platenumber || ' -- ' || p.brand || ' -- ' || p.num_workorders || ' -- ' || p.tot_amount);           
            END LOOP;
        END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('TOTALS:');
    DBMS_OUTPUT.PUT_LINE('NOT_YET_PAID: ' || notPaid );
    DBMS_OUTPUT.PUT_LINE('PAID: ' || paid );

END DELIVERY2_EXERCISE2;



CREATE OR REPLACE FUNCTION DELIVERY2_EXERCISE3 (vehicleBrand tvehicle.brand%type, plateNum OUT tvehicle.platenumber%type) 
    RETURN NUMBER AS numSubs NUMBER;
    --We pass the parameter of the brand to the function then, we return both the plate number
    --by passing the parameter OUT and also return the number of substitutions
    
BEGIN
    
    --We need to select the plate number from the vehicle from the brand passed by parameter
    --In order to obtain the number of substitutions we use COUNT
    --To specify that it is only one vehicle we use WHERE ROWNUM=1
    SELECT platenumber, max(vAmount) INTO plateNum,  numSubs FROM 
       (SELECT v.platenumber, COUNT(*) as vAmount
        FROM tvehicle v, tworkorder w, tintervention i, tsubstitution s
        WHERE v.platenumber=w.vehicle_pn AND v.brand=vehicleBrand AND w.vehicle_pn=i.vehicle_pn AND s.vehicle_pn=i.vehicle_pn
        GROUP BY v.platenumber)
    WHERE ROWNUM=1 group by platenumber;
    
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001,'No vehicles from that brand');
    
    --We print the neccesary informatin and return the number of substitutions
    DBMS_OUTPUT.put_line('* VEHICLE: ' || plateNum || ' - number of substitutions: ' || numSubs); 
    RETURN numSubs;
  
END DELIVERY2_EXERCISE3;



CREATE OR REPLACE PROCEDURE DELIVERY2_EXERCISE4 AS 

    --We create a cursor and select the invoices whose only mean of payment is vouchers therefore we use NOT IN to make clear 
    --that creditcard and cash are both restricted, then we order ascendingly  by the dates and descendingly by the amount
    CURSOR invoices IS 
    SELECT DISTINCT i.numb, i.in_date, i.amount 
    FROM tinvoice i, tcharge c, tvoucher v
    WHERE i.numb=c.invoice_numb AND c.paymentmean_id NOT IN (SELECT id FROM tcreditcard) AND
    c.paymentmean_id NOT IN (SELECT id FROM tcash) AND c.paymentmean_id = v.id      
    ORDER BY in_date ASC, amount DESC; 

    BEGIN        
        
        --For each invoice print the necessary info
        FOR i IN invoices loop   
            DBMS_OUTPUT.PUT_LINE('*INVOICE: ' || i.numb || ' - ' || i.in_date || ' - ' || i.amount);
        END LOOP;
        
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001,'NO INVOICES WHOSE MEAN OF PAYMENT IS JUST A VOUCHER FOUND');

END DELIVERY2_EXERCISE4;


---------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER DELIVERY3_EXERCISE1
    
    BEFORE INSERT OR UPDATE ON tsubstitution
    FOR EACH ROW 
    
    DECLARE
        --We declare an attribute that references the stock of a substitution        
        stock tsparepart.stock%TYPE;
    
BEGIN
    
    SELECT p.stock INTO stock
    FROM tsubstitution s, tsparepart p
    WHERE s.sparepart_code = p.code;
    
    IF inserting  THEN
        --We need to check if theres enough stockage of the spareparts
        IF stock < :NEW.quantity THEN 
            RAISE_APPLICATION_ERROR(-20001,'NO SUBSTITUTION CAN BE DONE IF THE STOCK IS LESS THAN THE QUANTITY');
        END IF; 
        ELSE
            --Since there are enough we need to update the stock minus the quantity we substitute
            UPDATE tsparepart SET stock = stock - :NEW.quantity  WHERE code= :NEW.sparepart_code;
    END IF;
    
    IF deleting THEN
        --we add to the stock the quantity we deleted
        UPDATE tsparepart SET stock = :OLD.quantity + stock  WHERE code= :OLD.sparepart_code; 
    END IF; 
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001,'NO SUBSTITUTIONS FOUND');
        
END;


CREATE OR REPLACE TRIGGER DELIVERY3_EXERCISE2
    BEFORE INSERT ON tpaymentmean 
    FOR EACH ROW 

    DECLARE
        --We declare an attribute that references the type of the paymentmean
        type2 tpaymentmean.type%type;
        
    BEGIN
    
        --In case the order is processed then we give type2 that value
        SELECT p.type INTO type2
        FROM tpaymentmean p, tcharge c, tinvoice i
        WHERE p.id=c.paymentmean_id  AND c.paymentmean_id=i.numb;
        
        --If it is of the same type as the :NEW.type an error is raised
        IF type2=:NEW.type THEN
            RAISE_APPLICATION_ERROR(-20002,'IT ALREADY HAS A PAYMENTMEAN OF THE SAME TYPE'); 
        END IF;
        
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002,'NO PAYMENTS FOUND'); 
        
END;










