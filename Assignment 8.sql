-- Q1
update rental
set status = case
	when return_date > rental_date + interval '1 day' * (
		select rental_duration from film
		left join inventory on film.film_id = inventory.film_id
		where inventory.inventory_id = rental.inventory_id) then 'late'
	when return_date < rental_date + interval '1 day' * (
		select rental_duration from film
		left join inventory on film.film_id = inventory.film_id
		where inventory.inventory_id = rental.inventory_id) then 'early'
	else 'on time'
end;
	
-- Q2
select sum(payment.amount) as total_amount
from payment
left join customer on customer.customer_id = payment.customer_id
left join address on address.address_id = customer.address_id
left join city on city.city_id = address.city_id
where city.city in ('Saint Louis');

-- Q3
select category.name, count(film.film_id)
from film
left join film_category on film.film_id = film_category.film_id
left join category on film_category.category_id = category.category_id
group by category.name;
-- Family has 69 films, Games has 61, Animation has 66, classics has 57, Documentary has 68,
-- New has 63, Sports have 74, Children have 60, Music has 51, Travel has 57, Foreign has 73,
-- Drama has 62, Horror has 56, Action has 64, Sci-Fi has 61, and Comedy has 58 films

-- Q4
-- There is a table for category because it serves as a junction table to handle
-- There is a table for film category because a relationship exists between film and category,
-- where all the films are seperated by catgeory and are placed in movie genres

-- Q5
select film.film_id, film.title, film.length
from rental
left join inventory on rental.inventory_id = inventory.inventory_id
left join film on inventory.film_id = film.film_id
where rental.return_date between '2005-05-15' and '2005-05-31';

-- Q6
select film.film_id, film.title, film.rental_rate
from film
where film.rental_rate < (select avg(film.rental_rate) from film);

-- Q7
select status, count(*) as count
from rental
group by status;
-- 8121 films were retuned late, 7738 were returned early, and 185 were returned on time

--Q8
select film.title, film.length,
	percent_rank() over (order by film.length) as duration_percentile
from film;

--Q9

Explain 
select film.film_id, film.title, film.length
from rental
left join inventory on rental.inventory_id = inventory.inventory_id
left join film on inventory.film_id = film.film_id
where rental.return_date between '2005-05-15' and '2005-05-31';

-- The nested Loop Left Join is creating the number of rows and width needed for the data
-- being called by the code. The data being called is the film_id, title, and length variables
-- that were returned from MAY 15th to the 31st in 2005. Then there is the filter function which
-- seperates the data called from the data as a whole and sorts that needed data out. In this
-- case, the needed data are the May1st-May31st 2005 data. In addition, there is the Indec con
-- function which is used to find the location of rows from the case. In this case, the
-- rows for the specific interval of film_id, title, and lenght data for movies is being located. The rest
-- of the functions have their own task that contribute the cleanliness and sufficeny of data being moved.

Explain
select status, count(*) as count
from rental
group by status;

-- The Hash Aggregate function is basically taking all the variables in the data that are
-- under the early, late, and on time window and grouping them into new rows and columns. The code is asking
-- to get a count for each of these areas of the data, and so each group will have its own column and the count data will be put
-- into each one. Then there is the group key function, which groups the times
-- movies were either returned on time, early, or late and puts them all in one row/column each. And finally, there is
-- the Seq Scan on rental function, which reads the rows of film_id, title, and length from the data set in order
-- and does so in a fast way

-- Both these queries differ in the sense that for question 7, the functions are be using to
-- get a count for a number of variables that are under a specific bigger variable (ex: Tarzan under the movie category),
-- whereas for question 5, the functiins are being used to find variables of three specific catgeories that were returned
-- between a specific interval (May 1st - May 30th of 2005). Question 5 also has more functions in its
-- query plan than question 7 does, which is only three

-- Extra credit
-- Set-based programming focuses on operations over entire sets of data, whereas procedural programming
-- is dependent on step-by-step instructions through the use of different loops, conditions, and print statements.
-- SQL is a set-based programming language while python is a procedural programming language. This is because SQL is declarative
-- and set-based, while python is procedural

