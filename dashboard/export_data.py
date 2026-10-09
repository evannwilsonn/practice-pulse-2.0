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
    "location_id", "month_start", "gross_production", "collections", "patient_visits",
    "new_patients", "provider_hours", "payroll_cost", "supply_cost", "lab_fees",
    "overhead_cost", "ad_spend", "operating_profit",
]


def main() -> None:
    con = duckdb.connect(str(DB), read_only=True)
    locations = [
        dict(zip(["id", "name", "city", "pms", "specialty"], r))
        for r in con.execute(
            "select location_id, location_name, city, pms_system, specialty from core.dim_locations order by 1"
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
    }
    OUT.write_text(json.dumps(payload, separators=(",", ":")))
    print(f"Wrote {OUT.relative_to(ROOT)} ({OUT.stat().st_size / 1024:.0f} KB, {len(kpis)} KPI rows, {len(mix)} mix rows)")


if __name__ == "__main__":
    main()
