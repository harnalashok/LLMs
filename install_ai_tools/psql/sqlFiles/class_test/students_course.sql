--Class test
--23rd August, 2025
--Time 1.5 hour



Q1. Create a user chrome in Linux with password chrome
Write your code here:


Q2. Create user chrome with password chrome in postgresql
Write your code here:


Q3. Create database chrome in postgresql
Write your code here:



Q4. Grant all necessary privileges over database chrome to user chrome
    to create tables
Write your code here:

	
Q5. Create three tables for students-courses database as per the given diagram	
Write your code here:







--User creation
--=============

--create user edu, database edu in postgres
--grant all privileges to user edu over database edu
--grant all on public schema of database edu to user edu


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



insert into st values 
('a001','amit',23,'mba'),
('a002','joker',23,'eng'),
('a003','king',22,'ba'),
('a004','queen',24,'eng'),
('a005','geet',25,'phd');

insert into c values
('c1','IT,'smith'),
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
('a003','c1',1986);


--SQL queries Questions
--Write your SQL code here. COpy and paste output of code here
--All questions carry equak marks

--1. Show all available courses
--SQL code & output




--2. Show all student details
--SQL code & output




--3. Show the courses taken by student with rollno a003
--SQL code & output




--4. Show the course being taught by faculty smith
--SQL code & output




--5. Which all students (mention names)) have subscribed to the course floated by faculty smith
--SQL code & output




--6. Which courses have been subscribed by students of age less than 24
--SQL code & output




--7. What is the average age of students in the class of smith
--SQL code & output




--8. What is the overall average age of students
--SQL code & output




--9. What is the max age and min age
--SQL code & output





--10.Which courses have no takers
--SQL code & output




--11.What are the names of students who are not enrolled in any course
--SQL code & output



--12.Students who are between the age of 23 and 25 (inclusive), have taken which courses	
--SQL code & output





--13.How many students have taken IT course	
--SQL code & output




--14. Faculty, jones, is teachinh which all students (give names of students)
--SQL code & output



--15. In the year 1986, whcih all faculty have taught courses
--SQL code & output




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





