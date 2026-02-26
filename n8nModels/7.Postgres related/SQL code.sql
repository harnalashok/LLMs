--SQL code
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
