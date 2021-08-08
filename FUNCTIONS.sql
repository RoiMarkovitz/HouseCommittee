-- Return an array with all details
create or replace FUNCTION get_receipt_details 
(
    in_payment_due_date apartment_payments.payment_due_date%type,
    in_reason apartment_payments.reason%type
)
RETURN apartment_payments.first_name%type
IS
    var_first_name apartment_payments.first_name%type;
    var_last_name apartment_payments.last_name%type;
    var_amount apartment_payments.amount%type;
    var_payment_method apartment_payments.payment_method%type;
    var_paid_date apartment_payments.paid_date%type;
    var_apartment_number apartment_payments.apartment_number%type;
    not_paid EXCEPTION;
BEGIN  
    SELECT first_name, last_name, amount, payment_method, paid_date, apartment_number
    INTO var_first_name, var_last_name, var_amount, var_payment_method, var_paid_date,
    var_apartment_number
    FROM apartment_payments 
    WHERE payment_due_date = in_payment_due_date AND reason = in_reason;
      
    IF (var_paid_date IS NULL OR var_payment_method IS NULL) THEN
        RAISE not_paid;
    ELSE           
        RETURN var_first_name;
    END IF;
EXCEPTION
    WHEN not_paid THEN
        raise_application_error(-20001, 'Payment is not paid yet. 
        cannot retrieve details.');
END;

--SELECT get_receipt_details(TO_DATE('20/10/2015', 'DD/MM/YYYY'), 'Damage') from dual;
--SELECT get_receipt_details(TO_DATE('20/10/2015', 'DD/MM/YYYY'), 'Monthly fee') from dual;
--select * from apartment_payments;