# HouseCommittee
With this system the house committee can manage payments, maintenance works, elections, service providers, apartments and tenants.

The system was created as my idea for a project in oracle course at the academy.

The user interface is implemented with Python and cx_Oracle API.
The exchange of data is made through the activation of function and procedure objects stored in the oracle database.


### Main Features 
- 35 PLSQL functions and procedures to manipulate and present information from the database.
- Use of views objects to benefit performance. 
- Use of different queries such as Join, Decode and Nested Queries.
- Use of Sequences.
- Use of before insert and before delete triggers.
- Use of cursors to fetch data and improve performance.
- Use of Types and Collections.
- Use of Oracle Exceptions (both user defined and system) and 'catching' them with the GUI.
- Database deisgn with 10 tables including One to One, One to Many and Many to Many relations.
- 42 GUI screens.
 

### Example of some of the GUI screens

Database Diagram         
:-------------------------:
<img src="https://github.com/roi-c/HouseCommittee/blob/main/database%20diagram/HouseCommittee.png" alt="drawing" width="800"/>  

Main Menu         
:-------------------------:
<img src="https://github.com/roi-c/HouseCommittee/blob/main/images/MainMenu.jpg" alt="drawing" width="800"/>  

Apartments Details     
:-------------------------:
<img src="https://github.com/roi-c/HouseCommittee/blob/main/images/ApartmentsDetails.png" alt="drawing" width="800"/>  

Apartments Payments Details     
:-------------------------:
<img src="https://github.com/roi-c/HouseCommittee/blob/main/images/ApartmentPaymentsDetails.png" alt="drawing" width="800"/> 

Tenants Details     
:-------------------------:
<img src="https://github.com/roi-c/HouseCommittee/blob/main/images/Tenants.jpg" alt="drawing" width="800"/>  

Service Providers Payments Details     
:-------------------------:
<img src="https://github.com/roi-c/HouseCommittee/blob/main/images/ProvidersPayments.jpg" alt="drawing" width="800"/>  

Receipt Details     
:-------------------------:
<img src="https://github.com/roi-c/HouseCommittee/blob/main/images/Receipt.jpg" alt="drawing" width="800"/>  

Add To Elections     
:-------------------------:
<img src="https://github.com/roi-c/HouseCommittee/blob/main/images/AddToElections.jpg" alt="drawing" width="800"/> 


### "Installation" instructions 
- Create an oracle database. 
- Run DDL.sql to create the tables.
- Run FUNCTIONS.sql to create the functions, views, types and such.
- Run PROCEDURES.sql to create the procedures, triggers, sequences and such.
- Run DML.sql to populate the tables with initial data.
- In the file connection.py update the connection details as follows: cx_Oracle.connect('<user>/<pass>@//localhost:1521/<SID>')
- Have fun.

