--this query counts the amount of customers
select count(customer_id) as customers_count
from customers
;

--this query counts top 10 total income
with tab as (
select sales_id,
	   concat(e.first_name||' '||e.last_name) as name1,
	   quantity,
	   p.price,
	   quantity*price as sale_amount,
	   sale_date,
	   s.product_id,
	   p.name
from sales as s
	left join products as p 
	on s.product_id = p.product_id
	left join employees as e 
	on s.sales_person_id = e.employee_id
order by sales_person_id)

select name1 as name,
	   count(sales_id) as operations,
	   sum(sale_amount) as income
from tab
group by name1
order by income desc
limit 10;

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
order by sales_person_id)

select name1 as name,
	   round(avg(income)) as average_income
from tab
group by name1
order by average_income
;

--this query counts day of the week income
with tab as (
select sales_id,
	   concat(e.first_name||' '||e.last_name) as name1,
	   quantity,
	   p.price,
	   quantity*price as income,
	   sale_date,
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
	   sum(income)
from tab
group by sale_date,weekday,name1
order by sale_date,weekday,name1;
	   
