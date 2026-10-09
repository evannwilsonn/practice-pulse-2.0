select
    location_id,
    location_name,
    city,
    pms_system,
    specialty,
    opened_on
from {{ ref('locations') }}
