# 1. Ask

## Context

Part of Google Data Analytics Capstone Case Study 3 ("Follow Your Own Case Study Path"): acting
as a junior data analyst at a business intelligence consultancy, choosing a business question,
sourcing a fresh dataset, and delivering client-ready recommendations from scratch.

## Business task

**Client:** a (hypothetical) film production/investment company deciding which types of projects
to greenlight.

**Task:** Using metadata on ~45,000 movies, analyze which factors — budget, genre, runtime,
release timing — are most associated with financial return (revenue vs. budget) and audience
rating, to inform which kinds of projects the client should prioritize.

Guiding question: **Which movie characteristics are most associated with strong financial return
and strong audience reception, and do the same characteristics predict both?**

## Key factors / metrics

- Budget, revenue (→ return on investment)
- Vote average, vote count / popularity (audience reception)
- Genre(s), runtime, release date (→ seasonality of release timing)

## Stakeholders

| Stakeholder | Role | Interest |
|---|---|---|
| Studio investment committee (client) | Decision-maker | Greenlights/declines projects based on expected return |
| BI consultancy account lead | Internal | Reviews the analysis before client presentation |
| Production planning team | Downstream users | Would use genre/timing findings to shape release schedules |

## Data source (planned)

[The Movies Dataset](https://www.kaggle.com/rounakbanik/the-movies-dataset) (Kaggle, CC0, via
Rounak Banik) — full source evaluation in the Prepare phase.

## Audience & presentation

Primary audience: the studio's investment committee — decision-focused, cares about ROI and risk.
Deliverable: a concise written report plus visualizations that make the budget/return and
genre/rating patterns clear enough to inform greenlighting decisions.
