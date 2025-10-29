-- revenue_by_state.sql

-- This query calculates the total revenue and total quantity sold for each store.
SELECT
  store_id,
  SUM(total_amount) AS total_revenue,
  SUM(quantity) AS total_quantity
FROM {{ ref('silver_sales') }}
GROUP BY store_id