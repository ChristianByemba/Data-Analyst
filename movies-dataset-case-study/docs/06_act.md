# 6. Act

## Final conclusion

Budget, genre, and release timing are all real, usable levers for a greenlighting decision — but
**budget size is a bet on box-office scale, not on quality or percentage return.** Budget
correlates strongly with revenue (r = 0.73) but barely with rating (r = 0.08) and not at all with
ROI (r = -0.03). The two levers that actually move the needle differently are **genre** (which
splits into a "chase return" track and a largely separate "chase reputation" track) and
**release timing** (a free lever — the same film earns more in a strong window than a weak one).

## Top recommendations

1. **Treat genre as two separate decisions, not one, depending on the greenlight's goal.** By
   median ROI, Animation (1.77x), Horror (1.49x), and Family (1.48x) lead; by average rating,
   Documentary (6.65), Animation (6.45), and History (6.41) lead. These are mostly different
   genres. If the goal is reliable financial return, Horror is the standout case: 2nd-highest
   median ROI at the *lowest* average budget of any major genre ($9.3M) — cheap to make, reliably
   profitable, but the lowest-rated genre in the data (5.31), so it should not be greenlit
   expecting critical reception. If the goal is prestige/critical reception, Documentary and
   History lead, but Documentary's ROI can't be assessed with confidence (only 56 of 3,930
   documentaries have usable ROI data) — budget those projects for reputation, not return.
   **Animation is the one genre that credibly serves both goals** (top-3 on both metrics), at a
   real budget premium ($46.7M average).

2. **Don't over-invest budget expecting a better-reviewed or safer film — and be wary of the
   $5-100M "mid-budget" range specifically.** Median ROI is highest at the low end (<$5M: 1.93x)
   and recovers at the high end ($100M+: 1.77x), but sags through the middle ($5-100M: 0.72-0.99x)
   — the classic industry risk zone, with real production cost but without either a low-budget
   film's small break-even bar or a tentpole's marketing/distribution advantage. A budget increase
   should be justified by a specific case (franchise, proven talent, international distribution
   deal) that this dataset can't measure — not by an assumption that more money buys a better or
   safer film.

3. **Lock release scheduling into the confirmed strong windows, and avoid the confirmed dump
   months for anything counting on box office.** June ($121M avg revenue) and July ($93M avg) —
   the summer blockbuster window — and November/December ($96M avg) — the holiday window — clearly
   outperform January and September (both under $33M avg). Release timing doesn't trade off
   against genre or budget choice — it's a free lever available on top of whatever else is
   greenlit.

## How the client can apply this

- **Investment committee**: use the genre ROI table (`docs/05_share.md`, chart 2) as a first-pass
  financial screen and the genre rating table (chart 3) as a first-pass prestige screen — pick
  the one that matches the specific project's greenlighting goal, rather than a single blended
  "good genre" list.
- **Budget/finance team**: flag any project proposed in the $5-100M range for extra scrutiny —
  this is the data's weakest historical ROI zone — and require an explicit justification (star
  power, franchise, pre-sold IP) before approving mid-budget spend that isn't backed by a
  low-budget or tentpole-scale plan.
- **Release planning/distribution**: prioritize June/July and November/December release slots for
  films where box-office performance is the primary success metric; treat January/September slots
  as appropriate only for films where box office is a secondary concern (award-qualifying runs,
  niche/limited releases).

## Next steps / additional data

- **This dataset is dated (compiled ~2017; release dates run through late 2020)** — theatrical
  and streaming economics have changed substantially since (day-and-date and streaming-first
  releases in particular). Any greenlighting decision should validate these patterns against more
  recent box-office and streaming performance data before being finalized.
- **Only ~20% of movies have a usable budget figure** (TMDB's community-submitted metadata, not
  audited financials) — the ROI findings here are directional, not exact. The client's own
  internal budget/revenue data (available for its own past projects) should replace this
  dataset's figures wherever it exists.
- **A natural follow-up**: `credits.csv` and `keywords.csv` were downloaded alongside this
  dataset but not used in this analysis (the business question centers on budget/genre/runtime/
  timing, not cast). A follow-up analysis could test whether specific cast/crew or plot-keyword
  patterns predict return or rating *within* a genre — e.g., does a recognizable lead actor move
  ROI more than genre choice does?
- **Additional deliverable worth adding**: this analysis treats each genre in isolation; a
  multi-variable model (budget, genre, runtime, release month together) would let the client
  estimate an expected ROI/rating range for a specific proposed project rather than reading two
  separate single-factor rankings.