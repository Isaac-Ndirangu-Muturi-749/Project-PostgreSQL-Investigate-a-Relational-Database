/*Question 3
Finally, for each of these top 10 paying customers, I would like to find out
the difference across their monthly payments during 2007. Please go ahead and
 write a query to compare the payment amounts in each successive month. Repeat
  this for each of these 10 paying customers. Also, it will be tremendously
   helpful if you can identify the customer name who paid the most difference
    in terms of payments.*/


-- CTE top 10 paying customers in 2007
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

SELECT
    tpc."Full Name",
    EXTRACT(MONTH FROM p1.payment_date) AS "Month",
    -- difference in payments using the LAG() window function
    SUM(p1.amount) - LAG(SUM(p1.amount), 1) OVER (PARTITION BY tpc.customer_id ORDER BY EXTRACT(MONTH FROM p1.payment_date)) AS "Payment Difference"
FROM
    payment p1
JOIN
    TopPayingCustomers tpc ON p1.customer_id = tpc.customer_id
WHERE
    EXTRACT(YEAR FROM p1.payment_date) = 2007
GROUP BY
    tpc."Full Name", "Month", tpc.customer_id
ORDER BY
    tpc."Full Name", "Month";
