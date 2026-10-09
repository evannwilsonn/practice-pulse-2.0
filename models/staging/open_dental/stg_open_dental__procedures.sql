with source as (
    select * from {{ source('open_dental', 'procedurelog') }}
),

clinics as (
    select alias_value, location_id from {{ ref('location_aliases') }}
    where alias_type = 'open_dental_clinic'
)

select
    'OD-' || source.ProcNum                                          as procedure_id,
    'open_dental'                                                    as source_system,
    clinics.location_id,
    clinics.location_id || '-P' || lpad(source.PatNum, 6, '0')      as patient_id,
    nullif(trim(source.ProvNum), '')                                 as provider_id,
    {{ parse_date('source.ProcDate', 'iso') }}                       as service_date,
    upper(trim(source.ProcCode))                                     as cdt_code,
    {{ clean_money('source.ProcFee') }}                              as fee_amount,
    case cast(source.ProcStatus as integer)
        when 2 then 'completed'
        when 1 then 'planned'
        when 6 then 'deleted'
        else 'other'
    end                                                              as procedure_status,
    source._loaded_at
from source
left join clinics on trim(source.ClinicNum) = clinics.alias_value
