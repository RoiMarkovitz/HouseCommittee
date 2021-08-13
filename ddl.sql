-- Initiating database: creating tables 


CREATE TABLE tenant
(
tenant_id NUMBER(9,0) PRIMARY KEY,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
phone_number VARCHAR(15),
committee_member NUMBER(1,0) DEFAULT 0 NOT NULL CHECK (committee_member = 0
or committee_member = 1)
);


CREATE TABLE warehouse
(
warehouse_number NUMBER(2, 0) PRIMARY KEY CHECK (warehouse_number > 0 and warehouse_number < 11),
warehouse_size NUMBER(4, 2) NOT NULL CHECK (warehouse_size > 0)
);


CREATE TABLE apartment
(
apartment_number NUMBER(2,0) PRIMARY KEY CHECK (apartment_number > 0 and apartment_number < 14),
floor NUMBER(1,0) NOT NULL CHECK(floor > 0 and floor < 6),
rooms NUMBER(1,0) NOT NULL CHECK (rooms > 0),
apartment_size NUMBER(5,2) NOT NULL CHECK (apartment_size > 0),
warehouse_number NUMBER(2, 0) UNIQUE REFERENCES warehouse(warehouse_number) ON DELETE CASCADE
);


-- associative table of tenant and apartment
CREATE TABLE tenant_apartment
(
tenant_id NUMBER(9,0) REFERENCES tenant(tenant_id) ON DELETE CASCADE,
apartment_number NUMBER(2,0) REFERENCES apartment(apartment_number) ON DELETE CASCADE,
start_date DATE NOT NULL,
PRIMARY KEY (tenant_id, apartment_number)
);


CREATE TABLE apartment_history
(
apartment_number NUMBER(2,0) REFERENCES apartment(apartment_number) ON DELETE CASCADE,
start_date DATE,
tenant_id NUMBER(9,0),
end_date DATE NOT NULL,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
phone_number VARCHAR(15),
PRIMARY KEY (apartment_number, start_date, tenant_id),
CHECK (end_date > start_date)
);


CREATE TABLE apartment_payments
(
payment_number NUMBER(38,0) PRIMARY KEY,
payment_due_date DATE NOT NULL,
reason VARCHAR(20) NOT NULL,
first_name VARCHAR(30),
last_name VARCHAR(30),
amount NUMBER(9,2) NOT NULL CHECK (amount > 0),
payment_method VARCHAR(20) CHECK(payment_method = 'cash' or payment_method = 'credit' or payment_method IS NULL),
paid_date DATE,
apartment_number NUMBER(2,0) REFERENCES apartment(apartment_number) ON DELETE CASCADE 
);


CREATE TABLE service_provider
(
business_number NUMBER(9,0) PRIMARY KEY,
provider_name VARCHAR(30) NOT NULL,
address VARCHAR(40),
phone_number VARCHAR(15)
);


CREATE TABLE works
(
work_number NUMBER(38,0) PRIMARY KEY,
work_type VARCHAR(30) NOT NULL,
price NUMBER(9,2) NOT NULL CHECK (price > 0),
business_number NUMBER(9,0) REFERENCES service_provider(business_number) ON DELETE CASCADE,
tenant_id NUMBER(9,0)  
);


CREATE TABLE service_payments
(
payment_number NUMBER(38,0) PRIMARY KEY,
paid_date DATE NOT NULL,
amount NUMBER(9,2) NOT NULL CHECK (amount > 0),
business_number NUMBER(9,0),
work_number NUMBER(38,0) UNIQUE REFERENCES works(work_number) 
);


CREATE TABLE elections
(
election_date DATE,
tenant_id NUMBER(9,0),
votes NUMBER(3,0) DEFAULT 0 NOT NULL CHECK (votes >= 0),
chosen NUMBER(1,0) NOT NULL CHECK (chosen = 0 or chosen = 1),
PRIMARY KEY(election_date, tenant_id)
);



