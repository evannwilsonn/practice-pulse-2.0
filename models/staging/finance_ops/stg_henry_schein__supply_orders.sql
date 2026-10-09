with source as (
    select * from {{ source('henry_schein', 'supply_orders') }}
)

select
    row_number() over (order by order_date, ship_to, sku)    as supply_order_line_id,
    trim(ship_to)                                             as location_id,
    {{ parse_date('order_date', 'iso') }}                     as order_date,
    trim(category)                                            as supply_category,
    trim(sku)                                                 as sku,
    cast(qty as integer)                                      as quantity,
    {{ clean_money('unit_cost') }}                            as unit_cost,
    cast(qty as integer) * {{ clean_money('unit_cost') }}     as line_total
from source
