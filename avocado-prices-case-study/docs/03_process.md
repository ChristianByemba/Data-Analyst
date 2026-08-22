# 3. Process

## Tools chosen

Two parallel pipelines, cross-validated against each other:

- **Python (pandas)** — [`notebooks/01_process_data.ipynb`](../notebooks/01_process_data.ipynb),
  the canonical pipeline.
- **SQL (DuckDB)** — [`sql/01_process_data.sql`](../sql/01_process_data.sql).

## Cleaning steps applied (documented in order)

1. **Dropped the leftover `Unnamed: 0` index column** (an artifact of the source export) and
   standardized all column names to `snake_case`.
2. **Classified `region` into its true 3-level hierarchy** — the central Process-phase task
   identified in Prepare: `national` (`TotalUS`, 338 rows), `major_region` (the 8 regions that sum
   exactly to `TotalUS`, 2,704 rows), and `city` (the 45 metro markets, 15,207 rows). Re-verified
   after tagging: the 8 major regions still sum to `TotalUS` within floating-point rounding
   ($0.03 on a ~$27.3M weekly total). **Any Analyze-phase aggregation must filter to a single
   `region_tier` before summing** — mixing tiers would overcount volume.
3. **Checked weekly date cadence** — 106 of 108 region×type series have a perfectly regular
   7-day cadence; 1 series has 2 irregular gaps. Left as-is; no data was fabricated to fill gaps.
4. **Checked for invalid values** — no non-positive prices, no negative volumes. No rows dropped
   for data-quality reasons beyond the index column.

## Verification

The DuckDB pipeline reproduces the pandas result exactly: 18,249 rows, 54 regions, and the same
hierarchy check (8 major regions sum to `TotalUS` within the same floating-point rounding).

## Output

`data/processed/avocado_clean.parquet` — 18,249 rows, 14 columns (952.8 KB — not committed, large
enough to regenerate on demand; see `.gitignore`).
