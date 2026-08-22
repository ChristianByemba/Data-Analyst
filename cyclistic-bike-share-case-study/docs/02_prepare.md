# 2. Prepare

## Data source & location

12 months of Cyclistic (Divvy) trip data (January–December 2025), downloaded as monthly ZIP
files from the public Divvy dataset: https://divvy-tripdata.s3.amazonaws.com/index.html

Files are stored locally in [`data/raw/`](../data/raw/) (excluded from version control — see
[data/raw/README.md](../data/raw/README.md) for download instructions). Each month is one CSV
file, e.g. `202501-divvy-tripdata.csv`.

## Organization

Each of the 12 files shares the same schema — 13 columns, one row per ride:

| Column | Type | Notes |
|---|---|---|
| `ride_id` | string | unique identifier |
| `rideable_type` | string | `classic_bike` or `electric_bike` |
| `started_at` / `ended_at` | datetime | timestamp with milliseconds |
| `start_station_name` / `start_station_id` | string | ~21% missing |
| `end_station_name` / `end_station_id` | string | ~22% missing |
| `start_lat` / `start_lng` / `end_lat` / `end_lng` | float | `end_lat`/`end_lng` missing in 5,535 rows |
| `member_casual` | string | `member` or `casual` |

**Total: 5,552,994 rows** across the 12 files.

## Credibility check — ROCCC

| Criterion | Assessment |
|---|---|
| **Reliable** | Official operator export; large sample size; but a meaningful share of station fields is missing (see below) |
| **Original** | Yes — sourced directly from the Divvy public data portal, not a secondary aggregator |
| **Comprehensive** | Covers all fields needed to compare member vs. casual behavior (time, duration, bike type, location) |
| **Current** | Full 12 most recent months (Jan–Dec 2025) at time of analysis |
| **Cited** | Published by Motivate International Inc. under a documented [license](https://divvybikes.com/data-license-agreement) |

## Licensing, privacy, security, accessibility

- Data is public and licensed for this kind of analysis (see license link above).
- No personally identifiable information is present — rides cannot be linked to a specific rider
  or payment method, so questions like "do casual riders live in the service area" are out of
  scope for this dataset.
- Files are kept locally in `data/raw/` and `data/processed/`, both excluded from Git via
  `.gitignore` (too large for GitHub, and not necessary to version — the source is public and
  reproducible).

## Data integrity checks performed

Ran a full pass over all 12 files (`ride_id` uniqueness, null counts, value sets, date ranges) —
see `notebooks/` for the exploration code once added in the Process phase. Findings:

- **Schema is consistent** across all 12 files (same 13 columns, same dtypes).
- **`rideable_type`**: only 2 distinct values (`classic_bike`, `electric_bike`) — no `docked_bike`
  in this 2025 extract.
- **`member_casual`**: exactly 2 distinct values (`member`, `casual`) — clean, no typos/variants.
- **No duplicate `ride_id`** across the full 5,552,994-row dataset.
- **Missing station data**: `start_station_name`/`start_station_id` are null in ~1.18M rows
  (~21%); `end_station_name`/`end_station_id` in ~1.24M rows (~22%). Consistent with Divvy's known
  behavior for electric bikes, which can be locked outside a formal station. Not removed at this
  stage — station name isn't required for the core member-vs-casual comparison (duration, day of
  week, bike type), so these rows stay in unless a station-level analysis needs them.
- **`end_lat`/`end_lng`** missing in 5,535 rows (bike not returned to a GPS-tracked location).
- **29 rows have `ended_at` earlier than `started_at`** (negative ride duration) — data-entry or
  system anomalies. **To be removed in the Process phase.**
- Monthly files overlap slightly at month boundaries (e.g. the January file contains a few rides
  starting Dec 31) — expected, not an error; `started_at` is the authoritative field for date
  filtering rather than the filename.

## Issues to resolve in Process

1. Drop the 29 rows with negative ride duration.
2. Combine the 12 monthly files into a single dataset.
3. Add computed columns: `ride_length` (duration) and `day_of_week`.
4. Decide handling for missing station names (keep, since not required for the member/casual
   duration & frequency comparison).
