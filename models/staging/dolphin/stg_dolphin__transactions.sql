-- Dolphin only runs at the ortho office, so every row belongs to that location.
with source as (
    select * from {{ source('dolphin', 'transactions') }}
)

select
    trim(TxID)                                  as procedure_id,
    'dolphin'                                   as source_system,
    (select location_id from {{ ref('locations') }} where pms_system = 'dolphin') as location_id,
    trim(PatientID)                             as patient_id,
    nullif(trim(Doctor), '')                    as provider_id,
    {{ parse_date('TxDate', 'dmy') }}           as service_date,
    upper(trim(Code))                           as cdt_code,
    {{ clean_money('Fee') }}                    as fee_amount,
    'completed'                                 as procedure_status,
    _loaded_at
from source
