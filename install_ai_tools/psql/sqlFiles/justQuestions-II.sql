/* Last amended: 28th Dec, 2021
# SQL queries on Supplier-Parts dataset
# Ref: http://myslu.stlawu.edu/~ehar/Fall08/cs348/hw/hw3_solutions.html
#
# # Sample SQL queries. See answers in file: sqlQueries.sql

*/

/*

Database used is : spp
Contains tables: s, p , j and spj
See file spp.sql

ToDo

*/


use spp ;

-- 18.0 Get snum for suppliers supplying at least
--      one part supplied by at least one S who supplies
--   	 at least one Red part.

-- Difficult question

-- 19.0 Get S numbers for suppliers supplying at least one part 
--  	supplied by at least one S who supplies at least one red part.

--Difficult question


-- 20.0 Get pnum for P supplied
-- 	 by a S in London.






-- 21.0 Get all pairs of part numbers such that some
-- 	S supplies both the indicated p.


-- 22.0 Get part numbers of P supplied to some project
--  	in an average quantity of more than 320.



     
-- ------------------------------------------------
-- ------------------------------------------------

-- SQL queries on Supplier-Parts-projects:
-- Ref: https://www.cs.odu.edu/~ibl/450/sql/q-07sql.html

-- 23.0 Get all snum/pnum/jnum triples such that the S,
--  	part and project are NOT co-located.


-- or:



-- 24.0 Get part numbers for P supplied by a S
-- 	in London.


-- A subquery version next
-- (Above again) Get part numbers for P supplied by a
-- S in London.


-- (above again) Get part numbers for P supplied by a
-- S in London.


--Called Subquery Factoring
--Can only be done with uncorrelated subqueries


-- Get part numbers for P supplied by a
-- S in London to a project in London.


-- subquery version next
-- (above again) Get part numbers for P supplied by a
-- S in London to a project in London.


-- alternative using EXISTS next
--  (above again) Get part numbers for P supplied
-- by a S in London to a project in London.


 -- study the P in red
  

--When Subqueries are NOT possible:


-- Get part numbers for P their S's
--  number and status when they are supplied by a
--   London S



-- illegal: status's table (S) must appear
-- on the FROM line below it.
-- Illegal!

-- Get all pairs of city names such that a S
-- in the first city supplies a project in the second.



-- non-nested alternative next


-- (above again) Get all pairs of city names such that a
-- S in the first city supplies a project in the
-- second.
-- non-nested alternative



-- Get part numbers for P supplied to any
-- project by a S in the same city as that
-- project.




--nested alternative next
-- (above again) Get part numbers for p supplied to
-- any project by a s in the same city as that
-- project.
-- nested version: note double nesting required




-- (above again) Get part numbers for p supplied
-- to any project by a s in the same city as
-- that project.
-- another version





-- Get all P whose names begin with 'C'.



-- Get S numbers for suppliers with status greater than 25.



-- Get S names for suppliers who supply part P2.


-- -------------------------------
-- -------------------------------
-- Ref: https://titanwolf.org/Network/Articles/Article?AID=716e9f11-1f51-40f9-81d5-61cbd7e38b5f

-- Find the S number snum of supply engineering Jl P;


-- Find the S number snum of supply engineering Jl P Pl;


-- Find the S number snum of the supply engineering Jl part is red;

-- Find at least the engineering number jnum of all P supplied by the S Sl;
--   A, query the part number supplied by the S1 S


-- The result is (P1, P2) B. Query which project uses both P1 P and P2 p.


-- Try the SQL language for the four tables in Exercise 3
--  to complete the following operations:
--   Find out the names and cities of all suppliers .


-- Find out the name, color and weight of all p.


-- Find out the engineering number of the P supplied by S S1.


-- Find out the names and quantity of various P used in the project J2.


-- Find out all the part numbers supplied by Shanghai manufacturers.


-- Find out the engineering name of the P made in Shanghai.


-- ---------------------------------------------------
-- --------------------------------------------
