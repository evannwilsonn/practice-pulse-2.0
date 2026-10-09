-- A payment tied to a procedure can't be posted before the procedure happened.
select pay.payment_id, pay.payment_date, proc.service_date
from {{ ref('fct_payments') }} pay
join {{ ref('fct_procedures') }} proc on pay.procedure_id = proc.procedure_id
where pay.payment_date < proc.service_date
