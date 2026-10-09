-- Total production in the mart must equal completed work in each source system, to the cent.
-- If this fails, rows were dropped or double-counted between staging and reporting.
with source_totals as (
    select 'open_dental' as source_system, sum(fee_amount) as total
    from {{ ref('stg_open_dental__procedures') }} where procedure_status = 'completed'
    union all
    select 'dentrix_ascend', sum(fee_amount)
    from {{ ref('stg_dentrix_ascend__procedures') }} where procedure_status = 'completed'
    union all
    select 'dolphin', sum(fee_amount)
    from {{ ref('stg_dolphin__transactions') }}
),

mart_totals as (
    select l.pms_system as source_system, sum(k.gross_production) as total
    from {{ ref('rpt_location_monthly_kpis') }} k
    join {{ ref('dim_locations') }} l on k.location_id = l.location_id
    group by 1
)

select s.source_system, s.total as source_total, m.total as mart_total
from source_totals s
left join mart_totals m on s.source_system = m.source_system
where abs(coalesce(m.total, 0) - s.total) > 0.01
