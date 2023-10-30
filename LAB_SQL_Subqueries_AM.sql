-- LAB SQL Subqueries
-- Antonio Montilla

-- In this lab, you will be working with the Sakila database on movie rentals.

USE sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT film_id, COUNT(inventory_id) as 'number of copies'
FROM inventory
WHERE film_id = (SELECT film_id
From film
WHERE title = "Hunchback Impossible")
GROUP BY film_id;


-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT *
FROM film
WHERE length > (SELECT AVG(length) FROM film)
ORDER BY length;

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT actor_id
FROM film_actor
WHERE film_id = (SELECT film_id
From film
WHERE title = "Alone Trip")
ORDER BY actor_id;


-- Bonus:

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT *
FROM film_category
WHERE category_id IN (SELECT category_id
FROM category
WHERE name = 'Family')
ORDER BY film_id;

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
# using JOIN:
SELECT c.first_name as 'First name', c.last_name as 'Last name', c.email as 'email'
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country cu on ci.country_id = cu.country_id
WHERE cu.country = 'Canada'
ORDER BY c.last_name;

# using subqueries
SELECT c.first_name as 'First name', c.last_name as 'Last name', c.email as 'email'
FROM customer c
WHERE c.address_id IN (
SELECT a.address_id
FROM address as a
WHERE a.city_id in (
SELECT ci.city_id
FROM city ci
WHERE ci.country_id = (
SELECT cu.country_id
FROM country as cu
WHERE cu.country = 'Canada')))
ORDER BY c.last_name;


-- 6. Determine which films were starred by the most prolific actor in the Sakila database. 
-- A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that 
-- he or she starred in.

-- as reference I paste the query for getting the most prolific actor
SELECT film_actor.actor_id as 'actor id', actor.first_name as 'first name', actor.last_name as 'last name', COUNT(film_actor.film_id) as 'number of films'
FROM film_actor
JOIN actor ON film_actor.actor_id = actor.actor_id
GROUP BY film_actor.actor_id
ORDER BY COUNT(film_actor.film_id) DESC
LIMIT 1;

-- now using part of this query as input to answer 6:
SELECT film_id
FROM film_actor
WHERE actor_id = (SELECT actor_id 
FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 1)
ORDER BY film_id;

-- 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and 
-- payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

-- 
SELECT DISTINCT film_id
FROM inventory
WHERE inventory_id IN (
SELECT inventory_id
FROM rental
WHERE customer_id = (
SELECT customer_id
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1))
ORDER BY film_id;



-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the 
-- total_amount spent by each client. You can use subqueries to accomplish this.


