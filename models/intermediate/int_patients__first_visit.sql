-- A patient is "new" in the month of their first completed procedure.
select
    patient_id,
    location_id,
    min(service_date) as first_visit_date
from {{ ref('int_procedures__unioned') }}
group by 1, 2
