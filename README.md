# Pagila SQL Analysis

SQL analysis of the [Pagila](https://github.com/devrimgunduz/pagila) sample database (a DVD rental store: customers, films, rentals, payments, staff and stores) in PostgreSQL, organized by business question.

Each query file starts with a comment block covering the question, the SQL concepts it uses, the approach, and any judgment calls about the data (for example, which of two possible joins defines a customer's "store").

## Queries

| # | Question | Concepts |
|---|---|---|
| 01 | [Top 3 customers by total paid, per store](01_top_customers_per_store.sql) | CTEs, GROUP BY, window functions (`RANK` with `PARTITION BY`) |
| 02 | [Revenue by film category](02_revenue_by_category.sql) | 5-table joins, bridge tables, `COUNT(DISTINCT)`, inner-join pitfalls |
| 03 | [Month-over-month revenue](03_month_over_month_revenue.sql) | DATE_TRUNC, chained CTEs, `LAG()`, `NULLIF` |
| 04 | [Films never rented](04_films_never_rented.sql) | Anti-join, `NOT EXISTS`, correlated subqueries |
| 05 | [Late returns by customer](05_late_returns_by_customer.sql) | `INTERVAL` date math, `CASE`, `FILTER`, `HAVING` |

## Running the queries

1. Install PostgreSQL and load Pagila using the instructions in the [Pagila repository](https://github.com/devrimgunduz/pagila).
2. Connect to the `pagila` database (pgAdmin Query Tool or `psql`) and run any of the `.sql` files.

Written and tested on PostgreSQL 18.3.