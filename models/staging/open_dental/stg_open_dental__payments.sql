with source as (
    select * from {{ source('open_dental', 'payment') }}
),

clinics as (
    select alias_value, location_id from {{ ref('location_aliases') }}
    where alias_type = 'open_dental_clinic'
)

select
    'OD-PAY-' || source.PayNum                                       as payment_id,
    'open_dental'                                                    as source_system,
    clinics.location_id,
    clinics.location_id || '-P' || lpad(source.PatNum, 6, '0')      as patient_id,
    nullif('OD-' || nullif(trim(source.ProcNum), ''), 'OD-')         as procedure_id,
    {{ parse_date('source.PayDate', 'iso') }}                        as payment_date,
    {{ clean_money('source.PayAmt') }}                               as payment_amount,
    lower(trim(source.PayType))                                      as payment_method,
    source._loaded_at
from source
left join clinics on trim(source.ClinicNum) = clinics.alias_value
