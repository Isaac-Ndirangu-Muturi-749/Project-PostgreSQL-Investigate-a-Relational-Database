/*  Question 2
Now we need to know how the length of rental duration of these family-friendly
 movies compares to the duration that all movies are rented for. Can you
  provide a table with the movie titles and divide them into
   4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) 
   based on the quartiles (25%, 50%, 75%) of the average rental 
   duration(in the number of days) for movies across all categories? 
   Make sure to also indicate the category that these family-friendly movies 
   fall into.*/



-- CTE family movie rental durations and their categories
WITH FamilyRentalDurations AS (
    SELECT
        category.name AS "Category",
        film.title AS "Film title",
        film.rental_duration AS "Rental Duration"
    FROM
        film
    JOIN
        film_category ON film.film_id = film_category.film_id
    JOIN
        category ON film_category.category_id = category.category_id
    WHERE
        category.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
),

-- CTE percentiles for rental durations within each category
CategoryAverages AS (
    SELECT
        category.name AS "Category",
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY film.rental_duration) AS "25th Percentile",
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY film.rental_duration) AS "50th Percentile",
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY film.rental_duration) AS "75th Percentile"
    FROM
        film
    JOIN
        film_category ON film.film_id = film_category.film_id
    JOIN
        category ON film_category.category_id = category.category_id
    GROUP BY
        category.name
)

-- Combine CTEs  final table with movie titles categorized by quartiles
SELECT
    frd."Film title",
    frd."Category",
    frd."Rental Duration",
    CASE
        WHEN frd."Rental Duration" <= ca."25th Percentile" THEN '1'
        WHEN frd."Rental Duration" <= ca."50th Percentile" THEN '2'
        WHEN frd."Rental Duration" <= ca."75th Percentile" THEN '3'
        ELSE '4'
    END AS "Rental Duration quartile"
FROM
    FamilyRentalDurations frd
JOIN
    CategoryAverages ca ON frd."Category" = ca."Category"
ORDER BY
    frd."Rental Duration" ASC;
