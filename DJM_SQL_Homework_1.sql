use sakila;

select * from actor limit 10;
-- 1a Display the first and last names of all actors from the table actor. 
select first_name, last_name from actor;

-- 1b Display the first and last name of each actor in a single column in upper case letters. Name the column "Actor Name".
select concat(first_name, ' ', last_name) as Actor_Name from actor;

-- 2a You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe". What is one query you would use to obtain this information?
select actor_id, first_name, last_name 
from actor
where first_name = 'Joe';

-- 2b Find all actors whose last name contain the letters GEN
select *
from actor
where last_name like '%gen%';

-- 2c Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order. 
select *
from actor
where last_name like '%li%'
order by last_name, first_name;

-- 2d Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China. 
-- select * from country limit 10;
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a You want to keep a description of each actor. 
-- You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB 
-- (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant)
alter table actor
add description blob;

-- select * from actor limit 10;

-- 3b Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor
drop column description;

-- select * from actor limit 10;

-- 4a List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) as 'Count'
from actor
group by last_name
order by count(*) desc;

-- 4b List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors. 
select last_name, count(*) as 'Count'
from actor
group by last_name
having count(*) >= 2
order by count(*) desc;

-- 4c The actor Harpo Williams was accidentally entered in the actor table as Groucho Williams. Write a query to fix the record. 
update actor
set first_name = 'Harpo'
where first_name = 'Groucho' and last_name = 'Williams';

-- 4d Perhaps we were too hasty in changing Groucho to Harpo. It turns out that Groucho was the correct name after all!
-- In a single query, if the first name of the actor is currently Harpo, change it to Groucho. 
update actor
set first_name = 'Groucho'
where first_name = 'Harpo' and last_name = 'Williams';

-- 5a You cannot locate the schema of the address table. Which query would you use to re-create it? 
show create table address;

-- 6a Use join to display the first and last names, as well as the address, of each staff member. Use the tables staff and address. 
-- select * from staff;

select staff.first_name, staff.last_name, address.address
from staff
inner join address on staff.address_id = address.address_id;

-- 6b Use join to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. 
-- select * from payment limit 10;
select staff.first_name, staff.last_name, sum(payment.amount) as 'Aug 2005 Total'
from staff
inner join payment on staff.staff_id = payment.staff_id
where month(payment.payment_date)=8
group by staff.staff_id;

-- 6c List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join
-- select * from film_actor;
select f.title, count(distinct a.actor_id) as 'Number_of_Actors'
from film as f
inner join film_actor as a on f.film_id = a.film_id
group by f.film_id
order by Number_of_Actors desc;

-- 6d How many copies of the film Hunchback Impossible exist in the inventory system?
-- find the Hunchback film_id from film table
select film_id, title
from film 
where title like '%Hunchback Impossible%';
-- film_id = 439
select count(inventory_id) as 'Total Inventory'
from inventory
where film_id = 439;
-- Total of 6 copies

-- 6e Using the tables payment and customer and the join command, list the total paid by each customer. 
-- List the customers alphabetically by last name. 
select * from payment limit 10;

select c.first_name, c.last_name, sum(p.amount)
from customer as c
join payment as p on c.customer_id = p.customer_id
group by c.customer_id
order by c.last_name;

-- 7a The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films
-- starting with the letters k and q have also soared in popularity. Use subqueries to discplay the titles of movies starting with the letters k and q whose language is English. 
select * from film
where title like 'K%' or title like 'Q%'and 
language_id = (select language_id from language where name = 'English');

-- 7b Use  subqueries to display all actors who appear in the film Alone Trip
-- select * from actor limit 10;
select first_name, last_name
from actor
where actor_id in (select actor_id from film_actor
where film_id = (select film_id from film where title = 'Alone Trip'));

-- 7c You want to run an email marketing campaign in Canada, for which you will need the names and email addresses 
-- all Canadian customers. Use joins to retrieve this information. 
-- select * from customer limit 10;
select c.email, l.name
from customer as c
join customer_list as l on c.customer_id = l.ID
where country = 'Canada';

-- 7d Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films
select * 
from film_list
where category = 'Family';

-- 7e Display the most frequently rented movies in descending order. 
select * from rental;
select  f.title, count(r.rental_id) as 'Total_Rented'
from film as f
join inventory as i on f.film_id = i.film_id
join rental as r on i.inventory_id = r.inventory_id
group by f.film_id
order by Total_Rented desc;

-- 7f Write a query to display how much business, in dollars, each store brougt in. 
select * from sales_by_store;

-- 7g Write a query to display for each store its store ID, city and country. 
select * from address; 
select store.store_id, city.city, country.country
from store
join address on store.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id;

-- 7h List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables:
-- category, film_category, inventory, payment, and rental.)
select c.name as 'Genre', sum(p.amount) as 'Gross_Revenue'
from category as c
join film_category as f on c.category_id = f.category_id
join inventory as i on f.film_id = i.film_id
join rental as r on i.inventory_id = r.inventory_id
join payment as p on r.rental_id = p.rental_id
group by c.category_id
order by Gross_Revenue desc;

-- 8a In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. 
create view top_five_genres as
select c.name as 'Genre', sum(p.amount) as 'Gross_Revenue'
from category as c
join film_category as f on c.category_id = f.category_id
join inventory as i on f.film_id = i.film_id
join rental as r on i.inventory_id = r.inventory_id
join payment as p on r.rental_id = p.rental_id
group by c.category_id
order by Gross_Revenue desc;

-- 8b How would you display the view that you created in 8a?
select * from top_five_genres;

-- 8c You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view top_five_genres; 