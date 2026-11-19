/*
Question:  How did revenue change month over month?
Concepts:  DATE_TRUNC, chained CTEs, LAG() window function, NULLIF

Approach:
  1. monthly: total revenue per month (DATE_TRUNC rounds each payment
     date down to the first of its month, so a month's payments group together).
  2. monthly_compared: LAG() puts the previous month's revenue beside each month.
  3. Dollar change and percent change from those two columns.

Notes:
  - The first month has no previous month, so its change columns are NULL
    rather than 0.
  - NULLIF(prev_revenue, 0) prevents a divide-by-zero error if a month ever
    had no revenue.
  - Months follow the session time zone (America/New_York here), because
    payment_date is a timestamp with time zone.
    - The data covers 2022-01-23 to 2022-07-27, so January and July are
    partial months. February's large jump and July's drop reflect missing
    days, not real changes in the business. Only February-June are full
    months that can be compared fairly.
*/

WITH monthly AS (
    SELECT
        DATE_TRUNC('month', payment_date) AS month,
        SUM(amount)                       AS revenue
    FROM payment
    GROUP BY DATE_TRUNC('month', payment_date)
),
monthly_compared AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS prev_revenue
    FROM monthly
)
SELECT
    month,
    revenue,
    prev_revenue,
    revenue - prev_revenue                                             AS change,
    ROUND((revenue - prev_revenue) / NULLIF(prev_revenue, 0) * 100, 1) AS pct_change
FROM monthly_compared
ORDER BY month;