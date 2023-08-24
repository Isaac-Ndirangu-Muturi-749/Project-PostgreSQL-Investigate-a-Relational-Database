/* Question 1
We want to understand more about the movies that families are watching. 
The following categories are considered family movies: Animation, Children,
 Classics, Comedy, Family and Music.

Create a query that lists each movie, the film category it is classified in,
 and the number of times it has been rented out.*/


-- Selects film title, category name, and count of rentals
SELECT
    film.title AS "Film title",
    category.name AS "Category name",
    COUNT(rental.rental_id) AS "Count of Rentals"

-- Joins film, film_category, category, inventory, and rental tables
FROM
    film
JOIN
    film_category ON film.film_id = film_category.film_id
JOIN
    category ON film_category.category_id = category.category_id
JOIN
    inventory ON film.film_id = inventory.film_id
JOIN
    rental ON inventory.inventory_id = rental.inventory_id

-- Filters results for specific family movie categories
WHERE
    category.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')

-- Groups results by film title and category name
GROUP BY
    film.title, category.name

-- Orders results first by category name, then by film title
ORDER BY
    category.name, film.title;
