-- Last amended: 10th August, 2025
-- Myfolder: /home/ashok/Documents/sampleDatabases/sd4
-- VM: Ubuntu database VM
-- Within database, gandhi, we have a table 'sp'
--Assuming user: gandhi and database: gandhi in postgresql
--We create three tables within this database
-- See queries in file: sqlQueries.sql

--Assumuing user gandhi has ALL privileges over
-- databasw gandhi and public schema gandhi,
--Proceed by first logging into Ubuntu as gandhi
--and then logging into psql (as user gandhi).
--Connect to gandhi database

gandhi=> \c gandhi

--Create tables as follows:	
CREATE TABLE s
  (
	snum int NOT NULL PRIMARY KEY,
	sname varchar(16) NOT NULL UNIQUE,
	status int NOT NULL,
	city varchar(20) NOT NULL
  );


  CREATE TABLE p
  (
	pnum int NOT NULL PRIMARY KEY,
	pname varchar(18) NOT NULL,
	color varchar(10) NOT NULL,
	weight decimal(4,1) NOT NULL,
	city varchar(20) NOT NULL,
	unique (pname, color, city)
  );


  CREATE TABLE sp
  (
	snum int NOT NULL REFERENCES s,
	pnum int NOT NULL REFERENCES p,
	qty int NOT NULL,
	PRIMARY KEY (snum, pnum)
  );


  INSERT INTO s VALUES (1, 'Smith', 20, 'London');
  INSERT INTO s VALUES (2, 'Jones', 10, 'Paris');
  INSERT INTO s VALUES (3, 'Blake', 30, 'Paris');
  INSERT INTO s VALUES (4, 'Clark', 20, 'London');
  INSERT INTO s VALUES (5, 'Adams', 30, 'Athens');
  INSERT INTO s VALUES (6, 'Amit', 25, 'Delhi');
  INSERT INTO s VALUES (7, 'debashis', 15, 'Delhi');

  INSERT INTO p VALUES (1, 'Nut', 'Red', 12, 'London');
  INSERT INTO p VALUES (2, 'Bolt', 'Green', 17, 'Paris');
  INSERT INTO p VALUES (3, 'Screw', 'Blue', 17, 'Oslo');
  INSERT INTO p VALUES (4, 'Screw', 'Red', 14, 'London');
  INSERT INTO p VALUES (5, 'Cam', 'Blue', 12, 'Paris');
  INSERT INTO P VALUES (6, 'Cog', 'Red', 19, 'London');

  INSERT INTO sp VALUES (1, 1, 300);
  INSERT INTO sp VALUES (1, 2, 200);
  INSERT INTO sp VALUES (1, 3, 400);
  INSERT INTO sp VALUES (1, 4, 200);
  INSERT INTO sp VALUES (1, 5, 100);
  INSERT INTO sp VALUES (1, 6, 100);
  INSERT INTO sp VALUES (2, 1, 300);
  INSERT INTO sp VALUES (2, 2, 400);
  INSERT INTO sp VALUES (3, 2, 200);
  INSERT INTO sp VALUES (4, 2, 200);
  INSERT INTO sp VALUES (4, 4, 300);
  INSERT INTO sp VALUES (4, 5, 400);

--psql shortcuts
--  \dt: List tables
--  \d tableName : List tableName structure
--  \du: List all users
--  \du+:Extended version of \du
--  \c database :  Connect to named database 
--  \dn List schemas



--Questions
--#############################
---- Queries on sp tables
-- Suppliers, parts tables
--For answers see file: sqlQueries.sql
--#############################

-- 1.0 List all of the S numbers and the part numbers supplied by the s.
-- 2.0 Order the above output by qty.
-- 3.0 Get S numbers for suppliers who supply part 1. 
-- 4.0 Get S names and status for all suppliers who have a
--     status between 15 and 25 inclusive.
-- 5.0 Get S names and status for all suppliers who have a
--     status between 15 and 25 exclusive.
-- 6.0 List all suppliers which are NOT supplying any part
-- 7.0 List those suppliers which are supplying parts
-- 8.0 Get all part numbers and the S names for P
-- 	   supplied by a S in London. 
-- 9.0 Get all part numbers and the S names for P
-- 	   supplied by a S not in London. 
-- 10.0 Get all pno and the sname for part
-- 	    supplied by a supplier to London city
-- 11.0 Get all pno and the sname for part
-- 	    supplied by a supplier to all cities BUT London city
-- 12.0 Find the average status for all the suppliers. 
-- 13.0 Get part numbers for P not supplied by any 
--      S staying in London. 
-- 14.0 Get city names for cities in which at least two suppliers
--      are located. ANswer has one attribute (city).
-- 15.0 Get the total number of different P supplied by S one. Answer is scalar.
-- 16.0 Get the part # and total shipment quantity for each part.
-- 17.0 Get S numbers for suppliers with a status lower than that of S 1. 
-- 18.0 Get S numbers for suppliers whose city is first in the 
--  	 lexicographic order of cities. Answer has one attribute (sno).
-- 19.0 Get part numbers for P supplied by all suppliers in London. Answer has one attribute (pno).
--###########
     

