"""
Load raw source exports into the warehouse landing zone.

Everything lands as text, exactly as exported, plus two audit columns
(_source_file, _loaded_at). Typing, cleaning and deduping happen in dbt,
so the raw layer is always a faithful copy of what the vendor sent.

Local run (DuckDB):  python ingest/load_raw.py
On Snowflake, the same files are staged and loaded with COPY INTO;
see ingest/snowflake_load.sql.
"""
from __future__ import annotations

from datetime import datetime, timezone
from pathlib import Path

import duckdb

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
DB = ROOT / "warehouse" / "practice_pulse.duckdb"

# (schema, table, file, reader)
SOURCES = [
    ("raw_open_dental", "procedurelog", "open_dental/procedurelog.csv", "csv"),
    ("raw_open_dental", "payment", "open_dental/payment.csv", "csv"),
    ("raw_open_dental", "adjustment", "open_dental/adjustment.csv", "csv"),
    ("raw_dentrix_ascend", "procedures_export", "dentrix_ascend/procedures_export.csv", "csv"),
    ("raw_dentrix_ascend", "payments_export", "dentrix_ascend/payments_export.csv", "csv"),
    ("raw_dentrix_ascend", "adjustments_export", "dentrix_ascend/adjustments_export.csv", "csv"),
    ("raw_dolphin", "transactions", "dolphin/transactions.csv", "csv;"),
    ("raw_dolphin", "receipts", "dolphin/receipts.csv", "csv;"),
    ("raw_dolphin", "adjustments", "dolphin/adjustments.csv", "csv;"),
    ("raw_sage_intacct", "gl_detail", "sage_intacct/gl_detail.csv", "csv"),
    ("raw_ukg", "payroll_register", "ukg/payroll_register.csv", "csv"),
    ("raw_henry_schein", "supply_orders", "henry_schein/supply_orders.csv", "csv"),
    ("raw_google_ads", "campaign_daily", "google_ads/campaign_daily.jsonl", "json"),
]


def main() -> None:
    DB.parent.mkdir(parents=True, exist_ok=True)
    con = duckdb.connect(str(DB))
    loaded_at = datetime.now(timezone.utc).isoformat(timespec="seconds")
    print(f"Loading into {DB.relative_to(ROOT)}")
    for schema, table, rel, reader in SOURCES:
        path = (RAW / rel).as_posix()
        if not Path(path).exists():
            raise SystemExit(f"Missing {rel}. Run ingest/generate_sources.py first.")
        con.execute(f"create schema if not exists {schema}")
        if reader.startswith("csv"):
            delim = ";" if reader == "csv;" else ","
            src = f"read_csv('{path}', delim='{delim}', quote='\"', escape='\"', header=true, all_varchar=true)"
        else:
            # API payloads land untouched as one JSON column, like a Snowflake VARIANT
            src = f"(select json as payload from read_json_objects('{path}', format='newline_delimited'))"
        con.execute(f"""
            create or replace table {schema}.{table} as
            select *, '{rel}' as _source_file, '{loaded_at}'::timestamp as _loaded_at
            from {src}
        """)
        n = con.execute(f"select count(*) from {schema}.{table}").fetchone()[0]
        print(f"  {schema}.{table:<20} {n:>8,} rows")
    con.close()


if __name__ == "__main__":
    main()
