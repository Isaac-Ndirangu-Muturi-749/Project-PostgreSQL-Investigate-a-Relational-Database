/*Question 2
We would like to know who were our top 10 paying customers, how many payments they made on a monthly basis
during 2007, and what was the amount of the monthly payments. Can you write a query to capture the customer
name, month and year of payment, and total payment amount for each month by these top 10 paying customers?*/


-- Create a Common Table Expression (CTE) to get the top 10 paying customers during 2007
WITH TopPayingCustomers AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS "Full Name"
    FROM
        payment p
    JOIN
        customer c ON p.customer_id = c.customer_id
    WHERE
        EXTRACT(YEAR FROM p.payment_date) = 2007
    GROUP BY
        c.customer_id, "Full Name"
    ORDER BY
        SUM(p.amount) DESC
    LIMIT
        10
)
-- Retrieve month, customer name, number of payments, and total payment amount
SELECT
    EXTRACT(MONTH FROM p.payment_date) AS "Month",
    tpc."Full Name",
    COUNT(p.payment_id) AS "Number of Payments in the Month",
    SUM(p.amount) AS "Amount Paid"
FROM
    payment p
-- Join with the TopPayingCustomers CTE to limit results to top paying customers
JOIN
    TopPayingCustomers tpc ON p.customer_id = tpc.customer_id
WHERE
    EXTRACT(YEAR FROM p.payment_date) = 2007
-- Group by month and customer name
GROUP BY
    "Month", tpc."Full Name"
-- Order results by customer name and month
ORDER BY
    tpc."Full Name", "Month";
