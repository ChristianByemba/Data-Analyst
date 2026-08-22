# 2. Prepare

## Data source & location

[World Happiness Report](https://www.kaggle.com/unsdsn/world-happiness) (Kaggle, CC0, via the
Sustainable Development Solutions Network), downloaded with
`kagglehub.dataset_download("unsdsn/world-happiness")`. Five yearly CSVs (2015–2019), stored in
[`data/raw/`](../data/raw/) (not committed — see `data/raw/README.md`).

## Organization

Wide format, one row per country per year. **Column names and available fields differ across
years** — this is the central data-quality issue for this dataset:

| Year | Rows | Columns | Has `Region`? | Naming style |
|---|---|---|---|---|
| 2015 | 158 | 12 | Yes | `Economy (GDP per Capita)`, spaces + parens |
| 2016 | 157 | 13 | Yes | Same as 2015, plus confidence interval columns |
| 2017 | 155 | 12 | **No** | `Economy..GDP.per.Capita.` — dotted (R-exported) names |
| 2018 | 156 | 9 | **No** | `GDP per capita` — simplified names, no Dystopia Residual |
| 2019 | 156 | 9 | **No** | Same as 2018 |

All 5 years share the same underlying six factors (GDP per capita, social support/family, health,
freedom, generosity, corruption perception) plus a happiness score/rank, but under **three
different naming conventions** and with `Region` only present in 2015–2016.

## Credibility check — ROCCC

| Criterion | Assessment |
|---|---|
| **Reliable** | Published methodology, based on Gallup World Poll survey data; well-established, widely cited source |
| **Original** | Yes — primary publisher (SDSN), not a secondary aggregator |
| **Comprehensive** | Covers the 6 standard explanatory factors + happiness score for 150+ countries/year |
| **Current** | Data runs through 2019 — the most recent year in this Kaggle mirror; more recent years exist on the official World Happiness Report site but aren't in this dataset |
| **Cited** | Public domain, clear methodology and source documentation |

## Key data-quality findings

1. **Inconsistent column naming across years** (see table above) — must be standardized before
   any cross-year merge; this is the main Process-phase task.
2. **`Region` is only present in 2015 and 2016.** Later years drop it, so a country→region mapping
   built from 2015/2016 will be needed to analyze by region across all 5 years.
3. **The country panel is not fully stable across years.** Only **141 of 170 total distinct
   countries** appear in all 5 years. Some of this is genuine — e.g. **Somalia** and **South
   Sudan** appear as separate entities in later years where 2015 only listed "Somaliland region"
   and "Sudan" — and some is naming drift, not a real change:
   - `Macedonia` (2015) → `North Macedonia` (2019) — the country's actual name change in 2019.
   - `North Cyprus` (2015) → `Northern Cyprus` (2019) — spelling variant, same entity.
   - `Trinidad and Tobago` (2015) → `Trinidad & Tobago` (2019) — punctuation variant, same entity.
   These naming variants must be reconciled in Process to build an accurate multi-year panel;
   genuine country-list changes (Somalia/South Sudan appearing) should be kept as-is, not merged.
4. **One missing value**: United Arab Emirates has a null `Perceptions of corruption` value in
   the 2018 file only.
5. **No duplicate country rows** within any single year.

## Licensing, privacy, security, accessibility

- CC0 Public Domain, no restrictions.
- Country-level aggregate statistics only — no individual-level or personally identifiable data.
- Kept locally in `data/raw/` and `data/processed/`, excluded from Git (see `.gitignore`); source
  is public and reproducible (`data/raw/README.md`).

## Issues to resolve in Process

1. Standardize column names to a common `snake_case` schema across all 5 years.
2. Build a country-name reconciliation map (spelling/punctuation variants) and apply it before
   merging years into one panel.
3. Backfill `Region` for 2017–2019 using the 2015/2016 country→region mapping.
4. Decide how to handle the UAE 2018 null corruption-perception value (likely leave as missing
   rather than impute, and document the decision).
5. Add a `year` column and concatenate into one long-format panel dataset.
