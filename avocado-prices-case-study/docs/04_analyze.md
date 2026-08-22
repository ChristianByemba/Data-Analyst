# 4. Analyze

Full calculations, code, and captured output: [`notebooks/02_analyze_data.ipynb`](../notebooks/02_analyze_data.ipynb).
Small aggregate tables (reused in the Share phase) are saved to [`data/summary/`](../data/summary/).
All aggregations use a single `region_tier` at a time (national or major_region) to avoid the
double-counting risk identified in Prepare/Process.

## Key findings

1. **Organic carries a ~42% price premium** over conventional ($1.55 vs. $1.09 average, national).
2. **Clear seasonality in both types**: prices peak in **September/October** and bottom out in
   **January/February**, every year in the dataset.
3. **2017 saw a sharp price spike** — conventional peaked at **$1.58/unit in September 2017**,
   well above the $0.87–$1.15 range typical of 2015–2016 — consistent with the widely-reported
   2017 avocado supply shortage.
4. **Regional prices vary by up to 55%**: the Northeast pays $1.34 on average for conventional
   avocados vs. $0.87 in SouthCentral. California — the primary US growing region — sits mid-pack,
   not the cheapest, likely reflecting distribution/logistics costs more than proximity to supply.
5. **Price and volume move inversely** (r = -0.51, national conventional) — a textbook
   demand-curve signal: higher-price weeks see lower volume.
6. **Organic is small but growing fast**: only 2.8% of total volume, but its volume grew ~87%
   from 2015 to 2017, roughly 8x the conventional growth rate (~11%) over the same span.

## Data quality note found while charting

Plotting the monthly price trend (chart 3 in Share) surfaced one likely data artifact: **national
organic price is exactly $1.00 for all 4 weeks of July 2015** — an unusually round, unvarying
number compared to every other month (which show normal cent-level variation). This looks like a
placeholder or reporting gap in the source data for that single month, not a genuine market price.
It wasn't caught in the Prepare/Process null/duplicate checks because the value is technically
valid (not null, not negative) — a reminder that "no nulls" doesn't mean "no anomalies." Left
in the dataset and visible in the trend chart, but should not be read as a real price signal.

## Interpretation

The data supports a clear, actionable pricing and inventory picture for a retail client: demand is
seasonal (build inventory ahead of the September/October peak), regionally uneven (a national flat
price leaves margin on the table in high-willingness-to-pay regions like the Northeast and
underprices in low ones like SouthCentral), and increasingly split between a large, price-sensitive
conventional market and a small but fast-growing organic segment carrying a real premium.
