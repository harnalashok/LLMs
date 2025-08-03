-- Last amended: 3rd August, 2025
-- Myfolder: /home/ashok/Documents/sampleDatabases/sd4
-- VM: Ubuntu database VM
-- Within database, gandhi, we have a table 'sp'
--Assuming user: gandhi and database: gandhi in postgresql
--We create three tables within this database
-- See queries in file: sqlQueries.sql


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
