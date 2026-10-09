-- Load the raw exports into Snowflake (same landing zone as the DuckDB loader).
-- Run in a worksheet as a role that can create schemas in PRACTICE_PULSE.
-- Upload files first:  PUT file://data/raw/<source>/<file> @raw_stage/<source>/;

create database if not exists practice_pulse;
use database practice_pulse;

create schema if not exists raw_open_dental;
create schema if not exists raw_dentrix_ascend;
create schema if not exists raw_dolphin;
create schema if not exists raw_sage_intacct;
create schema if not exists raw_ukg;
create schema if not exists raw_henry_schein;
create schema if not exists raw_google_ads;

create or replace stage public.raw_stage;

create or replace file format public.csv_comma type = csv parse_header = true field_optionally_enclosed_by = '"';
create or replace file format public.csv_semicolon type = csv parse_header = true field_delimiter = ';';
create or replace file format public.jsonl type = json;

-- Example for one table; repeat the pattern for each file in ingest/load_raw.py.
-- Every column lands as varchar, plus the same two audit columns.
create or replace table raw_open_dental.procedurelog
  using template (
    select array_agg(object_construct('COLUMN_NAME', column_name, 'TYPE', 'VARCHAR', 'NULLABLE', true))
    from table(infer_schema(location => '@public.raw_stage/open_dental/procedurelog.csv',
                            file_format => 'public.csv_comma'))
  );
alter table raw_open_dental.procedurelog add column _source_file varchar, _loaded_at timestamp_ntz;

copy into raw_open_dental.procedurelog
  from (select t.*, metadata$filename, current_timestamp() from @public.raw_stage/open_dental/procedurelog.csv t)
  file_format = (format_name = 'public.csv_comma')
  match_by_column_name = case_insensitive;

-- Google Ads (JSON lines) lands as one variant column, then gets flattened in staging:
create or replace table raw_google_ads.campaign_daily (payload variant, _source_file varchar, _loaded_at timestamp_ntz);
copy into raw_google_ads.campaign_daily
  from (select $1, metadata$filename, current_timestamp() from @public.raw_stage/google_ads/campaign_daily.jsonl)
  file_format = (format_name = 'public.jsonl');
