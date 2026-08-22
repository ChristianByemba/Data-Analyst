# Movies Dataset Case Study

Capstone Case Study 3 ("Follow Your Own Case Study Path") from the Google Data Analytics
Professional Certificate. Client scenario: a film production/investment company wants to know
**which movie characteristics are most associated with financial return and audience rating.**

## Process

1. [Ask](./docs/01_ask.md) — business task & stakeholders ✅
2. [Prepare](./docs/02_prepare.md) — data sources, organization, credibility ✅
3. [Process](./docs/03_process.md) — cleaning & transformation ✅
4. Analyze — trends & calculations (🚧 next)
5. Share — visualizations & key findings
6. Act — final recommendations

## Repo structure

```
movies-dataset-case-study/
├── docs/         # write-ups for each phase (Ask, Prepare, Process, Analyze, Share, Act)
├── data/
│   ├── raw/      # original downloaded data (not committed — see data/raw/README.md)
│   ├── processed/# cleaned/merged datasets used for analysis
│   └── summary/  # small aggregate tables used to build the Share-phase charts
├── notebooks/    # Python (pandas/Jupyter) analysis
├── sql/          # SQL scripts
└── images/       # exported charts/visualizations
```

## Data source

[The Movies Dataset](https://www.kaggle.com/rounakbanik/the-movies-dataset) (Kaggle, CC0, via
Rounak Banik) — metadata on ~45,000 movies.