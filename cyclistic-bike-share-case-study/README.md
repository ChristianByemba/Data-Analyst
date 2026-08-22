# Cyclistic Bike-Share Case Study

Capstone case study from the Google Data Analytics Professional Certificate. Cyclistic is a
fictional Chicago bike-share company; this project analyzes 12 months of historical trip data to
answer: **how do annual members and casual riders use Cyclistic bikes differently?** The goal is
to inform a marketing strategy that converts casual riders into annual members.

## Process

This project follows the six-phase data analysis process:

1. [Ask](./docs/01_ask.md) — business task & stakeholders ✅
2. [Prepare](./docs/02_prepare.md) — data sources, organization, credibility ✅
3. [Process](./docs/03_process.md) — cleaning & transformation ✅
4. [Analyze](./docs/04_analyze.md) — trends & calculations ✅
5. [Share](./docs/05_share.md) — visualizations & key findings ✅
6. Act — final recommendations (🚧 next)

## Key finding

![Rides by hour of day](./images/03_rides_by_hour.png)

Members show a textbook two-peak commute profile; casual riders show one broad afternoon peak
with no morning rush. See [docs/05_share.md](./docs/05_share.md) for the full set of visualizations.

## Repo structure

```
cyclistic-bike-share-case-study/
├── docs/         # write-ups for each phase (Ask, Prepare, Process, Analyze, Share, Act)
├── data/
│   ├── raw/      # original downloaded data (not committed — see data/raw/README.md)
│   └── processed/# cleaned/merged datasets used for analysis
├── notebooks/    # Python (pandas/Jupyter) analysis
├── sql/          # SQL scripts
└── images/       # exported charts/visualizations
```

## Data source

Public Cyclistic (Divvy) trip data, made available by Motivate International Inc. under
[this license](https://divvybikes.com/data-license-agreement). See
[data/raw/README.md](./data/raw/README.md) for download instructions.
