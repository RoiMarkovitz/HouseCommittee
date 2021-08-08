/*

-- Maybe change BEFORE DELETE to INSTEAD OF DELETE, it may solve the error
-- and then i will DELETE it inside myself
CREATE OR REPLACE TRIGGER trig_remove_tenant 
BEFORE DELETE ON tenant
FOR EACH ROW
DECLARE
    var_apartment_number apartment.apartment_number%type;
    var_start_date DATE;    
    var_tenant_id tenant.tenant_id%type;
    var_first_name tenant.first_name%type;
    var_last_name tenant.last_name%type;
    var_phone_number tenant.phone_number%type;  
BEGIN
    SELECT a.apartment_number, a.start_date, b.tenant_id, b.first_name, b.last_name, b.phone_number  
    INTO var_apartment_number, var_start_date, var_tenant_id, var_first_name,
    var_last_name, var_phone_number
    FROM tenant_apartment a, tenant b
    WHERE :OLD.tenant_id = a.tenant_id AND :OLD.tenant_id = b.tenant_id;   
    INSERT INTO apartment_history VALUES(var_apartment_number, var_start_date,
    var_tenant_id, SYSDATE, var_first_name, var_last_name, var_phone_number);    
END;

--DELETE FROM tenant where tenant_id = 555999231;

*/


create or replace PROCEDURE update_tenant 
( 
    in_tenant_id tenant.tenant_id%type,
    in_first_name tenant.first_name%type,
    in_last_name tenant.last_name%type,
    in_phone_number tenant.phone_number%type,
    in_committee_member tenant.committee_member%type
)
IS
BEGIN
    UPDATE tenant
    SET first_name = in_first_name, last_name = in_last_name,
    phone_number = in_phone_number, committee_member = in_committee_member
    WHERE tenant_id = in_tenant_id;
END;

--EXECUTE  update_tenant(555999232, 'aaa', 'dddd', '353522' , 0);


create or replace PROCEDURE add_tenant 
( 
    in_tenant_id tenant.tenant_id%type,
    in_first_name tenant.first_name%type,
    in_last_name tenant.last_name%type,
    in_phone_number tenant.phone_number%type,
    in_committee_member tenant.committee_member%type,
    in_apartment_number apartment.apartment_number%type,
    in_start_date DATE
)
IS
BEGIN
    INSERT INTO tenant VALUES(in_tenant_id, in_first_name, in_last_name,
    in_phone_number, in_committee_member);
    
    add_tenant_apartment(in_tenant_id, in_apartment_number, in_start_date);        
END;

-- EXECUTE add_tenant(123321123, 'daniel', 'dan', '55432', 0, 3, SYSDATE);

create or replace PROCEDURE add_tenant_apartment 
( 
    in_tenant_id tenant_apartment.tenant_id%type,
    in_apartment_number tenant_apartment.apartment_number%type,
    in_start_date tenant_apartment.start_date%type  
)
IS
BEGIN   
    INSERT INTO tenant_apartment VALUES(in_tenant_id, in_apartment_number, 
    in_start_date);   
END;


create or replace PROCEDURE add_apartment_general_payment
( 
    in_payment_due_date apartment_payments.payment_due_date%type,
    in_reason apartment_payments.reason%type,
    in_first_name apartment_payments.first_name%type,
    in_last_name apartment_payments.last_name%type,
    in_amount apartment_payments.amount%type,
    in_apartment_number apartment_payments.apartment_number%type
)
IS
BEGIN
    INSERT INTO apartment_payments VALUES(in_payment_due_date, in_reason, 
    in_first_name, in_last_name, in_amount, NULL, NULL, in_apartment_number);   
END;

--EXECUTE add_apartment_general_payment(SYSDATE, 'Damage', 'roi', 'markovitz', 200, 5);


create or replace PROCEDURE add_apartment_monthly_payment
( 
    in_payment_due_date apartment_payments.payment_due_date%type,
    in_first_name apartment_payments.first_name%type,
    in_last_name apartment_payments.last_name%type,   
    in_apartment_number apartment_payments.apartment_number%type
)
IS
    var_amount apartment_payments.amount%type;
    var_apartment_size apartment.apartment_size%type;
    var_warehouse_size warehouse.warehouse_size%type;
    var_warehouse_number apartment.warehouse_number%type;
BEGIN
    SELECT warehouse_number, apartment_size INTO var_warehouse_number, var_apartment_size 
    FROM apartment WHERE apartment_number = in_apartment_number;
    IF var_warehouse_number IS NULL THEN
        var_amount := 5 * var_apartment_size;
    ELSE   
        select warehouse_size INTO var_warehouse_size
        FROM apartment a, warehouse w
        WHERE a.warehouse_number = w.warehouse_number AND in_apartment_number = a.apartment_number; 
        var_amount := 5 * (var_apartment_size + var_warehouse_size);
    END IF;
       
    INSERT INTO apartment_payments VALUES(in_payment_due_date, 'Monthly fee', 
    in_first_name, in_last_name, var_amount, NULL, NULL, in_apartment_number);   
END;

--EXECUTE add_apartment_monthly_payment(SYSDATE, 'roi', 'markovitz', 5);
--EXECUTE add_apartment_monthly_payment(SYSDATE, 'dann', 'ran', 1);


CREATE SEQUENCE work_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE NOMINVALUE NOCYCLE NOCACHE;


create or replace TRIGGER trig_new_work
BEFORE INSERT ON works
FOR EACH ROW
DECLARE
    var_wnum works.work_number%type;
BEGIN
    SELECT work_seq.NEXTVAL INTO var_wnum FROM dual;
    :NEW.work_number := var_wnum;
END;
   

create or replace PROCEDURE add_work
( 
    in_work_type works.work_type%type,
    in_price works.price%type,
    in_business_number service_provider.business_number%type,
    in_tenant_id tenant.tenant_id%type
)
IS
BEGIN
    INSERT INTO works (work_type, price, business_number, tenant_id) 
    VALUES(in_work_type, in_price,in_business_number, in_tenant_id);       
END;


CREATE SEQUENCE service_payment_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE NOMINVALUE NOCYCLE NOCACHE;


create or replace TRIGGER trig_new_service_payment
BEFORE INSERT ON service_payments
FOR EACH ROW
DECLARE
    var_pnum service_payments.payment_number%type;
BEGIN
    SELECT service_payment_seq.NEXTVAL INTO var_pnum FROM dual;
    :NEW.payment_number := var_pnum;
END;
   

create or replace PROCEDURE add_service_payment
( 
    in_paid_date service_payments.paid_date%type,     
    in_work_number service_payments.work_number%type
)
IS
    var_amount service_payments.amount%type;
    var_business_number works.business_number%type;
BEGIN
    SELECT price, business_number INTO var_amount, var_business_number 
    FROM works 
    WHERE in_work_number = work_number;
    
    INSERT INTO service_payments (paid_date, amount, business_number, work_number) 
    VALUES(in_paid_date, var_amount, var_business_number, in_work_number);       
END;


create or replace PROCEDURE add_to_elections
( 
    in_election_date elections.election_date%type,     
    in_tenant_id elections.tenant_id%type,
    in_votes elections.votes%type,
    in_chosen elections.chosen%type
)
IS
BEGIN  
    INSERT INTO elections 
    VALUES(in_election_date, in_tenant_id, in_votes, in_chosen); 
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    raise_application_error (-20002,'You have tried to insert a duplicate tenant.');
END;


-- add exception if not in list 
create or replace PROCEDURE remove_from_elections
( 
    in_election_date elections.election_date%type,     
    in_tenant_id elections.tenant_id%type  
)
IS
BEGIN  
    DELETE FROM elections 
    WHERE in_election_date = election_date AND in_tenant_id = tenant_id;
END;


-- add exception if not in list 
create or replace PROCEDURE update_from_elections
(    
    in_election_date elections.election_date%type,     
    in_tenant_id elections.tenant_id%type, 
    in_votes elections.votes%type,
    in_chosen elections.chosen%type
)
IS
BEGIN  
    UPDATE elections 
    SET votes = in_votes, chosen = in_chosen
    WHERE in_election_date = election_date AND in_tenant_id = tenant_id;
END;


create or replace PROCEDURE add_warehouse
( 
    in_warehouse_number warehouse.warehouse_number%type,     
    in_warehouse_size warehouse.warehouse_size%type   
)
IS
BEGIN  
    INSERT INTO warehouse 
    VALUES(in_warehouse_number, in_warehouse_size); 
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    raise_application_error (-20003,'You have tried to insert a duplicate warehouse.');
END;


create or replace PROCEDURE add_apartment
( 
    in_apartment_number apartment.apartment_number%type,     
    in_floor apartment.floor%type, 
    in_rooms apartment.rooms%type, 
    in_apartment_size apartment.apartment_size%type, 
    in_warehouse_number apartment.warehouse_number%type
)
IS
BEGIN  
    INSERT INTO apartment 
    VALUES(in_apartment_number, in_floor, in_rooms, in_apartment_size, in_warehouse_number); 
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    raise_application_error (-20003,'You have tried to insert a duplicate apartment.');
END;


create or replace PROCEDURE add_service_provider
( 
    in_business_number service_provider.business_number%type,     
    in_provider_name service_provider.provider_name%type,  
    in_address service_provider.address%type, 
    in_phone_number service_provider.phone_number%type
)
IS
BEGIN  
    INSERT INTO service_provider 
    VALUES(in_business_number, in_provider_name, in_address, in_phone_number); 
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    raise_application_error (-20004,'You have tried to insert a duplicate service provider.');
END;

