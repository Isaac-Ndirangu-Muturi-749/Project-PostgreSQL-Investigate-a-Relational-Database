/*Question 3
Finally, provide a table with the family-friendly film category, each of the
 quartiles, and the corresponding count of movies within each combination of
  film category for each corresponding rental duration category. The resulting
   table should have three columns:

Category
Rental length category
Count*/


-- CTE family movie rental durations and their categories
WITH FamilyRentalDurations AS (
    SELECT
        category.name AS "Category",
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

-- Combine CTEs final table with movie counts categorized by quartiles
SELECT
    frd."Category" AS "Category",
    CASE
        WHEN frd."Rental Duration" <= ca."25th Percentile" THEN '1'
        WHEN frd."Rental Duration" <= ca."50th Percentile" THEN '2'
        WHEN frd."Rental Duration" <= ca."75th Percentile" THEN '3'
        ELSE '4'
    END AS "Rental Duration quartile",
    COUNT(*) AS "Count"
FROM
    FamilyRentalDurations frd
JOIN
    CategoryAverages ca ON frd."Category" = ca."Category"
GROUP BY
    frd."Category", "Rental Duration quartile"
ORDER BY
    frd."Category", "Rental Duration quartile";
