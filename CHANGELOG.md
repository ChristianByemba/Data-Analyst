# Changelog

All notable changes to this repository are documented here, organized by project. Format loosely
follows [Keep a Changelog](https://keepachangelog.com/).

## cyclistic-bike-share-case-study

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
