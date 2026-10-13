-- Dentrix Ascend prints negative amounts accounting-style, e.g. ($1,234.56); clean_money() reads the parentheses as a minus sign.
with source as (
    select * from {{ source('dentrix_ascend', 'adjustments_export') }}
),

aliases as (
    select alias_value, location_id from {{ ref('location_aliases') }}
    where alias_type = 'location_name'
)

select
    trim(source.adjustment_id)                          as adjustment_id,
    'dentrix_ascend'                                    as source_system,
    aliases.location_id,
    trim(source.patient_guid)                           as patient_id,
    trim(source.procedure_id)                           as procedure_id,
    {{ parse_date('source.posted_on', 'mdy') }}         as adjustment_date,
    {{ clean_money('source.amount') }}                  as adjustment_amount,
    case when lower(source.adjustment_type) like '%insurance%' then 'insurance_write_off' else 'courtesy' end
                                                        as adjustment_type,
    source._loaded_at
from source
left join aliases on {{ normalize_text('source.location_name') }} = aliases.alias_value
