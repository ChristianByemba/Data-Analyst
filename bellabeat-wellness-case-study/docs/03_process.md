# 3. Process

## Tools chosen

Two parallel pipelines, cross-validated against each other:

- **Python (pandas)** — [`notebooks/01_process_data.ipynb`](../notebooks/01_process_data.ipynb),
  the canonical pipeline.
- **SQL (DuckDB)** — [`sql/01_process_data.sql`](../sql/01_process_data.sql), querying the raw
  CSVs directly and producing identical row/user counts.

## Cleaning steps applied (documented in order)

1. **Load** daily activity from both collection periods: 457 rows (Period 1) + 940 rows
   (Period 2).
2. **Resolve the overlapping date** — both periods include April 12, 2016, with **conflicting
   values** for the same users (e.g. user `1503960366`: 224 steps in Period 1's file vs. 13,162 in
   Period 2's for the same date). Period 1's export appears to cut off mid-day; Period 2's row is
   kept, and the 24 conflicting Period-1 rows are dropped.
3. **Combine & standardize** — concatenated into one 1,373-row table (35 unique users, Mar 12 –
   May 12 2016), columns renamed to `snake_case`. Zero duplicate `(id, activity_date)` pairs
   after step 2.
4. **Flag (not drop) zero-step days** — 133 rows (9.7%) show `total_steps == 0`. These are very
   likely tracker-not-worn days rather than genuine zero-activity days; dropping them outright
   would silently bias activity averages, so they're kept and flagged via `is_zero_steps` for the
   Analyze phase to report both ways.
5. **Clean sleep data** — only the second period ships a `sleepDay_merged.csv` table (see the
   Prepare-phase finding that Period 1 lacks it). Dropped 3 exact duplicate rows → 410 rows across
   24 users. Added `sleep_efficiency_pct` (minutes asleep ÷ minutes in bed).
6. **Merge** activity + sleep on `(id, date)`, left join — 1,373 rows total, **29.9%** with
   matching sleep data (expected, since only 24 of 35 users logged sleep at all).

## Verification

The DuckDB SQL pipeline reproduces the pandas pipeline **exactly**: 1,373 activity rows, 35
unique users, 410 sleep rows, 410 merged rows with sleep data. No discrepancy between the two
engines this time (unlike the Cyclistic case study, where sub-second rounding caused a tiny gap).

## Output

- `data/processed/daily_activity.parquet` — cleaned, combined daily activity (35 users × up to
  62 days).
- `data/processed/sleep_day.parquet` — cleaned daily sleep summary (24 users).
- `data/processed/activity_sleep_merged.parquet` — left-joined activity + sleep, used in Analyze.

Unlike the Cyclistic case study's multi-hundred-MB processed files, these are small (<100KB
combined) and are committed directly for easy reuse.
