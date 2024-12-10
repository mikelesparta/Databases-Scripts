--1. Last_name, job, salary, and commission_pct of those employees that DO earn commissions.
--Results should be ordered by job ascendingly and by salary descendingly.
--commision_pct exits
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NOT null
ORDER BY salary DESC, job_id;

--2. Employees with last_name beginning with J, K, L or M.
SELECT last_name
FROM employees
WHERE last_name LIKE 'J%' OR last_name LIKE 'K%' 
OR last_name LIKE 'L%' OR last_name LIKE 'M%';

SELECT last_name
FROM employees
WHERE SUBSTR(last_name,0,1) IN ('J', 'K', 'L', 'M'); --field, pos where it starts, ends

--3. Show last_name, employee_id of employees, together with last_name, employee_id of their
--managers.
SELECT e.last_name, e.employee_id, m.last_name as manager_last_name, m.employee_id as manager_id
FROM employees e, employees m
WHERE e.manager_id = m.employee_id;

--4. Last_name and hire_date for employees hired after employee ‘Davies’.
SELECT e.last_name, e.hire_date
FROM employees e, employees d
WHERE e.hire_date > d.hire_date AND d.last_name = 'Davies';

--5. Last_name and hire_date of employees hired before their managers. Show the last_name and
--hire_date of their managers as well.
SELECT e.last_name, e.employee_id
FROM employees e, employees m
WHERE e.manager_id = m.employee_id and m.hire_date > e.hire_date;

--6. Department id, and minimum salary of departments with the greatest average salary.
SELECT department_id, min(salary) as min_salary
FROM employees
GROUP BY department_id HAVING avg(salary) >= ALL(SELECT avg(salary) 
FROM employees GROUP BY department_id);

--7. Department id, name, and location for departments where there are no ‘SA_REP’ (job_id)
--employees working.
SELECT department_id, department_name, NVL(manager_id,0), location_id --SELECT *
FROM departments 
WHERE department_id NOT IN(SELECT department_id FROM employees WHERE job_id='SA_REP' );

--8. Department id, name, and number of employees working at it for departments having: a) less
--than 3 employees, b) the maximum number of employees, c) the minimum number of
--employees.


--9. Job title (job_id) that was fulfilled (hire_date) in the first half of 1990, and also in the first half
--of 1991.
(SELECT job_id
FROM employees
WHERE hire_date BETWEEN '01/01/90' AND '30/06/90')
INTERSECT
(SELECT job_id
FROM employees
WHERE hire_date BETWEEN '01/01/91' AND '30/06/91');

--10. Show the top 3 employees that earn the most.
SELECT *
FROM (SELECT last_name, salary
FROM employees
ORDER BY salary DESC)
WHERE rownum <= 3;

SELECT last_name, salary
FROM employees e
WHERE 3 > (SELECT count(*) FROM employees WHERE e.salary < salary);

--11. Employee_id and surname of employees that work in the state of California.
SELECT employee_id, last_name
FROM employees e
WHERE (SELECT location_id FROM departments d WHERE e.department_id=d.department_id) 
IN (SELECT location_id FROM locations WHERE state_province='California'); 

--12. The salary of employees working in a job whose minimum wage (min_salary) is 4,200 must be
--increased by 15%.
UPDATE employees SET salary = salary * 1.15
WHERE job_id IN (SELECT job_id FROM jobs WHERE min_salary = 4200);
