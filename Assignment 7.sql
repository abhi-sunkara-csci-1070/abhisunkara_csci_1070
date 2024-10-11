--1.
select *
from customer
where last_name LIKE 'T%'
order by first_name;

--2.
select *
from rental
where return_date BETWEEN '2005-05-28' AND '2005-06-01';

--3.
select title, count(rental.rental_id)
from rental
left join inventory 
on rental.inventory_id = inventory.inventory_id
left join film on inventory.film_id = film.film_id
group by title
order by count(rental.rental_id) DESC
LIMIT 10;
-- You would use a count query. You would use a counter query because a count function
-- always returns a number of rows that satisifes a specific criterion such as movies rented the most.

--4.
select customer.customer_id, sum(amount)
from payment
left join customer on customer.customer_id = payment.customer_id
group by customer.customer_id
order by sum(amount);

--5.
select CONCAT( actor.first_name,' ',actor.last_name), count(actor.actor_id) as total_movies
from actor
left join film_actor on actor.actor_id = film_actor.actor_id
left join film on film_actor.film_id = film.film_id
where film.release_year = 2006
group by CONCAT(actor.first_name,' ',actor.last_name)
order by total_movies desc;
-- The actor/acctress with the most movies in 2006 is Susan Davis, with a total of 54 movies.
-- This is achieved when we implement the function "limit 1;" below this code, which displays the person with the most movies in 2006 being Susan

--6.
explain select customer.customer_id, sum(amount)
from payment
left join customer on customer.customer_id = payment.customer_id
group by customer.customer_id
order by sum(amount);

-- An Explain plan displays execution plans that hold a sequence of
-- operations used for the database to run some statement. Here, the sort key
-- function takes the total of a persons (customer_id) rentals and provides the
-- amount of money they have spent buying rentals since the creation of the rental
-- system. The HashAggregate function then groups the payment.amount data to get the number
-- of rows needed for each piece of payment amount paid by the customer. The group
-- key function groups the cost data then by customer.customer_id. Then finally, the various other 
-- functions explain what the remainder of the sql code does.

explain select CONCAT( actor.first_name,'',actor.last_name), count(actor.actor_id) as total_movies
from actor
left join film_actor on actor.actor_id = film_actor.actor_id
left join film 
on film_actor.film_id = film.film_id
where film.release_year = 2006
group by CONCAT(actor.first_name,'',actor.last_name)
order by total_movies desc;

-- The sort key function for question 5 is taking the count of movies
-- that actors were i. The Group Key function is then later used to group the first
-- and last names of actors into a single column. This is done through the concat function, which
-- brings two different strings together in SQL. The Filter function, based upon my interpretation, acts as a where clause
-- that takes the release_year and compares it to actors movies to see if any movies they have
-- acted in were in 2006. If a movie for that actor is found under 2006, the data item will be added
-- to the count to keep tabs on the number of movies that actor had in 2006. And in addition to the functions above, the rest
-- of the functions display what the remainder of the SQL code does.

--7.
select category.name as genre, avg(film.rental_rate)
from film
join film_category 
on film.film_id = film_category.film_id
join category 
on film_category.category_id = category.category_id
group by genre;
-- The average rental rate for Comedy, Sci-FI, Horror, Drama, Foreign,
-- Travel, Sports, NEW, and Games is about/around 3. The rest of the genres
-- average about 2.6 to 2.9.

--8.
select category.name as genre, count(rental.rental_id), sum(payment.amount)
from rental
left join payment on rental.rental_id = payment.rental_id
left join inventory on rental.inventory_id = inventory.inventory_id
left join film on inventory.film_id = film.film_id
left join film_category on film.film_id = film_category.film_id
left join category on film_category.category_id = category.category_id
group by genre
order by count(rental.rental_id) DESC
limit 5;
-- The most rented categories are Sports, Animation, Action, Sci-Fi, and Family.
-- The total sales for Sports is $4892.19, for Animation its $4245.31, for Action its $3951.84, for Sci-Fi its $4336.01, and for Family its $3830.15.


-- Extra Credit
select to_char(rental.rental_date, 'Month') as Month, category.name as genre, count(rental.rental_id)
from rental
left join inventory on rental.inventory_id = inventory.inventory_id
left join film on inventory.film_id = film.film_id
left join film_category on film.film_id = film_category.film_id
left join category on film_category.category_id = category.category_id
group by month, genre
order by month