-- silver_sales.sql

{{ config(
    materialized='incremental',
    unique_key='Sale_ID',
)}}

-- loads raw sales data from the bronze source.
with source_data as (
    select * from {{ source('retail_bronze', 'sales') }}
),

-- deduplicates records by sale_id, keeping the latest sale_date.
deduped as (
    select
        trim(sale_id) as sale_id,
        trim(product_id) as product_id,
        trim(store_id) as store_id,
        {{ standardize_date('sale_date') }} as sale_date,
        cast(quantity as integer) as quantity,
        cast(total_amount as float) as total_amount
    from (
        select *
        from source_data
        where sale_id is not null
          and product_id is not null
          and store_id is not null
          and quantity > 0
          and total_amount > 0
        qualify row_number() over (partition by sale_id order by sale_date desc) = 1
    )
),

-- joins with silver_products and silver_stores to ensure referential integrity.
refs as (
    select d.*
    from deduped d
    inner join {{ ref('silver_products') }} p on d.product_id = p.product_id
    inner join {{ ref('silver_stores') }} s on d.store_id = s.store_id
)

-- on incremental runs, only loads new sales with sale_date greater than the latest in the target table.
select *
from refs
{% if is_incremental() %}
  where sale_date > (select max(sale_date) from {{ this }})
{% endif %}