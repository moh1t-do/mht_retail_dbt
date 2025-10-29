-- silver_stores.sql

-- Loads all records from the source table.
with source_data as (
    select * from {{ source('retail_bronze', 'stores') }}
),
-- Removes duplicate stores based on Store_ID, keeping only the first occurrence.
deduped_stores as (
    select
        trim(store_id) as store_id,
        trim(store_name) as store_name,
        trim(state) as state,
        trim(city) as city
    from source_data
    where 
        store_id is not null and
        store_name is not null and
        state is not null and
        city is not null
    qualify row_number() over (partition by trim(store_id) order by trim(store_id)) = 1
)

select * from deduped_stores