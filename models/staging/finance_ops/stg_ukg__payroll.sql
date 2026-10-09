with source as (
    select * from {{ source('ukg', 'payroll_register') }}
),

aliases as (
    select alias_value, location_id from {{ ref('location_aliases') }}
    where alias_type = 'location_name'
)

select
    source.employee_id || '-' || source.pay_date        as payroll_line_id,
    trim(source.employee_id)                            as employee_id,
    aliases.location_id,
    {{ parse_date('source.pay_date', 'iso') }}          as pay_date,
    trim(source.job_title)                              as job_title,
    cast(source.hours_worked as decimal(8, 2))          as hours_worked,
    {{ clean_money('source.gross_pay') }}               as gross_pay
from source
left join aliases on {{ normalize_text('source.home_location') }} = aliases.alias_value
