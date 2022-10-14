USE sakila;

-- 1. Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, ci.city, co.country
FROM sakila.store s
JOIN sakila.address a
ON a.address_id = s.address_id
JOIN sakila.city ci
ON ci.city_id = a.city_id
JOIN sakila.country co
ON co.country_id = ci.country_id
ORDER BY s.store_id;

-- 2. Write a query to display how much business, in dollars, each store brought in.

SELECT i.store_id, SUM(p.amount) AS buisness
FROM sakila.inventory i
JOIN sakila.rental r
ON i.inventory_id = r.inventory_id
JOIN sakila.payment p
ON p.rental_id = r.rental_id
GROUP BY i.store_id;

-- 3. Which film categories are longest?

SELECT c.name AS category, AVG(f.length) AS duration
FROM sakila.film f
JOIN sakila.film_category fc
ON fc.film_id = f.film_id
JOIN sakila.category c
ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY duration DESC;

-- 4. Display the most frequently rented movies in descending order.

SELECT f.title AS movie_title, count(r.rental_id) AS num_rented
FROM sakila.film f
JOIN sakila.inventory i
ON i.film_id = f.film_id
JOIN sakila.rental r
ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER BY num_rented DESC;

-- 5. List the top five genres in gross revenue in descending order.

SELECT c.name AS genre , sum(p.amount) AS gross_revenue
FROM sakila.category c
JOIN sakila.film_category fc
ON fc.category_id = c.category_id
JOIN sakila.film f
ON f.film_id = fc.film_id
JOIN sakila.inventory i
ON i.film_id = f.film_id
JOIN sakila.rental r
ON r.inventory_id = i.inventory_id
JOIN sakila.payment p
ON p.rental_id = r.rental_id 
GROUP BY c.name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 6. Is "Academy Dinosaur" available for rent from Store 1?

SELECT f.title AS movie_title, i.store_id AS store
FROM sakila.film f 
JOIN sakila.inventory i 
ON f.film_id = i.film_id
WHERE (f.title='Academy Dinosaur') AND (i.store_id=1)
LIMIT 1;

-- 7. Get all pairs of actors that worked together.

SELECT f.title, fa1.actor_id AS actor1_id, fa2.actor_id AS actor2_id, concat(a1.first_name," ", a1.last_name) AS actor1_name, concat(a2.first_name," ", a2.last_name) AS actor2_name
FROM sakila.film f
JOIN film_actor fa1
ON f.film_id=fa1.film_id
JOIN sakila.actor a1
ON fa1.actor_id=a1.actor_id
JOIN sakila.film_actor fa2
ON f.film_id=fa2.film_id
JOIN sakila.actor a2
ON fa2.actor_id=a2.actor_id
WHERE fa1.actor_id > fa2.actor_id
ORDER BY f.film_id;

-- 8. Get all pairs of customers that have rented the same film more than 3 times

SELECT o1.customer_id AS customer_id1,
       o2.customer_id AS customer_id2,
       COUNT(*) num_overal_movies
FROM( (SELECT c.customer_id, f.film_id
        FROM sakila.customer AS c
        JOIN sakila.rental AS r ON r.customer_id = c.customer_id
        JOIN sakila.inventory AS i ON i.inventory_id = r.inventory_id
        JOIN sakila.film AS f ON i.film_id = f.film_id
        ) AS o1
        JOIN (SELECT c.customer_id, f.film_id
                FROM sakila.customer AS c
                JOIN sakila.rental AS r ON r.customer_id = c.customer_id
                JOIN sakila.inventory AS i ON i.inventory_id = r.inventory_id
                JOIN sakila.film AS f ON i.film_id = f.film_id
    ) AS o2 ON o2.film_id = o1.film_id AND o2.customer_id < o1.customer_id )
GROUP BY o1.customer_id, o2.customer_id
HAVING COUNT(*) >3
ORDER BY COUNT(*) DESC;

/*I got this from the web, and from what I can understand it creates a subset where it gets information twice from the customer, rental, inventory and film tables.
It then counts the rows of the inner join betweem both customers to know the number of same title movies rented between them.
*/
-- 9. For each film, list actor that has acted in more films.

SELECT a.actor_id, concat(a.first_name," ", a.last_name) AS actor_name , count(*) AS num_movies
FROM sakila.film f
JOIN sakila.film_actor fa
ON fa.film_id = f.film_id
JOIN sakila.actor a
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY num_movies DESC;


