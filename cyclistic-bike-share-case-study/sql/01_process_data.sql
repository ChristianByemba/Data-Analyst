-- Cyclistic Bike-Share — Process phase (SQL / DuckDB equivalent of notebooks/01_process_data.ipynb)
--
-- Run with: duckdb -c ".read sql/01_process_data.sql"  (from the project root)
-- or via the DuckDB Python API. DuckDB can query the raw CSVs directly via a glob pattern,
-- so no separate load/import step is needed.

-- Step 1-3: load, clean, and engineer features in one query
CREATE OR REPLACE TABLE trips AS
SELECT
    ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    end_station_name,
    member_casual,
    date_diff('second', started_at, ended_at) / 60.0                    AS ride_length_min,
    -- 1 = Sunday ... 7 = Saturday, matching the case study's WEEKDAY(date, 1) convention
    (dayofweek(started_at) + 1)                                         AS day_of_week,
    dayname(started_at)                                                 AS day_name,
    month(started_at)                                                   AS month,
    hour(started_at)                                                    AS hour
FROM read_csv('data/raw/*.csv', header = true)
WHERE ended_at >= started_at;                                           -- drop negative-duration rows (29 rows)

-- Step 4b: remove outlier rides (< 1 min, likely false starts; > 24h, likely bike not returned)
CREATE OR REPLACE TABLE trips AS
SELECT *
FROM trips
WHERE ride_length_min >= 1 AND ride_length_min <= 1440;

-- Step 5: sanity check — member vs. casual split (expected: ~64.5% member / ~35.5% casual)
SELECT member_casual, count(*) AS n, round(100.0 * count(*) / sum(count(*)) OVER (), 2) AS pct
FROM trips
GROUP BY member_casual;

-- Step 6: export the cleaned dataset for the Analyze phase
COPY trips TO 'data/processed/all_trips_2025_sql.parquet' (FORMAT parquet);
