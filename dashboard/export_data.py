"""
Export the reporting marts the dashboard reads into dashboard/data.json.

Run after `dbt build`:  python dashboard/export_data.py
"""
from __future__ import annotations

import json
from datetime import date
from pathlib import Path

import duckdb

ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "warehouse" / "practice_pulse.duckdb"
OUT = ROOT / "dashboard" / "data.json"

KPI_COLS = [
    "location_id", "month_start", "gross_production", "write_offs", "net_production", "collections", "patient_visits",
    "new_patients", "provider_hours", "payroll_cost", "supply_cost", "lab_fees",
    "overhead_cost", "ad_spend", "operating_profit",
]


def main() -> None:
    con = duckdb.connect(str(DB), read_only=True)
    locations = [
        dict(zip(["id", "name", "region", "metro", "pms", "specialty"], r))
        for r in con.execute(
            "select location_id, location_name, region, metro, pms_system, specialty from core.dim_locations order by 1"
        ).fetchall()
    ]
    kpis = con.execute(
        f"select {', '.join(KPI_COLS)} from reporting.rpt_location_monthly_kpis order by location_id, month_start"
    ).fetchall()
    mix = con.execute(
        "select location_id, month_start, procedure_category, procedures, gross_production "
        "from reporting.rpt_procedure_mix_monthly order by 1, 2, 3"
    ).fetchall()
    sources = con.execute(
        "select source_system, count(*) from core.fct_procedures group by 1 order by 1"
    ).fetchall()

    one = lambda sql: con.execute(sql).fetchone()[0]
    cleanup = {
        "dentrix_duplicates_removed": one("select (select count(*) from raw_dentrix_ascend.procedures_export) - (select count(*) from staging.stg_dentrix_ascend__procedures)"),
        "open_dental_deleted_excluded": one("select count(*) from staging.stg_open_dental__procedures where procedure_status = 'deleted'"),
        "dentrix_planned_excluded": one("select count(*) from staging.stg_dentrix_ascend__procedures where procedure_status = 'planned'"),
        "location_spellings": one("select count(distinct location_name) from raw_dentrix_ascend.procedures_export"),
        "location_spellings_offices": one("select count(distinct s.location_id) from staging.stg_dentrix_ascend__procedures s"),
        "refunds": one("select count(*) from core.fct_payments where is_refund"),
        "adjustment_rows": one("select count(*) from core.fct_adjustments"),
        "dentrix_accounting_negatives": one("select count(*) from raw_dentrix_ascend.adjustments_export where trim(amount) like '(%)'"),
        "dolphin_sign_flips": one("select count(*) from raw_dolphin.adjustments"),
        "dolphin_office_codes": one("select count(distinct Office) from raw_dolphin.transactions"),
        "refund_amount": float(one("select sum(payment_amount) from core.fct_payments where is_refund")),
    }
    # the same check as tests/assert_production_reconciles_to_sources.sql, exported so the page can show it
    write_off_recon = [
        {"source": s, "source_total": float(st), "mart_total": float(mt)}
        for s, st, mt in con.execute("""
            with src as (
                select 'open_dental' as s, sum(adjustment_amount) as t from staging.stg_open_dental__adjustments
                union all select 'dentrix_ascend', sum(adjustment_amount) from staging.stg_dentrix_ascend__adjustments
                union all select 'dolphin', sum(adjustment_amount) from staging.stg_dolphin__adjustments
            ), mart as (
                select l.pms_system as s, -sum(k.write_offs) as t
                from reporting.rpt_location_monthly_kpis k join core.dim_locations l using (location_id) group by 1
            )
            select src.s, round(-src.t, 2), round(-mart.t, 2) from src left join mart using (s) order by 1""").fetchall()
    ]
    reconciliation = [
        {"source": s, "source_total": float(st), "mart_total": float(mt)}
        for s, st, mt in con.execute("""
            with src as (
                select 'open_dental' as s, sum(fee_amount) as t from staging.stg_open_dental__procedures where procedure_status = 'completed'
                union all select 'dentrix_ascend', sum(fee_amount) from staging.stg_dentrix_ascend__procedures where procedure_status = 'completed'
                union all select 'dolphin', sum(fee_amount) from staging.stg_dolphin__transactions
            ), mart as (
                select l.pms_system as s, sum(k.gross_production) as t
                from reporting.rpt_location_monthly_kpis k join core.dim_locations l using (location_id) group by 1
            )
            select src.s, round(src.t, 2), round(mart.t, 2) from src left join mart using (s) order by 1""").fetchall()
    ]

    def clean(v):
        if isinstance(v, date):
            return v.isoformat()[:7]
        if isinstance(v, float):
            return round(v, 2)
        return float(round(v, 2)) if hasattr(v, "as_tuple") else v

    payload = {
        "generated": date.today().isoformat(),
        "locations": locations,
        "kpi_columns": KPI_COLS,
        "kpis": [[clean(v) for v in r] for r in kpis],
        "mix_columns": ["location_id", "month", "category", "procedures", "production"],
        "mix": [[clean(v) for v in r] for r in mix],
        "procedure_rows_by_source": {s: n for s, n in sources},
        "cleanup": cleanup,
        "reconciliation": reconciliation,
        "write_off_reconciliation": write_off_recon,
    }
    OUT.write_text(json.dumps(payload, separators=(",", ":")))
    print(f"Wrote {OUT.relative_to(ROOT)} ({OUT.stat().st_size / 1024:.0f} KB, {len(kpis)} KPI rows, {len(mix)} mix rows)")


if __name__ == "__main__":
    main()
