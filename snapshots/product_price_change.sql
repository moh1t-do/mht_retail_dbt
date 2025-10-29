-- Snapshot: product_price_changes
-- This snapshot tracks changes in the 'price' column for products in the 'silver_products' table.
{% snapshot product_price_changes %}

{{
  config(
    target_schema='retail_snapshot',
    unique_key='Product_ID',
    strategy='check',
    check_cols=['price']
  )
}}

SELECT * FROM {{ ref('silver_products') }}

{% endsnapshot %}