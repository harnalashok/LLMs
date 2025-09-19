--Class test
--23rd August, 2025
--Time 1.5 hour



Q1. Create a user chrome in Linux with password chrome
Write your code here:
	
sudo useradd -m chrome
[sudo] password for ashok: 
ashok@ashok:~$ sudo passwd chrome

Q2. Create user chrome with password chrome in postgresql
Write your code here:

sudo su postgres
psql
postgres=# create user chrome;

Q3. Create database chrome in postgresql
Write your code here:

create database chrome ;	


Q4. Grant all necessary privileges over database chrome to user chrome
    to create tables
Write your code here:

psql
postgres=# grant all privileges on database chrome to chrome ;
\c chrome
grant all on schema public to chrome ;
	
Q5. Create three tables for students-courses database as per the given diagram	
Write your code here:

sudo su chrome
psql
\c chrome
chrome=# grant all on schema public to chrome ;

--students-course table

create table st(
		rollno   char(4) primary key,
		name      varchar(10) not null,
		age       int,
		deg       varchar(5)
		);


create table c (
		cid char(2) primary key,
		cname	varchar(10),
		faculty varchar(10)
		);
		
		
create table st_c(
		  rollno char(4) references st(rollno),
		  cid char(2) references c(cid),
		  year int,
		  primary key(rollno,cid)
		  );

-- Insert data
insert into st values 
('a001','amit',23,'mba'),
('a002','joker',23,'eng'),
('a003','king',22,'ba'),
('a004','queen',24,'eng'),
('a005','geet',25,'phd');

insert into c values
('c1','IT','smith'),
('c2','finance','jones'),
('c3','mgt','clark'),
('c4','genmgt','adams'),
('c5','sales','ashok'),
('c6','marketing','kavita');

insert into st_c values
('a001','c1',1984),
('a001','c2',1985),
('a001','c4',1984),
('a002','c5',1986),
('a003','c6',1986),
('a003','c1',1986),
('a003','c2',1986),	


--SQL queries Questions
--Write your SQL code here. COpy and paste output of code here
--All questions carry equak marks

--1. Show all available courses
--SQL code & output
select * from c;



--2. Show all student details
--SQL code & output

select * from st ;



--3. Show the courses taken by student with rollno a003
--SQL code & output

SELECT T2.cname
FROM st_c AS T1
JOIN c AS T2 ON T1.cid = T2.cid
WHERE T1.rollno = 'a003';

-- OR

select cname
from st_c, c where st_c.cid = c.cid and rollno = 'a003' ; 

/*
 cname
-----------
 IT
 finance
 marketing
(3 rows)
*/

--4. Show the course being taught by faculty smith
--SQL code & output

SELECT cname
FROM c      
WHERE faculty = 'smith';
/*
 cname
-------
 IT
(1 row)
*/

--5. Which all students (mention names)) have subscribed to the course floated by faculty smith
--SQL code & output

SELECT T1.name
FROM st AS T1
JOIN st_c AS T2 ON T1.rollno = T2.rollno
JOIN c AS T3 ON T2.cid = T3.cid
WHERE T3.faculty = 'smith';

-- OR

select name
from st,st_c,c
where st_c.cid = c. cid 
and st_c.rollno = st.rollno
and c.faculty = 'smith' ; 


/*
 name
------
 amit
 king
(2 rows)
*/



--6. Which courses have been subscribed by students of age less than 24
--SQL code & output


SELECT DISTINCT T3.cname
FROM St AS T1
JOIN st_C AS T2 ON T1.Rollno = T2.Rollno
JOIN C AS T3 ON T2.cid = T3.cid
WHERE T1.age < 24;

-- OR

select distinct cname
from st,st_c,c
where st_c.cid = c. cid 
and st_c.rollno = st.rollno
and st.age < 24; 

/*
   cname
-----------
 marketing
 genmgt
 finance
 sales
 IT
(5 rows)
*/

--7. What is the average age of students in the class of smith
--SQL code & output

SELECT AVG(T1.age)
FROM st AS T1
JOIN st_C AS T2 ON T1.rollno = T2.rollno
JOIN c AS T3 ON T2.cid = T3.cid
WHERE T3.faculty = 'smith';

--OR

select avg(age)
from st,st_c,c
where st_c.cid = c. cid 
and st_c.rollno = st.rollno
and c.faculty < 'smith' ; 

/* Answer
         avg
---------------------
 22.5000000000000000
(1 row)
*/

--8. What is the overall average age of students
--SQL code & output

SELECT AVG(age) FROM st ;
/*
         avg
---------------------
 23.4000000000000000
(1 row)
*/

--9. What is the max age and min age
--SQL code & output

SELECT MAX(age), MIN(age)
FROM st;

/*
 max | min
-----+-----
  25 |  22
*/

--10.Which courses have no takers
--SQL code & output

SELECT cname             
FROM c     
WHERE cid NOT IN (SELECT DISTINCT cid FROM st_c);

/*
 cname
-------
 mgt
(1 row)
*/


--11.What are the names of students who are not enrolled in any course
--SQL code & output

SELECT name
FROM st      
WHERE rollno NOT IN (SELECT DISTINCT rollno FROM st_c);

/*
 name
-------
 queen
 geet
(2 rows)
*/

--12.Students who are between the age of 23 and 25 (inclusive), have taken which courses	
--SQL code & output

SELECT DISTINCT T3.cname
FROM st AS T1
JOIN st_c AS T2 ON T1.rollno = T2.rollno
JOIN c AS T3 ON T2.cid = T3.cid
WHERE T1.age BETWEEN 23 AND 25;

--OR

select distinct cname
from st,st_c,c
where st_c.cid = c. cid 
and st_c.rollno = st.rollno
and st.age between 23 and 25 ; 

/*
  cname
---------
 IT
 finance
 genmgt
 sales
(4 rows)
*/


--13.How many students have taken IT course	
--SQL code & output

SELECT COUNT(rollno)
FROM st_c
JOIN c  ON c.cid = st_c.cid
WHERE cname = 'IT' ;

/*
 count
-------
     2
(1 row)
*/

--14. Faculty, jones, is teaching which all students (give names of students)
--SQL code & output




--15. In the year 1986, whcih all faculty have taught courses
--SQL code & output

SELECT DISTINCT faculty
FROM st_c
JOIN c ON c.cid = st_c.cid
WHERE year = 1986;

/*
 faculty
---------
 ashok
 jones
 kavita
 smith
(4 rows)
*/



--16.What is the average age of students who passed out in 1986
--SQL code& output




--17.What is the average age of students, degree-wise
--SQL code& output




--18.What is the average age of students who have taken IT course
--SQL code& output





--19.What is the average age of students who have taken IT course earlier to year 1985
--SQL code& output




--20.What are the names of faculty under whom roll numbers a001 and roll number a003 have enrolled
--SQL code& output





