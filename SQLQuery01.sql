CREATE DATABASE IT_CompanyDB;
GO
USE IT_CompanyDB;
GO

/* TASK 1

Bütün işçilərin adını və maaşını çıxart. */

select full_name, salary 
from Employees;


/* TASK 2

Maaşı 1500-dən böyük olan işçiləri tap. */

select full_name
from Employees
where salary > 1500;


/* TASK 3

2023-cü ildən sonra işə başlayan işçilərin siyahısı. */

select full_name, hire_date 
from Employees
where hire_date >= '2023-01-01';


/* TASK 4

Ən yüksək maaş alan 2 işçini tap. */

select top 2 full_name, salary
from Employees
order by salary desc;


/* TASK 5

Email-i @company.com ilə bitən işçiləri tap. */

select full_name, email, salary 
from Employees
where email like '%@company.com';


/* TASK 6

Maaşı 1000 ilə 2500 arasında olan işçiləri artan sırayla göstər. */

select full_name, salary
from Employees
where salary between 1000 and 2500 
order by salary asc;


/* TASK 7

Department_id-si 1 və ya 2 olan işçiləri tap. */

select full_name, department_id
from Employees 
where department_id in (1, 2);


/* TASK 8

Ən köhnə işçi (ən əvvəl işə başlayan). */

select top 1 full_name, hire_date
from Employees
order by hire_date asc;


/* TASK 9

Adı “A” hərfi ilə başlayan işçilər. */

select full_name
from Employees
where full_name like 'a%';


/* TASK 10

Maaşı NULL OLMAYAN işçilər. */

select full_name, salary
from Employees 
where salary is not null;


/* TASK 11 – INNER JOIN

Bütün işçilərin adını və işlədikləri department adını çıxart. */

select e.full_name, d.department_name
from Employees e
join Departments d
on d.id = e.department_id;


/* TASK 12 – JOIN + WHERE

Maaşı 1500-dən böyük olan işçilərin adını və department adını tap. */

select e.full_name, d.department_name, e.salary
from Employees e
join Departments d
on e.department_id = d.id
where salary > 1500;


/* TASK 13 – GROUP BY + COUNT

Hər department-də neçə işçi var? */

select department_name, COUNT(e.id) count_emp
from Departments d
join Employees e
on e.department_id = d.id
group by department_name;


/* TASK 14 – HAVING

Hər department-də 1-dən çox işçi olanları göstər. */

select department_name, COUNT(e.id) count_emp
from Departments d
join Employees e
on e.department_id = d.id
group by department_name
having COUNT(e.id) > 1;


/* TASK 15 – JOIN + GROUP BY + SUM

Hər project-in ümumi büdcəsini və neçə işçi işlədiyini göstər. */

select p.project_name, COUNT(a.employee_id) as count_emp, SUM(p.budget) as sum_budget
from Projects p
join Assignments a
on p.id = a.project_id
group by p.project_name;


/* TASK 16 – SUBQUERY

Hansı işçilərin maaşı bütün şirkət maaşlarından yüksəkdir? */

select full_name
from Employees e
where salary > (
	select AVG(salary) as avg_salary
	from Employees
);


/* TASK 17 – JOIN + SUBQUERY

Hansı işçilər E-Government System layihəsində işləyir? */

select e.full_name, p.project_name
from Employees e
join Assignments a
on e.id = a.employee_id
join Projects p
on p.id = a.project_id
where p.project_name = 'E-Government System';


/* TASK 18 – ORDER + JOIN

Hər işçinin department və position-ını çıxart, maaşa görə azalan sırayla. */

select e.full_name, e.salary, d.department_name, p.position_name
from Employees e
join Departments d
on e.department_id = d.id
join positions p
on p.id = e.position_id
order by salary desc;


