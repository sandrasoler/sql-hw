USE sakila;

-- Display the first and last names of all actors from the table `actor`

SELECT first_name AS 'First Name', 
       last_name  AS 'Last Name'
FROM actor;

-- Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`

SELECT upper(concat(first_name, ' ', last_name)) AS 'Actor Name' 
FROM actor;

--  Display the ID number, first name, and last name of an actor, for actor with first name "Joe" 

SELECT actor_id   AS 'Actor ID', 
       first_name AS 'First Name', 
       last_name  AS 'Last Name'
FROM   actor
WHERE  first_name = "Joe";


-- Find all actors whose last name contain the letters `GEN`

SELECT first_name AS 'First Name', 
       last_name  AS 'Last Name'
FROM   actor
WHERE  last_name LIKE '%GEN%';

-- Find all actors whose last names contain the letters `LI` display in order of last name and first name

SELECT first_name AS 'First Name', 
	   last_name  AS 'Last Name'
FROM   actor
WHERE  last_name LIKE '%LI%'
ORDER BY last_name, 
         first_name;


-- Using `IN`, display the `country_id` and `country` columns for Afghanistan, Bangladesh, and China.


SELECT country_id AS 'Country ID', 
       country    AS 'Country'
FROM   country
WHERE  country IN ("Afghanistan","Bangladesh" ,"China");


-- Add 'description' column as data type 'BLOB'

ALTER TABLE actor 
ADD description BLOB; 

-- Delete 'description' column

ALTER TABLE actor
DROP description;

-- Display the last name of actors and how many actors have the same last name

SELECT DISTINCT last_name AS 'Last Name', 
                Count(*)  AS 'Number of Actors with Last Name'
FROM  actor 
GROUP BY last_name;

-- Display last names of actors and the number of actors who have the same last name for last names that are shared by at least two actors 

SELECT DISTINCT last_name AS 'Last Name', 
                count(*)  AS 'Number of Actors with Last Name'
FROM   actor
GROUP  BY last_name
HAVING Count(*) > 1;

-- Query to fix 'GROUCHO WILLIAMS' to 'HARPO WILLIAMS'

UPDATE actor
SET    first_name ='HARPO'
WHERE  last_name = 'WILLIAMS' 
       AND first_name = 'GROUCHO';


-- Query to fix 'HARPO WILLIAMS' back to 'GROUCHO WILLIAMS'

UPDATE actor
SET    first_name ='GROUCHO'
WHERE  last_name = 'WILLIAMS' 
       AND first_name = 'HARPO';


-- Re-create 'address'query

SHOW CREATE TABLE address;
       
       
-- Display first and last name and address for each staff member

SELECT  s.first_name AS 'First Name', 
        s.last_name  AS 'Last Name', 
        a.address    AS 'Address'
FROM staff s
	 INNER JOIN address a 
		     ON s.address_id = a.address_id;
        

-- Display total amount rung up by each staff member in August of 2005

SELECT  s.first_name  AS 'First Name', 
        s.last_name   AS 'Last Name', 
        Sum(p.amount) AS 'Total Sales'
FROM staff s
	 INNER JOIN payment p 
			 ON p.staff_id = s.staff_id
WHERE payment_date >= '2005-08-01' 
      AND payment_date <= '2005-08-31'
GROUP BY s.staff_id;

-- List each film and the number of actors listed for the film

SELECT f.title            AS 'Film',
       Count(fa.actor_id) AS 'Number of Actors'
FROM   film f
	   INNER JOIN film_actor fa 
			   ON fa.film_id = f.film_id
GROUP BY f.title;

-- Display number of copies for film 'Hunchback Impossible'

SELECT f.title               AS 'Film', 
       Count(i.inventory_id) AS 'Number of Copies'
FROM   film f
	   INNER JOIN inventory i 
			   ON f.film_id = i.film_id
WHERE title = 'Hunchback Impossible';

-- Display total paid by each customer, list customers in alphabetical order by last name

SELECT c.first_name  AS 'First Name', 
       c.last_name   AS 'Last Name', 
       Sum(p.amount) AS 'Total Paid'
FROM   customer c
       INNER JOIN payment p 
               ON c.customer_id = p.customer_id
GROUP BY last_name, 
         first_name
ORDER BY last_name ASC;


-- Display films starting with letters 'K' and 'Q' whose language is English

SELECT f.title AS 'English-Language Films'
FROM   film f
WHERE  f.language_id = (SELECT language_id 
						FROM   language 
                        WHERE  name ='English')
	   AND f.title LIKE 'K%' 
        OR f.title LIKE 'Q%';
      

-- Display all actors who appear in the film 'Alone Trip'

SELECT Concat(first_name,' ',last_name) AS 'Actors in Alone Trip'
FROM   actor
WHERE  actor_id IN (SELECT actor_id 
                    FROM film_actor 
                    WHERE film_id =  (SELECT film_id 
                                      FROM film 
                                      WHERE title = 'Alone Trip'));

 
-- Display names and email addresses of all Canadian customers

SELECT c.first_name AS 'First Name', 
       c.last_name  AS 'Last Name', 
       c.email      AS 'Email Address'
FROM   customer c
       INNER JOIN address a 
               ON c.address_id = a.address_id
       INNER JOIN city cy 
               ON a.city_id = cy.city_id
       INNER JOIN country co 
               ON cy.country_id = co.country_id
WHERE country = 'Canada';

-- Display all movies categorazed as family films. 

SELECT f.title AS 'Family Films'
FROM   film_category fc
       INNER JOIN category c 
               ON fc.category_id = c.category_id
	   INNER JOIN film f 
               ON fc.film_id = f.film_id
WHERE name = 'Family';


-- Display most frequently rented movies in descending order

SELECT f.title        AS 'Film', 
       Count(f.title) AS 'Number of Times Rented'
FROM   rental r
       INNER JOIN inventory i 
               ON r.inventory_id = i.inventory_id
       INNER JOIN film f 
               ON i.film_id = f.film_id
GROUP BY title
ORDER BY count(title) DESC;



-- Display how much business, in dollars, each store brought in

SELECT a.address  AS 'Store', 
       c.city     AS 'City',
       cy.country AS 'Country',
       Sum(p.amount) AS 'Total Sales'
FROM store s
     INNER JOIN inventory i 
             ON s.store_id = i.store_id
     INNER JOIN rental r 
             ON i.inventory_id = r.inventory_id
     INNER JOIN payment p 
             ON r.rental_id = p.rental_id
	 INNER JOIN address a
             ON s.address_id = a.address_id
	 INNER JOIN city c
             ON a.city_id = c.city_id
	 INNER JOIN country cy
             ON c.country_id = cy.country_id
GROUP BY s.store_id;


-- Display each store with its store ID, city and country


SELECT s.store_id AS 'Store ID', 
       cy.city    AS 'City', 
       co.country AS 'Country'
FROM   store s
       INNER JOIN address a 
               ON s.address_id = a.address_id
	   INNER JOIN city cy
               ON a.city_id = cy.city_id
       INNER JOIN country co 
               ON cy.country_id = co.country_id
GROUP BY s.store_id;

-- Display top five genres in gross revenue in descending order

SELECT c.name        AS 'Genre', 
       sum(p.amount) AS 'Gross Revenue'
FROM   category c
	   INNER JOIN film_category fc 
               ON c.category_id = fc.category_id
       INNER JOIN inventory i 
               ON fc.film_id = i.film_id
       INNER JOIN rental r 
               ON i.inventory_id = r.inventory_id
       INNER JOIN payment p 
               ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY sum(p.amount) DESC
LIMIT 5;


-- Create view displaying the top five genres by gross revenue

CREATE VIEW top_5_genres AS
SELECT c.name        AS 'Genre', 
       sum(p.amount) AS 'Gross Revenue'
FROM   category c
	   INNER JOIN film_category fc 
               ON c.category_id = fc.category_id
       INNER JOIN inventory i 
               ON fc.film_id = i.film_id
       INNER JOIN rental r 
               ON i.inventory_id = r.inventory_id
       INNER JOIN payment p 
               ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY sum(p.amount) DESC
LIMIT 5;

-- Display top_5_genres view
SELECT * FROM top_5_genres;

-- Drop top_5_genres view
DROP VIEW top_5_genres;