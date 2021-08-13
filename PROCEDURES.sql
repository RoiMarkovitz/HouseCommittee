--- $$$$$ PROCEDURES $$$$$ ---
-- All procedures for manipulating the data.
-- Usage of sequences and triggers.

-- ##### APARTMENT_PAYMENTS ##### --

CREATE SEQUENCE apartment_payments_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE NOMINVALUE NOCYCLE NOCACHE;


create or replace TRIGGER trig_new_apartment_payment
BEFORE INSERT ON apartment_payments
FOR EACH ROW
DECLARE
    var_pnum apartment_payments.payment_number%type;
BEGIN
    SELECT apartment_payments_seq.NEXTVAL INTO var_pnum FROM dual;
    :NEW.payment_number := var_pnum;
END;


create or replace PROCEDURE add_apartment_monthly_payment
( 
    in_payment_due_date apartment_payments.payment_due_date%type,    
    in_apartment_number apartment_payments.apartment_number%type
)
IS
    var_amount apartment_payments.amount%type;
    var_apartment_size apartment.apartment_size%type;
    var_warehouse_size warehouse.warehouse_size%type;
    var_warehouse_number apartment.warehouse_number%type;
BEGIN
    var_amount := calculate_tariff(in_apartment_number);
  
    INSERT INTO apartment_payments (payment_due_date, reason, first_name, last_name,
    amount, payment_method, paid_date, apartment_number)
    VALUES(in_payment_due_date, 'Monthly fee',  NULL, NULL, var_amount, NULL,
    NULL, in_apartment_number); 
     
END;


create or replace PROCEDURE add_apartment_general_payment
( 
    in_payment_due_date apartment_payments.payment_due_date%type,
    in_reason apartment_payments.reason%type,
    in_amount apartment_payments.amount%type,
    in_apartment_number apartment_payments.apartment_number%type
)
IS
BEGIN
    INSERT INTO apartment_payments (payment_due_date, reason, first_name, last_name,
    amount, payment_method, paid_date, apartment_number)
    VALUES(in_payment_due_date, in_reason, 
    NULL, NULL, in_amount, NULL, NULL, in_apartment_number);   
END;


create or replace PROCEDURE update_apartment_payment
( 
    in_payment_number apartment_payments.payment_number%type,
    in_payment_due_date apartment_payments.payment_due_date%type,
    in_reason apartment_payments.reason%type,
    in_new_payment_due_date apartment_payments.payment_due_date%type,
    in_new_reason apartment_payments.reason%type,
    in_first_name apartment_payments.first_name%type,
    in_last_name apartment_payments.last_name%type,
    in_amount apartment_payments.amount%type,
    in_payment_method apartment_payments.payment_method%type,
    in_paid_date apartment_payments.paid_date%type,
    in_apartment_number apartment_payments.apartment_number%type
)
IS
BEGIN
    UPDATE apartment_payments
    SET payment_due_date = in_new_payment_due_date, reason = in_new_reason, 
    first_name = in_first_name, last_name = in_last_name, amount = in_amount,
    payment_method = in_payment_method, paid_date = in_paid_date,
    apartment_number = in_apartment_number
    WHERE payment_number = in_payment_number;
END;


-- ##### WAREHOUSE ##### --

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


-- ##### APARTMENT ##### --

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


-- ##### TENANT_APARTMENT ##### --

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


-- ##### TENANT ##### -- 

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


create or replace PROCEDURE update_tenant 
( 
    in_tenant_id tenant.tenant_id%type,
    in_new_tenant_id tenant.tenant_id%type,
    in_first_name tenant.first_name%type,
    in_last_name tenant.last_name%type,
    in_phone_number tenant.phone_number%type,
    in_committee_member tenant.committee_member%type
)
IS
BEGIN
    UPDATE tenant
    SET tenant_id = in_new_tenant_id, first_name = in_first_name, last_name = in_last_name,
    phone_number = in_phone_number, committee_member = in_committee_member
    WHERE tenant_id = in_tenant_id;
END;


create or replace PROCEDURE remove_tenant
( 
    in_tenant_id tenant.tenant_id%type    
)
IS
BEGIN      
    DELETE FROM tenant 
    WHERE tenant_id = in_tenant_id;
    
END;


CREATE OR REPLACE TRIGGER trig_remove_tenant 
BEFORE DELETE ON tenant
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;       
    TYPE t_apart_tenant IS RECORD
    (
        apartment_number tenant_apartment.apartment_number%type,
        start_date tenant_apartment.start_date%type,
        tenant_id tenant.tenant_id%type,
        first_name tenant.first_name%type,
        last_name tenant.last_name%type,
        phone_number tenant.phone_number%type
    );   
    CURSOR cur_tenant_apartment IS SELECT apartment_number, start_date, t.tenant_id, 
    first_name, last_name, phone_number    
    FROM tenant_apartment a, tenant t
    WHERE :OLD.tenant_id = a.tenant_id AND :OLD.tenant_id = t.tenant_id;    
    row_tenant_apartment t_apart_tenant;       
BEGIN
    OPEN cur_tenant_apartment;
    LOOP
    FETCH cur_tenant_apartment INTO row_tenant_apartment;
    EXIT WHEN cur_tenant_apartment%NOTFOUND;
    INSERT INTO apartment_history VALUES(row_tenant_apartment.apartment_number, 
    row_tenant_apartment.start_date, row_tenant_apartment.tenant_id,
    SYSDATE, row_tenant_apartment.first_name, row_tenant_apartment.last_name,
    row_tenant_apartment.phone_number);
    END LOOP;
    CLOSE cur_tenant_apartment;
    COMMIT;
  
END;


--EXECUTE remove_tenant(111111111);


-- ##### WORKS ##### -- 

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


create or replace PROCEDURE update_work 
( 
    in_work_number works.work_number%type,
    in_work_type works.work_type%type,
    in_price works.price%type,
    in_business_number service_provider.business_number%type,
    in_tenant_id tenant.tenant_id%type
)
IS
    var_work_number service_payments.work_number%type;
    work_already_paid EXCEPTION;
BEGIN   
    BEGIN
    SELECT work_number INTO var_work_number 
    FROM service_payments WHERE in_work_number = work_number;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         var_work_number := NULL;
    END;
    
    IF var_work_number IS NULL THEN -- Work is not paid yet. can update
        UPDATE works
        SET work_type = in_work_type, price = in_price, business_number = in_business_number,
        tenant_id = in_tenant_id
        WHERE work_number = in_work_number;
    ELSE   
        RAISE work_already_paid;
    END IF;
    
EXCEPTION
    WHEN work_already_paid THEN
        raise_application_error(-20004, 'Work is already paid. cannot update.'); 
  --  WHEN NO_DATA_FOUND THEN
      --  raise_application_error(-20005, 'Work was not found.');
END;

   
-- ##### SERVICE_PAYMENTS ##### -- 

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


create or replace PROCEDURE update_service_payment 
( 
    in_payment_number service_payments.payment_number%type,
    in_paid_date service_payments.paid_date%type,
    in_amount service_payments.amount%type,
    in_business_number service_payments.business_number%type,
    in_work_number service_payments.work_number%type
)
IS
    var_work_number service_payments.work_number%type;
    var_payment_number service_payments.payment_number%type;
    var_busines_number service_payments.payment_number%type;
BEGIN
    BEGIN
    SELECT work_number INTO var_work_number 
    FROM works WHERE in_work_number = work_number;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'Work was not found.');
    END;
    
    BEGIN
    SELECT payment_number INTO var_payment_number 
    FROM service_payments WHERE in_payment_number = payment_number;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'Payment number was not found.');
    END;
    
    BEGIN
    SELECT business_number INTO var_busines_number 
    FROM service_provider WHERE in_business_number = business_number;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20006, 'Business number was not found.');
    END;

    UPDATE service_payments
    SET paid_date = in_paid_date, amount = in_amount, business_number = in_business_number,
    work_number = in_work_number
    WHERE payment_number = in_payment_number;
END;


-- ##### SERVICE_PROVIDER  ##### -- 

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


-- add exception if not in list 
create or replace PROCEDURE update_service_provider
(    
    in_business_number service_provider.business_number%type,   
    in_provider_name service_provider.provider_name%type,  
    in_address service_provider.address%type, 
    in_phone_number service_provider.phone_number%type
)
IS
BEGIN  
    UPDATE service_provider 
    SET provider_name = in_provider_name, 
    address = in_address, phone_number = in_phone_number 
    WHERE in_business_number = business_number; 
END;

-- add exception if not in list 
create or replace PROCEDURE remove_service_provider
( 
    in_business_number service_provider.business_number%type     
)
IS
BEGIN  
    DELETE FROM service_provider 
    WHERE in_business_number = business_number;
END;

-- ##### ELECTIONS  ##### -- 

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
   
    UPDATE tenant 
    SET committee_member = in_chosen
    WHERE in_tenant_id = tenant_id;
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    raise_application_error (-20002,'You have tried to insert a duplicate tenant.');
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
    
    UPDATE tenant 
    SET committee_member = in_chosen
    WHERE in_tenant_id = tenant_id;
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

