-- Grain: one expense line. Combines GL detail and supply orders into one expense view,
-- so every non-payroll cost can be sliced by location and month the same way.
select
    gl_entry_id                                                as expense_line_id,
    'sage_intacct'                                             as source_system,
    location_id,
    posted_date                                                as expense_date,
    cast({{ dbt.date_trunc('month', 'posted_date') }} as date)  as expense_month,
    case account_number
        when '6200' then 'Lab Fees'
        else 'Facilities & Overhead'
    end                                                        as expense_group,
    account_title                                              as expense_type,
    net_amount                                                 as expense_amount
from {{ ref('stg_sage_intacct__gl_detail') }}

union all

select
    'SUP-' || cast(supply_order_line_id as varchar),
    'henry_schein',
    location_id,
    order_date,
    cast({{ dbt.date_trunc('month', 'order_date') }} as date),
    'Supplies',
    supply_category,
    line_total
from {{ ref('stg_henry_schein__supply_orders') }}
