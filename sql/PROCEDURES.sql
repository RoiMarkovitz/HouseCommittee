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
    var_apartment_number apartment_payments.apartment_number%type;
BEGIN      
    BEGIN
    SELECT apartment_number INTO var_apartment_number 
    FROM apartment WHERE apartment_number = in_apartment_number;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'apartment was not found.');
    END;

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
    var_apartment_number apartment_payments.apartment_number%type;
    invalid_amount EXCEPTION;
BEGIN
    IF  in_amount <= 0 THEN
        RAISE invalid_amount;
    END IF;
    
    BEGIN
    SELECT apartment_number INTO var_apartment_number 
    FROM apartment WHERE apartment_number = in_apartment_number;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'apartment was not found.');
    END;

    INSERT INTO apartment_payments (payment_due_date, reason, first_name, last_name,
    amount, payment_method, paid_date, apartment_number)
    VALUES(in_payment_due_date, in_reason, 
    NULL, NULL, in_amount, NULL, NULL, in_apartment_number);
    
EXCEPTION
    WHEN invalid_amount THEN
         raise_application_error(-20005, 'amount must be positive');
END;


create or replace PROCEDURE update_apartment_payment
( 
    in_payment_number apartment_payments.payment_number%type,
    in_payment_due_date apartment_payments.payment_due_date%type,
    in_reason apartment_payments.reason%type, 
    in_first_name apartment_payments.first_name%type,
    in_last_name apartment_payments.last_name%type,
    in_amount apartment_payments.amount%type,
    in_payment_method apartment_payments.payment_method%type,
    in_paid_date apartment_payments.paid_date%type,
    in_apartment_number apartment_payments.apartment_number%type
)
IS
    var_payment_number apartment_payments.payment_number%type;
    var_apartment_number apartment_payments.apartment_number%type;
    wrong_payment_method EXCEPTION;
    invalid_amount EXCEPTION;
BEGIN
    BEGIN
    SELECT payment_number INTO var_payment_number 
    FROM apartment_payments WHERE payment_number = in_payment_number;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'payment was not found.');
    END;
    
    BEGIN
    SELECT apartment_number INTO var_apartment_number 
    FROM apartment WHERE apartment_number = in_apartment_number;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'apartment was not found.');
    END;
    
    IF  in_payment_method not in ('cash', 'credit') THEN
        RAISE wrong_payment_method;
    END IF;
    
    IF  in_amount <= 0 THEN
        RAISE invalid_amount;
    END IF;
    
    UPDATE apartment_payments
    SET payment_due_date = in_payment_due_date, reason = in_reason, 
    first_name = in_first_name, last_name = in_last_name, amount = in_amount,
    payment_method = in_payment_method, paid_date = in_paid_date,
    apartment_number = in_apartment_number
    WHERE payment_number = in_payment_number;
EXCEPTION
    WHEN wrong_payment_method THEN
        raise_application_error(-20005, 'payment method must be cash or credit');
    WHEN invalid_amount THEN
         raise_application_error(-20005, 'amount must be positive');
END;


-- ##### WAREHOUSE ##### --

create or replace PROCEDURE add_warehouse
( 
    in_warehouse_number warehouse.warehouse_number%type,     
    in_warehouse_size warehouse.warehouse_size%type   
)
IS
    invalid_warehouse_number EXCEPTION;
    invalid_warehouse_size EXCEPTION;
BEGIN  
    IF  in_warehouse_number < 1 OR in_warehouse_number > 10 THEN
        RAISE invalid_warehouse_number;
    END IF;
    
    IF  in_warehouse_size <= 0 THEN
        RAISE invalid_warehouse_size;
    END IF;

    INSERT INTO warehouse 
    VALUES(in_warehouse_number, in_warehouse_size); 
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    raise_application_error (-20003,'You have tried to insert a duplicate warehouse.');
    WHEN invalid_warehouse_number THEN
    raise_application_error (-20004,'Warehouse number must be between 1 and 10.');
    WHEN invalid_warehouse_size THEN
    raise_application_error (-20005,'Warehouse size must be above 0.');
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
    var_warehouse_number apartment.warehouse_number%type;
    invalid_apartment_number EXCEPTION;
    invalid_floor EXCEPTION;
    invalid_rooms EXCEPTION;
    invalid_apartment_size EXCEPTION;
BEGIN 
    BEGIN
    IF in_warehouse_number IS NOT NULL THEN
    SELECT warehouse_number INTO var_warehouse_number 
    FROM warehouse WHERE warehouse_number = in_warehouse_number;
    END IF;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'Warehouse was not found.');
    END;

    IF  in_apartment_number < 1 OR in_apartment_number > 13 THEN
        RAISE invalid_apartment_number;
    END IF;
    
    IF  in_floor < 1 OR in_floor > 5 THEN
        RAISE invalid_floor;
    END IF;
    
    IF  in_rooms < 1 THEN
        RAISE invalid_rooms;
    END IF;
    
     IF  in_apartment_size < 1 THEN
        RAISE invalid_apartment_size;
    END IF;

    INSERT INTO apartment 
    VALUES(in_apartment_number, in_floor, in_rooms, in_apartment_size, in_warehouse_number); 
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    raise_application_error (-20003,'You have tried to insert a duplicate apartment.');
    WHEN invalid_apartment_number THEN
    raise_application_error (-20004,'Apartment number must be between 1 and 13.');
    WHEN invalid_floor THEN
    raise_application_error (-20005,'Floor number must be between 1 and 5.');
    WHEN invalid_rooms THEN
    raise_application_error (-20006,'Room number must be above 0.');
    WHEN invalid_apartment_size THEN
    raise_application_error (-20007,'Apartment size must be above 0.');
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
    var_apartment_number apartment.apartment_number%type;
    invalid_committee_member EXCEPTION;
    invalid_tenant_id EXCEPTION;
BEGIN
    IF  in_committee_member not in (0, 1) THEN
        RAISE invalid_committee_member;
    END IF;
    
    IF  in_tenant_id <= 99999999 OR in_tenant_id > 999999999 THEN
        RAISE invalid_tenant_id;
    END IF;
    
    BEGIN
    SELECT apartment_number INTO var_apartment_number 
    FROM apartment WHERE apartment_number = in_apartment_number;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'apartment was not found.');
    END;

    INSERT INTO tenant VALUES(in_tenant_id, in_first_name, in_last_name,
    in_phone_number, in_committee_member);
    
    add_tenant_apartment(in_tenant_id, in_apartment_number, in_start_date);  
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    raise_application_error (-20004,'Tenant already exists.');
    WHEN invalid_committee_member THEN
         raise_application_error(-20008, 'committee member must be 0 or 1'); 
    WHEN invalid_tenant_id THEN
         raise_application_error(-20008, 'tenant id must be 9 digits'); 
    
END;


create or replace PROCEDURE update_tenant 
( 
    in_tenant_id tenant.tenant_id%type,   
    in_first_name tenant.first_name%type,
    in_last_name tenant.last_name%type,
    in_phone_number tenant.phone_number%type,
    in_committee_member tenant.committee_member%type
)
IS
    var_tenant_id tenant.tenant_id%type;
    invalid_committee_member EXCEPTION;   
BEGIN
    IF  in_committee_member not in (0, 1) THEN
        RAISE invalid_committee_member;
    END IF;

    BEGIN
    SELECT tenant_id INTO var_tenant_id 
    FROM tenant WHERE tenant_id = in_tenant_id;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'tenant was not found.');
    END;

    UPDATE tenant
    SET first_name = in_first_name, last_name = in_last_name,
    phone_number = in_phone_number, committee_member = in_committee_member
    WHERE tenant_id = in_tenant_id;
EXCEPTION
    WHEN invalid_committee_member THEN
         raise_application_error(-20008, 'committee member must be 0 or 1');

END;


create or replace PROCEDURE remove_tenant
( 
    in_tenant_id tenant.tenant_id%type  
)
IS
     var_tenant_id tenant.tenant_id%type;
BEGIN  
    BEGIN
    SELECT tenant_id INTO var_tenant_id 
    FROM tenant WHERE tenant_id = in_tenant_id;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'tenant was not found.');
    END;

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
    var_business_number service_provider.business_number%type;
    var_tenant_id tenant.tenant_id%type;
    invalid_price EXCEPTION;
BEGIN
    IF  in_price <= 0 THEN
        RAISE invalid_price;
     END IF;

    BEGIN
    SELECT business_number INTO var_business_number 
    FROM service_provider WHERE business_number = in_business_number;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'Business was not found.');
    END;
    
    BEGIN
    SELECT tenant_id INTO var_tenant_id 
    FROM tenant WHERE tenant_id = in_tenant_id;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'tenant was not found.');
    END;

    INSERT INTO works (work_type, price, business_number, tenant_id) 
    VALUES(in_work_type, in_price,in_business_number, in_tenant_id);
EXCEPTION
    WHEN invalid_price THEN 
        raise_application_error(-20005, 'Price must be above 0.');
       
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
    var_business_number service_provider.business_number%type;
    var_tenant_id tenant.tenant_id%type;
    work_already_paid EXCEPTION;
    invalid_price EXCEPTION;
BEGIN 
    IF  in_price <= 0 THEN
        RAISE invalid_price;
    END IF;

    BEGIN
    SELECT tenant_id INTO var_tenant_id 
    FROM tenant WHERE tenant_id = in_tenant_id;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'tenant was not found.');
    END;
    
    BEGIN
    SELECT business_number INTO var_business_number 
    FROM service_provider WHERE business_number = in_business_number;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'Business was not found.');
    END;

    BEGIN
    SELECT work_number INTO var_work_number 
    FROM works WHERE in_work_number = work_number;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        raise_application_error(-20005, 'Work was not found.');
    END;

    BEGIN
    SELECT work_number INTO var_work_number 
    FROM service_payments WHERE in_work_number = work_number;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         var_work_number := NULL;
    END;
      
    IF var_work_number IS NULL THEN -- Work is not paid yet. update work allowed
        UPDATE works
        SET work_type = in_work_type, price = in_price, business_number = in_business_number,
        tenant_id = in_tenant_id
        WHERE work_number = in_work_number;
    ELSE   
        RAISE work_already_paid;
    END IF;
    
EXCEPTION
    WHEN work_already_paid THEN -- Work is already paid, update work is not allowed.
        raise_application_error(-20004, 'Work is already paid. cannot update.'); 
    WHEN invalid_price THEN 
        raise_application_error(-20005, 'Price must be above 0.');
   
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
    var_work_number service_payments.work_number%type;
BEGIN
    BEGIN
    SELECT work_number INTO var_work_number 
    FROM works WHERE in_work_number = work_number;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'Work was not found.');
    END;
 
    SELECT price, business_number INTO var_amount, var_business_number 
    FROM works 
    WHERE in_work_number = work_number;
    
    INSERT INTO service_payments (paid_date, amount, business_number, work_number) 
    VALUES(in_paid_date, var_amount, var_business_number, in_work_number);
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    raise_application_error (-20004,'Work already paid.');     

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
    invalid_amount EXCEPTION;
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
    
    IF  in_amount <= 0 THEN
        RAISE invalid_amount;
    END IF;
    
    UPDATE service_payments
    SET paid_date = in_paid_date, amount = in_amount, business_number = in_business_number,
    work_number = in_work_number
    WHERE payment_number = in_payment_number;
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    raise_application_error (-20004,'Work number already exists.'); 
    WHEN invalid_amount THEN
         raise_application_error(-20007, 'amount must be above 0.');
    
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
    invalid_business_number EXCEPTION;
BEGIN  
    IF  in_business_number <= 99999999 OR in_business_number > 999999999 THEN
        RAISE invalid_business_number;
    END IF;

    INSERT INTO service_provider 
    VALUES(in_business_number, in_provider_name, in_address, in_phone_number); 
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    raise_application_error (-20004,'You have tried to insert a duplicate service provider number.');
    WHEN invalid_business_number THEN
         raise_application_error(-20008, 'business number must be 9 digits');
END;

 
create or replace PROCEDURE update_service_provider
(    
    in_business_number service_provider.business_number%type,   
    in_provider_name service_provider.provider_name%type,  
    in_address service_provider.address%type, 
    in_phone_number service_provider.phone_number%type
)
IS
    var_business_number service_provider.business_number%type;
BEGIN 
    SELECT business_number INTO var_business_number
    FROM service_provider
    WHERE in_business_number = business_number; 

    UPDATE service_provider 
    SET provider_name = in_provider_name, 
    address = in_address, phone_number = in_phone_number 
    WHERE in_business_number = business_number; 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    raise_application_error (-20005,'This service provider does not exist.');     
END;

 
create or replace PROCEDURE remove_service_provider
( 
    in_business_number service_provider.business_number%type     
)
IS
    var_business_number service_provider.business_number%type;   
BEGIN 
    SELECT business_number INTO var_business_number
    FROM service_provider
    WHERE in_business_number = business_number;

    DELETE FROM service_provider 
    WHERE in_business_number = business_number;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    raise_application_error (-20005,'This service provider does not exist.');
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
    var_tenant_id elections.tenant_id%type;
    invalid_votes EXCEPTION;
    invalid_chosen EXCEPTION;
    invalid_tenant_id EXCEPTION;
BEGIN 
    IF  in_tenant_id <= 99999999 OR in_tenant_id > 999999999 THEN
        RAISE invalid_tenant_id;
    END IF;

    IF  in_votes < 0 THEN
        RAISE invalid_votes;
    END IF;
    
    IF  in_chosen not in (0, 1) THEN
        RAISE invalid_chosen;
    END IF;
    
    BEGIN
    SELECT tenant_id INTO var_tenant_id 
    FROM tenant WHERE tenant_id = in_tenant_id;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'tenant was not found.');
    END;

    INSERT INTO elections 
    VALUES(in_election_date, in_tenant_id, in_votes, in_chosen);
   
    UPDATE tenant 
    SET committee_member = in_chosen
    WHERE in_tenant_id = tenant_id;
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    raise_application_error (-20002,'You have tried to insert a duplicate tenant.');
    WHEN invalid_votes THEN
         raise_application_error(-20007, 'votes cant be below 0');
    WHEN invalid_chosen THEN
         raise_application_error(-20008, 'chosen must be 0 or 1');
    WHEN invalid_tenant_id THEN
         raise_application_error(-20008, 'tenant id must be 9 digits');
END;


create or replace PROCEDURE update_from_elections
(    
    in_election_date elections.election_date%type,     
    in_tenant_id elections.tenant_id%type, 
    in_votes elections.votes%type,
    in_chosen elections.chosen%type
)
IS
    var_election_date elections.election_date%type;
    var_tenant_id elections.tenant_id%type;
    invalid_votes EXCEPTION;
    invalid_chosen EXCEPTION;
BEGIN  
    SELECT election_date, tenant_id INTO var_election_date, var_tenant_id
    FROM elections 
    WHERE in_election_date = election_date AND in_tenant_id = tenant_id;
  
    IF  in_votes < 0 THEN
        RAISE invalid_votes;
    END IF;
    
    IF  in_chosen not in (0, 1) THEN
        RAISE invalid_chosen;
    END IF;
    
    UPDATE elections 
    SET votes = in_votes, chosen = in_chosen
    WHERE in_election_date = election_date AND in_tenant_id = tenant_id;
    
    UPDATE tenant 
    SET committee_member = in_chosen
    WHERE in_tenant_id = tenant_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         raise_application_error(-20006,'This nominee does not exist.');    
    WHEN invalid_votes THEN
         raise_application_error(-20007, 'votes cant be below 0');
    WHEN invalid_chosen THEN
         raise_application_error(-20008, 'chosen must be 0 or 1');
END;


create or replace PROCEDURE remove_from_elections
( 
    in_election_date elections.election_date%type,     
    in_tenant_id elections.tenant_id%type  
)
IS
    var_election_date elections.election_date%type;
    var_tenant_id elections.tenant_id%type;
BEGIN 
    SELECT election_date, tenant_id INTO var_election_date, var_tenant_id
    FROM elections 
    WHERE in_election_date = election_date AND in_tenant_id = tenant_id;

    DELETE FROM elections 
    WHERE in_election_date = election_date AND in_tenant_id = tenant_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    raise_application_error (-20005,'This nominee does not exist.');
    
END;

