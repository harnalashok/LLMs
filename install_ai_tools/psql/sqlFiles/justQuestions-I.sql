/* Last amended: 28th Dec, 2021
# SQL queries on Supplier-Parts dataset
# Ref: http://myslu.stlawu.edu/~ehar/Fall08/cs348/hw/hw3_solutions.html
#
# Sample SQL queries. See answers in file: sqlQueries.sql

*/


/* These questions use tables: s, p, sp in databse sp */

    use sp ;	

-- 1.0 List all of the snum and the pnum supplied by the suppliers
--	listed in S.
-- 2.0 The "order by" clause is not strictly necessary.

-- 3.0 Get snum for suppliers who supply pnum of 1. 
--     Answer should have one attribute, (snum).

-- 4.0 Get sname and status for all suppliers who have a
--     status between 15 and 25 inclusive.
-- 	Answer should have two attributes (sname,status)


-- 5.0 Get all pnum and the sname for part
-- 	supplied by a supplier to London city
-- 	Answer should have two attributes (pnum,sname).


-- 5a.0 Get all pnum and the sname for part
-- 	supplied by a supplier staying in London city
-- 	Answer should have two attributes (pnum,sname).


-- 6.0 Find the average status for all the suppliers. 
-- 	Answer is scalar (a table with one row and one column).


-- 7.0 Get part numbers for P not supplied by any 
--      S staying in London. 
--     Answer should have one attribute (pnum).

  

-- 8.0 Get city names for cities in which at least two suppliers
--     are located. ANswer has one attribute (city).

     

-- 9.0 Get all pairs of part numbers and sname such that the S
--     supplies both of the p. Don't include trivial pairs of part numbers.
-- 	For example don't list the tuple Smith 1 1. That's obvious. For ease,
-- 	you can list symmetric tuples, for example, Smith 1 2 and Smith 2 1. 
-- 	Your answer schema should have three attributes (sname,pnum,pnum).

     

-- 10.0 Get the total number of different pnum supplied by sname.
--      Answer is scalar.



-- 11.0 Get snum for suppliers with a status lower than that of snum = 1. 
-- 	Answer has one attribute (snum).

     

--  12.0 Get snum for suppliers whose city is first in the 
--  	 lexicographic order of cities. 
--       Answer has one attribute (snum).



-- 13.0 Get pnum for P supplied by all suppliers in London. 
--       Answer has one attribute (pnum).


     

-- 14.0 Get snum, sname, and pnum such that the S does 
--      not supply the part. 
--      Answer has three attributes (snum,sname,pnum).

--       Very difficult. Consider skipping.

-- 15.0 Get the pnum and total shipment quantity for each part.


--  16.0 Get pnum for all P supplied by more than one S:


-- 17.0 Get sname for suppliers who supply part 2.



#######################
