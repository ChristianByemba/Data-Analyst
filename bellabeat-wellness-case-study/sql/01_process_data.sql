-- Bellabeat — Process phase (SQL / DuckDB equivalent of notebooks/01_process_data.ipynb)
--
-- Run with: duckdb -c ".read sql/01_process_data.sql"  (from the project root)
-- or via the DuckDB Python API.

-- Step 1-3: load both periods, drop Period 1's rows on the overlap date (2016-04-12 —
-- Period 1's export cuts off mid-day for that date, Period 2's is the complete day), combine.
CREATE OR REPLACE TABLE daily_activity AS
SELECT
    Id                          AS id,
    ActivityDate                AS activity_date,
    TotalSteps                  AS total_steps,
    TotalDistance                AS total_distance,
    TrackerDistance              AS tracker_distance,
    LoggedActivitiesDistance     AS logged_activities_distance,
    VeryActiveDistance           AS very_active_distance,
    ModeratelyActiveDistance     AS moderately_active_distance,
    LightActiveDistance          AS light_active_distance,
    SedentaryActiveDistance      AS sedentary_active_distance,
    VeryActiveMinutes            AS very_active_minutes,
    FairlyActiveMinutes          AS fairly_active_minutes,
    LightlyActiveMinutes         AS lightly_active_minutes,
    SedentaryMinutes             AS sedentary_minutes,
    Calories                     AS calories,
    (TotalSteps = 0)             AS is_zero_steps
FROM read_csv('data/raw/2016-03-12_to_2016-04-11/dailyActivity_merged.csv', header = true)
WHERE ActivityDate != DATE '2016-04-12'

UNION ALL

SELECT
    Id, ActivityDate, TotalSteps, TotalDistance, TrackerDistance, LoggedActivitiesDistance,
    VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, SedentaryActiveDistance,
    VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, Calories,
    (TotalSteps = 0)
FROM read_csv('data/raw/2016-04-12_to_2016-05-12/dailyActivity_merged.csv', header = true);

-- Step 4: sanity check — should be zero duplicate (id, activity_date) pairs
SELECT count(*) AS duplicate_id_date_pairs
FROM (SELECT id, activity_date, count(*) AS n FROM daily_activity GROUP BY id, activity_date)
WHERE n > 1;

-- Step 5: clean sleep data (Period 2 only — Period 1 has no sleepDay table) and dedupe
CREATE OR REPLACE TABLE sleep_day AS
SELECT DISTINCT
    Id                    AS id,
    SleepDay              AS sleep_day,
    TotalSleepRecords     AS total_sleep_records,
    TotalMinutesAsleep    AS total_minutes_asleep,
    TotalTimeInBed        AS total_time_in_bed,
    round(100.0 * TotalMinutesAsleep / TotalTimeInBed, 1) AS sleep_efficiency_pct
FROM read_csv('data/raw/2016-04-12_to_2016-05-12/sleepDay_merged.csv', header = true);

-- Step 6: merge activity + sleep (left join)
CREATE OR REPLACE TABLE activity_sleep_merged AS
SELECT a.*, s.total_sleep_records, s.total_minutes_asleep, s.total_time_in_bed, s.sleep_efficiency_pct
FROM daily_activity a
LEFT JOIN sleep_day s
  ON a.id = s.id AND a.activity_date = s.sleep_day;

-- Step 7: export for the Analyze phase
COPY daily_activity TO 'data/processed/daily_activity_sql.parquet' (FORMAT parquet);
COPY sleep_day TO 'data/processed/sleep_day_sql.parquet' (FORMAT parquet);
