/*
Question:  Which film categories bring in the most rental revenue?
Concepts:  5-table join path, a bridge table (film_category), COUNT(DISTINCT), GROUP BY

Approach:
  1. Join payment -> rental -> inventory -> film_category -> category.
  2. Revenue = SUM(amount). Rentals = COUNT(DISTINCT rental_id), since one
     rental can have several payment rows. Average = revenue / rentals.

Notes (what INNER JOINs silently exclude):
  - Unpaid rentals have no payment row, so the rental count only covers paid rentals.
  - A film with no category would drop out of every category's total.
  - A category with no rentals doesn't appear at all (a LEFT JOIN from category
    would show it with 0).
*/

SELECT
    c.name                                                AS category,
    SUM(p.amount)                                         AS total_revenue,
    COUNT(DISTINCT r.rental_id)                           AS rentals,
    ROUND(SUM(p.amount) / COUNT(DISTINCT r.rental_id), 2) AS avg_per_rental
FROM payment p
JOIN rental r         ON r.rental_id    = p.rental_id
JOIN inventory i      ON i.inventory_id = r.inventory_id
JOIN film_category fc ON fc.film_id     = i.film_id
JOIN category c       ON c.category_id  = fc.category_id
GROUP BY c.category_id, c.name
ORDER BY total_revenue DESC;