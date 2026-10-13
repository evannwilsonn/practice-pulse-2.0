-- Write-offs in the mart must equal the adjustments each practice system exported, to the cent.
with source_totals as (
    select 'open_dental' as source_system, sum(adjustment_amount) as total from {{ ref('stg_open_dental__adjustments') }}
    union all
    select 'dentrix_ascend', sum(adjustment_amount) from {{ ref('stg_dentrix_ascend__adjustments') }}
    union all
    select 'dolphin', sum(adjustment_amount) from {{ ref('stg_dolphin__adjustments') }}
),

mart_totals as (
    select l.pms_system as source_system, -sum(k.write_offs) as total
    from {{ ref('rpt_location_monthly_kpis') }} k
    join {{ ref('dim_locations') }} l on k.location_id = l.location_id
    group by 1
)

select s.source_system, s.total as source_total, m.total as mart_total
from source_totals s
left join mart_totals m on s.source_system = m.source_system
where abs(coalesce(m.total, 0) - s.total) > 0.01
