-- Amazon Bestselling Books — Process phase (SQL / DuckDB equivalent of notebooks/01_process_data.ipynb)
--
-- Run with: duckdb -c ".read sql/01_process_data.sql"  (from the project root)

CREATE OR REPLACE TABLE bestsellers AS
SELECT
    Name                    AS name,
    Author                  AS author,
    "User Rating"           AS user_rating,
    Reviews                 AS reviews,
    Price                   AS price,
    Year                    AS year,
    Genre                   AS genre
FROM read_csv('data/raw/bestsellers_with_categories.csv', header = true);

-- Canonicalize the one near-duplicate title found in Prepare: a capitalization-only split on
-- "The 5 Love Languages: The Secret to Love That/that Lasts" that would otherwise undercount a
-- real 10-year repeat bestseller as two separate 5-year ones.
UPDATE bestsellers
SET name = 'The 5 Love Languages: The Secret to Love That Lasts'
WHERE lower(name) = 'the 5 love languages: the secret to love that lasts';

-- Compute times_on_list (distinct-year count per canonical title) via a window function and
-- attach it to every row.
CREATE OR REPLACE TABLE bestsellers AS
SELECT
    *,
    count(DISTINCT year) OVER (PARTITION BY name) AS times_on_list
FROM bestsellers;

-- Sanity checks
SELECT count(*) AS total_rows, count(DISTINCT name) AS distinct_titles FROM bestsellers;
SELECT max(times_on_list) AS max_times_on_list, count(DISTINCT name) FILTER (WHERE times_on_list > 1) AS repeat_titles FROM bestsellers;
SELECT name, times_on_list FROM bestsellers ORDER BY times_on_list DESC, name LIMIT 5;
SELECT genre, count(*) AS n FROM bestsellers GROUP BY genre;
SELECT count(*) AS nulls FROM bestsellers WHERE name IS NULL OR author IS NULL OR user_rating IS NULL
    OR reviews IS NULL OR price IS NULL OR year IS NULL OR genre IS NULL;

-- Export for the Analyze phase
COPY bestsellers TO 'data/processed/bestsellers_clean_sql.parquet' (FORMAT parquet);
