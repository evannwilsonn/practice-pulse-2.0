"""
Generate realistic source-system exports for a five-location dental group.

Each file mimics how the data actually arrives from that vendor: different
column names, date formats, delimiters and quirks. Some of the mess real
exports have is included on purpose (deleted records, duplicate rows,
inconsistent location names, currency strings), because handling it is
the point of the pipeline.

All data is synthetic. Run:  python ingest/generate_sources.py
"""
from __future__ import annotations

import argparse
import csv
import json
from datetime import date, timedelta
from pathlib import Path

import numpy as np

RAW = Path(__file__).resolve().parents[1] / "data" / "raw"

START = date(2024, 1, 1)
END = date(2026, 9, 30)

# location_id, display name, PMS, specialty, size factor
LOCATIONS = [
    ("L001", "Tampa Downtown", "open_dental", "general", 1.15),
    ("L002", "Brandon", "open_dental", "general", 0.95),
    ("L003", "Clearwater", "dentrix_ascend", "general", 1.00),
    ("L004", "Sarasota", "dentrix_ascend", "general", 0.80),
    ("L005", "Tampa Ortho", "dolphin", "orthodontics", 0.70),
]

# How each system spells the same clinic (Dentrix exports are free text)
DENTRIX_NAME_VARIANTS = {
    "L003": ["Clearwater", "CLEARWATER", "Clearwater ", "Clearwater Office"],
    "L004": ["Sarasota", "SARASOTA", "Sarasota Office", " Sarasota"],
}

# CDT code, description, category, typical fee, weight in visit mix
GENERAL_CODES = [
    ("D0120", "Periodic oral evaluation", "Diagnostic", 65, 22),
    ("D0150", "Comprehensive oral evaluation", "Diagnostic", 110, 5),
    ("D0274", "Bitewings, four films", "Diagnostic", 85, 12),
    ("D0330", "Panoramic radiograph", "Diagnostic", 135, 3),
    ("D1110", "Adult prophylaxis", "Preventive", 120, 24),
    ("D1120", "Child prophylaxis", "Preventive", 85, 5),
    ("D1206", "Fluoride varnish", "Preventive", 45, 5),
    ("D2391", "Resin composite, one surface", "Restorative", 210, 8),
    ("D2392", "Resin composite, two surfaces", "Restorative", 265, 5),
    ("D2740", "Porcelain crown", "Restorative", 1350, 3),
    ("D3330", "Root canal, molar", "Endodontics", 1250, 1.2),
    ("D4341", "Periodontal scaling, per quadrant", "Periodontics", 260, 3),
    ("D4910", "Periodontal maintenance", "Periodontics", 165, 4),
    ("D6010", "Implant body placement", "Implants", 2400, 0.6),
    ("D7140", "Extraction, erupted tooth", "Oral Surgery", 195, 2),
    ("D9944", "Occlusal guard", "Adjunctive", 550, 0.8),
]
ORTHO_CODES = [
    ("D8090", "Comprehensive orthodontic treatment, adult", "Orthodontics", 6200, 0.25),
    ("D8080", "Comprehensive orthodontic treatment, adolescent", "Orthodontics", 5600, 0.4),
    ("D8670", "Periodic orthodontic visit", "Orthodontics", 95, 40),
    ("D8680", "Orthodontic retention", "Orthodontics", 450, 4),
    ("D0140", "Limited oral evaluation", "Diagnostic", 75, 6),
    ("D8660", "Pre-orthodontic treatment visit", "Orthodontics", 150, 5),
]

ROLES = [  # title, hourly base, headcount per general office
    ("Dentist", 115.0, 2),
    ("Dental Hygienist", 44.0, 3),
    ("Dental Assistant", 22.0, 4),
    ("Front Office Coordinator", 19.5, 2),
    ("Office Manager", 32.0, 1),
]
ORTHO_ROLES = [
    ("Orthodontist", 120.0, 1),
    ("Orthodontic Assistant", 23.0, 4),
    ("Treatment Coordinator", 24.0, 1),
    ("Front Office Coordinator", 19.5, 2),
]

SUPPLY_CATEGORIES = [  # category, share of production
    ("Clinical Consumables", 0.028),
    ("Impression & Lab Materials", 0.012),
    ("Infection Control", 0.010),
    ("Orthodontic Brackets & Wires", 0.0),
    ("Office Supplies", 0.003),
]

GL_ACCOUNTS = [  # number, title, monthly base per size unit
    ("6100", "Rent & Occupancy", 24000),
    ("6200", "Dental Lab Fees", 0),          # driven by crowns/implants
    ("6300", "Utilities", 2800),
    ("6400", "Equipment Lease", 6500),
    ("6500", "Software & IT", 3500),
    ("6600", "Insurance", 2500),
    ("6700", "Billing & Admin Services", 9000),
    ("6800", "Merchant & Bank Fees", 6000),
    ("6900", "Continuing Education & Licenses", 1500),
    ("7000", "Community & Print Marketing", 2000),
]


def business_days(start: date, end: date):
    d = start
    while d <= end:
        if d.weekday() < 5 or (d.weekday() == 5 and d.day % 2 == 0):  # some Saturdays
            yield d
        d += timedelta(days=1)


def seasonality(d: date) -> float:
    # slower late Dec and mid-summer, busier Jan (new benefits) and fall
    m = d.month
    base = {1: 1.10, 2: 1.02, 3: 1.04, 4: 1.0, 5: 0.98, 6: 0.93, 7: 0.90,
            8: 0.97, 9: 1.03, 10: 1.05, 11: 1.0, 12: 0.86}[m]
    growth = 1 + 0.06 * ((d - START).days / 365)  # ~6% a year
    return base * growth


def pick(rng, codes, n):
    w = np.array([c[4] for c in codes], dtype=float)
    idx = rng.choice(len(codes), size=n, p=w / w.sum())
    return [codes[i] for i in idx]


def main(seed: int = 42) -> None:
    rng = np.random.default_rng(seed)
    RAW.mkdir(parents=True, exist_ok=True)

    od_procs, od_pays = [], []
    dx_procs, dx_pays = [], []
    dol_tx, dol_pays = [], []
    ads, supplies, payroll, gl = [], [], [], []

    proc_id = {"open_dental": 100000, "dentrix_ascend": 0, "dolphin": 0}
    pay_id = 500000
    patient_seq = {loc[0]: 0 for loc in LOCATIONS}
    patients = {loc[0]: [] for loc in LOCATIONS}
    production_by_loc_month: dict[tuple[str, str], float] = {}
    lab_by_loc_month: dict[tuple[str, str], float] = {}

    for loc_id, name, pms, specialty, size in LOCATIONS:
        codes = ORTHO_CODES if specialty == "orthodontics" else GENERAL_CODES
        providers = (["DR-ORTHO-1"] if specialty == "orthodontics"
                     else [f"{loc_id}-DDS{i}" for i in (1, 2)] + [f"{loc_id}-RDH{i}" for i in (1, 2, 3)])
        ad_base = 95 * size  # daily Google Ads budget

        for d in business_days(START, END):
            s = seasonality(d) * size
            month = d.strftime("%Y-%m")

            # ---- marketing: spend drives new patient leads ----
            cost = max(0.0, rng.normal(ad_base * s, ad_base * 0.18))
            clicks = int(cost / rng.uniform(3.2, 5.5))
            conversions = int(rng.poisson(cost / 70))
            ads.append({
                "Day": d.isoformat(),
                "Campaign": f"Search | {name} | New Patients",
                "Cost": f"{cost:.2f}",
                "Clicks": clicks,
                "Conversions": conversions,
            })
            new_patients = int(rng.binomial(conversions, 0.55)) + int(rng.poisson(1.2 * size))
            for _ in range(new_patients):
                patient_seq[loc_id] += 1
                patients[loc_id].append(f"{loc_id}-P{patient_seq[loc_id]:06d}")

            # ---- visits & procedures ----
            n_visits = int(rng.poisson((34 if specialty == "general" else 30) * s))
            pool = patients[loc_id]
            if not pool:
                continue
            for _ in range(n_visits):
                # new patients more likely to be seen soon after joining
                if rng.random() < 0.25:
                    pat = pool[-int(rng.integers(1, min(len(pool), 60) + 1))]
                else:
                    pat = pool[int(rng.integers(0, len(pool)))]
                prov = providers[int(rng.integers(0, len(providers)))]
                n_procs = int(rng.choice([1, 2, 3], p=[0.45, 0.38, 0.17]))
                for code, desc, cat, fee, _w in pick(rng, codes, n_procs):
                    charged = round(fee * rng.uniform(0.94, 1.08), 2)
                    proc_id[pms] += 1
                    production_by_loc_month[(loc_id, month)] = production_by_loc_month.get((loc_id, month), 0) + charged
                    if code in ("D2740", "D6010", "D9944", "D8680"):
                        lab_by_loc_month[(loc_id, month)] = lab_by_loc_month.get((loc_id, month), 0) + charged * 0.22

                    # collection: most collected 0-60 days later, some written off
                    collect_rate = rng.choice([1.0, 0.85, 0.0], p=[0.86, 0.10, 0.04])
                    pay_date = d + timedelta(days=int(rng.choice([0, 0, 0, 14, 21, 30, 45, 60])))
                    paid = round(charged * collect_rate, 2)

                    if pms == "open_dental":
                        status = 2
                        if rng.random() < 0.015:
                            status = 6  # deleted in the PMS, still in the export
                        od_procs.append({
                            "ProcNum": proc_id[pms], "PatNum": pat.split("-P")[1].lstrip("0"),
                            "ClinicNum": {"L001": 1, "L002": 2}[loc_id], "ProvNum": prov,
                            "ProcDate": d.isoformat(), "ProcCode": code, "ProcFee": f"{charged:.2f}",
                            "ProcStatus": status,
                        })
                        if paid > 0 and pay_date <= END and status == 2:
                            pay_id += 1
                            od_pays.append({
                                "PayNum": pay_id, "PatNum": pat.split("-P")[1].lstrip("0"),
                                "ClinicNum": {"L001": 1, "L002": 2}[loc_id],
                                "PayDate": pay_date.isoformat(), "PayAmt": f"{paid:.2f}",
                                "PayType": rng.choice(["Insurance", "Card", "Card", "Cash", "CareCredit"]),
                                "ProcNum": proc_id[pms],
                            })
                    elif pms == "dentrix_ascend":
                        row = {
                            "procedure_id": f"DXA-{proc_id[pms]:07d}", "patient_guid": pat,
                            "service_date": d.strftime("%m/%d/%Y"), "cdt_code": code,
                            "amount": f"${charged:,.2f}",
                            "provider": prov if rng.random() > 0.02 else "",
                            "location_name": rng.choice(DENTRIX_NAME_VARIANTS[loc_id]),
                            "status": "Completed",
                        }
                        dx_procs.append(row)
                        if rng.random() < 0.01:
                            dx_procs.append(dict(row))  # duplicate row from a re-export
                        if rng.random() < 0.05:
                            planned = dict(row, procedure_id=f"DXA-P{proc_id[pms]:07d}", status="Planned")
                            dx_procs.append(planned)  # treatment plan, not production
                        if paid > 0 and pay_date <= END:
                            dx_pays.append({
                                "payment_id": f"DXA-PAY-{len(dx_pays) + 1:07d}",
                                "procedure_id": row["procedure_id"], "patient_guid": pat,
                                "posted_on": pay_date.strftime("%m/%d/%Y"),
                                "amount": f"${paid:,.2f}",
                                "location_name": row["location_name"],
                                "method": rng.choice(["insurance", "credit_card", "credit_card", "cash"]),
                            })
                    else:  # dolphin (ortho): semicolon CSV, day-first dates
                        dol_tx.append({
                            "TxID": f"DOL{proc_id[pms]:07d}", "PatientID": pat,
                            "TxDate": d.strftime("%d-%m-%Y"), "Code": code,
                            "Fee": f"{charged:.2f}", "Doctor": prov,
                        })
                        if paid > 0 and pay_date <= END:
                            dol_pays.append({
                                "ReceiptNo": f"R{len(dol_pays) + 1:07d}", "PatientID": pat,
                                "TxID": f"DOL{proc_id[pms]:07d}",
                                "ReceiptDate": pay_date.strftime("%d-%m-%Y"), "Amount": f"{paid:.2f}",
                            })

            # a small number of refunds
            if rng.random() < 0.02 and pms == "open_dental":
                pay_id += 1
                od_pays.append({
                    "PayNum": pay_id, "PatNum": pool[int(rng.integers(0, len(pool)))].split("-P")[1].lstrip("0"),
                    "ClinicNum": {"L001": 1, "L002": 2}[loc_id], "PayDate": d.isoformat(),
                    "PayAmt": f"{-round(rng.uniform(40, 400), 2):.2f}", "PayType": "Refund", "ProcNum": "",
                })

        # ---- payroll (UKG, biweekly) ----
        roles = ORTHO_ROLES if specialty == "orthodontics" else ROLES
        emp = []
        for title, rate, hc in roles:
            for i in range(max(1, round(hc * size))):
                emp.append((f"E{loc_id[1:]}{len(emp) + 1:03d}", title, rate * rng.uniform(0.92, 1.12)))
        pay_date = date(2024, 1, 12)
        while pay_date <= END:
            for eid, title, rate in emp:
                hours = max(0.0, rng.normal(76, 5)) if title not in ("Dentist", "Orthodontist") else rng.normal(68, 6)
                gross = hours * rate * (1 + 0.03 * ((pay_date - START).days / 365))
                payroll.append({
                    "pay_date": pay_date.isoformat(), "employee_id": eid,
                    "home_location": name if rng.random() > 0.03 else name.upper(),
                    "job_title": title, "hours_worked": f"{hours:.2f}", "gross_pay": f"{gross:.2f}",
                })
            pay_date += timedelta(days=14)

    # ---- supplies & GL (monthly, from production) ----
    for (loc_id, month), prod in production_by_loc_month.items():
        specialty = next(l[3] for l in LOCATIONS if l[0] == loc_id)
        size = next(l[4] for l in LOCATIONS if l[0] == loc_id)
        y, m = map(int, month.split("-"))
        for cat, share in SUPPLY_CATEGORIES:
            if specialty == "orthodontics" and cat == "Orthodontic Brackets & Wires":
                share = 0.045
            if share == 0:
                continue
            n_orders = int(rng.integers(2, 6))
            for k in range(n_orders):
                total = prod * share * rng.uniform(0.8, 1.2) / n_orders
                unit = round(rng.uniform(8, 140), 2)
                qty = max(1, int(total / unit))
                supplies.append({
                    "order_date": date(y, m, int(rng.integers(1, 28))).isoformat(),
                    "ship_to": loc_id, "category": cat,
                    "sku": f"SKU-{sum(map(ord, cat)) % 9000 + 1000}-{k}",
                    "qty": qty, "unit_cost": f"{unit:.2f}",
                })
        for acct, title, base in GL_ACCOUNTS:
            amt = base * size * rng.uniform(0.95, 1.06) if acct != "6200" else lab_by_loc_month.get((loc_id, month), 0)
            if amt <= 0:
                continue
            gl.append({
                "RECORDNO": len(gl) + 1, "WHENCREATED": date(y, m, 28).strftime("%m/%d/%Y"),
                "LOCATIONID": loc_id, "ACCOUNTNO": acct, "ACCOUNTTITLE": title,
                "DEBITAMOUNT": f"{amt:.2f}", "CREDITAMOUNT": "0.00",
            })

    def write(path: Path, rows: list[dict], delimiter: str = ","):
        path.parent.mkdir(parents=True, exist_ok=True)
        with path.open("w", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0].keys()), delimiter=delimiter)
            w.writeheader()
            w.writerows(rows)
        print(f"  {path.relative_to(RAW.parent.parent)}  {len(rows):>8,} rows")

    print("Writing source exports:")
    write(RAW / "open_dental" / "procedurelog.csv", od_procs)
    write(RAW / "open_dental" / "payment.csv", od_pays)
    write(RAW / "dentrix_ascend" / "procedures_export.csv", dx_procs)
    write(RAW / "dentrix_ascend" / "payments_export.csv", dx_pays)
    write(RAW / "dolphin" / "transactions.csv", dol_tx, delimiter=";")
    write(RAW / "dolphin" / "receipts.csv", dol_pays, delimiter=";")
    write(RAW / "sage_intacct" / "gl_detail.csv", gl)
    write(RAW / "ukg" / "payroll_register.csv", payroll)
    write(RAW / "henry_schein" / "supply_orders.csv", supplies)
    # Google Ads comes in as JSON lines from the API
    (RAW / "google_ads").mkdir(parents=True, exist_ok=True)
    with (RAW / "google_ads" / "campaign_daily.jsonl").open("w") as f:
        for r in ads:
            f.write(json.dumps(r) + "\n")
    print(f"  data/raw/google_ads/campaign_daily.jsonl  {len(ads):>8,} rows")


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--seed", type=int, default=42)
    main(ap.parse_args().seed)
