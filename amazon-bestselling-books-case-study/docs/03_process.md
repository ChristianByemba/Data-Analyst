# 3. Process

## Tools chosen

Two parallel pipelines, cross-validated against each other:

- **Python (pandas)** — [`notebooks/01_process_data.ipynb`](../notebooks/01_process_data.ipynb),
  the canonical pipeline.
- **SQL (DuckDB)** — [`sql/01_process_data.sql`](../sql/01_process_data.sql).

## Cleaning steps applied (documented in order)

1. **Standardized all column names to `snake_case`**: `name`, `author`, `user_rating`,
   `reviews`, `price`, `year`, `genre`.
2. **Canonicalized the one near-duplicate title identified in Prepare** — *"The 5 Love Languages:
   The Secret to Love **That** Lasts"* (2010–2014, capital T) and *"...to Love **that** Lasts"*
   (2015–2019, lowercase t) are the same book by the same author (Gary Chapman), split only by
   capitalization. Rewrote all rows to the single canonical spelling *before* computing
   `times_on_list`, so the title correctly counts as one 10-year repeater instead of two separate
   5-year ones. Distinct titles: 351 → 350 after canonicalization.
3. **Computed `times_on_list`** — the central derived variable for the business question: the
   count of distinct years each canonical title appears across 2009–2019, computed via
   `groupby("name")["year"].nunique()` and merged back onto every row. Result: max 10 (a tie
   between the *APA Publication Manual, 6th Edition* and *The 5 Love Languages...* after
   canonicalization), **95 titles (of 350) repeat in more than one year**.
4. **Left the 3 same-year duplicate (Name, Year) rows and the 12 `Price == 0` rows as-is** — both
   were checked in Prepare and judged to be real data (likely two formats/editions charting at
   different prices; genuine free-promotion pricing), not errors. No rows dropped.
5. **Re-verified data quality after cleaning**: 0 nulls, 0 exact-duplicate rows, `genre` still
   exactly 2 clean values (`Fiction`: 240, `Non Fiction`: 310).

## Verification

The DuckDB SQL pipeline was run independently (using a window function,
`count(DISTINCT year) OVER (PARTITION BY name)`, in place of pandas' `groupby().nunique()` +
merge) and cross-checked against the pandas output. **Both pipelines agree exactly** — 550 rows,
350 distinct titles, identical `times_on_list` value for every single title (max 10, 95 titles
repeating), and the same genre split. No cross-engine discrepancy was found this time; unlike
prior projects in this repo, there was no rounding, null-handling, or type-coercion difference to
reconcile — both engines produced byte-for-byte-identical `times_on_list` values per title.

## Output

`data/processed/bestsellers_clean.parquet` — 550 rows, 8 columns (25.7 KB — small enough to commit
directly; see `.gitignore` exception added for this project).
