# 4. Analyze

Full calculations, code, and captured output: [`notebooks/02_analyze_data.ipynb`](../notebooks/02_analyze_data.ipynb).
Small aggregate tables (reused in the Share phase) are saved to [`data/summary/`](../data/summary/).

## Key findings

1. **Ride length**: casual riders ride **~63% longer on average** than members (19.91 vs 12.18
   min; median 11.89 vs 8.74 min), and this gap holds on every single day of the week.
2. **Weekly pattern**: members ride steadily Monday–Friday with counts peaking Tuesday–Thursday —
   a commute rhythm. Casual riders ride progressively more toward the weekend, peaking Saturday in
   both volume and average duration (23.10 min, the longest of any day for either group). Mode day
   is **Saturday for casual riders, Thursday for members**.
3. **Seasonality**: casual ridership is far more seasonal — ride counts grow **~14x** from January
   to August (23,405 → 323,533), versus **~4x** for members (112,331 → 443,130). Member usage is
   comparatively stable year-round; casual usage is weather/leisure-driven.
4. **Time of day**: members show a classic two-peak commuting profile (sharp AM peak at 7–8h,
   larger PM peak at 16–18h). Casual riders show **no morning rush** — volume ramps up gradually
   and peaks in the afternoon (12–18h).
5. **Weekday vs. weekend**: members are **76.6% weekday** rides. Casual riders are still
   majority-weekday (62.8%, since weekdays are 5/7 of the week) but their weekend share (37.2%) is
   proportionally **~59% higher** than members' — reinforcing the leisure-vs-commute split.
6. **Bike type**: not a strong differentiator — both groups prefer electric bikes at similar rates
   (casual 65.1%, member 63.4%).

## Interpretation

The data supports a clear behavioral split:

- **Members** use Cyclistic primarily to **commute**: short, frequent, weekday, rush-hour rides,
  stable across seasons.
- **Casual riders** use it primarily for **leisure**: longer, weekend- and summer-skewed rides,
  concentrated in the afternoon with no commute-hour peak.

This directly answers the business question from the Ask phase and sets up the Share phase
visualizations and the final recommendations in the Act phase — a marketing strategy converting
casual riders into members should lean on the *leisure* framing (e.g. promoting membership value
for weekend/summer riders) rather than a commute-focused pitch.
