-- Write-offs and discounts posted against procedures. Open Dental stores them as negative amounts.
with source as (
    select * from {{ source('open_dental', 'adjustment') }}
),

clinics as (
    select alias_value, location_id from {{ ref('location_aliases') }}
    where alias_type = 'open_dental_clinic'
)

select
    'OD-ADJ-' || source.AdjNum                                       as adjustment_id,
    'open_dental'                                                    as source_system,
    clinics.location_id,
    clinics.location_id || '-P' || lpad(source.PatNum, 6, '0')      as patient_id,
    'OD-' || trim(source.ProcNum)                                    as procedure_id,
    {{ parse_date('source.AdjDate', 'iso') }}                        as adjustment_date,
    {{ clean_money('source.AdjAmt') }}                               as adjustment_amount,
    case when lower(source.AdjType) like '%ppo%' then 'insurance_write_off' else 'courtesy' end
                                                                     as adjustment_type,
    source._loaded_at
from source
left join clinics on trim(source.ClinicNum) = clinics.alias_value
