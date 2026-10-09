{% set sources = ['stg_open_dental__payments', 'stg_dentrix_ascend__payments', 'stg_dolphin__receipts'] %}

with unioned as (
    {% for model in sources %}
    select
        payment_id, source_system, location_id, patient_id, procedure_id,
        payment_date, payment_amount, payment_method
    from {{ ref(model) }}
    {% if not loop.last %}union all{% endif %}
    {% endfor %}
)

select
    *,
    payment_amount < 0 as is_refund
from unioned
