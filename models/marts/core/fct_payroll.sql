-- Grain: one employee on one pay date.
select
    payroll_line_id,
    employee_id,
    location_id,
    pay_date,
    cast({{ dbt.date_trunc('month', 'pay_date') }} as date)  as pay_month,
    job_title,
    job_title in ('Dentist', 'Orthodontist', 'Dental Hygienist')  as is_producing_provider,
    hours_worked,
    gross_pay
from {{ ref('stg_ukg__payroll') }}
