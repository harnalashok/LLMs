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


--Questions

--1. Show all available courses
--2. Show all student details
--3. Show the courses taken by student with rollno a003
--4. Show the course being taught by faculty smith
--5. Which all students (mention names)) have subscribed to the course floated by faculty smith
--6. Which courses have been subscribed by students of age less than 24
--7. What is the average age of students in the class of smith
--8. What is the overall average age of students
--9. What is the max age and min age
--10.Which courses have no takers
--11.What are the names of students who are not enrolled in any course
--12.Students who are between the age of 23 and 25 (inclusive), have taken which courses	
--13.How many students have taken IT course	




