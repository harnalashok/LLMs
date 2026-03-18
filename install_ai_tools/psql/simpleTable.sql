\c ravi ;

drop table IF EXISTS ravi.public.distributors ;
CREATE TABLE ravi.public.distributors (
                                           did  integer PRIMARY KEY,
                                           name    varchar(40),
                                           designation char(10)
                                           );
insert into ravi.public.distributors values (10, 'ashok', 'manager');
insert into ravi.public.distributors values (100, 'vikas', 'dymgr');
insert into ravi.public.distributors values (5, 'vidur', 'srmgr');
insert into ravi.public.distributors values (15, 'kapil', 'dymgr');
insert into ravi.public.distributors values (105, 'ashok', 'manager');
insert into ravi.public.distributors values (110, 'vikas', 'manager');
insert into ravi.public.distributors values (20, 'vidur', 'srmgr');
insert into ravi.public.distributors values (30, 'kapil', 'dymgr');
select * from distributors ;



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


