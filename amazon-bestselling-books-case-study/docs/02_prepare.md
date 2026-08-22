# 2. Prepare

## Data source & location

[Amazon Top 50 Bestselling Books 2009–2019](https://www.kaggle.com/sootersaalu/amazon-top-50-bestselling-books-2009-2019)
(Kaggle, CC0, via Souter Saalu), downloaded with
`kagglehub.dataset_download("sootersaalu/amazon-top-50-bestselling-books-2009-2019")`. Single
CSV, stored as
[`data/raw/bestsellers_with_categories.csv`](../data/raw/bestsellers_with_categories.csv) (not
committed — see `data/raw/README.md`).

## Organization

One row per (book title × year it appeared) in Amazon's top-50 bestseller list. **550 rows, 7
columns**: `Name`, `Author`, `User Rating`, `Reviews`, `Price`, `Year`, `Genre`
(Fiction/Non Fiction).

- **Year range**: 2009–2019 (11 years), 50 rows per year.
- **No nulls in any column, no exact duplicate rows.**

## Credibility check — ROCCC

| Criterion | Assessment |
|---|---|
| **Reliable** | This is Amazon's own published top-50 bestseller ranking, not raw sales figures — reliable as a record of *what Amazon ranked*, but it is a curated list (methodology not disclosed by Amazon), not an independent sales audit |
| **Original** | Yes — the underlying ranking is Amazon's; this file is a direct scrape/compilation of it, not a re-estimate |
| **Comprehensive** | Only 50 books/year and only 7 fields — no genre sub-category, no publisher, no page count, no publication date, no format (print/ebook) recorded. `Reviews` is a proxy for engagement/popularity, not necessarily for quality — a controversial or heavily marketed book can rack up reviews independent of how good it is |
| **Current** | Fixed 11-year window (2009–2019), now **dated** — over 6 years old at the time of this analysis (2026); more recent bestseller dynamics (post-2019 genre shifts, ebook/audiobook growth) are not captured |
| **Cited** | CC0 public domain, source and compiler documented on Kaggle |

**Implication for the client**: this dataset answers "what did repeat *Amazon* bestsellers look
like in 2009–2019," not "what makes a book sell well" in general — Amazon's own list curation
(whatever weighting it applies) is baked into every row. Treat findings as directional signal for
acquisition/marketing strategy, not a guarantee.

## Data-quality findings

All checks run directly against `bestsellers_with_categories.csv` (550 rows).

### Nulls and exact duplicates

- **Nulls**: 0 in every column.
- **Exact duplicate rows** (all 7 columns identical): 0.

### The central structural fact: books repeat across years

This is not a data error — it is the actual signal the business question is about. Verified
directly:

- **550 rows compress to 351 distinct raw `Name` values** — meaning many titles appear in more
  than one year's top-50 list.
- **96 of those 351 distinct titles (27%) appear in more than one distinct year** — these are the
  repeat bestsellers the client cares about. The remaining **255 titles (73%) are one-hit
  wonders**, appearing in exactly one year.
- Among the 96 repeaters, the **mean span is ~3.0 distinct years**; the top two are:
  - *Publication Manual of the American Psychological Association, 6th Edition* — 10 distinct
    years (2009–2018).
  - *StrengthsFinder 2.0* — 9 distinct years (2009–2017).
- **Decision for Process**: compute a `times_on_list` field (distinct-year count per title) and
  carry it as a first-class row-level variable, so Analyze can directly compare one-hit-wonders
  vs. repeat bestsellers.

### Duplicate (Name, Year) pairs — same book, same year, twice

- **3 titles have an exact duplicate (Name, Year) pair** (6 rows total): *The Fault in Our Stars*
  (2014), *The Help* (2011), and *Unbroken: A World War II Story of Survival, Resilience, and
  Redemption* (2014).
- In all 3 cases, `Author`, `User Rating`, `Reviews`, and `Genre` are identical between the pair —
  **only `Price` differs** (e.g. *The Fault in Our Stars* 2014 lists at both $7 and $13). This
  looks like two separate SKUs/formats (e.g. hardcover vs. paperback) of the same title charting
  in the same year at different prices, not a data-entry error.
- These do **not** distort `times_on_list` (which counts *distinct years*, not rows), but they do
  give these 3 titles one extra row's worth of weight in any row-level average (e.g. average
  price). Left as-is in Process — the price variation is real information, not noise — but flagged
  so Analyze doesn't read too much into row counts as a popularity measure.

### Near-duplicate titles — one real miscount found

Checked whether `Name` is a clean, consistent key for the same book across years by normalizing
titles (lowercase, strip punctuation) and looking for normalized groups that map to more than one
raw spelling.

- **One genuine case found**: *"The 5 Love Languages: The Secret to Love **That** Lasts"*
  (capital T, 2010–2014) and *"The 5 Love Languages: The Secret to Love **that** Lasts"*
  (lowercase t, 2015–2019), same author (Gary Chapman) — a capitalization-only variant that Amazon
  (or the scrape) recorded inconsistently across the decade. Treated as a raw-`Name` count, this
  splits what is really a **10-year repeat bestseller** into two separate 5-year entries — exactly
  the kind of miscount that would understate the strongest repeat signal in the dataset.
- No other normalized-title collisions were found — every other repeat title in the 96 is spelled
  identically across all its appearances.
- **Decision for Process**: canonicalize this one title to a single spelling (title case, matching
  the pre-2015 rows) before computing `times_on_list`, so it correctly counts as one 10-year
  repeater rather than two 5-year ones.

### Price and User Rating outlier checks

- **`User Rating`**: range 3.3–4.9, mean 4.62. All values fall within the expected 0–5 scale — no
  out-of-range values. (Note the range is compressed near the top — this is a *bestseller* list,
  so low-rated books are underrepresented by construction, not a data issue.)
- **`Price`**: range $0–$105, mean $13.10. **12 rows have `Price == 0`** (e.g. *A Higher Loyalty*
  price entries, *Little Blue Truck*, *To Kill a Mockingbird* in several years) and 0 rows have a
  negative price. A $0 price on a bestselling book is plausible — Amazon regularly runs free
  Kindle promotions, and a free/heavily-discounted period can itself drive a book onto the
  bestseller list — so these are treated as valid data, not errors, but flagged for Analyze since
  they will pull down price-based averages if not considered separately.

### Genre value-set check

- **Only 2 values present**: `Non Fiction` (310 rows) and `Fiction` (240 rows) — no typos, no
  case variants, no unexpected third category.

## Licensing, privacy, security, accessibility

- CC0 Public Domain, no restrictions.
- Public, aggregate bestseller-list data — no individual customer data.
- Kept locally in `data/raw/` and `data/processed/`; raw file excluded from Git (see
  `.gitignore`), source is public and reproducible (`data/raw/README.md`).

## Issues to resolve in Process

1. Standardize column names to `snake_case` (`name`, `author`, `user_rating`, `reviews`, `price`,
   `year`, `genre`).
2. Canonicalize the one near-duplicate title (*The 5 Love Languages...*, "That"/"that") to a
   single spelling before any title-level aggregation.
3. Compute `times_on_list` (distinct-year count per canonical title) and merge it back onto every
   row.
4. Leave the 3 same-year duplicate (Name, Year) price pairs and the 12 `Price == 0` rows in place
   (documented above as real, not erroneous) — no rows to drop.
