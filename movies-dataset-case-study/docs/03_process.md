# 3. Process

## Tools chosen

Two parallel pipelines, cross-validated against each other:

- **Python (pandas)** — [`notebooks/01_process_data.ipynb`](../notebooks/01_process_data.ipynb),
  the canonical pipeline.
- **SQL (DuckDB)** — [`sql/01_process_data.sql`](../sql/01_process_data.sql).

## Cleaning steps applied (documented in order)

1. **Dropped the 6 corrupted/shifted rows** identified in Prepare — a CSV export issue that left
   `id`, `budget`, or `popularity` unparseable as numbers on 3 pairs of adjacent rows.
2. **Coerced `id`, `budget`, `revenue`, `popularity`, `runtime`, `vote_average`, `vote_count` to
   numeric types**, then **dropped 30 duplicate-`id` rows**, keeping the first occurrence (29
   distinct `id` values were duplicated; some fully identical scrape duplicates).
3. **Parsed `release_date`** into a real datetime and derived `release_year`/`release_month`
   (84 rows have an unparseable/missing date, left as null).
4. **Parsed `genres`** (a stringified Python list of dicts) with `ast.literal_eval`, keeping just
   the genre name(s) per movie. Built two outputs: the movie-level table keeps a `genres_list`
   column (a Python list, possibly empty — 2,442 rows have no genre), and a separate **exploded
   movie x genre table** (one row per movie x genre) for genre-level aggregation without
   double-counting or under-counting multi-genre films.
5. **Treated `budget == 0` and `revenue == 0` as missing** (TMDB's "not reported" convention, per
   Prepare) — nulled out rather than treated as a real $0.
6. **Computed `roi` and `profit`** only where both `budget > $1,000` and `revenue > $1,000`
   (5,307 rows) — excludes obvious placeholder values (e.g. a literal `$1` budget) while keeping
   every genuine low-budget film. `roi = (revenue - budget) / budget`; `profit = revenue - budget`.

## Verification

The DuckDB pipeline reproduces the pandas result **exactly**: 45,430 final rows, 8,880 rows with
a known (nonzero) budget, 7,398 with a known revenue, 5,307 with a valid `roi`, and an identical
average/median `roi` (8.0703 / 1.0691).

**One real cross-engine discrepancy, found and resolved**: DuckDB's `read_csv` in strict mode
cannot parse the raw file at all — the same 6 corrupted rows contain a multi-line quoted
`overview` field that breaks DuckDB's column-count validation (`Expected 24 columns, found 10`).
Loading with `ignore_errors = true` makes DuckDB silently skip those 6 malformed rows during CSV
parsing itself (landing directly on 45,460 loaded rows, with 0 further corrupted rows found by
the subsequent id/budget/popularity check) — whereas pandas' more lenient parser loads all 45,466
rows, including the 6 corrupted ones, which are then explicitly filtered out by the
id/budget/popularity validity check. Two different mechanisms exclude the same 6 rows and land on
the same final counts — not forced to match, genuinely convergent.

## Output

- `data/processed/movies_clean.parquet` — 45,430 rows, 18 columns (2,148.7 KB).
- `data/processed/movie_genres.parquet` — 91,006 rows (movie x genre), 3 columns (1,162.3 KB).

Both are **not committed** — large enough to regenerate on demand (no `.gitignore` exception
added, matching `cyclistic-bike-share-case-study`/`avocado-prices-case-study`). Small aggregate
tables for the Share phase will be saved to `data/summary/` and committed there instead.