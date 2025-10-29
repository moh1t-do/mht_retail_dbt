-- silver_products.sql

-- loads all records from the 'products' source table.
WITH source_data AS (
    SELECT *
    FROM {{ source('retail_bronze', 'products') }}
),

-- cleans and deduplicates product records 
deduped_products AS (
    SELECT
        trim(product_id) AS product_id,
        trim(product_name) AS product_name,
        trim(category) AS category,
        cast(price AS FLOAT) AS price
    FROM source_data
    WHERE product_id IS NOT NULL
      AND product_name IS NOT NULL
      AND price > 0
    QUALIFY ROW_NUMBER() OVER (PARTITION BY trim(product_id) ORDER BY product_name) = 1
)

-- outputs the cleaned and deduplicated product records
SELECT *
FROM deduped_products