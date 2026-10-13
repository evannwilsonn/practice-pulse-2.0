-- Dolphin records adjustments as positive reductions; flip the sign so every system agrees (negative = less revenue).
with offices as (
    select alias_value, location_id from {{ ref('location_aliases') }}
    where alias_type = 'dolphin_office'
),

source as (
    select * from {{ source('dolphin', 'adjustments') }}
)

select
    'DOL-' || trim(source.AdjID)                        as adjustment_id,
    'dolphin'                                           as source_system,
    offices.location_id,
    trim(source.PatientID)                              as patient_id,
    trim(source.TxID)                                   as procedure_id,
    {{ parse_date('source.AdjDate', 'dmy') }}           as adjustment_date,
    -{{ clean_money('source.Amount') }}                 as adjustment_amount,
    case when lower(source.Reason) like '%insurance%' then 'insurance_write_off' else 'courtesy' end
                                                        as adjustment_type,
    source._loaded_at
from source
left join offices on {{ normalize_text('source.Office') }} = offices.alias_value
