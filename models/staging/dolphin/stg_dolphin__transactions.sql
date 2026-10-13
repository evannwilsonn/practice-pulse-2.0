-- Dolphin runs at the three ortho offices; each row carries a short office code mapped through the alias seed.
with offices as (
    select alias_value, location_id from {{ ref('location_aliases') }}
    where alias_type = 'dolphin_office'
),

source as (
    select * from {{ source('dolphin', 'transactions') }}
)

select
    trim(TxID)                                  as procedure_id,
    'dolphin'                                   as source_system,
    offices.location_id,
    trim(PatientID)                             as patient_id,
    nullif(trim(Doctor), '')                    as provider_id,
    {{ parse_date('TxDate', 'dmy') }}           as service_date,
    upper(trim(Code))                           as cdt_code,
    {{ clean_money('Fee') }}                    as fee_amount,
    'completed'                                 as procedure_status,
    _loaded_at
from source
left join offices on {{ normalize_text('source.Office') }} = offices.alias_value
