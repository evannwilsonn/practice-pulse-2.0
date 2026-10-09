with source as (
    select * from {{ source('dentrix_ascend', 'payments_export') }}
),

aliases as (
    select alias_value, location_id from {{ ref('location_aliases') }}
    where alias_type = 'location_name'
)

select
    source.payment_id,
    'dentrix_ascend'                                    as source_system,
    aliases.location_id,
    trim(source.patient_guid)                           as patient_id,
    trim(source.procedure_id)                           as procedure_id,
    {{ parse_date('source.posted_on', 'mdy') }}         as payment_date,
    {{ clean_money('source.amount') }}                  as payment_amount,
    lower(trim(source.method))                          as payment_method,
    source._loaded_at
from source
left join aliases on {{ normalize_text('source.location_name') }} = aliases.alias_value
