with source as (
    select * from {{ source('sage_intacct', 'gl_detail') }}
)

select
    'GL-' || RECORDNO                                                   as gl_entry_id,
    trim(LOCATIONID)                                                    as location_id,
    {{ parse_date('WHENCREATED', 'mdy') }}                              as posted_date,
    trim(ACCOUNTNO)                                                     as account_number,
    trim(ACCOUNTTITLE)                                                  as account_title,
    {{ clean_money('DEBITAMOUNT') }} - {{ clean_money('CREDITAMOUNT') }} as net_amount
from source
