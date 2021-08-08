-- Inserting initial values to the tables

EXECUTE add_warehouse(1, 12.5);
EXECUTE add_warehouse(2, 10);
EXECUTE add_warehouse(3, 4); 
EXECUTE add_warehouse(4, 5.5); 
EXECUTE add_warehouse(5, 5);  
EXECUTE add_warehouse(6, 6.5); 
EXECUTE add_warehouse(7, 7.5); 
EXECUTE add_warehouse(8, 9);
EXECUTE add_warehouse(9, 4.5); 
EXECUTE add_warehouse(10, 5); 


EXECUTE add_apartment(1, 1, 3, 80, NULL);
EXECUTE add_apartment(2, 1, 4, 100, 10);
EXECUTE add_apartment(3, 1, 5, 120, 6);
EXECUTE add_apartment(4, 2, 3, 80, NULL);
EXECUTE add_apartment(5, 2, 4, 100, 5);
EXECUTE add_apartment(6, 2, 5, 120, 4);
EXECUTE add_apartment(7, 3, 3, 80, 3);
EXECUTE add_apartment(8, 3, 4, 100, 9);
EXECUTE add_apartment(9, 3, 5, 120, 2);
EXECUTE add_apartment(10, 4, 3, 80, NULL);
EXECUTE add_apartment(11, 4, 4, 100, 7);
EXECUTE add_apartment(12, 4, 5, 120, 8);
EXECUTE add_apartment(13, 5, 6, 250, 1);

  
EXECUTE add_tenant(111111111, 'Steven', 'King', '515.123.4567', 1, 13, '01/JAN/2010');
EXECUTE add_tenant_apartment(111111111, 1, '05/JAN/2010');
EXECUTE add_tenant(222222222, 'Neena', 'Kochhar', '515.123.4568', 0, 2, '07/FEB/2010');
EXECUTE add_tenant(333333333, 'Alexander', 'Hunold', '590.423.4567', 0, 2, '07/FEB/2010'); 
EXECUTE add_tenant(444444444, 'Bruce', 'Ernst', '590.423.4568', 0, 3, '15/FEB/2010');
EXECUTE add_tenant(555555555, 'David', 'Austin', '590.423.4569', 0, 3, '15/FEB/2010');
EXECUTE add_tenant(666666666, 'Diana', 'Lorentz', '590.423.5567', 0, 4, '18/MAR/2010');
EXECUTE add_tenant(777777777, 'Nancy', 'Greenberg', '515.124.4569', 0, 5, '15/JAN/2010');
EXECUTE add_tenant(888888888, 'Daniel', 'Faviet', '515.124.4169', 0, 5, '15/JAN/2010');
EXECUTE add_tenant(999999999, 'John', 'Chen', '515.124.4269', 0, 5, '20/MAR/2010');
EXECUTE add_tenant(111222222, 'Ismael', 'Sciarra', '515.124.4369', 0, 6, '12/MAR/2010');
EXECUTE add_tenant(111333333, 'Shelli', 'Baida', '515.127.4563', 0, 7, '22/MAR/2010');
EXECUTE add_tenant(111444444, 'Sigal', 'Tobias', '515.127.4564', 0, 8, '12/JAN/2010');
EXECUTE add_tenant(111555555, 'Guy', 'Himuro', '515.127.4565', 0, 9, '07/APR/2010');
EXECUTE add_tenant(111666666, 'Adam', 'Fripp', '650.123.2234', 0, 9, '07/APR/2010');
EXECUTE add_tenant(111777777, 'Kevin', 'Mourqos', '650.123.5234', 0, 10, '03/MAR/2010');
EXECUTE add_tenant(111888888, 'James', 'Landrv', '650.124.1334', 0, 11, '23/MAR/2010');
EXECUTE add_tenant(111999999, 'Jason', 'Mallin', '650.127.1934', 0, 11, '23/MAR/2010');
EXECUTE add_tenant(222111111, 'Ki', 'Gee', '650.127.1734', 0, 12, '20/JAN/2010');
EXECUTE add_tenant(222333333, 'Amit', 'Banda', '750.124.1731', 0, 12, '20/JAN/2010');
EXECUTE add_tenant(222344444, 'Winston', 'Tavlor', '750.124.1738', 0, 12, '28/JAN/2010');


-- should be kept. initial values for data
INSERT INTO apartment_history (apartment_number, start_date, tenant_id, end_date, 
first_name, last_name, phone_number)    
VALUES (2, '20/FEB/2015', 555666777, '20/FEB/2018',  'Nandita', 'Sarchand', '650.509.1876');
INSERT INTO apartment_history (apartment_number, start_date, tenant_id, end_date, 
first_name, last_name, phone_number)    
VALUES (6, '10/MAY/2012', 555666888, '20/MAR/2020',  'Alexis', 'Bull', '650.509.2876');
INSERT INTO apartment_history (apartment_number, start_date, tenant_id, end_date, 
first_name, last_name, phone_number)    
VALUES (3, '10/JUN/2012', 555666999, '10/JUN/2014',  'Kelly', 'Chung', '650.505.1876');
INSERT INTO apartment_history (apartment_number, start_date, tenant_id, end_date, 
first_name, last_name, phone_number)    
VALUES (3, '11/JUN/2014', 555666111, '11/JUN/2020',  'Kevin', 'Feenev', '650.507.9822');
INSERT INTO apartment_history (apartment_number, start_date, tenant_id, end_date, 
first_name, last_name, phone_number)    
VALUES (10, '15/DEC/2013', 555123111, '11/JUN/2017',  'Pat', 'Fav', '603.123.6666');
INSERT INTO apartment_history (apartment_number, start_date, tenant_id, end_date, 
first_name, last_name, phone_number)    
VALUES (9, '18/JAN/2014', 321666111, '28/AUG/2020',  'Donald', 'Cohen', '650.507.9819');
INSERT INTO apartment_history (apartment_number, start_date, tenant_id, end_date, 
first_name, last_name, phone_number)    
VALUES (4, '18/JAN/2014', 321769111, '28/AUG/2020',  'William', 'Gietz', '515.123.8181');
INSERT INTO apartment_history (apartment_number, start_date, tenant_id, end_date, 
first_name, last_name, phone_number)    
VALUES (5, '05/JAN/2011', 321362171, '28/SEP/2018',  'Susan', 'Mavris', '515.123.7777');
INSERT INTO apartment_history (apartment_number, start_date, tenant_id, end_date, 
first_name, last_name, phone_number)    
VALUES (7, '05/JAN/2011', 399362175, '28/SEP/2018',  'Sarah', 'Bell', '650.501.1876');
INSERT INTO apartment_history (apartment_number, start_date, tenant_id, end_date, 
first_name, last_name, phone_number)    
VALUES (8, '19/APR/2011', 449325145, '05/NOV/2018',  'Michael', 'Hartstein', '515.123.5555');


EXECUTE add_apartment_monthly_payment('15/FEB/2015', 'Nandita', 'Sarchand', 2);
EXECUTE add_apartment_monthly_payment('15/MAR/2015', 'Nandita', 'Sarchand', 2);
EXECUTE add_apartment_monthly_payment('15/APR/2015', 'Nandita', 'Sarchand', 2);
EXECUTE add_apartment_monthly_payment('15/MAY/2015', 'Nandita', 'Sarchand', 2);
EXECUTE add_apartment_monthly_payment('15/JUN/2015', 'Nandita', 'Sarchand', 2);
EXECUTE add_apartment_monthly_payment('15/JUL/2015', 'Nandita', 'Sarchand', 2);
EXECUTE add_apartment_monthly_payment('15/AUG/2015', 'Nandita', 'Sarchand', 2);
EXECUTE add_apartment_monthly_payment('15/SEP/2015', 'Nandita', 'Sarchand', 2);
EXECUTE add_apartment_monthly_payment('15/OCT/2015', 'Nandita', 'Sarchand', 2); 

EXECUTE add_apartment_general_payment('20/OCT/2015', 'Damage', 'Nandita', 'Sarchand', 2500, 2);


EXECUTE add_service_provider(517555777, 'TopClean', '1297 Ben Gurion, Tel Aviv', '353.123.5555');
EXECUTE add_service_provider(113545897, 'BestClean', '93091 Prachim, Petah-Tikva', '353.123.6666');
EXECUTE add_service_provider(113566896, 'TopPaint', '2017 Ganim, Netanya', '353.123.7777');
EXECUTE add_service_provider(992546891, 'BestPaint', '165 Rotshield, Netanya', '353.123.8888');
EXECUTE add_service_provider(552556391, 'TopPumps', '777 Hadasim, Ranana', '353.123.9999');
EXECUTE add_service_provider(552777791, 'BestPumps', '822 Oranim, Tzfat', '353.555.1234');
EXECUTE add_service_provider(552999991, 'TopGraden', '56 Narkisim, Hadera', '353.555.2222');
EXECUTE add_service_provider(532933391, 'BestGraden', '765 Yamim, Hadera', '353.555.3333');
EXECUTE add_service_provider(777773391, 'TopPesticide', '76 Sands, Kfar-Sava', '353.555.4444');
EXECUTE add_service_provider(777775555, 'BestPesticide', '888 Heaven, Or-Yehuda', '353.555.5555');


EXECUTE add_work('Clean', 250, 113545897, 111111111);
EXECUTE add_work('Pump', 320, 552777791, 222222222);
EXECUTE add_work('Pesticide', 180, 777775555, 333333333);
EXECUTE add_work('Gardening', 220, 552999991, 555555555);
EXECUTE add_work('Painting', 270, 113566896, 666666666);
EXECUTE add_work('Clean', 160, 517555777, 666666666);
EXECUTE add_work('Pump', 410, 552556391, 111111111);
EXECUTE add_work('Pesticide', 270, 777773391, 111111111);
EXECUTE add_work('Gardening', 310, 532933391, 111111111);
EXECUTE add_work('Painting', 150, 992546891, 111111111);


EXECUTE add_service_payment('18/JUL/2015', 2);
EXECUTE add_service_payment('09/SEP/2015', 4);
EXECUTE add_service_payment('14/SEP/2015', 1);
EXECUTE add_service_payment('19/SEP/2015', 10);
EXECUTE add_service_payment('21/SEP/2015', 3);
EXECUTE add_service_payment('23/SEP/2015', 9);
EXECUTE add_service_payment('26/SEP/2015', 7);
EXECUTE add_service_payment('02/OCT/2015', 6);
EXECUTE add_service_payment('10/OCT/2015', 5);
EXECUTE add_service_payment('24/OCT/2015', 8);


EXECUTE add_to_elections('04/MAY/2010', 111111111, 12, 1);
EXECUTE add_to_elections('04/MAY/2010', 222222222, 2, 0);
EXECUTE add_to_elections('04/MAY/2010', 333333333, 1, 0);
EXECUTE add_to_elections('04/MAY/2010', 444444444, 0, 0);
EXECUTE add_to_elections('04/MAY/2010', 555555555, 1, 0);
EXECUTE add_to_elections('04/MAY/2010', 666666666, 0, 0);
EXECUTE add_to_elections('04/MAY/2010', 777777777, 0, 0);
EXECUTE add_to_elections('04/MAY/2010', 888888888, 5, 0);
EXECUTE add_to_elections('04/MAY/2010', 999999999, 0, 0);
EXECUTE add_to_elections('04/MAY/2010', 111555555, 0, 0);

