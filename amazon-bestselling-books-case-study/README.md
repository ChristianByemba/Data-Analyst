# Amazon Top 50 Bestselling Books Case Study

Capstone Case Study 3 ("Follow Your Own Case Study Path") from the Google Data Analytics
Professional Certificate. Client scenario: a publishing house wants to know **what characterizes
repeat Amazon bestsellers (2009–2019) — to inform acquisition and marketing strategy.**

## Process

1. [Ask](./docs/01_ask.md) — business task & stakeholders ✅
2. [Prepare](./docs/02_prepare.md) — data sources, organization, credibility ✅
3. [Process](./docs/03_process.md) — cleaning & transformation ✅
4. Analyze — trends & calculations (🚧 next)
5. Share — visualizations & key findings
6. Act — final recommendations

## Repo structure

```
amazon-bestselling-books-case-study/
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

[Amazon Top 50 Bestselling Books 2009–2019](https://www.kaggle.com/sootersaalu/amazon-top-50-bestselling-books-2009-2019)
(Kaggle, CC0, via Souter Saalu).
