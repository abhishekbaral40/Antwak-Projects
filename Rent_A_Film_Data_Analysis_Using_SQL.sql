-- 1. We want to run an Email Campaigns for customers of Store 2 (First, Last name,and Email address of customers from Store 2)

SELECT C.FIRST_NAME,C.LAST_NAME,C.EMAIL FROM customer C
INNER JOIN store S ON C.STORE_ID=S.STORE_ID
AND C.STORE_ID=2;

-- 2. List of the movies with a rental rate of 0.99$

select  distinct f.film_id ,f.title ,p.amount from payment p
inner join rental r on r.rental_id = p.rental_id
inner join inventory i on i.inventory_id = r.inventory_id
inner join film f on f.film_id = i.film_id 
where p.amount =0.99

-- 3. Your objective is to show the rental rate and how many movies are in each rental rate categories

select f.rental_rate ,count(f.title) as from rental r 
inner join inventory i on i.inventory_id = r.inventory_id 
inner join film f on f.film_id = i.film_id
group by f.rental_rate 

-- 4. Which rating do we have the most films in?

select film_id ,title from film where rating in
(select y.rating from
(select rating,count(*) as rating_count from film  group by rating order by count(*) desc limit 1)y )


-- 5. Which rating is most prevalent in each store?

select s.store_id , max(f.rating) as most_prevalent from film f 
inner join inventory i on i.film_id = f.film_id 
inner join store s on s.store_id = i.store_id 
group by s.store_id 


-- 6. We want to mail the customers about the upcoming promotion

select c.customer_id ,c.first_name ,c.last_name ,c.email from customer c 

-- 7. List of films by Film Name, Category, Language

select distinct f.title as Film_Name,c.name as Category,l.name as Language from film f
inner join film_category fc on fc.film_id = fc.film_id
inner join category c on c.category_id = fc.category_id 
inner join language l on l.language_id = f.language_id 


-- 8. How many times each movie has been rented out?

select f.title ,count(i.film_id) as rental_count from inventory i 
inner join rental r on r.inventory_id = i.inventory_id 
inner join film f on f.film_id = i.film_id 
group by i.film_id


-- 9. What is the Revenue per Movie?

select f.title,sum(p.amount) as revenue from payment p 
inner join rental r on r.rental_id = p.rental_id 
inner join inventory i on i.inventory_id = r.inventory_id 
inner join film f on f.film_id = i.film_id
group by f.title

-- 10.Most Spending Customer so that we can send him/her rewards or debate points

select c.first_name , c.last_name ,p.customer_id,sum(p.amount) as amount_spent from payment p 
inner join customer c on c.customer_id = p.customer_id 
group by p.customer_id order by amount_spent desc limit 1


-- 11. What Store has historically brought the most revenue?

select s.store_id , sum(p.amount) as revenue from store s 
inner join staff s2 on s2.store_id = s.store_id 
inner join payment p on p.staff_id = s2.staff_id 
group by s.store_id order by revenue desc limit 1


-- 12.How many rentals do we have for each month?


select MONTHNAME(r.rental_date) as rental_month ,count(EXTRACT(MONTH FROM r.rental_date)) as rentals from rental r 
group by rental_month 


-- 13.Rentals per Month (such Jan => How much, etc)

select MONTHNAME(r.rental_date) as month_name,count(MONTHNAME(r.rental_date)) as rentals,sum(p.amount) as revenue from rental r 
inner join payment p on p.rental_id = r.rental_id 
group by month_name

-- 14.Which date the first movie was rented out?

select f.film_id ,f.title , r.rental_date from film f 
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id 
order by f.film_id ,f.title ,r.rental_date  limit 1



-- 15.Which date the last movie was rented out?

select f.film_id ,f.title , r.rental_date from film f 
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id 
order by f.film_id desc,f.title desc,r.rental_date desc limit 1


-- 16.For each movie, when was the first time and last time it was rented out?

select f.film_id ,f.title , min(r.rental_date) as first_time , max(r.rental_date) as last_time from rental r 
inner join inventory i on i.inventory_id = r.inventory_id 
inner join film f on f.film_id = i.film_id 
group by f.film_id 

-- 17.What is the Last Rental Date of every customer?

select max(r.rental_date) as last_rental_date , r.customer_id from rental r 
group by  r.customer_id 

-- 18.What is our Revenue Per Month?

select sum(p.amount) as revenue , MONTHNAME(p.payment_date) as month from payment p 
group by month 

-- 19.How many distinct Renters do we have per month?

select MONTHNAME(r.rental_date) as month_name,count(MONTHNAME(r.rental_date)) as renters from rental r 
group by month_name


-- 20.Show the Number of Distinct Film Rented Each Month

select MONTHNAME(r.rental_date) as month_name , count(distinct f.film_id) as distinct_film from rental r 
inner join inventory i on r.inventory_id = i.inventory_id 
inner join film f on f.film_id = i.film_id 
group by month_name



-- 21.Number of Rentals in Comedy, Sports, and Family

select c.name , count(c.name) as rentals from rental r 
inner join inventory i on i.inventory_id = r.inventory_id 
inner join film f on f.film_id = i.film_id 
inner join film_category fc on fc.film_id = f.film_id 
inner join category c on c.category_id = fc.category_id 
group by c.name having c.name in ('Comedy','Sports','Family')


-- 22.Users who have been rented at least 3 times

select c.customer_id , count(c.customer_id) from customer c 
inner join rental r on r.customer_id = c.customer_id 
group by r.customer_id 

-- 23.How much revenue has one single store made over PG13 and R-rated films?

select  s.store_id ,sum(p.amount) as revenue from payment p
inner join rental r on p.rental_id = r.rental_id 
inner join inventory i on i.inventory_id = r.inventory_id 
inner join store s on s.store_id = i.store_id 
inner join film f on f.film_id = i.film_id 
where f.rating in ('PG-13','R')
group by s.store_id 

-- 24.Active User where active = 1

SELECT * FROM customer c WHERE c.active =1

-- 25.Reward Users: who has rented at least 30 times

select c.customer_id , count(c.customer_id) as reward_users from rental r 
inner join customer c on c.customer_id = r.customer_id
group by c.customer_id  having reward_users>=30

-- 26.Reward Users who are also active

select c.first_name ,c.last_name ,c.customer_id  from rental r 
inner join customer c on c.customer_id = r.customer_id and c.active =1
group by c.customer_id  having count(c.customer_id)>=30 

-- 27.All Rewards Users with Phone

select c.customer_id , a.phone , a.address_id  from rental r 
inner join customer c on c.customer_id = r.customer_id
inner join address a on a.address_id = c.address_id 
group by c.customer_id  having count(c.customer_id)>=30




