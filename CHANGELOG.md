# Changelog

All notable changes to this repository are documented here, organized by project. Format loosely
follows [Keep a Changelog](https://keepachangelog.com/).

## world-happiness-case-study

### 2026-08-22 (3)

- **Process phase**: two cross-validated pipelines (pandas notebook + DuckDB SQL) standardize the
  5 yearly schemas, reconcile 5 country-name variants (raising the consistent-country count from
  141/170 to 146/165), backfill `region` for 2017-2019, and merge into a 782-row panel. Caught and
  fixed a real cross-engine discrepancy: DuckDB doesn't null-out the literal `"N/A"` string the
  way pandas does. Documented in
  [`docs/03_process.md`](./world-happiness-case-study/docs/03_process.md).

## world-happiness-case-study, avocado-prices-case-study, movies-dataset-case-study, amazon-bestselling-books-case-study

### 2026-08-22 (2)

- Downloaded raw data for all 4 projects via `kagglehub` (World Happiness: 5 yearly CSVs; Avocado
  Prices: 1 CSV; Movies Dataset: `movies_metadata`/`credits`/`keywords`/`links_small`/`ratings_small`
  — the 677MB full `ratings.csv` and full `links.csv` were skipped as unnecessary for a
  movie-level analysis; Amazon Books: 1 CSV). `data/raw/README.md` added to each.
- **World Happiness — Prepare phase**: ROCCC assessment and data-quality findings in
  [`docs/02_prepare.md`](./world-happiness-case-study/docs/02_prepare.md). Key finding: column
  names and available fields (notably `Region`) differ across all 5 years, and country naming is
  inconsistent (`Macedonia`→`North Macedonia`, `Trinidad and Tobago`→`Trinidad & Tobago`, etc.) —
  141 of 170 total distinct countries appear in every year.

### 2026-08-22

- Set up 4 new project folders for Google Data Analytics Capstone Case Study 3 ("Follow Your Own
  Case Study Path") — each investigates one of the case study's 4 suggested public datasets, with
  its own client scenario and business task since (unlike Cyclistic/Bellabeat) this case study
  requires the analyst to choose the topic:
  - **World Happiness Report** — which factors most strongly associate with national happiness?
  - **Avocado Prices** — how do prices/volume vary by region, season, and type?
  - **Movies Dataset** — what predicts a movie's financial return and audience rating?
  - **Amazon Bestselling Books** — what characterizes a repeat Amazon bestseller?
- Wrote the Ask-phase business task and stakeholders for all 4 (`docs/01_ask.md` in each), and
  added them to the portfolio README.

## bellabeat-wellness-case-study

### 2026-08-22 (6)

- **Act phase**: wrote the final conclusion and top 3 content recommendations in
  [`docs/06_act.md`](./bellabeat-wellness-case-study/docs/06_act.md) — lead with "interrupt
  sitting" messaging instead of step-count goals, turn the sedentary/sleep link into a
  personalized membership feature, and schedule engagement content for the 6–8 PM peak window.
- **Case study complete** — marked as ✅ in the main portfolio README.

### 2026-08-22 (5)

- **Share phase**: built 5 executive-facing visualizations (user activity segmentation,
  time-of-day intensity breakdown, correlation comparison, sedentary-vs-sleep scatter, hourly
  activity pattern) using a single blue sequential ramp for ordinal data and a blue/red diverging
  scheme for correlation signs, in
  [`notebooks/03_share_visualizations.ipynb`](./bellabeat-wellness-case-study/notebooks/03_share_visualizations.ipynb).
  PNGs in `images/`, written up in
  [`docs/05_share.md`](./bellabeat-wellness-case-study/docs/05_share.md).

### 2026-08-22 (4)

- **Analyze phase**: computed activity descriptive stats, sedentary/active time breakdown, a
  4-band user activity segmentation, sleep stats, cross-metric correlations, and an hourly
  activity pattern (from `hourlySteps_merged.csv`) in
  [`notebooks/02_analyze_data.ipynb`](./bellabeat-wellness-case-study/notebooks/02_analyze_data.ipynb).
- Key finding: 80% of users average under 10,000 steps/day, 81.9% of tracked time is sedentary,
  and **sedentary minutes correlate with poor sleep (r=-0.601) far more strongly than step count
  does (r=-0.190)** — reframing the opportunity from "more steps" to "less sedentary time."
  Activity peaks in the early evening (6-8 PM). Full write-up in
  [`docs/04_analyze.md`](./bellabeat-wellness-case-study/docs/04_analyze.md).

### 2026-08-22 (3)

- **Process phase**: built two parallel pipelines (pandas notebook + DuckDB SQL) that combine the
  two collection periods, resolve a real conflict on the overlapping date (2016-04-12 — Period 1's
  export cuts off mid-day), flag (not drop) 133 zero-step days, dedupe 3 sleep rows, and merge
  activity + sleep. Cross-validated exactly between both pipelines. Documented in
  [`docs/03_process.md`](./bellabeat-wellness-case-study/docs/03_process.md).
- Processed Parquet outputs are small (<100KB) and committed directly (`.gitignore` exception
  added for this project only).

### 2026-08-22 (2)

- **Prepare phase**: downloaded the FitBit Fitness Tracker dataset via `kagglehub` and ran a full
  ROCCC/data-quality pass — documented in
  [`docs/02_prepare.md`](./bellabeat-wellness-case-study/docs/02_prepare.md).
- Key findings: only 35 unique users (33 in both periods), no gender data (a major limitation for
  a women's-wellness product), very uneven completeness across tables (sleep n=24, weight n=8,
  heart rate n=14), and the first time period is much sparser (~13 logged days/user) than the
  second (~28.5 days/user).
- Fixed `.gitignore` to exclude raw CSVs at any depth under `data/raw/` (this dataset ships in
  subfolders).

### 2026-08-22

- **Ask phase**: documented the business task and key stakeholders in
  [`docs/01_ask.md`](./bellabeat-wellness-case-study/docs/01_ask.md) — analyze public FitBit smart
  device usage data to inform Bellabeat's marketing strategy for one of its products.
- Set up the project folder structure and added it to the portfolio README.

## cyclistic-bike-share-case-study

### 2026-08-22 (5)

- **Act phase**: wrote the final conclusion and top 3 recommendations in
  [`docs/06_act.md`](./cyclistic-bike-share-case-study/docs/06_act.md) — pitch membership as a
  leisure/weekend value plan, time the campaign to the May–September casual-ridership surge, and
  target digital media to casual riders' actual active hours instead of commute hours.
- **Case study complete** — marked as ✅ in the main portfolio README.

### 2026-08-22 (4)

- **Share phase**: built 5 executive-facing visualizations (average ride length, rides by day of
  week, rides by hour of day, rides by month, weekday vs. weekend split) using a consistent
  two-color palette (blue = members, orange = casual riders) in
  [`notebooks/03_share_visualizations.ipynb`](./cyclistic-bike-share-case-study/notebooks/03_share_visualizations.ipynb).
  PNGs saved to `images/` (committed) and written up in
  [`docs/05_share.md`](./cyclistic-bike-share-case-study/docs/05_share.md).
- Added the hour-of-day chart (clearest commute-vs-leisure signal) as the case study README's
  key-finding preview image.

### 2026-08-22 (3)

- **Analyze phase**: computed ride-length stats, day-of-week / monthly / hourly breakdowns, bike
  type preference, and weekday-vs-weekend split by rider type in
  [`notebooks/02_analyze_data.ipynb`](./cyclistic-bike-share-case-study/notebooks/02_analyze_data.ipynb).
- Small aggregate tables saved to `data/summary/` (committed — reused for Share-phase charts).
- Key finding: members show a clear commuting pattern (weekday, rush-hour, short/stable rides
  year-round); casual riders show a leisure pattern (weekend- and summer-skewed, ~63% longer
  rides, afternoon-peaked, no morning rush). Full write-up in
  [`docs/04_analyze.md`](./cyclistic-bike-share-case-study/docs/04_analyze.md).

### 2026-08-22 (2)

- **Process phase**: built two parallel cleaning/merge pipelines —
  [`notebooks/01_process_data.ipynb`](./cyclistic-bike-share-case-study/notebooks/01_process_data.ipynb)
  (pandas, canonical) and [`sql/01_process_data.sql`](./cyclistic-bike-share-case-study/sql/01_process_data.sql)
  (DuckDB, cross-check) — used to validate each other.
- Dropped 29 rows with negative ride duration and 152,957 outlier rides (<1 min or >24h);
  final cleaned dataset: 5,400,008 rows (64.5% member / 35.5% casual).
- Added `ride_length_min`, `day_of_week`, `day_name`, `month`, `hour` columns.
- Documented all cleaning decisions and the cross-validation result in
  [`docs/03_process.md`](./cyclistic-bike-share-case-study/docs/03_process.md).
- Updated `.gitignore` to also exclude `data/processed/` (large derived Parquet files).

### 2026-08-22

- **Prepare phase**: documented data source, schema, and ROCCC credibility assessment in
  [`docs/02_prepare.md`](./cyclistic-bike-share-case-study/docs/02_prepare.md).
- Downloaded and unzipped the 12 monthly Divvy trip data files (Jan–Dec 2025, 5,552,994 rows
  total) into `data/raw/` (not committed — see `data/raw/README.md`).
- Ran a full data-integrity pass across all 12 files: confirmed consistent schema, no duplicate
  `ride_id`, only 2 clean values each for `rideable_type` and `member_casual`; found ~21–22%
  missing station names/ids and 29 rows with negative ride duration (both flagged for handling in
  the Process phase).
- Initialized the `Data-Analyst` repository (`README.md`, `.gitignore`) and pushed the first
  commit.
- **Ask phase**: documented the business task and key stakeholders in
  [`docs/01_ask.md`](./cyclistic-bike-share-case-study/docs/01_ask.md).
