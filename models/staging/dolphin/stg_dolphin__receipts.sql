with source as (
    select * from {{ source('dolphin', 'receipts') }}
)

select
    'DOL-' || trim(ReceiptNo)                   as payment_id,
    'dolphin'                                   as source_system,
    (select location_id from {{ ref('locations') }} where pms_system = 'dolphin') as location_id,
    trim(PatientID)                             as patient_id,
    trim(TxID)                                  as procedure_id,
    {{ parse_date('ReceiptDate', 'dmy') }}      as payment_date,
    {{ clean_money('Amount') }}                 as payment_amount,
    'unspecified'                               as payment_method,
    _loaded_at
from source
