-- Every write-off must belong to a completed procedure at the same office, reduce revenue (negative),
-- and never exceed the fee it adjusts.
select a.adjustment_id, a.adjustment_amount, p.production_amount
from {{ ref('fct_adjustments') }} a
left join {{ ref('fct_procedures') }} p on a.procedure_id = p.procedure_id
where p.procedure_id is null
   or a.location_id <> p.location_id
   or a.adjustment_amount >= 0
   or -a.adjustment_amount > p.production_amount
