-- Initiating database: creating tables and inserting rows

CREATE TABLE tenant
(
tenant_id NUMBER(9,0) PRIMARY KEY,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
phone_number VARCHAR(15),
committee_member NUMBER(1,0) DEFAULT 0 NOT NULL CHECK (committee_member = 0
or committee_member = 1)
);

INSERT INTO tenant VALUES (111111111, 'Steven', 'King', '515.123.4567', 1); 
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (222222222, 'Neena', 'Kochhar', '515.123.4568'); 
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (333333333, 'Alexander', 'Hunold', '590.423.4567');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (444444444, 'Bruce', 'Ernst', '590.423.4568');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (555555555, 'David', 'Austin', '590.423.4569');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (666666666, 'Diana', 'Lorentz', '590.423.5567');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (777777777, 'Nancy', 'Greenberg', '515.124.4569');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (888888888, 'Daniel', 'Faviet', '515.124.4169');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (999999999, 'John', 'Chen', '515.124.4269');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (111222222, 'Ismael', 'Sciarra', '515.124.4369');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (111333333, 'Shelli', 'Baida', '515.127.4563');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (111444444, 'Sigal', 'Tobias', '515.127.4564');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (111555555, 'Guy', 'Himuro', '515.127.4565');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (111666666, 'Adam', 'Fripp', '650.123.2234');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (111777777, 'Kevin', 'Mourqos', '650.123.5234');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (111888888, 'James', 'Landrv', '650.124.1334');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (111999999, 'Jason', 'Mallin', '650.127.1934');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (222111111, 'Ki', 'Gee', '650.127.1734');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (222333333, 'Amit', 'Banda', '750.124.1731');
INSERT INTO tenant (tenant_id, first_name, last_name, phone_number)  
VALUES (222344444, 'Winston', 'Tavlor', '750.124.1738');


CREATE TABLE warehouse
(
warehouse_number NUMBER(2, 0) PRIMARY KEY,
warehouse_size NUMBER(4, 2) NOT NULL CHECK (warehouse_size > 0)
);

INSERT INTO warehouse VALUES (1, 12.5);
INSERT INTO warehouse VALUES (2, 10); 
INSERT INTO warehouse VALUES (3, 4); 
INSERT INTO warehouse VALUES (4, 5.5); 
INSERT INTO warehouse VALUES (5, 5); 
INSERT INTO warehouse VALUES (6, 6.5); 
INSERT INTO warehouse VALUES (7, 7.5); 
INSERT INTO warehouse VALUES (8, 9); 
INSERT INTO warehouse VALUES (9, 4.5); 
INSERT INTO warehouse VALUES (10, 5); 


CREATE TABLE apartment
(
apartment_number NUMBER(2,0) PRIMARY KEY,
floor NUMBER(1,0) NOT NULL CHECK(floor > 0 and floor < 6),
rooms NUMBER(1,0) NOT NULL CHECK (rooms > 0),
apartment_size NUMBER(5,2) NOT NULL CHECK (apartment_size > 0),
warehouse_number NUMBER(2, 0) REFERENCES warehouse(warehouse_number) ON DELETE CASCADE
);

INSERT INTO apartment (apartment_number, floor, rooms, apartment_size, warehouse_number)    
VALUES (1, 1, 3, 80, NULL);
INSERT INTO apartment (apartment_number, floor, rooms, apartment_size, warehouse_number) 
VALUES (2, 1, 4, 100, 10);
INSERT INTO apartment (apartment_number, floor, rooms, apartment_size, warehouse_number) 
VALUES (3, 1, 5, 120, 6);
INSERT INTO apartment (apartment_number, floor, rooms, apartment_size, warehouse_number) 
VALUES (4, 2, 3, 80, NULL);
INSERT INTO apartment (apartment_number, floor, rooms, apartment_size, warehouse_number) 
VALUES (5, 2, 4, 100, 5);
INSERT INTO apartment (apartment_number, floor, rooms, apartment_size, warehouse_number) 
VALUES (6, 2, 5, 120, 4);
INSERT INTO apartment (apartment_number, floor, rooms, apartment_size, warehouse_number) 
VALUES (7, 3, 3, 80, 3);
INSERT INTO apartment (apartment_number, floor, rooms, apartment_size, warehouse_number) 
VALUES (8, 3, 4, 100, 9);
INSERT INTO apartment (apartment_number, floor, rooms, apartment_size, warehouse_number) 
VALUES (9, 3, 5, 120, 2);
INSERT INTO apartment (apartment_number, floor, rooms, apartment_size, warehouse_number) 
VALUES (10, 4, 3, 80, NULL);
INSERT INTO apartment (apartment_number, floor, rooms, apartment_size, warehouse_number) 
VALUES (11, 4, 4, 100, 7);
INSERT INTO apartment (apartment_number, floor, rooms, apartment_size, warehouse_number) 
VALUES (12, 4, 5, 120, 8);
INSERT INTO apartment (apartment_number, floor, rooms, apartment_size, warehouse_number) 
VALUES (13, 5, 6, 250, 1);

-- associative table of tenant and apartment
CREATE TABLE tenant_apartments
(
tenant_id NUMBER(9,0) REFERENCES tenant(tenant_id) ON DELETE CASCADE,
apartment_number NUMBER(2,0) REFERENCES apartment(apartment_number) ON DELETE CASCADE,
PRIMARY KEY (tenant_id, apartment_number)
);

INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (111111111, 13);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (111111111, 1);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (222222222, 2);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (333333333, 2);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (444444444, 3);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (555555555, 3);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (666666666, 4);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (777777777, 5);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (888888888, 5);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (999999999, 5);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (111222222, 6);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (111333333, 7);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (111444444, 8);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (111555555, 9);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (111666666, 9);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (111777777, 10);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (111888888, 11);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (111999999, 11);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (222111111, 12);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (222333333, 12);
INSERT INTO tenant_apartments (tenant_id, apartment_number)    
VALUES (222344444, 12);


CREATE TABLE apartment_history
(
apartment_number NUMBER(2,0) REFERENCES apartment(apartment_number) ON DELETE CASCADE,
start_date DATE,
end_date DATE NOT NULL,
tenant_id NUMBER(9,0) NOT NULL,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
phone_number VARCHAR(15),
PRIMARY KEY (apartment_number, start_date),
CHECK (end_date > start_date)
);

INSERT INTO apartment_history (apartment_number, start_date, end_date, tenant_id,
first_name, last_name, phone_number)    
VALUES (2, '20/FEB/2015', '20/FEB/2018', 555666777, 'Nandita', 'Sarchand', '650.509.1876');
INSERT INTO apartment_history (apartment_number, start_date, end_date, tenant_id,
first_name, last_name, phone_number)    
VALUES (6, '10/MAY/2012', '20/MAR/2020', 555666888, 'Alexis', 'Bull', '650.509.2876');
INSERT INTO apartment_history (apartment_number, start_date, end_date, tenant_id,
first_name, last_name, phone_number)    
VALUES (3, '10/JUN/2012', '10/JUN/2014', 555666999, 'Kelly', 'Chung', '650.505.1876');
INSERT INTO apartment_history (apartment_number, start_date, end_date, tenant_id,
first_name, last_name, phone_number)    
VALUES (3, '11/JUN/2014', '11/JUN/2020', 555666111, 'Kevin', 'Feenev', '650.507.9822');
INSERT INTO apartment_history (apartment_number, start_date, end_date, tenant_id,
first_name, last_name, phone_number)    
VALUES (10, '15/DEC/2013', '11/JUN/2017', 555123111, 'Pat', 'Fav', '603.123.6666');
INSERT INTO apartment_history (apartment_number, start_date, end_date, tenant_id,
first_name, last_name, phone_number)    
VALUES (9, '18/JAN/2014', '28/AUG/2020', 321666111, 'Donald', 'Cohen', '650.507.9819');
INSERT INTO apartment_history (apartment_number, start_date, end_date, tenant_id,
first_name, last_name, phone_number)    
VALUES (4, '18/JAN/2014', '28/AUG/2020', 321769111, 'William', 'Gietz', '515.123.8181');
INSERT INTO apartment_history (apartment_number, start_date, end_date, tenant_id,
first_name, last_name, phone_number)    
VALUES (5, '05/JAN/2011', '28/SEP/2018', 321362171, 'Susan', 'Mavris', '515.123.7777');
INSERT INTO apartment_history (apartment_number, start_date, end_date, tenant_id,
first_name, last_name, phone_number)    
VALUES (7, '05/JAN/2011', '28/SEP/2018', 399362175, 'Sarah', 'Bell', '650.501.1876');
INSERT INTO apartment_history (apartment_number, start_date, end_date, tenant_id,
first_name, last_name, phone_number)    
VALUES (8, '19/APR/2011', '05/NOV/2018', 449325145, 'Michael', 'Hartstein', '515.123.5555');


CREATE TABLE apartment_payments
(
payment_due_date DATE,
reason VARCHAR(20),
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
amount NUMBER(9,2) NOT NULL CHECK (amount > 0),
payment_method VARCHAR(20) NOT NULL CHECK(payment_method = 'cash' or payment_method = 'credit'),
paid_date DATE NOT NULL,
apartment_number NUMBER(2,0) REFERENCES apartment(apartment_number) ON DELETE CASCADE,
PRIMARY KEY (payment_due_date, reason)
);

INSERT INTO apartment_payments (payment_due_date, reason, first_name, last_name,
amount, payment_method, paid_date, apartment_number)    
VALUES ('20/FEB/2015', 'Monthly fee', 'Nandita', 'Sarchand',550, 'cash' ,'26/FEB/2015', 2); 
INSERT INTO apartment_payments (payment_due_date, reason, first_name, last_name,
amount, payment_method, paid_date, apartment_number)    
VALUES ('20/MAR/2015', 'Monthly fee', 'Nandita', 'Sarchand',550, 'cash' ,'18/MAR/2015', 2);
INSERT INTO apartment_payments (payment_due_date, reason, first_name, last_name,
amount, payment_method, paid_date, apartment_number)    
VALUES ('20/APR/2015', 'Monthly fee', 'Nandita', 'Sarchand',550, 'credit' ,'18/APR/2015', 2);
INSERT INTO apartment_payments (payment_due_date, reason, first_name, last_name,
amount, payment_method, paid_date, apartment_number)    
VALUES ('20/MAY/2015', 'Monthly fee', 'Nandita', 'Sarchand',550, 'credit' ,'18/MAY/2015', 2);
INSERT INTO apartment_payments (payment_due_date, reason, first_name, last_name,
amount, payment_method, paid_date, apartment_number)    
VALUES ('20/JUN/2015', 'Monthly fee', 'Nandita', 'Sarchand',550, 'credit' ,'18/JUN/2015', 2);
INSERT INTO apartment_payments (payment_due_date, reason, first_name, last_name,
amount, payment_method, paid_date, apartment_number)    
VALUES ('20/JUL/2015', 'Monthly fee', 'Nandita', 'Sarchand',550, 'credit' ,'18/JUL/2015', 2);
INSERT INTO apartment_payments (payment_due_date, reason, first_name, last_name,
amount, payment_method, paid_date, apartment_number)    
VALUES ('20/AUG/2015', 'Monthly fee', 'Nandita', 'Sarchand',550, 'credit' ,'18/AUG/2015', 2);
INSERT INTO apartment_payments (payment_due_date, reason, first_name, last_name,
amount, payment_method, paid_date, apartment_number)    
VALUES ('20/SEP/2015', 'Monthly fee', 'Nandita', 'Sarchand',550, 'cash' ,'18/SEP/2015', 2);
INSERT INTO apartment_payments (payment_due_date, reason, first_name, last_name,
amount, payment_method, paid_date, apartment_number)    
VALUES ('20/OCT/2015', 'Monthly fee', 'Nandita', 'Sarchand',550, 'cash' ,'18/OCT/2015', 2);
INSERT INTO apartment_payments (payment_due_date, reason, first_name, last_name,
amount, payment_method, paid_date, apartment_number)    
VALUES ('20/OCT/2015', 'Damage', 'Nandita', 'Sarchand',2500, 'cash' ,'09/OCT/2015', 2);


CREATE TABLE service_provider
(
business_number NUMBER(9,0) PRIMARY KEY,
provider_name VARCHAR(30) NOT NULL,
address VARCHAR(40),
phone_number VARCHAR(15)
);

INSERT INTO service_provider (business_number, provider_name, address, phone_number)
VALUES (517555777, 'TopClean', '1297 Ben Gurion, Tel Aviv', '353.123.5555');
INSERT INTO service_provider (business_number, provider_name, address, phone_number)
VALUES (113545897, 'BestClean', '93091 Prachim, Petah-Tikva', '353.123.6666');
INSERT INTO service_provider (business_number, provider_name, address, phone_number)
VALUES (113566896, 'TopPaint', '2017 Ganim, Netanya', '353.123.7777');
INSERT INTO service_provider (business_number, provider_name, address, phone_number)
VALUES (992546891, 'BestPaint', '165 Rotshield, Netanya', '353.123.8888');
INSERT INTO service_provider (business_number, provider_name, address, phone_number)
VALUES (552556391, 'TopPumps', '777 Hadasim, Ranana', '353.123.9999');
INSERT INTO service_provider (business_number, provider_name, address, phone_number)
VALUES (552777791, 'BestPumps', '822 Oranim, Tzfat', '353.555.1234');
INSERT INTO service_provider (business_number, provider_name, address, phone_number)
VALUES (552999991, 'TopGraden', '56 Narkisim, Hadera', '353.555.2222');
INSERT INTO service_provider (business_number, provider_name, address, phone_number)
VALUES (532933391, 'BestGraden', '765 Yamim, Hadera', '353.555.3333');
INSERT INTO service_provider (business_number, provider_name, address, phone_number)
VALUES (777773391, 'TopPesticide', '76 Sands, Kfar-Sava', '353.555.4444');
INSERT INTO service_provider (business_number, provider_name, address, phone_number)
VALUES (777775555, 'BestPesticide', '888 Heaven, Or-Yehuda', '353.555.5555');


CREATE TABLE works
(
work_number NUMBER(38,0) PRIMARY KEY,
work_type VARCHAR(30) NOT NULL,
price NUMBER(9,2) NOT NULL CHECK (price > 0),
business_number NUMBER(9,0) REFERENCES service_provider(business_number) ON DELETE CASCADE,
tenant_id NUMBER(9,0) REFERENCES tenant(tenant_id) ON DELETE CASCADE
);

INSERT INTO works (work_number, work_type, price, business_number, tenant_id)
VALUES (1, 'Clean', 250, 113545897, 111111111);
INSERT INTO works (work_number, work_type, price, business_number, tenant_id)
VALUES (2, 'Pump', 320, 552777791, 222222222);
INSERT INTO works (work_number, work_type, price, business_number, tenant_id)
VALUES (3, 'Pesticide', 180, 777775555, 333333333);
INSERT INTO works (work_number, work_type, price, business_number, tenant_id)
VALUES (4, 'Gardening', 220, 552999991, 555555555);
INSERT INTO works (work_number, work_type, price, business_number, tenant_id)
VALUES (5, 'Painting', 270, 113566896, 666666666);
INSERT INTO works (work_number, work_type, price, business_number, tenant_id)
VALUES (6, 'Clean', 160, 517555777, 666666666);
INSERT INTO works (work_number, work_type, price, business_number, tenant_id)
VALUES (7, 'Pump', 410, 552556391, 111111111);
INSERT INTO works (work_number, work_type, price, business_number, tenant_id)
VALUES (8, 'Pesticide', 270, 777773391, 111111111);
INSERT INTO works (work_number, work_type, price, business_number, tenant_id)
VALUES (9, 'Gardening', 310, 532933391, 111111111);
INSERT INTO works (work_number, work_type, price, business_number, tenant_id)
VALUES (10, 'Painting', 150, 992546891, 111111111);


CREATE TABLE service_payments
(
payment_number NUMBER(38,0) PRIMARY KEY,
paid_date DATE NOT NULL,
amount NUMBER(9,2) NOT NULL CHECK (amount > 0),
business_number NUMBER(9,0) REFERENCES service_provider(business_number) ON DELETE CASCADE,
work_number NUMBER(38,0) REFERENCES works(work_number) ON DELETE CASCADE
);

INSERT INTO service_payments (payment_number, paid_date, amount, business_number, work_number)
VALUES (1, '18/JUL/2015', 320, 552777791, 2);
INSERT INTO service_payments (payment_number, paid_date, amount, business_number, work_number)
VALUES (2, '09/SEP/2015', 220, 552999991, 4);
INSERT INTO service_payments (payment_number, paid_date, amount, business_number, work_number)
VALUES (3, '14/SEP/2015', 250, 113545897, 1);
INSERT INTO service_payments (payment_number, paid_date, amount, business_number, work_number)
VALUES (4, '19/SEP/2015', 150, 992546891, 10);
INSERT INTO service_payments (payment_number, paid_date, amount, business_number, work_number)
VALUES (5, '21/SEP/2015', 180, 777775555, 3);
INSERT INTO service_payments (payment_number, paid_date, amount, business_number, work_number)
VALUES (6, '23/SEP/2015', 310, 532933391, 9);
INSERT INTO service_payments (payment_number, paid_date, amount, business_number, work_number)
VALUES (7, '26/SEP/2015', 410, 552556391, 7);
INSERT INTO service_payments (payment_number, paid_date, amount, business_number, work_number)
VALUES (8, '02/OCT/2015', 160, 517555777, 6);
INSERT INTO service_payments (payment_number, paid_date, amount, business_number, work_number)
VALUES (9, '10/OCT/2015', 270, 113566896, 5);
INSERT INTO service_payments (payment_number, paid_date, amount, business_number, work_number)
VALUES (10, '24/OCT/2015', 270, 777773391, 8);


CREATE TABLE elections
(
election_date DATE,
tenant_id NUMBER(9,0) REFERENCES tenant(tenant_id) ON DELETE CASCADE,
votes NUMBER(3,0) DEFAULT 0 NOT NULL CHECK (votes >= 0),
chosen NUMBER(1,0) CHECK (chosen = 0 or chosen = 1 or chosen = NULL),
PRIMARY KEY(election_date, tenant_id)
);

INSERT INTO elections (election_date, tenant_id, votes, chosen)
VALUES ('04/MAY/2010', 111111111, 12, 1);
INSERT INTO elections (election_date, tenant_id, votes, chosen)
VALUES ('04/MAY/2010', 222222222, 2, 0);
INSERT INTO elections (election_date, tenant_id, votes, chosen)
VALUES ('04/MAY/2010', 333333333, 1, 0);
INSERT INTO elections (election_date, tenant_id, votes, chosen)
VALUES ('04/MAY/2010', 444444444, 0, 0);
INSERT INTO elections (election_date, tenant_id, votes, chosen)
VALUES ('04/MAY/2010', 555555555, 1, 0);
INSERT INTO elections (election_date, tenant_id, votes, chosen)
VALUES ('04/MAY/2010', 666666666, 0, 0);
INSERT INTO elections (election_date, tenant_id, votes, chosen)
VALUES ('04/MAY/2010', 777777777, 0, 0);
INSERT INTO elections (election_date, tenant_id, votes, chosen)
VALUES ('04/MAY/2010', 888888888, 5, 0);
INSERT INTO elections (election_date, tenant_id, votes, chosen)
VALUES ('04/MAY/2010', 999999999, 0, 0);
INSERT INTO elections (election_date, tenant_id, votes, chosen)
VALUES ('04/MAY/2010', 111555555, 0, 0);





