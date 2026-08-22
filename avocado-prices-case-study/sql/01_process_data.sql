-- Avocado Prices — Process phase (SQL / DuckDB equivalent of notebooks/01_process_data.ipynb)
--
-- Run with: duckdb -c ".read sql/01_process_data.sql"  (from the project root)

CREATE OR REPLACE TABLE avocado AS
SELECT
    Date                    AS date,
    AveragePrice            AS average_price,
    "Total Volume"          AS total_volume,
    "4046"                  AS volume_small,
    "4225"                  AS volume_medium,
    "4770"                  AS volume_large,
    "Total Bags"            AS total_bags,
    "Small Bags"            AS small_bags,
    "Large Bags"            AS large_bags,
    "XLarge Bags"           AS xlarge_bags,
    type                    AS type,
    year                    AS year,
    region                  AS region,
    CASE
        WHEN region = 'TotalUS' THEN 'national'
        WHEN region IN ('California','GreatLakes','Midsouth','Northeast','Plains',
                         'SouthCentral','Southeast','West') THEN 'major_region'
        ELSE 'city'
    END                     AS region_tier
FROM read_csv('data/raw/avocado.csv', header = true);

-- Verify the region hierarchy: the 8 major regions should sum to exactly TotalUS
SELECT
    (SELECT sum(total_volume) FROM avocado WHERE region = 'TotalUS' AND date = '2015-12-27' AND type = 'conventional') AS total_us,
    (SELECT sum(total_volume) FROM avocado WHERE region_tier = 'major_region' AND date = '2015-12-27' AND type = 'conventional') AS majors_sum;

-- Sanity checks
SELECT count(*) AS total_rows, count(DISTINCT region) AS regions FROM avocado;
SELECT region_tier, count(*) AS n FROM avocado GROUP BY region_tier;

-- Export for the Analyze phase
COPY avocado TO 'data/processed/avocado_clean_sql.parquet' (FORMAT parquet);
