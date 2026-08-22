# 3. Process

## Tools chosen

Two parallel pipelines were built, deliberately doing the same cleaning/transformation logic
twice to cross-validate the result:

- **Python (pandas)** — [`notebooks/01_process_data.ipynb`](../notebooks/01_process_data.ipynb).
  Chosen as the main pipeline: flexible for the feature engineering and descriptive statistics
  needed downstream in the Analyze phase.
- **SQL (DuckDB)** — [`sql/01_process_data.sql`](../sql/01_process_data.sql). DuckDB can query the
  raw CSVs directly with a glob pattern and write Parquet output, with no server/import step —
  a convenient way to demonstrate the same logic in SQL and sanity-check the pandas result.

## Cleaning steps applied (documented in order)

1. **Load & combine** the 12 monthly CSVs (Jan–Dec 2025) into one dataset: 5,552,994 rows.
2. **Drop negative-duration rows** — 29 rows where `ended_at < started_at` (data anomaly,
   identified in the Prepare phase). → 5,552,965 rows.
3. **Feature engineering** — added:
   - `ride_length_min`: trip duration in minutes.
   - `day_of_week`: numeric, 1 = Sunday … 7 = Saturday (matches the case study's
     `WEEKDAY(date, 1)` convention).
   - `day_name`, `month`, `hour`: convenience columns for the Analyze phase.
4. **Remove outlier rides** — checked the `ride_length_min` distribution and found:
   - 147,372 rides (2.65%) under 1 minute — very likely false starts / immediate redocks, not
     genuine trips.
   - 5,585 rides (0.10%) over 24 hours — very likely a bike not properly returned, not an actual
     multi-day rental.

   Both categories would distort the ride-length averages this analysis depends on without
   representing real member/casual usage, so they were removed. **Total removed: 152,957 rows
   (2.75%). Final dataset: 5,400,008 rows.**

## Verification

The SQL (DuckDB) pipeline was run independently against the same raw CSVs and produced
5,400,486 rows / a 64.52% member–35.48% casual split, versus pandas' 5,400,008 rows / 64.52%–35.48%.
The two pipelines agree to within **0.01%** (478 rows). The small gap is expected: DuckDB's
`date_diff('second', …)` truncates to whole seconds, while pandas' `total_seconds()` keeps
millisecond precision — a handful of rides sitting exactly on the 1-minute or 1440-minute cutoff
get rounded to opposite sides of the threshold by the two engines. This is not treated as an
error; the pandas output (millisecond precision) is used as the canonical dataset going forward.

## Output

- `data/processed/all_trips_2025.parquet` — canonical cleaned dataset (pandas pipeline), used in
  the Analyze phase. Not committed (large, regenerable — see `notebooks/01_process_data.ipynb`).
- `data/processed/all_trips_2025_sql.parquet` — SQL pipeline output, kept only as a cross-check.
