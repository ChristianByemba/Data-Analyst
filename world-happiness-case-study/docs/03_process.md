# 3. Process

## Tools chosen

Two parallel pipelines, cross-validated against each other:

- **Python (pandas)** — [`notebooks/01_process_data.ipynb`](../notebooks/01_process_data.ipynb),
  the canonical pipeline.
- **SQL (DuckDB)** — [`sql/01_process_data.sql`](../sql/01_process_data.sql).

## Cleaning steps applied (documented in order)

1. **Standardize column names** — each of the 5 yearly files uses a different native schema
   (spaces+parens in 2015/16, R-exported dotted names in 2017, simplified names in 2018/19; see
   the Prepare-phase table). Mapped all 5 to one common `snake_case` schema (`country`, `region`,
   `year`, `rank`, `happiness_score`, `gdp_per_capita`, `social_support`,
   `health_life_expectancy`, `freedom`, `corruption_perception`, `generosity`,
   `dystopia_residual`).
2. **Reconcile country-name variants** — 5 renames applied (`Macedonia` → `North Macedonia`,
   `North Cyprus` → `Northern Cyprus`, `Trinidad and Tobago` → `Trinidad & Tobago`,
   `Hong Kong S.A.R., China` → `Hong Kong`, `Taiwan Province of China` → `Taiwan`). This raised the
   count of countries present in **every** year from 141/170 to **146/165**. Remaining gaps
   (Angola, Djibouti, Oman, Somaliland region, Sudan, Suriname dropping out; Somalia, South Sudan,
   Gambia, Namibia appearing) are genuine list changes, not naming drift — left as-is.
3. **Backfill `region`** for 2017–2019 (which don't publish it) using a country→region map built
   from 2015/2016. Fully successful except **Gambia** (first appears in 2019, was never in the
   2015/2016 source) — left null rather than guessed.
4. **Combine into one long-format panel**: 782 rows (165 countries × up to 5 years each).

## Verification — and a real cross-engine discrepancy

The DuckDB pipeline reproduces the pandas result exactly (782 rows, 165 countries, 1 null
`corruption_perception`) — but only after fixing a genuine issue: **DuckDB's CSV type inference
does not treat the literal string `"N/A"` (the United Arab Emirates' 2018 row) as a null value the
way pandas does by default.** DuckDB silently inferred the whole `corruption_perception` column
as text (`VARCHAR`) because of that one string. Fixed with an explicit
`NULLIF(corruption_perception, 'N/A')::DOUBLE` cast in the SQL script. This is a useful reminder
that "the row counts match" isn't sufficient cross-validation on its own — null-handling has to be
checked too.

## Decisions documented

- **UAE's missing 2018 corruption-perception value is left as null**, not imputed — a
  single-country, single-year gap doesn't warrant estimating a value that would misrepresent the
  source data.
- **`dystopia_residual` is null for 2018/2019** (not published those years) rather than
  back-calculated — it's a modeling artifact of the original report's methodology, not something
  this analysis should reconstruct.

## Output

`data/processed/happiness_panel.parquet` — 782 rows, 12 columns, committed directly (small enough,
<60KB).
