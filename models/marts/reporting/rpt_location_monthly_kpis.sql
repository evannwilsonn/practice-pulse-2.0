-- Grain: one location in one month. The table the executive dashboard reads.
with months as (
    select distinct month_start
    from {{ ref('dim_date') }}
    where month_start <= (select max(service_month) from {{ ref('fct_procedures') }})
),

spine as (
    select l.location_id, l.location_name, l.specialty, m.month_start
    from {{ ref('dim_locations') }} l
    cross join months m
),

production as (
    select
        location_id,
        service_month                                                  as month_start,
        sum(production_amount)                                         as gross_production,
        count(*)                                                       as procedures,
        count(distinct patient_id || '|' || cast(service_date as varchar)) as patient_visits,
        count(distinct provider_id)                                    as active_providers
    from {{ ref('fct_procedures') }}
    group by 1, 2
),

new_patients as (
    select
        location_id,
        cast({{ dbt.date_trunc('month', 'first_visit_date') }} as date) as month_start,
        count(*)                                                        as new_patients
    from {{ ref('int_patients__first_visit') }}
    group by 1, 2
),

collections as (
    select
        location_id,
        payment_month                                              as month_start,
        sum(payment_amount)                                        as collections,
        sum(case when is_refund then -payment_amount else 0 end)   as refunds
    from {{ ref('fct_payments') }}
    group by 1, 2
),

payroll as (
    select
        location_id,
        pay_month                                                          as month_start,
        sum(gross_pay)                                                     as payroll_cost,
        sum(case when is_producing_provider then hours_worked else 0 end)  as provider_hours
    from {{ ref('fct_payroll') }}
    group by 1, 2
),

expenses as (
    select
        location_id,
        expense_month                                                                as month_start,
        sum(case when expense_group = 'Supplies' then expense_amount else 0 end)              as supply_cost,
        sum(case when expense_group = 'Lab Fees' then expense_amount else 0 end)              as lab_fees,
        sum(case when expense_group = 'Facilities & Overhead' then expense_amount else 0 end) as overhead_cost
    from {{ ref('fct_operating_expenses') }}
    group by 1, 2
),

marketing as (
    select
        location_id,
        ad_month           as month_start,
        sum(ad_spend)      as ad_spend,
        sum(conversions)   as ad_conversions
    from {{ ref('fct_marketing_daily') }}
    group by 1, 2
),

joined as (
    select
        s.location_id,
        s.location_name,
        s.specialty,
        s.month_start,
        coalesce(p.gross_production, 0)  as gross_production,
        coalesce(c.collections, 0)       as collections,
        coalesce(c.refunds, 0)           as refunds,
        coalesce(p.procedures, 0)        as procedures,
        coalesce(p.patient_visits, 0)    as patient_visits,
        coalesce(n.new_patients, 0)      as new_patients,
        coalesce(p.active_providers, 0)  as active_providers,
        coalesce(pr.payroll_cost, 0)     as payroll_cost,
        coalesce(pr.provider_hours, 0)   as provider_hours,
        coalesce(e.supply_cost, 0)       as supply_cost,
        coalesce(e.lab_fees, 0)          as lab_fees,
        coalesce(e.overhead_cost, 0)     as overhead_cost,
        coalesce(m.ad_spend, 0)          as ad_spend,
        coalesce(m.ad_conversions, 0)    as ad_conversions
    from spine s
    left join production p    on s.location_id = p.location_id  and s.month_start = p.month_start
    left join new_patients n  on s.location_id = n.location_id  and s.month_start = n.month_start
    left join collections c   on s.location_id = c.location_id  and s.month_start = c.month_start
    left join payroll pr      on s.location_id = pr.location_id and s.month_start = pr.month_start
    left join expenses e      on s.location_id = e.location_id  and s.month_start = e.month_start
    left join marketing m     on s.location_id = m.location_id  and s.month_start = m.month_start
)

select
    *,
    collections / nullif(gross_production, 0)                      as collection_ratio,
    sum(collections) over w3 / nullif(sum(gross_production) over w3, 0)
                                                                   as collection_ratio_t3m,
    gross_production / nullif(patient_visits, 0)                   as production_per_visit,
    gross_production / nullif(provider_hours, 0)                   as production_per_provider_hour,
    payroll_cost / nullif(gross_production, 0)                     as payroll_pct_of_production,
    supply_cost / nullif(gross_production, 0)                      as supply_pct_of_production,
    ad_spend / nullif(new_patients, 0)                             as ad_cost_per_new_patient,
    collections - payroll_cost - supply_cost - lab_fees - overhead_cost - ad_spend
                                                                   as operating_profit,
    (collections - payroll_cost - supply_cost - lab_fees - overhead_cost - ad_spend)
        / nullif(collections, 0)                                   as operating_margin
from joined
window w3 as (partition by location_id order by month_start rows between 2 preceding and current row)
