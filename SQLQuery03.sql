CREATE DATABASE IT_CompantDB;

USE IT_CompanyDB;

/* 50 PRAKTİK SQL SUALI (ORTA–ÇƏTİN)


1. SELECT / WHERE / FILTER

Maaşı 3000–7000 arası olan işçiləri tap */

select full_name
from Employees 
where salary between 3000 and 7000;


/* Adı A hərfi ilə başlayan işçilər */

select full_name
from Employees 
where full_name like 'a%';


/* Maaşı 4000-dən az və department_id ≠ 3 */

select full_name
from Employees 
where salary < 4000
and department_id <> 3;


/* Son 3 ildə işə girən işçilər */

select full_name
from Employees
where hire_date >= DATEADD(YEAR, -3, GETDATE());


/* Department_id IN (1,2,4) olanlar */

select full_name, department_id
from Employees
where department_id in (1, 2, 4);


/* Maaşı NULL olmayan işçilər */

select full_name, salary
from Employees
where salary is not null;


/* Maaşı 5000-dən böyük və ya department_id = 2 */

select full_name, salary, department_id
from Employees
where salary > 5000 or department_id = 2;


/* Adında “ov” olan işçilər */

select full_name
from Employees
where full_name like '%ov%';


/* Maaşı 2-ci və 3-cü min aralığında olanlar */

select full_name, salary
from Employees
where salary between 1000 and 3000;


/* Ən son işə girən 5 işçi */

select top 5 full_name, hire_date
from Employees
order by hire_date desc;


/* 2. ORDER BY / TOP

Maaşa görə azalan sırala */

select full_name, salary
from Employees
order by salary desc;


/* Department_id-ə görə artan, maaşa görə azalan */

select full_name, department_id, salary
from Employees
order by department_id asc, salary desc;


/* Ən yüksək maaş alan 3 işçi */

select top 3 full_name, salary
from Employees
order by salary desc;


/* Ən köhnə 5 işçi */

select top 5 full_name, hire_date
from Employees
order by hire_date asc;


/* Maaşı ən az olan 1 işçi */

select top 1 full_name, salary
from Employees
order by salary asc;


/* 3. AGGREGATION / GROUP BY / HAVING

Hər department üzrə orta maaş */

select department_id, AVG(salary) as avg_salary
from Employees
group by department_id;


/* Hər department üzrə işçi sayı */

select department_id, COUNT(*) as count_emp
from Employees
group by department_id;


/* Orta maaşı 5000-dən böyük olan departmentlər */

select department_id, AVG(salary) as avg_salary
from Employees
group by department_id
having AVG(salary) > 5000;

select e.full_name, e.department_id, d.avg_salary
from Employees e
join (
    select department_id, AVG(salary) as avg_salary
    from Employees
    group by department_id
) d
on e.department_id = d.department_id
where d.avg_salary > 5000;


/* Minimum maaş alan işçilərin olduğu departmentlər */

select department_id, MIN(salary) as min_salary
from Employees
group by department_id;


/* İşçi sayı 3-dən çox olan departmentlər */

select department_id, count(*) as count_emp
from Employees
group by department_id
having count(*) > 3;


/* Maksimum maaş > 8000 olan departmentlər */

select department_id, MAX(salary) as max_salary
from Employees
group by department_id
having MAX(salary) > 8000;


/* Hər department üçün MAX və MIN maaş */

select department_id, MAX(salary) as max_salary, MIN(salary) as min_salary
from Employees
group by department_id;


/* Orta maaşı ümumi orta maaşdan böyük olan departmentlər */

select e.full_name, e.department_id, e.salary
from Employees e
join (
    select department_id, AVG(salary) as avg_salary
    from Employees
    group by department_id
) d
on e.department_id = d.department_id
where e.salary > d.avg_salary;


/* 4. JOIN (INNER / LEFT / RIGHT / SELF)

İşçi adı + department adı */

select full_name, department_name
from Employees e
join Departments d
on e.department_id = d.id;


/* Departmenti olmayan işçilər */

select full_name
from Employees e
left join Departments d
on e.department_id = d.id
where d.id is null;


/* İşçisi olmayan departmentlər */

select department_name
from Departments d
left join Employees e
on e.department_id = d.id
where e.id is null;


/* İşçilər + iştirak etdikləri layihələr */

select full_name
from Employees e
join Assignments a
on e.id = a.employee_id;


/* Heç bir layihədə işləməyən işçilər */

select full_name
from Employees e
left join Assignments a
on e.id = a.employee_id
where a.project_id is null;


/* Layihəsi olmayan departmentlər */

select distinct d.department_name
from Departments d
left join Employees e
 on e.department_id = d.id
left join Assignments a
 on e.id = a.employee_id
left join Projects p
on a.project_id = p.id
where p.id is null;


/* Eyni department-də işləyən işçiləri self join ilə tap */

select e.full_name as emp1, e2.full_name as emp2
from Employees e
join Employees e2
on e.department_id = e2.department_id
and e.id <> e2.id;


/* 5. SUBQUERY – WHERE

Orta maaşdan çox alan işçilər */

select full_name
from Employees 
where salary > (
	select avg(salary) as avg_salary
	from Employees 
	);


/* Ən yüksək maaşı alan işçi(lər) */

select full_name
from Employees
where salary = (
	select MAX(salary)
	from Employees
	);


/* Maaşı department üzrə maksimum olanlar */

select full_name
from Employees e
where salary = (
	select MAX(salary)
	from Employees e2
	where e.department_id = e2.department_id
	);


/* Heç bir layihədə işləməyən işçilər (NOT EXISTS) */

select full_name
from Employees e
where not exists (
	select 1
	from Assignments a
	where e.id = a.employee_id
	);


/* Project-də işləyən işçilər (EXISTS) */

select full_name
from Employees e
where exists (
	select 1
	from Assignments a
	where a.employee_id = e.id
	);


/* Maaşı ANY department üzrə orta maaşdan böyük olanlar */

select full_name
from Employees e
where salary > (
	select AVG(salary)
	from Employees e2
	where e.department_id = e2.department_id
	);


-- ANY nümunəsi
select full_name, salary
from Employees e
where salary > ANY (
    select salary
    from Employees
    where department_id = 2
);


/* Maaşı ALL department orta maaşlarından böyük olan işçilər */

select full_name
from Employees e
where salary > (
	select AVG(salary)
	from Employees e2
	where e.department_id = e2.department_id
	);


-- ALL nümunəsi
select full_name, salary
from Employees e
where salary > ALL (
    select salary
    from Employees
    where department_id = 2
);


/* 6. SUBQUERY – SELECT

İşçi adı + department üzrə maksimum maaş */

select full_name,
	(select MAX(salary) 
	from Employees e2
	where e.department_id = e2.department_id) as max_salary
from Employees e;


/* İşçi adı + işlədiyi layihə sayı */

select full_name,
	(select COUNT(a.project_id) 
	from Assignments a
	where a.employee_id = e.id) as count_pro
from Employees e;


/* İşçi + department üzrə orta maaş fərqi */

select full_name, 
   salary - (select AVG(salary)
			from Employees e2
			where e.department_id = e2.department_id) as salary_diff
from Employees e;


/* 7. SUBQUERY – FROM

Department üzrə orta maaş cədvəli yaradıb üzərindən SELECT et */

select department_id, sub.avg_salary
from (
	(select department_id, AVG(salary) as avg_salary 
	from Employees e
	group by department_id) 
) sub;


/* Department + işçi sayı olan subquery yaz */

select employee_id, sub.count_emp
from (
	select employee_id, COUNT(a.employee_id) as count_emp
	from Assignments a
	group by employee_id
) sub;


/* Project üzrə ümumi maaş xərci olan subquery */

select sub.project_id, sub.total_salary
from (
    select a.project_id, SUM(e.salary) as total_salary
    from Assignments a
    join Employees e
        on a.employee_id = e.id
    group by a.project_id
) sub;


/* 8. WITH (CTE)

WITH ilə department orta maaşlarını çıxar */

with sub as (
	select department_id, AVG(salary) as avg_salary
	from Employees e
	group by department_id
	)
select full_name, salary, avg_salary
from Employees e2
join sub as s
on e2.department_id = s.department_id
and e2.salary = s.avg_salary;


/* Orta maaşı ümumi ortadan böyük olan departmentlər (WITH) */

with sub as (
	select department_id, AVG(salary) as avg_salary
	from Employees e
	group by department_id
	)
select full_name, salary, avg_salary
from Employees e2
join sub s
on e2.department_id = s.department_id
and e2.salary > s.avg_salary;


/* Project üzrə işçi sayı (WITH) */

with sub as (
	select a.employee_id, COUNT(a.employee_id) as cont_emp
	from Assignments a
	group by a.employee_id
	)
select employee_id, cont_emp
from sub s;


/* 9. CASE

Maaşa görə işçiləri kateqoriyaya böl

<3000 → Low

3000–6000 → Medium

6000 → High */

select e.full_name, e.salary,
	case
		when salary < 3000 then 'Low'
		when salary between 3000 and 6000 then 'Medium'
		else 'High'
	end as level
from Employees e;


/* Department_id-ə görə department adı çıxar (CASE) */

select full_name, department_id,
    case department_id
        when 1 then 'HR'
        when 2 then 'IT'
        when 3 then 'Finance'
        when 4 then 'Marketing'
        else 'Other'
    end as department_name
from Employees;


/* İşçi layihədə işləyirsə “Active”, yoxdursa “Idle” yaz */

select e.full_name,
	case 
		when a.employee_id is not null then 'Active'
		else 'Idle'
	end as project_status
from Employees e
left join Assignments a
on a.employee_id = e.id;


/* Maaşı department orta maaşından böyükdürsə “Above Avg” yaz */

select e.full_name, e.salary,
    case 
        when e.salary > d.avg_salary then 'Above Avg'
        else 'Below Avg'
    end as salary_comparison
from Employees e
join (
    select department_id, AVG(salary) as avg_salary
    from Employees
    group by department_id
) d
on e.department_id = d.department_id;
