# 4. Analyze

Full calculations, code, and captured output:
[`notebooks/02_analyze_data.ipynb`](../notebooks/02_analyze_data.ipynb). Small aggregate tables
(reused in the Share phase) are saved to [`data/summary/`](../data/summary/).

## Key findings

1. **Budget strongly predicts revenue (r = 0.73)** but is essentially uncorrelated with ROI
   (r = -0.03) — a bigger budget buys a bigger box office in absolute dollars, but not a better
   *return* on the money spent.
2. **Budget barely predicts audience rating (r = 0.08)**, and profitability doesn't predict
   rating either (ROI vs. rating, r = 0.01) — a movie's financial success and its critical
   reception are close to independent of each other in this data.
3. **The genres that pay off financially are mostly not the genres that rate best.** By median
   ROI (genres with >=20 movies with usable ROI data): Animation leads (1.77x), then Horror
   (1.49x) and Family (1.48x). By average rating (genres with >=100 movies): Documentary leads
   (6.65), then Animation (6.45) and History (6.41). **Animation is the rare double-winner** —
   top-3 on both rating and ROI — but also one of the most expensive genres to produce on average
   ($46.7M). **Horror is the clearest "reliable-return, low-prestige" genre**: 2nd-highest median
   ROI at the *lowest* average budget of any major genre ($9.3M), but dead last on rating (5.31).
   Documentary's rating lead is worth flagging with caution — only 56 of 3,930 documentaries have
   usable ROI data, too thin to assess its return with confidence.
4. **The <$5M budget tier has the highest median ROI (1.93x)**, roughly double the $5-100M
   "mid-budget" range (0.72-0.99x) — consistent with the film-industry pattern where low-budget
   films need only a modest absolute gross to post a large percentage return, while mid-budget
   films carry real box-office risk without a blockbuster's marketing/distribution edge. The
   $100M+ tier's median ROI (1.77x) recovers to nearly match the <$5M tier — the "middle" is the
   riskiest place to spend, not the extremes.
5. **Longer movies skew modestly higher-rated**: average rating rises from 5.76 (80-100 min) to
   6.64 (150min+) — a real but weak pattern (consistent with the r=0.11 runtime/rating
   correlation), not something to chase on its own.
6. **Revenue is seasonal**: June ($121M avg) and July ($93M avg) — the summer blockbuster window
   — and November/December ($96M avg) — the holiday window — clearly outperform January and
   September (both under $33M avg), the industry's well-known "dump months."

## Interpretation

For the client's greenlighting decision: **budget size buys box-office scale, not quality or
percentage return** — a large budget is a bet on absolute dollars, not a safer or better-reviewed
film. The strongest, most actionable signals are genre-specific ROI patterns and release-timing:
genre should inform the *return* case, release-window should inform the *revenue* case, and
neither of those two levers meaningfully predicts audience rating, which should be evaluated on
its own terms (creative/critical fit) rather than assumed to follow from budget or genre choice.
Genre choice should be treated as two separate decisions depending on the client's goal — chasing
reliable ROI (Animation, Horror, Family) is a different bet than chasing critical reception
(Documentary, Animation, History) — with Animation as the one genre that credibly serves both,
at a real budget premium.