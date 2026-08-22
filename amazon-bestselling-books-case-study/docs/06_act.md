# 6. Act

## Final conclusion

Across 2009–2019, staying on Amazon's top-50 bestseller list for more than one year is **not**
well-explained by genre, price, or star rating — all three show essentially no relationship with
repeat status. **Review count is the clearest signal available in this dataset** (r=0.23 with
`times_on_list`; repeat bestsellers average more than double the reviews of one-hit-wonders), and
the true long-run repeaters — a relationship self-help book and a professional reference manual,
both 10-year fixtures — share nothing except durable, non-trend-driven demand. This means an
acquisition strategy built primarily around "get the genre/price/rating right" is optimizing for
variables that don't predict staying power; a strategy built around engagement momentum and
evergreen utility is better supported by the data.

## Top recommendations

1. **Treat review-count growth, not star rating or genre, as the leading indicator of
   staying-power potential.** Reviews correlate with `times_on_list` (r=0.23) far more than price
   (r=0.01) or rating (r=0.05) do, and repeat bestsellers average 16,381 reviews vs. 7,321 for
   one-hit-wonders. Since reviews accumulate after publication, this is most useful as a
   marketing-investment trigger, not an acquisition-time filter: when a newly acquired title
   starts building review volume unusually fast in its first months, that is the signal to lean
   into paid promotion and print-run decisions — not the book's rating or genre.

2. **Build a specific acquisition track for "evergreen reference/utility" titles, separate from
   trend-driven trade publishing.** The two most durable repeaters in this data (10 years each) —
   *The 5 Love Languages* and the *APA Publication Manual* — are not premium-priced, not
   top-rated relative to peers, and not part of a franchise; they are books people return to or
   reference for years. This is a different acquisition thesis from "chase this year's hot genre,"
   and the data suggests it deserves its own line item and its own success metric (multi-year
   review accumulation), not evaluation against typical first-year trade-book sales curves.

3. **Do not treat this dataset's price and rating averages as current pricing/quality
   benchmarks.** Average price fell 35% ($15.40 → $10.08) and average review count more than
   tripled (+237%) across 2009–2019 — both almost certainly platform-driven (the shift to
   lower-priced Kindle editions; growth in Amazon's total reviewer base) rather than a signal
   about what today's market rewards. Any pricing decision should be benchmarked against current
   Amazon category data, not this decade-old average.

## How the client can apply this

- **Acquisitions team**: when evaluating a manuscript, weight genre and comparable-title rating
  less heavily than this data might have suggested by intuition; there is no evidence in this
  dataset that either predicts a book's ability to stay on-list across years.
- **Marketing team**: monitor review-count growth rate in the weeks/months after launch as an
  early trigger for reallocating marketing spend toward titles showing above-average momentum —
  the clearest actionable signal this analysis found.
- **Category strategy**: identify and separately track "evergreen reference" candidates (self-help,
  professional/reference, classic children's titles) as their own acquisition category, since the
  data's longest repeaters all fit this profile rather than a typical trade-fiction release
  pattern.

## Next steps / additional data

- **This dataset ends in 2019** — over six years old at the time of this analysis. Amazon's
  bestseller dynamics, ebook pricing, and review volume have all likely shifted materially since;
  any recommendation here should be validated against current Amazon Charts or category
  best-seller data before being finalized.
- **The dataset has no publication date, format (print/ebook/audio), publisher, or sub-genre
  fields** — all plausible drivers of repeat-bestseller status that this analysis could not test.
  A natural follow-up is enriching this data with publisher metadata (via ISBN lookup) to test
  whether publisher marketing budget or imprint explains more variance than the fields available
  here.
- **`Reviews` is a popularity/engagement proxy, not a quality or sentiment measure** — this
  dataset has no review-sentiment or return-rate data. Pairing review *count* with review
  *sentiment* (via NLP on review text, not available here) would sharpen the "evergreen demand"
  thesis from recommendation #2 into something the acquisitions team could act on with more
  confidence.
- **A natural follow-up model**: since no single variable here strongly predicts repeat status, a
  multivariate model (e.g. logistic regression predicting `times_on_list > 1` from genre + price +
  rating + early review velocity) could quantify whether the *combination* of these weak signals
  performs meaningfully better than any one alone — this analysis only tested pairwise
  relationships.
