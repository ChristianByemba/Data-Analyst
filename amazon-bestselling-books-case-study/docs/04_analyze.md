# 4. Analyze

Full calculations, code, and captured output:
[`notebooks/02_analyze_data.ipynb`](../notebooks/02_analyze_data.ipynb). Small aggregate tables
(reused in the Share phase) are saved to [`data/summary/`](../data/summary/). Genre/price/rating
comparisons use a title-level table (one row per canonical title) so repeat titles don't get
overweighted by their extra rows; year trends use the row-level table.

## Key findings

1. **72.9% of titles are one-hit-wonders (255 of 350); 27.1% (95) are repeat bestsellers.** The
   top repeaters span **10 distinct years** — a tie between *The 5 Love Languages: The Secret to
   Love That Lasts* (Gary Chapman) and the *APA Publication Manual, 6th Edition*.
2. **Genre barely matters.** Fiction titles repeat 27.5% of the time, Non Fiction 26.8% — a
   1-point gap, not a meaningful skew. Genre alone does not predict repeat-bestseller status.
3. **Price has essentially no relationship with repeat status** (r=0.01 between mean price and
   `times_on_list`; r=-0.13 between price and rating). If anything, repeat bestsellers are
   *slightly cheaper* on average ($12.28 vs. $13.28 for one-hit-wonders) — there is no evidence
   that a higher price signals a "safer" acquisition.
4. **Rating also shows almost no relationship with repeat status** (r=0.05). Repeaters and
   one-hit-wonders rate almost identically (mean 4.62 vs. 4.60) — both groups are drawn from an
   already high-rating pool (this is a bestseller list, so low ratings are rare by construction).
5. **Reviews are the clearest signal in the dataset.** Correlation between mean reviews and
   `times_on_list` is r=0.23 — modest but clearly the strongest of the three reader-facing metrics
   tested. Repeat bestsellers average **16,381 reviews vs. 7,321** for one-hit-wonders — **more
   than double**. Reviews are essentially uncorrelated with rating (r=-0.00) or price (r=-0.11),
   so this is an independent signal, not a proxy for "better" or "pricier" books.
6. **Top authors by total appearances**: Jeff Kinney leads with 12 appearances across 12 distinct
   *Diary of a Wimpy Kid* titles (a franchise effect — many different books, not one repeating
   title). Gary Chapman is the purest single-title repeater: 11 appearances from just 2 titles.
   Rick Riordan (11 appearances / 10 titles) and Suzanne Collins (11 / 5 titles) sit in between.
7. **Clear year-over-year trends across the decade**: average price fell **35%**, from $15.40
   (2009) to $10.08 (2019) — consistent with the well-known shift toward lower-priced Kindle
   ebook editions over this period. Average rating crept up slightly (+0.16, from 4.58 to 4.74).
   Average reviews **more than tripled** (+237%, from 4,710 to 15,898) — most plausibly reflecting
   Amazon's growing reviewer base over the decade rather than any change in the books themselves.

## Interpretation

For the publishing client, the data points to one dominant, actionable signal and several
non-signals worth ruling out explicitly:

- **Genre, price, and rating — the variables an acquisitions team might instinctively lean on —
  do not meaningfully predict whether a book will repeat.** A client optimizing for "safe," highly
  rated, premium-priced acquisitions in a specific genre is optimizing for variables that show
  almost no relationship with staying on the list across years.
- **Review count (engagement/popularity) is the strongest available predictor of repeat-bestseller
  status**, though the relationship is moderate, not deterministic (r=0.23) — reviews explain part
  of the picture, not all of it. Since reviews accumulate *after* a book starts selling, this is
  more useful as an early-warning signal (a book building review volume unusually fast in its
  first months/year is a candidate for sustained marketing investment) than as an acquisition-time
  filter (an unpublished manuscript has no reviews yet).
- **The two truest repeaters in the dataset — a relationship self-help book and a professional
  reference manual — share nothing in genre, price, or a franchise structure.** Their common trait
  is durable, non-trend-driven demand: content people return to or reference for years, not a
  single reading experience. This is a different acquisition thesis than "chase this year's hot
  genre" — it argues for valuing evergreen utility/reference value as its own acquisition
  criterion, distinct from any of the numeric fields in this dataset.
- **Remember the dataset's own trend**: average price on this list fell 35% and review counts
  roughly tripled over 2009–2019, both largely platform-driven (ebook pricing, growth in Amazon's
  reviewer base) rather than about the books themselves — any absolute-number recommendation
  (e.g. "price around $13") should be treated as decade-average, not current-market guidance.
