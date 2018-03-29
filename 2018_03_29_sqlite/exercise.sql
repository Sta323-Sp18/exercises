SELECT * FROM employees;


# Step 1
SELECT ROUND(AVG(salary),2) AS avg_salary, dept FROM employees GROUP BY dept;

# Step 2

SELECT * FROM employees NATURAL JOIN (SELECT ROUND(AVG(salary),2) AS avg_salary, dept FROM employees GROUP BY dept);

SELECT *, salary - avg_salary AS abv_avg FROM employees NATURAL JOIN (SELECT ROUND(AVG(salary),2) AS avg_salary, dept FROM employees GROUP BY dept);