/* Question 1
We want to understand more about the movies that families are watching. 
The following categories are considered family movies: Animation, Children,
 Classics, Comedy, Family and Music.

Create a query that lists each movie, the film category it is classified in,
 and the number of times it has been rented out.*/



SELECT
    f.title AS "Film title",
    c.name AS "Category name",
    COUNT(r.rental_id) AS "Count of Rentals"
FROM
    film f
JOIN
    film_category fc ON f.film_id = fc.film_id
JOIN
    category c ON fc.category_id = c.category_id
JOIN
    inventory i ON f.film_id = i.film_id
JOIN
    rental r ON i.inventory_id = r.inventory_id
WHERE
    c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY
    f.title, c.name
ORDER BY
    c.name, f.title;

