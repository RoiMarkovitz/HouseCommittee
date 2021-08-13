--- $$$$$ FUNCTIONS $$$$$ ---
-- All functions to retrieve information to the GUI.



-- ##### GENERAL ##### --

create or replace TYPE balance_array AS VARRAY(3) OF NUMBER(38,2); 

create or replace FUNCTION calculate_balance 
RETURN balance_array
IS
    balance_details balance_array :=  balance_array();
    var_income NUMBER(38,2);
    var_expenses NUMBER(38,2);
    var_balance NUMBER(38,2);    
BEGIN
    SELECT SUM(amount) INTO var_income FROM apartment_payments WHERE paid_date IS NOT NULL;
    SELECT SUM(amount) INTO var_expenses FROM service_payments WHERE paid_date IS NOT NULL;
    var_balance := var_income - var_expenses;
    balance_details.extend(3);
    balance_details(1) := var_income;
    balance_details(2) := var_expenses;
    balance_details(3) := var_balance;
    RETURN balance_details;   
END;

--select calculate_balance() from dual;
--select * from table(calculate_balance());

-- ##### APARTMENT_PAYMENTS ##### --

create or replace FUNCTION calculate_tariff
(
    in_apartment_number apartment_payments.apartment_number%type
)
RETURN NUMBER
IS
    var_tariff NUMBER(9,2); 
    var_apartment_size apartment.apartment_size%type;
    var_warehouse_size warehouse.warehouse_size%type;
    var_warehouse_number apartment.warehouse_number%type;
BEGIN
    SELECT warehouse_number, apartment_size INTO var_warehouse_number, var_apartment_size 
    FROM apartment WHERE apartment_number = in_apartment_number;
    IF var_warehouse_number IS NULL THEN
        var_tariff := 5 * var_apartment_size;
    ELSE 
        SELECT warehouse_size INTO var_warehouse_size
        FROM apartment a, warehouse w
        WHERE a.warehouse_number = w.warehouse_number AND in_apartment_number = a.apartment_number;
        var_tariff := 5 * (var_apartment_size + var_warehouse_size); 
    END IF;
    RETURN var_tariff;   
END;


create or replace TYPE apart_payments_obj_type AS OBJECT
    (
        payment_number NUMBER(38,0),
        payment_due_date DATE,
        reason VARCHAR(20),
        first_name VARCHAR(30),
        last_name VARCHAR(30),
        amount NUMBER(9,2),
        payment_method VARCHAR(20),
        paid_date DATE,
        apartment_number NUMBER(2,0)
    );

create or replace TYPE apart_payments_tbl_type IS TABLE OF apart_payments_obj_type;
 
create or replace FUNCTION get_receipt_details 
(
    in_payment_number apartment_payments.payment_number%type   
)
RETURN apart_payments_tbl_type
IS      
    apart_payment_details apart_payments_tbl_type := apart_payments_tbl_type();
    
    var_payment_due_date apartment_payments.payment_due_date%type;
    var_reason apartment_payments.reason%type;
    var_first_name apartment_payments.first_name%type;
    var_last_name apartment_payments.last_name%type;
    var_amount apartment_payments.amount%type;   
    var_payment_method apartment_payments.payment_method%type;  
    var_paid_date apartment_payments.paid_date%type;
    var_apartment_number apartment_payments.apartment_number%type;
    var_payment_number apartment_payments.payment_number%type;  
    not_paid EXCEPTION;
BEGIN  
    BEGIN
    SELECT payment_number INTO var_payment_number 
    FROM apartment_payments WHERE payment_number = in_payment_number;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         raise_application_error(-20005, 'payment was not found.');
    END;

    SELECT payment_method, paid_date
    INTO var_payment_method, var_paid_date
    FROM apartment_payments 
    WHERE payment_number = in_payment_number;
    
    IF (var_paid_date IS NULL OR var_payment_method IS NULL) THEN
        RAISE not_paid;
    ELSE    
        apart_payment_details.extend();
        
        SELECT payment_due_date, reason, first_name, last_name, amount, 
        payment_method, paid_date, apartment_number
        INTO var_payment_due_date, var_reason, var_first_name, var_last_name, 
        var_amount, var_payment_method, var_paid_date, var_apartment_number     
        FROM apartment_payments 
        WHERE payment_number = in_payment_number;
        
        apart_payment_details(1) := apart_payments_obj_type(in_payment_number,
        var_payment_due_date, var_reason, var_first_name, var_last_name, var_amount,
         var_payment_method,   var_paid_date, var_apartment_number); 
           
        RETURN apart_payment_details;
    END IF;
EXCEPTION
    WHEN not_paid THEN
        raise_application_error(-20001, 'Payment is not paid yet. 
        cannot retrieve details.');
END;

--SELECT get_receipt_details(1) from dual;
--select * from table(get_receipt_details(1));
--select * from apartment_payments;

create or replace FUNCTION get_all_apartment_payments
RETURN apart_payments_tbl_type
IS
    apart_payment_details apart_payments_tbl_type := apart_payments_tbl_type();    
    CURSOR cur_ap_payment IS SELECT * from apartment_payments;   
    row_ap_payment apartment_payments%rowtype;  
    var_counter PLS_INTEGER := 0;
BEGIN                                
    OPEN cur_ap_payment;
    LOOP
        var_counter := var_counter + 1;
        FETCH cur_ap_payment INTO row_ap_payment;
        EXIT WHEN cur_ap_payment%NOTFOUND;
        apart_payment_details.extend();
        apart_payment_details(var_counter) := apart_payments_obj_type
        (row_ap_payment.payment_number, row_ap_payment.payment_due_date, row_ap_payment.reason,
        row_ap_payment.first_name, row_ap_payment.last_name, row_ap_payment.amount,
        row_ap_payment.payment_method, row_ap_payment.paid_date, row_ap_payment.apartment_number);
                             
    END LOOP;
    CLOSE cur_ap_payment;
    RETURN apart_payment_details;
END;

--select get_all_apartment_payments() from dual;
--select * from table(get_all_apartment_payments());
--select * from apartment_payments;


create or replace FUNCTION get_apartments_owes_by_apartment_range
(
    in_apartment_min_range apartment_payments.apartment_number%type,
    in_apartment_max_range apartment_payments.apartment_number%type
)
RETURN apart_payments_tbl_type
IS
    apart_payment_details apart_payments_tbl_type := apart_payments_tbl_type();    
    CURSOR cur_ap_payment IS SELECT * FROM apartment_payments 
    WHERE apartment_number BETWEEN in_apartment_min_range AND in_apartment_max_range 
    AND paid_date IS NULL;   
    row_ap_payment apartment_payments%rowtype;  
    var_counter PLS_INTEGER := 0;
    invalid_range EXCEPTION;
BEGIN 
    IF  in_apartment_min_range > in_apartment_max_range 
    OR  (in_apartment_max_range > 13 OR in_apartment_max_range < 1)
    OR  (in_apartment_min_range > 13 OR in_apartment_min_range < 1)
    THEN
        RAISE invalid_range;
    END IF;
    
    OPEN cur_ap_payment;
    LOOP
        var_counter := var_counter + 1;
        FETCH cur_ap_payment INTO row_ap_payment;
        EXIT WHEN cur_ap_payment%NOTFOUND;
        apart_payment_details.extend();
        apart_payment_details(var_counter) := apart_payments_obj_type
        (row_ap_payment.payment_number, row_ap_payment.payment_due_date, row_ap_payment.reason,
        row_ap_payment.first_name, row_ap_payment.last_name, row_ap_payment.amount,
        row_ap_payment.payment_method, row_ap_payment.paid_date, row_ap_payment.apartment_number);
                             
    END LOOP;
    CLOSE cur_ap_payment;
    RETURN apart_payment_details;
    
EXCEPTION
    WHEN invalid_range THEN
    raise_application_error (-20004,'Apartment range must be between 1 and 13. Min range no more than max range');
   
END;


--select * from table(get_apartments_owes_by_apartment_range(1, 5));
--select * from apartment_payments;


create or replace FUNCTION get_apartments_owes_by_date_range
(
    in_apartment_min_range DATE,
    in_apartment_max_range DATE
)
RETURN apart_payments_tbl_type
IS 
    apart_payment_details apart_payments_tbl_type := apart_payments_tbl_type();    
    CURSOR cur_ap_payment IS SELECT * FROM apartment_payments 
    WHERE payment_due_date BETWEEN in_apartment_min_range AND in_apartment_max_range 
    AND paid_date IS NULL;   
    row_ap_payment apartment_payments%rowtype;  
    var_counter PLS_INTEGER := 0;
    invalid_range EXCEPTION;
BEGIN 
    IF  in_apartment_min_range > in_apartment_max_range   
    THEN
        RAISE invalid_range;
    END IF;

    OPEN cur_ap_payment;
    LOOP
        var_counter := var_counter + 1;
        FETCH cur_ap_payment INTO row_ap_payment;
        EXIT WHEN cur_ap_payment%NOTFOUND;
        apart_payment_details.extend();
        apart_payment_details(var_counter) := apart_payments_obj_type
        (row_ap_payment.payment_number, row_ap_payment.payment_due_date, row_ap_payment.reason,
        row_ap_payment.first_name, row_ap_payment.last_name, row_ap_payment.amount,
        row_ap_payment.payment_method, row_ap_payment.paid_date, row_ap_payment.apartment_number);
                             
    END LOOP;
    CLOSE cur_ap_payment;
    RETURN apart_payment_details;

EXCEPTION
    WHEN invalid_range THEN
    raise_application_error (-20004,'Max date must be higher than min date.');   
    
END;


--select * from table(get_apartments_owes_by_date_range
--(TO_DATE('10/01/2015', 'DD/MM/YYYY'), TO_DATE('20/07/2015', 'DD/MM/YYYY')));

--select * from table(get_apartments_owes_by_date_range
--(TO_DATE('20/07/2015', 'DD/MM/YYYY'), TO_DATE('10/01/2015', 'DD/MM/YYYY') ));

-- ##### APARTMENT_HISTORY ##### --


create or replace TYPE apart_hist_obj_type AS OBJECT
    (
        apartment_number NUMBER(2,0),
        start_date DATE,
        tenant_id NUMBER(9,0),
        end_date DATE,
        first_name VARCHAR(30),
        last_name VARCHAR(30),
        phone_number VARCHAR(15)
    );

create or replace TYPE apart_hist_tbl_type IS TABLE OF apart_hist_obj_type;


create or replace FUNCTION get_all_apartment_history
RETURN apart_hist_tbl_type
IS
    apart_hist_details apart_hist_tbl_type := apart_hist_tbl_type();    
    CURSOR cur_ap_h IS SELECT * from apartment_history;   
    row_ap_h apartment_history%rowtype;  
    var_counter PLS_INTEGER := 0;
BEGIN                                
    OPEN cur_ap_h;
    LOOP
        var_counter := var_counter + 1;
        FETCH cur_ap_h INTO row_ap_h;
        EXIT WHEN cur_ap_h%NOTFOUND;
        apart_hist_details.extend();
        apart_hist_details(var_counter) := apart_hist_obj_type(row_ap_h.apartment_number,
        row_ap_h.start_date, row_ap_h.tenant_id, row_ap_h.end_date, row_ap_h.first_name,
        row_ap_h.last_name, row_ap_h.phone_number);
        
    END LOOP;
    CLOSE cur_ap_h;
    RETURN apart_hist_details;
END;

--select get_all_apartment_history() from dual;
--select * from table(get_all_apartment_history());


-- ##### APARTMENT + WAREHOUSE + TARIFF ##### --

create or replace TYPE apartment_obj_type AS OBJECT
    (
        apartment_number NUMBER(2,0),
        floor NUMBER(1,0),
        rooms NUMBER(1,0),
        apartment_size NUMBER(5,2),
        warehouse_number NUMBER(2,0),
        warehouse_size NUMBER(4,2),
        tariff NUMBER(9,2)
    );

create or replace TYPE apartments_tbl_type IS TABLE OF apartment_obj_type;


create or replace view view_all_apartment
as
SELECT a.apartment_number, floor, rooms, apartment_size, warehouse_number, 
(SELECT warehouse_size FROM warehouse w WHERE a.warehouse_number = w.warehouse_number) as warehouse_size,
(SELECT calculate_tariff(a.apartment_number) FROM dual) as tariff      
FROM apartment a; 


create or replace FUNCTION get_all_apartment
RETURN apartments_tbl_type
IS
    TYPE t_apartment IS RECORD
    (
        apartment_number apartment.apartment_number%type,
        floor apartment.floor%type,
        rooms apartment.rooms%type,
        apartment_size apartment.apartment_size%type,
        warehouse_number apartment.warehouse_number%type,
        warehouse_size warehouse.warehouse_size%type,
        tariff NUMBER(9,2)
    );
    apartment_details apartments_tbl_type := apartments_tbl_type();    
    CURSOR cur_apartments IS SELECT * FROM view_all_apartment;
    row_apartments t_apartment;  
    var_counter PLS_INTEGER := 0;
BEGIN                                
    OPEN cur_apartments;
    LOOP
        var_counter := var_counter + 1;
        FETCH cur_apartments INTO row_apartments;
        EXIT WHEN cur_apartments%NOTFOUND;
        apartment_details.extend();
        apartment_details(var_counter) := apartment_obj_type
        (row_apartments.apartment_number, row_apartments.floor,
        row_apartments.rooms, row_apartments.apartment_size, row_apartments.warehouse_number,
        row_apartments.warehouse_size, row_apartments.tariff);
                             
    END LOOP;
    CLOSE cur_apartments;
    RETURN apartment_details;
END;

--select get_all_apartment() from dual;
--select * from table(get_all_apartment());


-- ##### TENANT + TENANT_APARTMENT ##### -- 

create or replace TYPE tenant_obj_type AS OBJECT
    (
        tenant_id NUMBER(9,0),
        first_name VARCHAR(30),
        last_name VARCHAR(30),
        phone_number VARCHAR(15),
        committee_member VARCHAR(30),
        apartment_number NUMBER(2,0),
        start_date DATE
    );

create or replace TYPE tenant_tbl_type IS TABLE OF tenant_obj_type;


create or replace view view_all_tenants
as
SELECT t.tenant_id, first_name, last_name, phone_number, 
DECODE (committee_member, '1', 'yes', 'no') as committee_member, a.apartment_number, a.start_date 
FROM tenant t, tenant_apartment a
WHERE t.tenant_id = a.tenant_id;

  
create or replace FUNCTION get_all_tenants
RETURN tenant_tbl_type
IS
    TYPE t_tenants IS RECORD
    (
        tenant_id tenant.tenant_id%type,
        first_name tenant.first_name%type,
        last_name tenant.last_name%type,
        phone_number tenant.phone_number%type,
        committee_member VARCHAR(30),
        apartment_number tenant_apartment.apartment_number%type,
        start_date tenant_apartment.start_date%type
    );
    
    tenant_details tenant_tbl_type := tenant_tbl_type();    
    CURSOR cur_tenants IS SELECT * FROM view_all_tenants;
    row_tenants t_tenants;  
    var_counter PLS_INTEGER := 0;
BEGIN                                
    OPEN cur_tenants;
    LOOP
        var_counter := var_counter + 1;
        FETCH cur_tenants INTO row_tenants;
        EXIT WHEN cur_tenants%NOTFOUND;
        tenant_details.extend();
        tenant_details(var_counter) := tenant_obj_type
        (row_tenants.tenant_id, row_tenants.first_name,
        row_tenants.last_name, row_tenants.phone_number, row_tenants.committee_member,
        row_tenants.apartment_number, row_tenants.start_date);
                             
    END LOOP;
    CLOSE cur_tenants;
    RETURN tenant_details;
END;

--select get_all_tenants() from dual;
--select * from table(get_all_tenants());


-- ##### WORKS ##### -- 

create or replace TYPE works_obj_type AS OBJECT
    (
        work_number NUMBER(38,0),
        work_type VARCHAR(30),
        price NUMBER(9,2),
        business_number NUMBER(9,0),
        tenant_id NUMBER(9,0)
    );

create or replace TYPE works_tbl_type IS TABLE OF works_obj_type;


create or replace FUNCTION get_all_works
RETURN works_tbl_type
IS
    work_details works_tbl_type := works_tbl_type();    
    CURSOR cur_works IS SELECT * from works;   
    row_work works%rowtype;  
    var_counter PLS_INTEGER := 0;
BEGIN                                
    OPEN cur_works;
    LOOP
        var_counter := var_counter + 1;
        FETCH cur_works INTO row_work;
        EXIT WHEN cur_works%NOTFOUND;
        work_details.extend();
        work_details(var_counter) := works_obj_type(row_work.work_number,
        row_work.work_type, row_work.price, row_work.business_number,
        row_work.tenant_id);                             
    END LOOP;
    CLOSE cur_works;
    RETURN work_details;
END;

--select get_all_works() from dual;
--select * from table(get_all_works());


-- ##### SERVICE_PAYMENTS ##### -- 

create or replace TYPE service_payments_obj_type AS OBJECT
    (
        payment_number NUMBER(38,0),
        paid_date DATE,
        amount NUMBER(9,2),
        business_number NUMBER(9,0),
        work_number NUMBER(38,0)
    );

create or replace TYPE service_payments_tbl_type IS TABLE OF service_payments_obj_type;

create or replace FUNCTION get_all_service_payments_ascend
RETURN service_payments_tbl_type
IS
    payment_details service_payments_tbl_type := service_payments_tbl_type();    
    CURSOR cur_payments IS SELECT * from service_payments;   
    row_payments service_payments%rowtype;  
    var_counter PLS_INTEGER := 0;
BEGIN                                
    OPEN cur_payments;
    LOOP
        var_counter := var_counter + 1;
        FETCH cur_payments INTO row_payments;
        EXIT WHEN cur_payments%NOTFOUND;
        payment_details.extend();
        payment_details(var_counter) := service_payments_obj_type(row_payments.payment_number,
        row_payments.paid_date, row_payments.amount, row_payments.business_number,
        row_payments.work_number);                             
    END LOOP;
    CLOSE cur_payments;
    RETURN payment_details;
      
END;

--select get_all_service_payments_ascend() from dual;
--select * from table(get_all_service_payments_ascend());

create or replace FUNCTION get_all_service_payments_desc
RETURN service_payments_tbl_type
IS
    payment_details service_payments_tbl_type := service_payments_tbl_type();    
    CURSOR cur_payments IS SELECT * from service_payments ORDER BY payment_number DESC;   
    row_payments service_payments%rowtype;  
    var_counter PLS_INTEGER := 0;
BEGIN                                
    OPEN cur_payments;
    LOOP
        var_counter := var_counter + 1;
        FETCH cur_payments INTO row_payments;
        EXIT WHEN cur_payments%NOTFOUND;
        payment_details.extend();
        payment_details(var_counter) := service_payments_obj_type(row_payments.payment_number,
        row_payments.paid_date, row_payments.amount, row_payments.business_number,
        row_payments.work_number);                             
    END LOOP;
    CLOSE cur_payments;
    RETURN payment_details;
END;

--select get_all_service_payments_desc() from dual;
--select * from table(get_all_service_payments_desc());


-- ##### SERVICE_PROVIDER  ##### -- 

create or replace TYPE providers_obj_type AS OBJECT
    (
        business_number NUMBER(9,0),
        provider_name VARCHAR(30),
        address VARCHAR(40),
        phone_number VARCHAR(15)
    );

create or replace TYPE providers_tbl_type IS TABLE OF providers_obj_type;


create or replace FUNCTION get_all_providers
RETURN providers_tbl_type
IS
    providers_details providers_tbl_type := providers_tbl_type();    
    CURSOR cur_providers IS SELECT * from service_provider;   
    row_provider service_provider%rowtype;  
    var_counter PLS_INTEGER := 0;
BEGIN                                
    OPEN cur_providers;
    LOOP
        var_counter := var_counter + 1;
        FETCH cur_providers INTO row_provider;
        EXIT WHEN cur_providers%NOTFOUND;
        providers_details.extend();
        providers_details(var_counter) := providers_obj_type(row_provider.business_number,
        row_provider.provider_name, row_provider.address, row_provider.phone_number);                             
    END LOOP;
    CLOSE cur_providers;
    RETURN providers_details;
END;

--select get_all_providers() from dual;
select * from table(get_all_providers());

-- ##### ELECTIONS  ##### --

create or replace TYPE elections_obj_type AS OBJECT
    (
        election_date DATE,
        tenant_id NUMBER(9,0),
        votes NUMBER(3,0),
        s_chosen VARCHAR(20)     
    );

create or replace TYPE elections_tbl_type IS TABLE OF elections_obj_type;


create or replace FUNCTION get_all_elections
RETURN elections_tbl_type
IS
    TYPE t_elections IS RECORD
    (
        election_date elections.election_date%type,
        tenant_id elections.tenant_id%type,
        votes elections.votes%type,
        s_chosen VARCHAR(20)
    );

    election_details elections_tbl_type := elections_tbl_type();    
    CURSOR cur_election IS SELECT election_date, tenant_id, votes, 
    DECODE(chosen, '1', 'elected', 'not elected') as chosen
    FROM elections;   
    row_election t_elections;  
    var_counter PLS_INTEGER := 0;
BEGIN                                
    OPEN cur_election;
    LOOP
        var_counter := var_counter + 1;
        FETCH cur_election INTO row_election;
        EXIT WHEN cur_election%NOTFOUND;
        election_details.extend();
        election_details(var_counter) := elections_obj_type(row_election.election_date,
        row_election.tenant_id, row_election.votes, row_election.s_chosen);
                               
    END LOOP;
    CLOSE cur_election;
    RETURN election_details;
END;

--select get_all_elections() from dual;
--select * from table(get_all_elections());

