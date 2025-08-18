-- students-course table

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


