select
    location_id,
    location_name,
    region,
    metro,
    pms_system,
    specialty,
    opened_on
from {{ ref('locations') }}
