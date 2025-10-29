-- daily sales trends.sql

-- calculates daily and running total revenue per store.
SELECT
  store_id,
  sale_date,
  SUM(total_amount) AS daily_revenue,
  SUM(SUM(total_amount)) OVER (PARTITION BY store_id ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_revenue
FROM {{ ref('silver_sales') }}
GROUP BY store_id, sale_date
ORDER BY store_id, sale_date