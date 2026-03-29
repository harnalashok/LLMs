-- AA. SQL code Generation by AI agent
-- 		The following two pieces of code are used in two tool branches by the AI agent
-- 		One gets which tables are present and the other gets information of columns for each table

-- Get list of Schema and Tables
-- =============
{{ $fromAI("sql_query", "SQL Query") }}

-- Gets db schema	
SELECT 
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE'
    AND table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY table_schema, table_name;

-- Get Table Definition
-- ==================
-- WRONG code
-- See correct code below

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

-- Correct code: This code is correct AND not the above one

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


--BB Following databas and tables are used in the experiment
--		To create a role: kumar, database kumar with two samples table

$sudo su kumar
$psql kumar
kumar=> \c kumar
You are now connected to database "kumar" as user "kumar".
kumar=> CREATE TABLE acars (  brand VARCHAR(255), model VARCHAR(255),year INT);
kumar=> INSERT INTO acars (brand, model, year) VALUES ('Dzire','Maruti', 1994);
kumar=> INSERT INTO acars (brand, model, year) VALUES ('Swift','Maruti', 1984);
kumar=> select * from acars ;


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
(1,'Alice', 30.4, 10),
(2,'Bob',50.8, 10),
(3,'sudha', 39.0, 20),
(4,'Charlie',34.0, 30);


