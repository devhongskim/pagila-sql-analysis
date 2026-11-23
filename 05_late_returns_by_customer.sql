/*
Question:  Which customers return rentals late most often?
Concepts:  Date arithmetic with INTERVAL, CASE, aggregate FILTER, HAVING
Approach:
  1. rental_status: label each rental 'on time', 'late' or 'not returned'.
     Due date = rental_date + the film's rental_duration (in days).
  2. Per customer: count late returns, the late rate among returned
     rentals, average days late, and rentals never returned.
  3. Keep customers with at least 20 returned rentals so a few rentals
     can't produce an extreme rate.
Notes:
  - rental_duration is an integer (days), so multiplying by INTERVAL '1 day'
    turns it into a time span that can be added to a timestamp.
  - Rentals with a NULL return_date were never returned. They are counted
    separately and excluded from the late rate.
  - COUNT(*) FILTER (WHERE ...) is PostgreSQL syntax. The portable
    equivalent is SUM(CASE WHEN ... THEN 1 ELSE 0 END).
  - Result: the top 10 customers have late rates of 69.2% to 86.4%.
    The overall late rate is __%, so lateness is common across all
    customers, not limited to a few. In real data this would point to
    a due-date policy problem rather than a customer problem.    
*/

WITH rental_status AS (
    SELECT
        r.customer_id,
        r.return_date - (r.rental_date + f.rental_duration * INTERVAL '1 day') AS time_over_due,
        CASE
            WHEN r.return_date IS NULL THEN 'not returned'
            WHEN r.return_date > r.rental_date + f.rental_duration * INTERVAL '1 day' THEN 'late'
            ELSE 'on time'
        END AS status
    FROM rental r
    JOIN inventory i ON i.inventory_id = r.inventory_id
    JOIN film f      ON f.film_id = i.film_id
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(*) FILTER (WHERE rs.status <> 'not returned') AS returned_rentals,
    COUNT(*) FILTER (WHERE rs.status = 'late')          AS late_returns,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE rs.status = 'late')
        / NULLIF(COUNT(*) FILTER (WHERE rs.status <> 'not returned'), 0)
    , 1) AS late_pct,
    ROUND(
        AVG(EXTRACT(EPOCH FROM rs.time_over_due) / 86400)
            FILTER (WHERE rs.status = 'late')
    , 1) AS avg_days_late,
    COUNT(*) FILTER (WHERE rs.status = 'not returned')  AS not_returned
FROM rental_status rs
JOIN customer c ON c.customer_id = rs.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(*) FILTER (WHERE rs.status <> 'not returned') >= 20
ORDER BY late_pct DESC, late_returns DESC
LIMIT 10;