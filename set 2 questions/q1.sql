/*Question 1:
We want to find out how the two stores compare in their count of rental
orders during every month for all the years we have data for. Write a query
 that returns the store ID for the store, the year and month and the number of
  rental orders each store has fulfilled for that month. Your table should
   include a column for each of the following: year, month, store ID and count
    of rental orders fulfilled during that month.*/


-- Retrieve the store ID, year, month, and the count of rental orders
SELECT
    EXTRACT(MONTH FROM r.rental_date) AS "Month",
    EXTRACT(YEAR FROM r.rental_date) AS "Year",
    c.store_id AS "Store ID",
    COUNT(r.rental_id) AS "Count of Rental Orders"
FROM
    rental r
JOIN
    customer c ON r.customer_id = c.customer_id
-- Group by year, month, and store ID
GROUP BY
    "Month", "Year", c.store_id
-- Order by year and month in descending order
ORDER BY
    "Month", "Year";