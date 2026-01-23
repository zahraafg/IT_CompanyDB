use IT_CompanyDB;

/* 🔹 1. SADƏ SELECT / WHERE

Sual 1
Bütün işçilərin full_name və salary-ni göstər. */

select full_name, salary
from Employees;


/* Sual 2
Maaşı 2000-dən böyük olan işçilərin adını tap. */

select full_name
from Employees e
where salary > 2000;


/* Sual 3
department_id = 1 olan işçiləri tap. */

select full_name
from Employees e
where e.department_id = 1;


/* 🔹 2. ORDER BY

Sual 4
İşçiləri maaşa görə artan sıra ilə göstər. */

select full_name
from Employees 
order by salary asc;


/* Sual 5
İşçiləri hire_date-ə görə ən yeni işçilər yuxarıda olacaq şəkildə sırala. */
select full_name, hire_date
from Employees 
order by hire_date desc;


/* 🔹 3. GROUP BY + AGGREGATE

Sual 6
Hər department üzrə işçi sayını tap. */

select DISTINCT d.department_name, COUNT(e.department_id) as count_dep
from Employees e
join Departments d
on d.id = e.department_id
group by d.department_name;


/* Sual 7
Hər department üzrə ortalama maaşı tap. */

select DISTINCT d.department_name, AVG(e.salary) as avg_salary
from Employees e
join Departments d
on d.id = e.department_id
group by d.department_name;


/* Sual 8
Ən yüksək maaş neçədir? */

select MAX(salary)
from Employees e;


/* 🔹 4. GROUP BY + HAVING

Sual 9
Ortalama maaşı 1500-dən böyük olan departmentləri tap. */

select d.department_name, AVG(salary) as avg_salary
from Departments d
join Employees e
on d.id = e.department_id
group by d.department_name
having AVG(salary) > 1500;


/* Sual 10
İşçi sayı 1-dən çox olan departmentləri tap. */

select d.department_name, COUNT(e.department_id) as count_emp
from Departments d
join Employees e
on d.id = e.department_id
group by d.department_name
having COUNT(e.department_id) > 1;


/* 🔹 5. JOIN (INNER JOIN)

Sual 11
İşçilərin adını və onların department_name-ni göstər. */

select full_name, d.department_name
from Employees e
join Departments d
on d.id = e.department_id;


/* Sual 12
İşçilərin adını və position_name-ni göstər. */

select full_name, p.position_name
from Employees e
join Positions p
on p.id = e.position_id;


/* Sual 13
Hansı işçi hansı layihədə (project_name) işləyir? */

select e.full_name, p.project_name
from Projects p
join Assignments a
on p.id = a.project_id
join Employees e
on e.id = a.employee_id;


/* 🔹 6. WHERE + JOIN

Sual 14
Backend departmentində işləyən işçilərin adını tap. */

select full_name, d.department_name
from Employees e
join Departments d
on d.id = e.department_id
where d.department_name = 'Backend';


/* Sual 15
Büdcəsi 50000-dən böyük olan layihələrdə işləyən işçiləri tap. */

select e.full_name, project_name
from Projects p
join Assignments a
on p.id = a.project_id
join Employees e
on e.id = a.employee_id
where budget > 50000;


/* 🔹 7. SUBQUERY – SINGLE ROW (WHERE)

Sual 16
Ən yüksək maaşı alan işçinin adını tap. */

select full_name
from Employees e
where salary = (
	select MAX(salary)
	from Employees e
	);


/* Sual 17
Ortalama maaşdan yüksək maaş alan işçilərin adını tap. */

select full_name
from Employees e
where salary > (
	select AVG(salary)
	from Employees e
	);


/* 🔹 8. SUBQUERY – MULTI ROW (IN)

Sual 18
Hər hansı layihədə işləyən işçilərin adını tap. */

select full_name
from Employees e
where id in (
	select a.employee_id
	from Assignments a
	join Projects p
	on p.id = a.project_id
	);


/* Sual 19
Büdcəsi 30000-dən böyük olan layihələrdə işləyən işçiləri tap. */

select full_name
from Employees e
where id in (
	select a.employee_id
	from Assignments a
	join Projects p
	on p.id = a.project_id
	where budget > 30000
	);


/* 🔹 9. EXISTS / NOT EXISTS

Sual 20
Sifarişi (order) olan müştərilərin company_name-ni tap. */

select company_name
from Customers c
where exists (
	select 1
	from Orders o
	);


/* Sual 21
Heç bir sifarişi olmayan müştəriləri tap. */

select company_name
from Customers c
where not exists (
	select 1
	from Orders o
	where o.customer_id = c.id
	);


/* Sual 22
Heç bir layihədə işləməyən işçiləri tap. */

select full_name
from Employees e
where not exists (
	select 1
	from Assignments a
	join Projects p
	on p.id = a.project_id
	where e.id = a.employee_id
	);


/* 🔹 10. REAL İMTAHAN TIPLI

Sual 23
Ödənişi (Payments) olan sifarişləri verən müştəriləri tap. */

select company_name
from Customers c
where exists (
	select o.customer_id
	from Orders o
	join Payments p
	on p.order_id = o.id
	where c.id = o.customer_id
	);


/* Sual 24
Gündə 8 saatdan çox işləyən işçilərin adını tap. */

select full_name
from Employees e
where exists (
	select a.employee_id
	from Attendance a
	where a.employee_id = e.id
	and hours_worked > 8
	);


/* Sual 25
Ən çox maaş alan department-in adını tap. */

select top 1 department_name, MAX(salary) as max_salary
from Departments d
join Employees e
on e.department_id = d.id
group by d.department_name
order by MAX(salary) desc;

--OR

select d.department_name
from Departments d
join Employees e
on e.department_id = d.id
group by d.department_name
having MAX(e.salary) = (
	select MAX(salary)
	from Employees
);
