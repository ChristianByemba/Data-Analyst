# 4. Analyze

Full calculations, code, and captured output: [`notebooks/02_analyze_data.ipynb`](../notebooks/02_analyze_data.ipynb).
Small aggregate tables (reused in the Share phase) are saved to [`data/summary/`](../data/summary/).

## Key findings

1. **Most users don't hit 10,000 steps/day.** Average across the sample is **7,377 steps/day**;
   segmenting the 35 users by their own average puts **31% in the "sedentary" band (<5,000
   steps)** and only **20% in "very active" (10,000+)** — 80% fall short of the commonly-cited
   10,000-step benchmark.
2. **The tracked day is overwhelmingly sedentary.** Of the ~20.4 hours/day the device actually
   tracks, **81.9% is sedentary minutes**; very-active and fairly-active minutes combined are only
   **2.7%** of tracked time.
3. **Sleep is efficient but often insufficient.** Average sleep efficiency (minutes asleep ÷ time
   in bed) is **91.6%** — once in bed, users mostly stay asleep — but **44% of nights fall short
   of 7 hours** of total sleep.
4. **Sedentary time predicts poor sleep more strongly than step count does.** Correlation between
   `sedentary_minutes` and `total_minutes_asleep` is **-0.601** (moderate-to-strong), versus only
   **-0.190** between `total_steps` and sleep. Steps vs. calories correlates positively as
   expected (**0.580**).
5. **Activity peaks in the early evening.** Average hourly steps rise from a low overnight,
   climb from 6 AM, stay elevated through the day, and peak at **7 PM (555 avg steps)** — a broad
   active window from mid-morning through evening, not a single sharp spike.

## Interpretation

The standard framing for this kind of dataset is "encourage more steps." The data suggests a more
specific and more actionable angle: **sedentary time, not step count, is the variable most tied to
a meaningful wellness outcome (sleep)** in this sample. That reframes the opportunity from "get
users to walk more" toward "help users interrupt long sedentary stretches" — directly relevant to
a product line (Leaf, Time) built around continuous, low-friction wearable nudges rather than a
dedicated workout tracker.

The early-evening activity peak (6–8 PM) also suggests the highest-attention window for
in-app engagement/reminders is the evening, not the morning — worth testing directly against
Bellabeat's own future usage data.

## Caveat carried from Prepare

These are trends among 35 FitBit users with **no recorded gender**, a 2016 sample, and very
uneven per-metric coverage (only 24 users have sleep data). They are directional, not conclusive,
for Bellabeat's specifically female customer base — addressed explicitly in the Act phase.
