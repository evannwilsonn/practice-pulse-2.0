-- Grain: one location on one day of paid search.
select
    ad_day_id,
    location_id,
    ad_date,
    cast({{ dbt.date_trunc('month', 'ad_date') }} as date)  as ad_month,
    ad_spend,
    clicks,
    conversions
from {{ ref('stg_google_ads__campaign_daily') }}
