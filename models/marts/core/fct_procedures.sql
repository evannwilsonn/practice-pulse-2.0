-- Grain: one completed procedure. This is gross production.
select
    p.procedure_id,
    p.source_system,
    p.location_id,
    p.patient_id,
    p.provider_id,
    p.service_date,
    cast({{ dbt.date_trunc('month', 'p.service_date') }} as date)  as service_month,
    p.cdt_code,
    coalesce(c.procedure_category, 'Uncategorized')               as procedure_category,
    p.fee_amount                                                  as production_amount
from {{ ref('int_procedures__unioned') }} p
left join {{ ref('dim_procedure_codes') }} c on p.cdt_code = c.cdt_code
