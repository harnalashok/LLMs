-- SQL code Generation by AI agent
-- 		Here is the description of AI Agent and Tools used.
--      The PostgreSQL connection used automatically decides the database.
--      For example, if the role is chinook then the database would be chinook
--	    If the role is ravi, database would be ravi (with s,p,j and spj tables)
--      IT WILL BE MUCH BETTER IF TABLES ALSO HAVE COMMENTS


-- AA. AI Agent: System message
/*
You are a helpful assistant expert in designing and writing postgresql SQL queries. 
You take help from three tools: 'getDBSchema', 'getTableStructure' and 'executeSQLquery'. 
'getDBSchema' gives a list of schemas and tables in the current database. For any table, 
'getTableStructure' gives information on table structure. Using these information and 
user input you frame an SQL query to extract data from the tables. This SQL query 
is executed using tool 'executeSQLquery' and then results returned as response to the user.

*/
-- ==================
--  Tool-1: executeSQLquery
--  Tool Description: Get all the data from PostgreSQL, make sure you append the tables with correct schema. 
--  Every table is associated with some schema in the database.
--  Query: {{ $fromAI("sql_query", "SQL Query") }}
--==================

--==================
-- Tool-2: getDBSchema
-- Tool Description: Get list of all tables with their schema in the database
-- Query:
SELECT 
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE'
    AND table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY table_schema, table_name;
--==================

--==================
-- Tool-3: getTableStructure
-- Tool Description: Get table definition to find all columns and types
-- Query:
SELECT 
    c.column_name, 
    c.data_type, 
    c.is_nullable, 
    c.column_default,
    tc.constraint_type,
    ccu.table_name AS referenced_table,
    ccu.column_name AS referenced_column
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage kcu 
    ON c.table_name = kcu.table_name 
    AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc 
    ON kcu.constraint_name = tc.constraint_name 
    AND tc.constraint_type = 'FOREIGN KEY' -- Filters for FKs specifically
LEFT JOIN information_schema.constraint_column_usage ccu 
    ON tc.constraint_name = ccu.constraint_name
WHERE c.table_name = '{{ $fromAI("table_name") }}'
  AND c.table_schema = '{{ $fromAI("schema_name") }}'
ORDER BY c.ordinal_position;
--==================

-- BB Following databas and tables are used in the experiment
--		To create a role: kumar, database kumar with two samples table
/*
sudo useradd -m -s /bin/bash kumar
sudo su kumar
cd
psql kumar
kumar=> \c kumar
*/
-- You are now connected to database "kumar" as user "kumar".
CREATE TABLE acars (  brand VARCHAR(255), model VARCHAR(255),year INT);
INSERT INTO acars (brand, model, year) VALUES ('Dzire','Maruti', 1994);
INSERT INTO acars (brand, model, year) VALUES ('Swift','Maruti', 1984);
select * from acars ;


CREATE TABLE departments (
		    		department_id int PRIMARY KEY,
		    		department_name VARCHAR(100) NOT NULL
			);

CREATE TABLE employees (
			    employee_id int PRIMARY KEY,
        	            employee_name VARCHAR(100) NOT NULL,
                	    age float,
			    departmentId INT REFERENCES departments (department_id)
		    );
	

INSERT INTO departments (department_id,department_name) values
(1, 'Human Resources'),
(10,'Finance'),
(20,'IT'),
(30, 'Operations') ;

INSERT INTO employees (employee_id,employee_name, age, departmentId) values
(1,'Alice', 30.4,10),
(2,'Bob',50.8,10),
(3,'sudha', 39.0,20),
(4,'Charlie',34.0,30),
(5,'Amrit',36.90,20),
(6,'Kavita',23.0,1),
(7,'tirth',45.5,1);


-- Get Table Definition
-- ==================
-- WRONG code
-- See correct code above

select
  c.column_name,
  c.data_type,
  c.is_nullable,
  c.column_default,
  tc.constraint_type,
  ccu.table_name AS referenced_table,
  ccu.column_name AS referenced_column
from
  information_schema.columns c
LEFT join
  information_schema.key_column_usage kcu
  ON c.table_name = kcu.table_name
  AND c.column_name = kcu.column_name
LEFT join
  information_schema.table_constraints tc
  ON kcu.constraint_name = tc.constraint_name
  AND tc.constraint_type = 'FOREIGN KEY'
LEFT join
  information_schema.constraint_column_usage ccu
  ON tc.constraint_name = ccu.constraint_name
where
  c.table_name = '{{ $fromAI("table_name") }}'
  AND c.table_schema = '{{ $fromAI("schema_name") }}'
order by
  c.ordinal_position ;

