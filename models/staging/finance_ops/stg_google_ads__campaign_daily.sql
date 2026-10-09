-- Campaign names follow "Search | <Location> | <Goal>"; the middle segment maps to a location.
with source as (
    select
        {{ json_text('payload', 'Day') }}          as day_text,
        {{ json_text('payload', 'Campaign') }}     as campaign_name,
        {{ json_text('payload', 'Cost') }}         as cost_text,
        {{ json_text('payload', 'Clicks') }}       as clicks_text,
        {{ json_text('payload', 'Conversions') }}  as conversions_text
    from {{ source('google_ads', 'campaign_daily') }}
),

aliases as (
    select alias_value, location_id from {{ ref('location_aliases') }}
    where alias_type = 'location_name'
)

select
    cast({{ parse_date('source.day_text', 'iso') }} as varchar) || '-' || aliases.location_id   as ad_day_id,
    {{ parse_date('source.day_text', 'iso') }}         as ad_date,
    aliases.location_id,
    source.campaign_name,
    {{ clean_money('source.cost_text') }}              as ad_spend,
    cast(source.clicks_text as integer)                as clicks,
    cast(source.conversions_text as integer)           as conversions
from source
left join aliases
    on {{ normalize_text("split_part(source.campaign_name, ' | ', 2)") }} = aliases.alias_value
