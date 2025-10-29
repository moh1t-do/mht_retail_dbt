-- top 5 products.sql

-- This query identifies the top 5 products by total revenue.
WITH product_revenue AS (
  SELECT
    product_id AS product_id,
    SUM(total_amount) AS revenue
  FROM {{ ref('silver_sales') }}
  GROUP BY product_id
),
ranked_products AS (
  SELECT
    product_id,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
  FROM product_revenue
)

SELECT
  product_id,
  revenue,
  revenue_rank
FROM ranked_products
WHERE revenue_rank <= 5