-- revenue_by_sales_category.sql

-- This query calculates the total revenue for each product and its corresponding sales category.
SELECT
  s.product_id,
  p.category,
  SUM(s.total_amount) AS revenue
FROM {{ ref('silver_sales') }} s
JOIN {{ ref('silver_products') }} p ON s.product_id = p.product_id
GROUP BY s.product_id, p.category