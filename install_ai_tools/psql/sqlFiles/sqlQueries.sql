/* Last amended: 3rd August, 2025
# SQL queries on Supplier-Parts dataset
# Ref: http://myslu.stlawu.edu/~ehar/Fall08/cs348/hw/hw3_solutions.html
#
# Sample SQL queries and answers. Mix of sp and spp databases
# These SQL commands work in psql shell
# See file: sp.sql
*/


--#############################
---- Queries on sp tables
-- Suppliers, parts tables
--#############################

-- 1.0 List all of the S numbers and the part numbers supplied by the s.

    select snum,pnum from sp order by snum;

-- 2.0 The "order by" clause is not strictly necessary.

-- 3.0 Get S numbers for suppliers who supply part 1. 
--     Answer should have one attribute, (snum).

    select snum from sp where pnum = 1;

-- 4.0 Get S names and status for all suppliers who have a
--     status between 15 and 25 inclusive.
-- 	Answer should have two attributes (sname,status)

     select sname,status from s where
       s.status >= 15 and
       s.status <= 20;

-- 5.0 Get all part numbers and the S names for P
-- 	supplied by a S in London. 
-- 	Answer should have two attributes (pnum,sname).

       select distinct sp.pnum,sname from
         s inner join sp using (snum)
         where s.city = 'London';

-- 5a.0 Get all pnum and the sname for part
-- 	supplied by a supplier to London city
-- 	Answer should have two attributes (pnum,sname).


	select sname, pnum from sp, s where s.snum = sp.snum AND
	sp.pnum in (select pnum from p where city = 'London'
	) ;
    // OR
    select sp.pnum, s.sname from sp, s, p where (sp.pnum = p.pnum) and (sp.snum = s.snum) and (p.city = 'London') ;



-- 6.0 Find the average status for all the suppliers. 
-- 	Answer is scalar (a table with one row and one column).

     select avg(status) from s;
     

-- 7.0 Get part numbers for P not supplied by any 
--      S staying in London. 
--     Answer should have one attribute (pnum).

       select distinct p.pnum from p
         where p.pnum not in
         (
           select distinct p.pnum from
             s inner join sp using (snum)
             inner join p using(pnum)
             where s.city='London'
         );
         
--    My answer:
        
        select sname,pnum from sp, s where s.snum = sp.snum AND s.city <> 'London' ;


-- 8.0 Get city names for cities in which at least two suppliers
--     are located. ANswer has one attribute (city).

       select city from s
         group by city
         having count(city) >= 2;
         
-- My answer but above is better:

         select city, count('city')   from s group by city having count('city') >=2 ;
     

-- 9.0 Get all pairs of part numbers and a S name such that the S
--     supplies both of the p. Don't include trivial pairs of part numbers.
-- 	For example don't list the tuple Smith 1 1. That's obvious. For ease,
-- 	you can list symmetric tuples, for example, Smith 1 2 and Smith 2 1. 
-- 	Your answer schema should have three attributes (sname,pnum,pnum).

     select distinct sname,pnum1,pnum2 from 
        s,  
        (
          select sp1.snum, sp1.pnum as pnum1, sp2.pnum as pnum2
            from sp as sp1,
                 sp as sp2
            where sp1.snum=sp2.snum and
                  sp1.pnum != sp2.pnum
        ) as temp
      where s.snum=temp.snum
      order by sname,pnum1;
     

-- 10.0 Get the total number of different P supplied by S one. Answer is scalar.

       select count(pnum) from sp where sp.snum=1;

-- My answer:

	select sname , count(pnum) from s,sp where s.snum = sp.snum group by sname ;


-- 11.0 Get S numbers for suppliers with a status lower than that of S 1. 
-- 	Answer has one attribute (snum).

      select snum from s 
        where status < (select status from s
    	                where snum=1) ;
     

--  12.0 Get S numbers for suppliers whose city is first in the 
--  	 lexicographic order of cities. Answer has one attribute (snum).

       select snum from s
       where
          city = (select min(city) from s);
          
--  another answer:

       select snum from s where city = (select city from s order by city limit 1) ;
          
     

-- 13.0 Get part numbers for P supplied by all suppliers in London. Answer has one attribute (pnum).

       select distinct pnum from 
         s inner join sp using (snum)
         where city = 'London';
         
-- my answer

         select distinct pnum from sp, s where sp.snum = s.snum AND s.city = 'London' ;         
     

-- 14.0 Get S number, S name, and part number such that the S does 
--      not supply the part. Answer has three attributes (snum,sname,pnum).

     select s.sname, s.snum, p.pnum
       from s,p
       where not exists
         (select * from sp
            where sp.pnum = p.pnum and
                  sp.snum = s.snum)
       order by sname,pnum;

-- 15.0 Get the part # and total shipment quantity for each part.

SELECT pnum, SUM(qty)
FROM sp
GROUP BY pnum ;


--  16.0 Get part numbers for all P supplied by more than one S:

SELECT pnum
FROM sp
GROUP BY pnum
HAVING COUNT(*) > 1 ;


--my answer:

     select pnum from sp where snum in 
                               (select snum from sp group by snum having count(snum) > 1 );



-- 17.0 Get S names for suppliers who supply part P2.

SELECT sname
FROM s
WHERE snum IN
( SELECT snum
FROM sp
WHERE pnum = '2' ) ;

-- my answer:

    select sname from s,sp where s.snum = sp.snum and sp.pnum = 2 ;

--#############################
---- Queries on spj tables
-- Suppliers, Project, parts tables
--#############################


-- 18.0 Get s numbers for suppliers supplying at least
--      one part supplied by at least one S who supplies
--   	at least one Red part.

use spp ;
SELECT DISTINCT snum
FROM spj
WHERE pnum IN
( SELECT pnum
FROM spj
WHERE snum IN
( SELECT snum
FROM spj
WHERE pnum IN
( SELECT pnum
FROM p
WHERE color = "Red") ) ) ;

-- 19.0 Get S numbers for suppliers supplying at least one part 
--  	supplied by at least one S who supplies at least one red part.


SELECT DISTINCT snum
FROM spj
WHERE pnum IN
( SELECT pnum
FROM spj
WHERE snum IN
( SELECT snum
FROM spj
WHERE pnum IN
( SELECT pnum
FROM p
WHERE color = "Red") ) ) ;


-- 20.0 Get part numbers for P supplied
-- 	by a S in London.

SELECT DISTINCT pnum
FROM spj, s
WHERE spj.snum = s.snum
AND city = 'London' ;

-- 21.0 Get all pairs of part numbers such that some
-- 	S supplies both the indicated p.

SELECT spjx.pnum, spjy.pnum
FROM spj spjx, spj spjy
WHERE spjx.snum = spjy.snum
AND spjx.pnum > spjy.pnum ;

-- 22.0 Get part numbers of P supplied to some project
--  	in an average quantity of more than 320.

SELECT DISTINCT pnum
FROM spj
GROUP BY pnum, jnum
HAVING AVG(qty) > 320 ;

   
-- SQL queries on Supplier-Parts-projects:
-- Ref: https://www.cs.odu.edu/~ibl/450/sql/q-07sql.html

-- 23.0 Get all snum/pnum/jnum triples such that the S,
--  	part and project are NOT co-located.

SELECT snum, pnum, jnum
FROM   s,p,j
WHERE  NOT(s.city = p.city
           AND p.city = J.city);

-- or:

SELECT snum, pnum, jnum
FROM   s,p,j
WHERE s.city <> p.city 
OR p.city <> J.city;


-- 24.0 Get part numbers for P supplied by a S
-- 	in London.

SELECT DISTINCT pnum
FROM   spj, s
WHERE  spj.snum = s.snum
AND      s.city = 'London';

-- A subquery version next
-- (Above again) Get part numbers for P supplied by a
-- S in London.

SELECT DISTINCT pnum
FROM   spj
WHERE  snum in (SELECT snum
              FROM   s
              WHERE s.city = 'London');

-- (above again) Get part numbers for P supplied by a
-- S in London.

WITH LondonSuppliers as 
            (SELECT snum
             FROM   s
             WHERE s.city = 'London')
SELECT DISTINCT pnum
FROM   spj, LondonSuppliers
WHERE  spj.snum = LondonSuppliers.snum;

--Called Subquery Factoring
--Can only be done with uncorrelated subqueries


-- Get part numbers for P supplied by a
-- S in London to a project in London.

SELECT pnum
FROM   spj, s, j
WHERE  spj.snum = s.snum
AND      spj.jnum = s.jnum
AND      s.city = 'London'
AND      j.city = 'London';

-- subquery version next
-- (above again) Get part numbers for P supplied by a
-- S in London to a project in London.

SELECT pnum
FROM   spj
 WHERE  snum in (SELECT snum
              FROM   s
              WHERE  city = 'London')
 AND   jnum in (SELECT jnum
             FROM   j
             WHERE  city = 'London') ;             

-- alternative using EXISTS next
--  (above again) Get part numbers for P supplied
-- by a S in London to a project in London.

SELECT pnum
FROM   spj
 WHERE  EXISTS (SELECT * FROM   s
               WHERE  city = 'London'
               AND    s.snum = spj.snum)
 AND    EXISTS (SELECT * FROM   j
               WHERE  city = 'London'
              AND    j.jnum = spj.jnum);

 -- study the P in red
  

--When Subqueries are NOT possible:


-- Get part numbers for P their S's
--  number and status when they are supplied by a
--   London S

SELECT pnum, snum, status 
FROM   spj
WHERE  snum in (SELECT snum
              FROM  s
              WHERE  city = 'London');


-- illegal: status's table (S) must appear
-- on the FROM line below it.
-- Illegal!

-- Get all pairs of city names such that a S
-- in the first city supplies a project in the second.


SELECT DISTINCT s.city, j.city
FROM   s,j
WHERE  EXISTS (SELECT *
               FROM   spj
               WHERE  spj.snum = s.snum
               AND      spj.jnum = J.jnum  );

-- non-nested alternative next


-- (above again) Get all pairs of city names such that a
-- S in the first city supplies a project in the
-- second.
-- non-nested alternative

SELECT DISTINCT s.city, J.city
FROM   S, J, spj
WHERE  spj.snum = s.snum
AND    spj.jnum = J.jnum;


-- Get part numbers for P supplied to any
-- project by a S in the same city as that
-- project.


SELECT DISTINCT pnum
FROM   s,j, spj
WHERE  spj.snum = s.snum
AND      spj.jnum = J.jnum
AND      s.city = J.city;


--nested alternative next
-- (above again) Get part numbers for p supplied to
-- any project by a s in the same city as that
-- project.
-- nested version: note double nesting required


SELECT DISTINCT pnum   FROM   spj
WHERE  EXISTS (
          SELECT *  FROM   S
          WHERE s.snum = spj.snum
          AND   s.city IN (
                SELECT city FROM  J
                WHERE J.jnum = spj.jnum
                )
          );



-- (above again) Get part numbers for p supplied
-- to any project by a s in the same city as
-- that project.
-- another version


SELECT DISTINCT pnum
FROM   spj
WHERE  (snum,jnum) IN (
             SELECT  snum, jnum
             FROM    S, J
             WHERE   s.city = J.city);



-- Get all P whose names begin with 'C'.


SELECT p.*
FROM P
WHERE p.pname LIKE 'C%' ;

-- Get S numbers for suppliers with status greater than 25.


SELECT snum
FROM s
WHERE STATUS > 25;


-- Get S names for suppliers who supply part P2.

use sp ;

SELECT sname
FROM s
WHERE EXISTS
( SELECT *
FROM sp
WHERE snum = s.snum
AND pnum = 'P2' ) ;

-- -------------------------------
-- -------------------------------
-- Ref: https://titanwolf.org/Network/Articles/Article?AID=716e9f11-1f51-40f9-81d5-61cbd7e38b5f

-- Find the S number snum of supply engineering Jl P;

use spp;

SELECT DISTINCT snum FROM spj WHERE jnum = 'J1' ;

-- Find the S number snum of supply engineering Jl P Pl;

SELECT DISTINCT snum FROM spj WHERE jnum = 'J1 'AND pnum =' P1 ' ;

-- Find the S number snum of the supply engineering Jl part is red;

SELECT snum FROM spj, P WHERE jnum =' J1 'AND spj.pnum = p.pnum AND color =' red ' ;

-- Find at least the engineering number jnum of all P supplied by the S Sl;
--   A, query the part number supplied by the S1 S

SELECT DISTINCT pnum FROM spj WHERE snum = 'S1' ;

-- The result is (P1, P2) B. Query which project uses both P1 P and P2 p.

SELECT jnum FROM spj WHERE pnum = 'P1'
AND jnum IN (SELECT jnum FROM spj WHERE pnum = 'P2') ;

-- Try the SQL language for the four tables in Exercise 3
--  to complete the following operations:
--   Find out the names and cities of all suppliers .

       SELECT sname, city FROM s ;

-- Find out the name, color and weight of all p.

SELECT pname, color, WEIGHT FROM p ; 

-- Find out the engineering number of the P supplied by S S1.

    SELECT DISTINCT jnum FROM spj WHERE snum = 'S1' ;

-- Find out the names and quantity of various P used in the project J2.

SELECT pname, qty FROM spj, p
WHERE p.pnum = spj.pnum AND spj.jnum = 'J2' ;

-- Find out all the part numbers supplied by Shanghai manufacturers.

SELECT pnum FROM spj, s WHERE s.snum = spj.snum AND city = 'Shanghai' ;

-- Find out the engineering name of the P made in Shanghai.

SELECT jname FROM spj, s,j
WHERE s.snum = spj.snum AND s.city = 'Shanghai' AND J.jnum = spj.jnum ;

-- ---------------------------------------------------
-- --------------------------------------------





