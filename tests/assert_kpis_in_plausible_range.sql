-- Guardrails on settled months: ratios outside these bands usually mean a broken join or a bad load.
-- Uses the trailing 3-month collection ratio, since single months swing with payment lag.
-- Skips the first 3 months (no full window yet) and the latest month (payments still arriving).
with bounds as (
    select min(month_start) as first_month, max(month_start) as last_month
    from {{ ref('rpt_location_monthly_kpis') }}
)

select k.location_id, k.month_start, k.collection_ratio_t3m, k.payroll_pct_of_production
from {{ ref('rpt_location_monthly_kpis') }} k
cross join bounds b
where k.month_start >= {{ dbt.dateadd('month', 3, 'b.first_month') }}
  and k.month_start < b.last_month
  and (k.collection_ratio_t3m not between 0.80 and 1.10
       or k.payroll_pct_of_production not between 0.10 and 0.60)
