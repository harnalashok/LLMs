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


