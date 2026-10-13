-- Guardrails on settled months: ratios outside these bands usually mean a broken join or a bad load.
-- Both ratios use trailing three-month windows: collections lag the visit by up to 60 days, and payroll
-- is biweekly, so a month with three paychecks would otherwise read 50% high.
-- Skips the first 3 months (no full window yet) and the latest month (payments still arriving).
with bounds as (
    select min(month_start) as first_month, max(month_start) as last_month
    from {{ ref('rpt_location_monthly_kpis') }}
),

windowed as (
    select
        location_id,
        month_start,
        collection_rate_t3m,
        sum(payroll_cost) over w3 / nullif(sum(gross_production) over w3, 0) as payroll_pct_t3m
    from {{ ref('rpt_location_monthly_kpis') }}
    window w3 as (partition by location_id order by month_start rows between 2 preceding and current row)
)

select k.location_id, k.month_start, k.collection_rate_t3m, k.payroll_pct_t3m
from windowed k
cross join bounds b
where k.month_start >= {{ dbt.dateadd('month', 3, 'b.first_month') }}
  and k.month_start < b.last_month
  and (k.collection_rate_t3m not between 0.80 and 1.10
       or k.payroll_pct_t3m not between 0.10 and 0.60)
