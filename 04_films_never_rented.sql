/*
Question:  Which films have never been rented, and why?
Concepts:  Anti-join (NOT EXISTS), correlated subqueries, EXISTS inside CASE
Approach:
  1. Films don't link to rentals directly: film -> inventory (copies) -> rental.
  2. NOT EXISTS keeps only films where no copy has any rental.
  3. A CASE with EXISTS labels the reason: the store either owns copies
     nobody rented, or owns no copies at all.
Notes:
  - Equivalent LEFT JOIN version:
        FROM film f
        LEFT JOIN inventory i ON i.film_id = f.film_id
        LEFT JOIN rental r    ON r.inventory_id = i.inventory_id
        WHERE r.rental_id IS NULL
    That version can return the same film more than once (once per unrented
    copy), so it needs DISTINCT. NOT EXISTS returns each film once.
  - Avoid NOT IN for anti-joins. If the subquery returns any NULL,
    NOT IN returns no rows at all. NOT EXISTS handles NULLs safely.
*/

SELECT
    f.film_id,
    f.title,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM inventory i
            WHERE i.film_id = f.film_id
        ) THEN 'Has copies, never rented'
        ELSE 'No copies in inventory'
    END AS reason
FROM film f
WHERE NOT EXISTS (
    SELECT 1
    FROM inventory i
    JOIN rental r ON r.inventory_id = i.inventory_id
    WHERE i.film_id = f.film_id
)
ORDER BY reason, f.title;