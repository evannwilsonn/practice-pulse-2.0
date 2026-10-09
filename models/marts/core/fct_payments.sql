-- Grain: one payment or refund. Refunds are negative.
select
    payment_id,
    source_system,
    location_id,
    patient_id,
    procedure_id,
    payment_date,
    cast({{ dbt.date_trunc('month', 'payment_date') }} as date)  as payment_month,
    payment_method,
    payment_amount,
    is_refund
from {{ ref('int_payments__unioned') }}
