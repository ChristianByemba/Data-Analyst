# Changelog

All notable changes to this repository are documented here, organized by project. Format loosely
follows [Keep a Changelog](https://keepachangelog.com/).

## cyclistic-bike-share-case-study

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
