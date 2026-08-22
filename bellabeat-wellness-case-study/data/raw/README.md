# Raw data

Raw FitBit tracker data is **not** committed to this repository (589 MB, excluded via
`.gitignore`). To reproduce this analysis:

```python
import kagglehub
path = kagglehub.dataset_download("arashnic/fitbit")
```

Or download manually from [Kaggle](https://www.kaggle.com/datasets/arashnic/fitbit). Place the
two date-range folders here as `2016-03-12_to_2016-04-11/` and `2016-04-12_to_2016-05-12/`.

## Contents

The dataset covers **30 consenting FitBit users** over two periods in 2016, each a folder of CSVs
(daily/hourly/minute-level activity, steps, calories, intensity, sleep, heart rate, and weight
logs). The two periods are **not identical in coverage**:

- `2016-03-12_to_2016-04-11/` — missing `dailyCalories`, `dailyIntensities`, `dailySteps`,
  `sleepDay`, and the "Wide" variants of the minute-level files.
- `2016-04-12_to_2016-05-12/` — has the full set of files.

This asymmetry is addressed in the Prepare phase.

## License

CC0: Public Domain, made available via [Mobius](https://www.kaggle.com/arashnic) on Kaggle. No
personally identifiable information — users are anonymized IDs only.
