with days as (
    {{ day_spine('2024-01-01', '2026-12-31') }}
)

select
    date_day,
    cast({{ dbt.date_trunc('month', 'date_day') }} as date)    as month_start,
    cast({{ dbt.date_trunc('quarter', 'date_day') }} as date)  as quarter_start,
    extract(year from date_day)                                as year_number,
    extract(month from date_day)                               as month_number,
    extract(dow from date_day) in (0, 6)                       as is_weekend
from days
