{#-
  Small cross-database helpers so every model runs unchanged on DuckDB (local)
  and Snowflake (production). Each one dispatches on the adapter.
-#}

{# Parse a text date in a known vendor format: 'iso' (2026-09-30), 'mdy' (09/30/2026), 'dmy' (30-09-2026) #}
{% macro parse_date(column, fmt) -%}{{ return(adapter.dispatch('parse_date')(column, fmt)) }}{%- endmacro %}

{% macro duckdb__parse_date(column, fmt) -%}
    {%- set f = {'iso': '%Y-%m-%d', 'mdy': '%m/%d/%Y', 'dmy': '%d-%m-%Y'}[fmt] -%}
    cast(try_strptime(trim({{ column }}), '{{ f }}') as date)
{%- endmacro %}

{% macro snowflake__parse_date(column, fmt) -%}
    {%- set f = {'iso': 'YYYY-MM-DD', 'mdy': 'MM/DD/YYYY', 'dmy': 'DD-MM-YYYY'}[fmt] -%}
    try_to_date(trim({{ column }}), '{{ f }}')
{%- endmacro %}

{# Turn '$1,234.56', ' 1234.56 ' or '' into a number (null when blank) #}
{% macro clean_money(column) -%}
    cast(nullif(replace(replace(trim({{ column }}), '$', ''), ',', ''), '') as decimal(12, 2))
{%- endmacro %}

{# Normalize free-text labels before matching them to the alias seed #}
{% macro normalize_text(column) -%}
    upper(trim({{ column }}))
{%- endmacro %}

{# Read a key out of a raw JSON payload as text #}
{% macro json_text(column, key) -%}{{ return(adapter.dispatch('json_text')(column, key)) }}{%- endmacro %}
{% macro duckdb__json_text(column, key) -%}({{ column }} ->> '{{ key }}'){%- endmacro %}
{% macro snowflake__json_text(column, key) -%}{{ column }}:"{{ key }}"::varchar{%- endmacro %}

{# One row per day between two literal dates #}
{% macro day_spine(start_date, end_date) -%}{{ return(adapter.dispatch('day_spine')(start_date, end_date)) }}{%- endmacro %}
{% macro duckdb__day_spine(start_date, end_date) -%}
    select cast(range as date) as date_day
    from range(date '{{ start_date }}', date '{{ end_date }}' + interval 1 day, interval 1 day)
{%- endmacro %}
{% macro snowflake__day_spine(start_date, end_date) -%}
    select dateadd(day, seq4(), to_date('{{ start_date }}')) as date_day
    from table(generator(rowcount => {{ (modules.datetime.date.fromisoformat(end_date) - modules.datetime.date.fromisoformat(start_date)).days + 1 }}))
{%- endmacro %}
