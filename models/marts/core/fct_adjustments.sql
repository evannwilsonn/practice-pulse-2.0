-- Grain: one write-off or discount. Amounts are negative: they reduce gross production to net production.
select
    adjustment_id,
    source_system,
    location_id,
    patient_id,
    procedure_id,
    adjustment_date,
    cast({{ dbt.date_trunc('month', 'adjustment_date') }} as date)  as adjustment_month,
    adjustment_type,
    adjustment_amount
from {{ ref('int_adjustments__unioned') }}
