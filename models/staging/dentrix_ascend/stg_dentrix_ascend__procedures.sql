-- Re-exports from Dentrix Ascend can repeat a procedure; keep one row per procedure_id.
with source as (
    select * from {{ source('dentrix_ascend', 'procedures_export') }}
),

deduped as (
    select *
    from source
    qualify row_number() over (partition by procedure_id order by _loaded_at desc) = 1
),

aliases as (
    select alias_value, location_id from {{ ref('location_aliases') }}
    where alias_type = 'location_name'
)

select
    deduped.procedure_id,
    'dentrix_ascend'                                    as source_system,
    aliases.location_id,
    trim(deduped.patient_guid)                          as patient_id,
    nullif(trim(deduped.provider), '')                  as provider_id,
    {{ parse_date('deduped.service_date', 'mdy') }}     as service_date,
    upper(trim(deduped.cdt_code))                       as cdt_code,
    {{ clean_money('deduped.amount') }}                 as fee_amount,
    lower(trim(deduped.status))                         as procedure_status,
    deduped._loaded_at
from deduped
left join aliases on {{ normalize_text('deduped.location_name') }} = aliases.alias_value
