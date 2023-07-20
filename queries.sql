--this query counts the amount of customers
select count(customer_id) as customers_count
from customers
;

--this query counts top 10 total income
select 
	   concat(e.first_name||' '||e.last_name) as name,
	   count(s.sales_id) as operations,
	   floor(sum(quantity*price)) as income
from sales as s
	left join products as p 
	on s.product_id = p.product_id
	left join employees as e 
	on s.sales_person_id = e.employee_id
group by concat(e.first_name||' '||e.last_name)
order by income desc
limit 10
;

--this query counts lowest average income
with tab as (
select sales_id,
	   concat(e.first_name||' '||e.last_name) as name1,
	   quantity,
	   p.price,
	   quantity*price as income,
	   sale_date,
	   s.product_id,
	   p.name
from sales as s
	left join products as p 
	on s.product_id = p.product_id
	left join employees as e 
	on s.sales_person_id = e.employee_id
order by sales_person_id
), tab2 as(
	select avg(income) as avg_gen 
	from tab
),
tab3 as (
	select distinct name1 as name,
	       round(avg(income)) as average_income
from tab
group by name1
order by average_income)

select *
from tab3
where average_income < (select round(avg(income)) from tab)
;

--this query counts day of the week income
with tab as (
select sales_id,
	   concat(e.first_name||' '||e.last_name) as name1,
	   quantity,
	   p.price,
	   quantity*price as income,
	   sale_date,
	   extract (isodow from sale_date) as day_number,
	   to_char(sale_date,'day') as weekday,
	   s.product_id,
	   p.name
from sales as s
	left join products as p 
	on s.product_id = p.product_id
	left join employees as e 
	on s.sales_person_id = e.employee_id
order by sale_date)

select name1 as name,
	   weekday,
	   round(sum(income)) as income
from tab
group by day_number,weekday,name1
order by day_number,name1; 
   
--this query shows age groups
select 
	(case 
		when age <= 25 then '16-25'
	   	when age > 25 and age <= 40 then '26-40'
	   	else '40+'
	 end) as age_category,
	 count (customer_id) as count
from customers
group by age_category
order by count
;

--this query shows customers by month


select 
	   to_char(sale_date, 'YYYY-MM') as date,
	   count(distinct s.customer_id) as total_customers,
	   floor(sum(s.quantity*p.price)) as income
from sales as s
left join customers as c
on s.customer_id = c.customer_id
left join products as p
on s.product_id = p.product_id
group by date
;


--this query shows first special offer customers

select 
	distinct on (concat (c.first_name||' '||c.last_name)) concat (c.first_name||' '||c.last_name) as customer,
	sale_date,
	concat(e.first_name||' '||e.last_name) as seller
from sales as s
left join customers as c 
	on s.customer_id = c.customer_id 
left join products as p
	on s.product_id = p.product_id 
left join employees as e 
	on s.sales_person_id = e.employee_id
where price = 0
order by customer, sale_date
;  
