-- One shape for completed production across all three practice management systems.
{% set sources = ['stg_open_dental__procedures', 'stg_dentrix_ascend__procedures', 'stg_dolphin__transactions'] %}

with unioned as (
    {% for model in sources %}
    select
        procedure_id, source_system, location_id, patient_id, provider_id,
        service_date, cdt_code, fee_amount, procedure_status
    from {{ ref(model) }}
    {% if not loop.last %}union all{% endif %}
    {% endfor %}
)

select * from unioned
where procedure_status = 'completed'
