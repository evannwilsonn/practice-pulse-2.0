with offices as (
    select alias_value, location_id from {{ ref('location_aliases') }}
    where alias_type = 'dolphin_office'
),

source as (
    select * from {{ source('dolphin', 'receipts') }}
)

select
    'DOL-' || trim(ReceiptNo)                   as payment_id,
    'dolphin'                                   as source_system,
    offices.location_id,
    trim(PatientID)                             as patient_id,
    trim(TxID)                                  as procedure_id,
    {{ parse_date('ReceiptDate', 'dmy') }}      as payment_date,
    {{ clean_money('Amount') }}                 as payment_amount,
    'unspecified'                               as payment_method,
    _loaded_at
from source
left join offices on {{ normalize_text('source.Office') }} = offices.alias_value
