WITH customer_totals AS (            -- Step 1: one row per customer with their total
    SELECT customer_id, SUM(amount) AS total
    FROM payment
    GROUP BY customer_id
),
ranked AS (                          -- Steps 2 + 3: add name/store, rank within each store
    SELECT
        c.store_id,
        c.first_name || ' ' || c.last_name AS customer_name,
		c.email,
        ct.total,
        RANK() OVER (
            PARTITION BY c.store_id      -- restart the ranking for each store
            ORDER BY ct.total DESC       -- biggest spender = rank 1
        ) AS store_rank
    FROM customer_totals ct
    JOIN customer c ON c.customer_id = ct.customer_id
)
SELECT store_id, store_rank, customer_name, email, total   -- Step 4: keep the top 3 per store
FROM ranked
WHERE store_rank <= 3
ORDER BY store_id, store_rank;