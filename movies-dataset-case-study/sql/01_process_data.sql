-- Movies Dataset — Process phase (SQL / DuckDB equivalent of notebooks/01_process_data.ipynb)
--
-- Run with: duckdb -c ".read sql/01_process_data.sql"  (from the project root)

CREATE OR REPLACE TABLE movies_raw AS
SELECT * FROM read_csv('data/raw/movies_metadata.csv', header = true, all_varchar = true, ignore_errors = true);

-- Identify and drop the 6 corrupted/shifted rows: id, budget, or popularity fails to cast to a number
SELECT count(*) AS rows_loaded_by_duckdb FROM movies_raw;

CREATE OR REPLACE TABLE movies_flagged AS
SELECT *,
    TRY_CAST(id AS BIGINT)         AS id_num,
    TRY_CAST(budget AS DOUBLE)     AS budget_num,
    TRY_CAST(popularity AS DOUBLE) AS popularity_num
FROM movies_raw;

SELECT count(*) AS corrupted_rows
FROM movies_flagged
WHERE id_num IS NULL OR budget_num IS NULL OR popularity_num IS NULL;

CREATE OR REPLACE TABLE movies_valid AS
SELECT * FROM movies_flagged
WHERE id_num IS NOT NULL AND budget_num IS NOT NULL AND popularity_num IS NOT NULL;

SELECT count(*) AS rows_after_corrupted_drop FROM movies_valid;

-- Drop duplicate id, keep first occurrence (by original row order)
CREATE OR REPLACE TABLE movies_valid AS
SELECT * FROM (
    SELECT *, row_number() OVER (PARTITION BY id_num ORDER BY id_num) AS rn
    FROM movies_valid
) WHERE rn = 1;

SELECT count(*) AS rows_after_dedup FROM movies_valid;

-- Build the clean movie-level table: coerce types, null-out budget/revenue==0, compute roi/profit
CREATE OR REPLACE TABLE movies_clean AS
SELECT
    id_num                                                          AS id,
    title                                                           AS title,
    TRY_CAST(release_date AS DATE)                                  AS release_date,
    date_part('year', TRY_CAST(release_date AS DATE))               AS release_year,
    date_part('month', TRY_CAST(release_date AS DATE))              AS release_month,
    status                                                          AS status,
    genres                                                          AS genres_raw,
    TRY_CAST(runtime AS DOUBLE)                                     AS runtime,
    NULLIF(budget_num, 0)                                           AS budget,
    NULLIF(TRY_CAST(revenue AS DOUBLE), 0)                          AS revenue,
    CASE WHEN NULLIF(budget_num, 0) > 1000 AND NULLIF(TRY_CAST(revenue AS DOUBLE), 0) > 1000
         THEN NULLIF(TRY_CAST(revenue AS DOUBLE), 0) - NULLIF(budget_num, 0) END AS profit,
    CASE WHEN NULLIF(budget_num, 0) > 1000 AND NULLIF(TRY_CAST(revenue AS DOUBLE), 0) > 1000
         THEN (NULLIF(TRY_CAST(revenue AS DOUBLE), 0) - NULLIF(budget_num, 0)) / NULLIF(budget_num, 0) END AS roi,
    TRY_CAST(vote_average AS DOUBLE)                                AS vote_average,
    TRY_CAST(vote_count AS DOUBLE)                                  AS vote_count,
    popularity_num                                                  AS popularity,
    original_language                                               AS original_language,
    adult                                                           AS adult,
    video                                                           AS video
FROM movies_valid;

-- Sanity checks — cross-validate against the pandas pipeline
SELECT count(*) AS total_rows FROM movies_clean;
SELECT count(*) AS rows_with_valid_roi FROM movies_clean WHERE roi IS NOT NULL;
SELECT count(*) AS budget_known FROM movies_clean WHERE budget IS NOT NULL;
SELECT count(*) AS revenue_known FROM movies_clean WHERE revenue IS NOT NULL;
SELECT round(avg(roi), 4) AS avg_roi, round(median(roi), 4) AS median_roi FROM movies_clean WHERE roi IS NOT NULL;

-- Export for the Analyze phase
COPY movies_clean TO 'data/processed/movies_clean_sql.parquet' (FORMAT parquet);