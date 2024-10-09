--Q1
select *
from payment
where amount >= 9.99;

--Q2
select max(amount)
from payment;

select *
from payment p
left join rental r
on p.rental_id = r.rental_id
left join inventory i
on r.inventory_id = i.inventory_id
left join film f
on i.film_id = f.film_id
where amount = 11.99;

--Q3
select first_name, last_name, email, address, city, country
from staff s
left join address a
on s.address_id = a.address_id
left join city ci
on a.city_id = ci.city_id
left join country co
on ci.country_id = co.country_id;

--Q4
-- I want to work in the tech industry, preferablly in the cybersecurity sector. Company whise, I would like to work for NVIDIA, Google, or Amazon

--Extra Credit
-- The two perpendicualr lines means each film can have one and only one language.
-- And, the circle and the crows feet means that each language can have none to many films made in the language.




