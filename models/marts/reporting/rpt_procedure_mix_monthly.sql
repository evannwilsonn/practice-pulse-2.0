-- Grain: one location, month and procedure category.
select
    location_id,
    service_month           as month_start,
    procedure_category,
    count(*)                as procedures,
    sum(production_amount)  as gross_production
from {{ ref('fct_procedures') }}
group by 1, 2, 3
