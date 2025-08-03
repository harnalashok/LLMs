-- Last amended: 29th Oct, 2021
-- Myfolder: /home/ashok/Documents/sampleDatabases/sd4
-- VM: Ubuntu VM
-- Page 102, C J Date
-- source /home/ashok/Documents/sampleDatabases/sd4/sp.sql
-- Usage:
--        $ mysql -u ashok -p
--        mysql> source /home/ashok/Documents/sampleDatabases/sd4/spp.sql

DROP DATABASE IF EXISTS spp;

CREATE DATABASE IF NOT EXISTS spp ;
USE spp ;

CREATE TABLE s
  (
	snum CHAR(2) NOT NULL PRIMARY KEY,
	sname varchar(16) NOT NULL UNIQUE,
	status int NOT NULL,
	city varchar(20) NOT NULL
  );


  CREATE TABLE p
  (
	pnum CHAR(2) NOT NULL PRIMARY KEY,
	pname varchar(18) NOT NULL,
	color varchar(10) NOT NULL,
	weight decimal(4,1) NOT NULL,
	city varchar(20) NOT NULL,
	UNIQUE (pname, color, city)
  );


  CREATE TABLE j
  (
	jnum CHAR(2) NOT NULL PRIMARY KEY,
	jname varchar(18) NOT NULL,
	city varchar(18) NOT NULL
  );


CREATE TABLE spj
  (
	snum CHAR(2) NOT NULL REFERENCES S,
	pnum CHAR(2) NOT NULL REFERENCES P,
	jnum CHAR(2)  NOT NULL REFERENCES J,
	qty int NOT NULL,
	PRIMARY KEY (snum, pnum, jnum)
  );


  INSERT INTO s VALUES ("S1", 'Smith', 20, 'London');
  INSERT INTO s VALUES ("S2", 'Jones', 10, 'Paris');
  INSERT INTO s VALUES ("S3", 'Blake', 30, 'Paris');
  INSERT INTO s VALUES ("S4", 'Clark', 20, 'London');
  INSERT INTO s VALUES ("S5", 'Adams', 30, 'Athens');
  INSERT INTO p VALUES ("P1", 'Nut', 'Red', 12, 'London');
  INSERT INTO p VALUES ("P2", 'Bolt', 'Green', 17, 'Paris');
  INSERT INTO p VALUES ("P3", 'Screw', 'Blue', 17, 'Oslo');
  INSERT INTO p VALUES ("P4", 'Screw', 'Red', 14, 'London');
  INSERT INTO p VALUES ("P5", 'Cam', 'Blue', 12, 'Paris');
  INSERT INTO p VALUES ("P6", 'Cog', 'Red', 19, 'London');
  
  
  INSERT INTO j VALUES ("J1", 'Sorter', 'Paris');
  INSERT INTO j VALUES ("J2", 'Display', 'Rome');
  INSERT INTO j VALUES ("J3", 'OCR',  'Athens');
  INSERT INTO j VALUES ("J4", 'Console','Athens');
  INSERT INTO j VALUES ("J5", 'RAID',  'London');
  INSERT INTO j VALUES ("J6", 'EDS',  'Oslo');
  INSERT INTO j VALUES ("J7", 'Tape','London');
  
  
  INSERT INTO spj VALUES("S1", "P1", "J1", 200) ;
  INSERT INTO spj VALUES("S1", "P1", "J4", 700) ;
  INSERT INTO spj VALUES("S2", "P3", "J1", 400) ;
  INSERT INTO spj VALUES("S2", "P3", "J2", 200) ;
  INSERT INTO spj VALUES("S2", "P3", "J3", 200) ;
  INSERT INTO spj VALUES("S2", "P3", "J4", 500) ;
  INSERT INTO spj VALUES("S2", "P3", "J5", 600) ;
  INSERT INTO spj VALUES("S2", "P3", "J6", 400) ;
  INSERT INTO spj VALUES("S2", "P3", "J7", 800) ;  
  INSERT INTO spj VALUES("S2", "P5", "J2", 100) ;
  INSERT INTO spj VALUES("S3", "P3", "J1", 200) ;
  INSERT INTO spj VALUES("S3", "P4", "J2", 500) ;
  INSERT INTO spj VALUES("S4", "P6", "J3", 300) ;
  INSERT INTO spj VALUES("S4", "P6", "J7", 300) ;
  INSERT INTO spj VALUES("S5", "P2", "J2", 200) ; 
  INSERT INTO spj VALUES("S5", "P2", "J4", 100) ;
  INSERT INTO spj VALUES("S5", "P5", "J5", 500) ;     
  INSERT INTO spj VALUES("S5", "P5", "J7", 100) ;  
  INSERT INTO spj VALUES("S5", "P6", "J2", 200) ;  
  INSERT INTO spj VALUES("S5", "P1", "J4", 100) ;
  INSERT INTO spj VALUES("S5", "P3", "J4", 200) ;
  INSERT INTO spj VALUES("S5", "P4", "J4", 800) ;
  INSERT INTO spj VALUES("S5", "P5", "J4", 400) ;
  INSERT INTO spj VALUES("S5", "P6", "J4", 500) ;
        
/* Questions:
1. Get full details of all projects
2. Get full details of all projects in London
3. Get supplier numbers for suppliers who supply project J1.
4. Get all shipments where quantity is in the range 300 to 750 inclusive.
5. Get all part-color/part-city pairs.
6. Get all supplier-number, part-number, project-number triples such that the indicated supplier, part and project are all colcated (ie in the same city).
7.  Get all supplier-number, part-number, project-number triples such that the indicated supplier, part and project are not all colcated.
8.  Get all supplier-number, part-number, project-number triples such that no two of the indicated supplier, part and project are colcated.
9. Get full details for parts supplied by a supplier in London.
10.Get part numbers for parts supplied by a supplier in London to a project in Londo.
11. Get all pairs of city names such that a supplier in first city supplies a project in the second city.
12. Get part numbers for parts supplied to any project by a supplier in the same city as that project.
13. Get project numbers for projects supplied by at least one supplier not in the same city.
14. Get all pairs of part numbers such that some supplier supplies both the indicated parts.

15. Get the total number of projects supplied by supplier S1.
16. Get the total quantity of part P1 supplied by supplier S1.

 “Get all (sno,jno) pairs such that sno appears in S, jno appears in J, and supplier sno supplies all parts used in project jno.” 
 
 SELECT SX.SNO , JX.JNO
     FROM   S AS SX , J AS JX
     WHERE  NOT EXISTS
          ( SELECT *
            FROM   P AS PX
            WHERE  EXISTS
                 ( SELECT *
                   FROM   PJ AS PJX
                   WHERE  PJX.PNO = PX.PNO
                   AND    PJX.JNO = JX.JNO )
            AND    NOT EXISTS
                 ( SELECT *
                   FROM   SP AS SPX
                   WHERE  SPX.PNO = PX.PNO
                   AND    SPX.SNO = SX.SNO ) )

Find suppliers who supply no parts at all.        
  
  
  
