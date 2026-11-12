# Pagila SQL Analysis

SQL analysis of the [Pagila](https://github.com/devrimgunduz/pagila) sample database (a DVD rental store: customers, films, rentals, payments, staff and stores) in PostgreSQL, organized by business question.

Each query file starts with a comment block covering the question, the SQL concepts it uses, the approach, and any judgment calls about the data (for example, which of two possible joins defines a customer's "store").

## Queries

| # | Question | Concepts |
|---|---|---|
| 01 | [Top 3 customers by total paid, per store](queries/01_top_customers_per_store.sql) | CTEs, GROUP BY, window functions (`RANK` with `PARTITION BY`) |

## Running the queries

1. Install PostgreSQL and load Pagila using the instructions in the [Pagila repository](https://github.com/devrimgunduz/pagila).
2. Connect to the `pagila` database (pgAdmin Query Tool or `psql`) and run any file in `queries/`.

Written and tested on PostgreSQL 18.3.