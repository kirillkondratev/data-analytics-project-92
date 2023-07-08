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
	   
--this query shows age groups
with tab as (
select *,
	   (case when age <= 25 then '16-25'
	   when age > 25 and age <= 40 then '26-40'
	   else '40+'
	   end) as age_category
from customers
order by age asc)

select age_category,
	   count(age)
from tab
group by age_category
order by age_category;

--this query shows customers by month

with tab as (

select sales_id,
	   sale_date,
	   to_char(sale_date, 'YYYY-MM') as date,
	   concat(c.first_name||' '||c.last_name) as customers_name,
	   s.quantity*p.price as income
from sales as s
left join customers as c
on s.customer_id = c.customer_id
left join products as p
on s.product_id = p.product_id
order by sale_date

)

select date,
	   count(distinct customers_name) as total_customers,
	   sum(income) as income
from tab
group by date
;

--this query shows first special offer customers

with tab as (
select c.customer_id,
	   concat (c.first_name||' '||c.last_name) as customer,
	   sale_date,
	   p.name,
	   price,
	   concat(e.first_name||' '||e.last_name) as seller
from sales as s
left join customers as c 
	on s.customer_id = c.customer_id
left join products as p
	on s.product_id = p.product_id
left join employees as e
	on s.sales_person_id = e.employee_id
order by customer_id, sale_date
), tab2 as (

select customer_id,
	   customer,
	   sale_date,
	   seller,
	   first_value (price) over (partition by customer) as f_v,
	   first_value (sale_date) over (partition by customer order by sale_date) as s_d
from tab
order by customer_id, sale_date
)
select distinct on 
	   (customer) customer,
	   s_d as sale_date,
	   seller
from tab2
where f_v = 0
order by customer
;
	   
