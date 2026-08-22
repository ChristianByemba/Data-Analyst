# 1. Ask

## Context

Part of Google Data Analytics Capstone Case Study 3 ("Follow Your Own Case Study Path"): the
brief is to act as a junior data analyst at a business intelligence consultancy, choose a
business question, source a fresh dataset, and deliver client-ready recommendations — from
scratch, unlike the two prior structured case studies.

## Business task

**Client:** a (hypothetical) international development NGO deciding where to prioritize
well-being programs across countries and which levers (economic, social, health) to invest in.

**Task:** Using the World Happiness Report data, analyze which factors most strongly relate to
national happiness scores, and how those relationships vary across regions and over time, to
inform where and how the client should direct development programs.

Guiding question: **Which factors — GDP per capita, social support, healthy life expectancy,
freedom, generosity, or perceived corruption — are most strongly associated with a country's
happiness score, and does that association hold consistently across regions?**

## Key factors / metrics

- Happiness score (the outcome variable)
- GDP per capita, social support, healthy life expectancy, freedom to make life choices,
  generosity, perceptions of corruption (the candidate explanatory factors)
- Country, region, year (for cross-sectional and trend comparisons)

## Stakeholders

| Stakeholder | Role | Interest |
|---|---|---|
| NGO program director (client) | Decision-maker | Wants an evidence-based case for where/how to allocate program budget |
| BI consultancy account lead | Internal | Reviews the analysis before it's presented to the client |
| Regional program teams | Downstream users | Would act on the recommendations in specific countries/regions |

## Data source (planned)

[World Happiness Report](https://www.kaggle.com/unsdsn/world-happiness) (Kaggle, CC0, via the
Sustainable Development Solutions Network) — full source evaluation in the Prepare phase.

## Audience & presentation

Primary audience: the NGO's program director and regional leads — non-technical, decision-focused.
Deliverable: a concise written report (this repo) plus visualizations that let a non-analyst
quickly see which factors matter most and where.
