-- Write-offs and courtesy discounts from all three practice management systems, in one sign convention.
{% set sources = ['stg_open_dental__adjustments', 'stg_dentrix_ascend__adjustments', 'stg_dolphin__adjustments'] %}

{% for model in sources %}
select
    adjustment_id, source_system, location_id, patient_id, procedure_id,
    adjustment_date, adjustment_amount, adjustment_type
from {{ ref(model) }}
{% if not loop.last %}union all{% endif %}
{% endfor %}
