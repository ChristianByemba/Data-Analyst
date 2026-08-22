# 2. Prepare

## Data source & location

[The Movies Dataset](https://www.kaggle.com/rounakbanik/the-movies-dataset) (Kaggle, CC0, via
Rounak Banik), downloaded with `kagglehub.dataset_download("rounakbanik/the-movies-dataset")`.
Metadata scraped from [TMDB](https://www.themoviedb.org/) (The Movie Database) and ratings from
[GroupLens/MovieLens](https://grouplens.org/datasets/movielens/). Five CSVs kept in
[`data/raw/`](../data/raw/) (not committed — see `data/raw/README.md`): `movies_metadata.csv`
(primary table), `credits.csv`, `keywords.csv`, `links_small.csv`, `ratings_small.csv`.

## Organization

`movies_metadata.csv` — **45,466 rows, 24 columns**, one row per movie: `budget`, `revenue`,
`genres`, `runtime`, `release_date`, `vote_average`, `vote_count`, `popularity`,
`production_companies`, `spoken_languages`, plus identifiers (`id`, `imdb_id`, `title`).
`release_date` spans **1874-12-09 to 2020-12-16** (the long tail before ~1920 is a handful of
very early films; the bulk of the catalog is 20th/21st century — 532 movies released in 2017
alone, the year TMDB's data was pulled for this dataset).

- `credits.csv` — 45,476 rows (`id`, `cast`, `crew`, JSON-stringified list-of-dicts).
- `keywords.csv` — 46,419 rows (`id`, `keywords`, JSON-stringified list-of-dicts).
- `links_small.csv` — 9,125 rows, a MovieLens ID ↔ TMDB ID ↔ IMDB ID crosswalk (13 rows have a
  null `tmdbId` — a MovieLens title TMDB has no match for).
- `ratings_small.csv` — 100,004 user ratings, 671 unique users, 9,066 unique `movieId` values
  (a sample, not every `links_small` movie has ratings).

## Credibility check — ROCCC

| Criterion | Assessment |
|---|---|
| **Reliable** | Moderate. TMDB is a large, well-known platform, but its metadata (especially `budget`/`revenue`) is **community-submitted, not audited financial data** — treated here as directional, not authoritative, figures |
| **Original** | Secondary — scraped/aggregated from the TMDB API and MovieLens, not primary studio/box-office filings |
| **Comprehensive** | 45,466 movies is broad, but only **19.5% have a usable (nonzero) budget figure** — comprehensiveness is real for genre/rating/runtime, much weaker for the financial-return angle (see finding below) |
| **Current** | Compiled ~2017 (published to Kaggle in 2017; release dates run through late 2020, likely backfilled at various pulls). **Not current** for a 2026 greenlighting decision — recent releases, inflation, and streaming-era revenue models are absent (see Act phase) |
| **Cited** | CC0 public domain, source (TMDB/GroupLens) documented on Kaggle |

## Data-quality findings (verified by running checks against the raw data)

### 1. `budget` and `revenue` are `0` for the large majority of rows — not a literal $0

Of 45,460 usable rows (after removing the 6 corrupted rows below):

- **`budget == 0`: 36,570 rows (80.4%)**
- **`revenue == 0`: 38,052 rows (83.7%)**
- **Both `budget > 0` and `revenue > 0`: only 5,381 rows** — the actual usable base for any
  return-on-investment calculation.

This is the well-documented TMDB pattern: `0` means "not reported," not "no budget." Among the
8,890 rows with a nonzero budget, the values themselves look like real dollar figures (min $1 —
itself likely a placeholder/error, 25th pct $2M, median $8M, 75th pct $25M, max $380M) — i.e. the
nonzero values are broadly trustworthy, the zero values are simply missing data.

**Decision carried into Process**: treat `budget == 0` and `revenue == 0` as missing (null) for
any financial-return calculation, and additionally require **both `budget > 1,000` and
`revenue > 1,000`** (5,312 rows) before computing ROI — this drops a further 69 rows where budget
or revenue is a tiny nonzero placeholder (e.g. `$1`) that would produce a nonsensical, wildly
inflated ROI. $1,000 is a low bar deliberately — it removes obvious placeholder values without
discarding any genuine low-budget/indie film.

### 2. 6 rows in `movies_metadata.csv` have shifted/corrupted columns — a known issue in this exact dataset

Converting `id`, `budget`, and `popularity` to numeric surfaces exactly **3 pairs of adjacent
rows (6 rows total)** where a CSV parsing/export issue shifted values across columns — `id` holds
a date string (e.g. `1997-08-20`), `budget` holds an image path
(e.g. `/ff9qCepilowshEtG2GYWwzt2bs4.jpg`), and `popularity` is null or holds stray text
(e.g. `"Beware Of Frost Bites"`) on the adjacent row. Example (`id`/`title`/`budget`):

| id | title | budget |
|---|---|---|
| `82663` | NaN | `0` |
| `1997-08-20` | NaN | `/ff9qCepilowshEtG2GYWwzt2bs4.jpg` |

**Decision carried into Process**: drop these 6 rows outright. They're a tiny fraction
(0.013%) of the dataset, `title` is null on all of them (unusable regardless), and there's no
reliable way to reconstruct the correct column alignment from the shifted values alone.

### 3. Genre and production-company fields are stringified Python lists of dicts

`genres`, `production_companies`, `production_countries`, `spoken_languages` all store values
like `"[{'id': 16, 'name': 'Animation'}, {'id': 35, 'name': 'Comedy'}]"` — a string, not a list.
`ast.literal_eval` (not `eval`, for safety) parses every non-null value in `genres` with zero
parse errors. **2,442 rows have an empty genre list (`[]`)** — technically parseable, but no
genre information; these are excluded from any genre-level aggregation but kept in the
movie-level table. **Decision carried into Process**: parse with `ast.literal_eval`, keep the
movie-level table with a Python-list `genres` column, and build a separate exploded
(one-row-per-movie-per-genre) table for genre-level aggregation.

### 4. Duplicate `id` and duplicate `title` values

- **30 rows share an `id` value with another row** (29 distinct `id` values duplicated, 59 rows
  involved). Of those, **33 rows are fully identical duplicates across every column** (e.g.
  `id=4912`, *Confessions of a Dangerous Mind*, appears twice with identical data) — true
  scrape duplicates. **Decision carried into Process**: drop duplicate `id` rows, keeping the
  first occurrence.
- **3,183 rows share an exact `title` with at least one other row** — but this is expected and
  *not* a data-quality issue: remakes, franchises with reused titles, and foreign films sharing
  an English title are all real (e.g. two different *12 Angry Men* films, 1957 and 1997). Left
  as-is; `id` (not `title`) is the reliable unique key.

### 5. Nulls in key columns (of 45,460 rows, after dropping the 6 corrupted rows)

| Column | Nulls |
|---|---|
| `release_date` | 84 |
| `runtime` | 257 |
| `original_language` | 11 |
| `overview` | 954 |
| `genres` | 0 (but 2,442 empty lists — see above) |

Also: **1,558 rows have `runtime == 0`** (in addition to the 257 nulls) — almost certainly
unreported, not a genuinely 0-minute film. **2,899 rows have `vote_count == 0`** — no audience
votes recorded, so `vote_average` is meaningless (likely defaults to 0) for those rows.

### 6. `status` and `adult`/`video` flags

`status` is mostly `Released` (45,014 of 45,460); the rest (`Rumored`, `Post Production`, `In
Production`, `Planned`, `Canceled`, plus 81 null) are movies with no real box-office outcome yet
and should be excluded from any revenue/rating analysis. `adult` (9 `True`) and `video` (93
`True`, meaning direct-to-video) are both heavily skewed toward `False` — usable as optional
filters, not analytically central.

## Licensing, privacy, security, accessibility

- CC0 Public Domain, no restrictions, source documented on Kaggle.
- Movie/entertainment metadata — no personal or sensitive data (MovieLens `userId` in
  `ratings_small.csv` is an anonymous integer ID, not linked to any real identity).
- Kept locally in `data/raw/` and `data/processed/`, excluded from Git where large (see
  `.gitignore`); source is public and reproducible (`data/raw/README.md`).

## Issues to resolve in Process

1. Drop the 6 corrupted/shifted rows (invalid `id`/`budget`/`popularity`).
2. Coerce `id`, `budget`, `popularity`, `revenue`, `runtime`, `vote_average`, `vote_count` to
   numeric; drop duplicate `id` rows (keep first).
3. Treat `budget == 0` and `revenue == 0` as null; compute `roi`/`profit` only where both
   `budget > 1,000` and `revenue > 1,000`.
4. Parse `genres` (and optionally `production_companies`, `spoken_languages`) with
   `ast.literal_eval`; build both a movie-level table (list column intact) and an exploded
   movie×genre table.
5. Parse `release_date`; derive `release_year` and `release_month`.
6. Standardize column names to `snake_case` where needed.
7. Decide row filters for the Analyze phase (e.g. `status == 'Released'` for any
   revenue/rating analysis) — documented explicitly rather than silently applied.
