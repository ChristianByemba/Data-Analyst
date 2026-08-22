# 2. Prepare

## Data source & location

[Avocado Prices](https://www.kaggle.com/neuromusic/avocado-prices) (Kaggle, CC0, via Justin
Kiggins / the Hass Avocado Board), downloaded with
`kagglehub.dataset_download("neuromusic/avocado-prices")`. Single CSV, stored in
[`data/raw/avocado.csv`](../data/raw/avocado.csv) (not committed — see `data/raw/README.md`).

## Organization

Wide format, one row per week × region × type. 18,249 rows, 14 columns: `AveragePrice`,
`Total Volume`, three PLU-code volume columns (`4046`, `4225`, `4770` — small/medium/large Hass
avocados), bag-size volumes (`Total Bags`, `Small/Large/XLarge Bags`), `type`
(conventional/organic), `year`, `region`, plus a leftover `Unnamed: 0` row-index column.

- **Date range**: 2015-01-04 → 2018-03-25, weekly observations.
- **54 distinct `region` values, no nulls, no duplicate rows.**

## Credibility check — ROCCC

| Criterion | Assessment |
|---|---|
| **Reliable** | Sourced from the Hass Avocado Board's official retail scan data — a credible, widely-used source for this exact question |
| **Original** | Yes — primary retail-panel data, not a secondary estimate |
| **Comprehensive** | Weekly price/volume broken down by type and region across 3+ years — good grain for the business task |
| **Current** | Ends March 2018 — **not current**; avocado prices/consumption have shifted materially since (see Act phase) |
| **Cited** | Public domain, source documented on Kaggle |

## Critical data-quality finding: the `region` column is a 3-level hierarchy, not 54 independent regions

This is the central issue to resolve before any aggregation. Verified directly against the data:

- **`TotalUS`** is the national total.
- **8 "major regions" — `California`, `GreatLakes`, `Midsouth`, `Northeast`, `Plains`,
  `SouthCentral`, `Southeast`, `West`** — sum to **exactly** `TotalUS` (0.00% difference,
  verified on a sample week). These are the top-level geographic rollup.
- **The remaining 45 entries are city/metro markets** (e.g. `Albany`, `Chicago`, `NewYork`), some
  of which nest inside a major region (`LosAngeles`, `SanDiego`, `SanFrancisco`, `Sacramento` are
  all part of `California`). These 45 sum to only **~65% of `TotalUS`** — city-level detail
  doesn't cover 100% of national volume, only the metro areas the panel tracks individually.

**Naively summing `Total Volume` across all 54 `region` values would overcount national volume by
roughly 3–4x** (TotalUS + the 8 majors + the 45 cities all represent overlapping totals at
different levels of the same hierarchy). This must be handled explicitly in Process — different
analyses should pick one level of the hierarchy and stay there, never mix levels in a sum.

## Licensing, privacy, security, accessibility

- CC0 Public Domain, no restrictions.
- Aggregated retail-panel data — no individual consumer or store-level data.
- Kept locally in `data/raw/` and `data/processed/`, excluded from Git (see `.gitignore`); source
  is public and reproducible (`data/raw/README.md`).

## Issues to resolve in Process

1. Drop the leftover `Unnamed: 0` index column.
2. Split `region` into three explicit tiers (`national`, `major_region`, `city`) rather than
   treating all 54 as one flat category, to prevent double-counting in any aggregation.
3. Parse `Date` and confirm the weekly cadence is consistent.
4. Standardize column names to `snake_case`.
