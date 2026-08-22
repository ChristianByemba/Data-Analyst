-- World Happiness Report — Process phase (SQL / DuckDB equivalent of notebooks/01_process_data.ipynb)
--
-- Run with: duckdb -c ".read sql/01_process_data.sql"  (from the project root)

-- Step 2-3: standardize columns per year (native names differ) and reconcile country-name variants
CREATE OR REPLACE TABLE y2015 AS
SELECT
    CASE Country
        WHEN 'Macedonia' THEN 'North Macedonia'
        WHEN 'North Cyprus' THEN 'Northern Cyprus'
        WHEN 'Trinidad and Tobago' THEN 'Trinidad & Tobago'
        ELSE Country END                          AS country,
    Region                                         AS region,
    2015                                           AS year,
    "Happiness Rank"                               AS rank,
    "Happiness Score"                              AS happiness_score,
    "Economy (GDP per Capita)"                     AS gdp_per_capita,
    Family                                         AS social_support,
    "Health (Life Expectancy)"                     AS health_life_expectancy,
    Freedom                                        AS freedom,
    "Trust (Government Corruption)"                AS corruption_perception,
    Generosity                                     AS generosity,
    "Dystopia Residual"                            AS dystopia_residual
FROM read_csv('data/raw/2015.csv', header = true);

CREATE OR REPLACE TABLE y2016 AS
SELECT
    CASE Country
        WHEN 'Macedonia' THEN 'North Macedonia'
        WHEN 'North Cyprus' THEN 'Northern Cyprus'
        WHEN 'Trinidad and Tobago' THEN 'Trinidad & Tobago'
        ELSE Country END                          AS country,
    Region                                         AS region,
    2016                                           AS year,
    "Happiness Rank"                               AS rank,
    "Happiness Score"                              AS happiness_score,
    "Economy (GDP per Capita)"                     AS gdp_per_capita,
    Family                                         AS social_support,
    "Health (Life Expectancy)"                     AS health_life_expectancy,
    Freedom                                        AS freedom,
    "Trust (Government Corruption)"                AS corruption_perception,
    Generosity                                     AS generosity,
    "Dystopia Residual"                            AS dystopia_residual
FROM read_csv('data/raw/2016.csv', header = true);

-- Region -> lookup table built from 2015 + 2016 (later years don't publish Region)
CREATE OR REPLACE TABLE region_map AS
SELECT DISTINCT country, region FROM (
    SELECT country, region FROM y2015
    UNION
    SELECT country, region FROM y2016
);

CREATE OR REPLACE TABLE y2017 AS
SELECT
    CASE Country
        WHEN 'Macedonia' THEN 'North Macedonia'
        WHEN 'North Cyprus' THEN 'Northern Cyprus'
        WHEN 'Trinidad and Tobago' THEN 'Trinidad & Tobago'
        WHEN 'Hong Kong S.A.R., China' THEN 'Hong Kong'
        WHEN 'Taiwan Province of China' THEN 'Taiwan'
        ELSE Country END                          AS country,
    NULL::VARCHAR                                  AS region_placeholder,
    2017                                           AS year,
    "Happiness.Rank"                               AS rank,
    "Happiness.Score"                              AS happiness_score,
    "Economy..GDP.per.Capita."                     AS gdp_per_capita,
    Family                                         AS social_support,
    "Health..Life.Expectancy."                     AS health_life_expectancy,
    Freedom                                        AS freedom,
    "Trust..Government.Corruption."                AS corruption_perception,
    Generosity                                     AS generosity,
    "Dystopia.Residual"                            AS dystopia_residual
FROM read_csv('data/raw/2017.csv', header = true);

CREATE OR REPLACE TABLE y2018 AS
SELECT
    CASE "Country or region" WHEN 'Macedonia' THEN 'North Macedonia' ELSE "Country or region" END AS country,
    NULL::VARCHAR                                  AS region_placeholder,
    2018                                            AS year,
    "Overall rank"                                  AS rank,
    Score                                            AS happiness_score,
    "GDP per capita"                                AS gdp_per_capita,
    "Social support"                                AS social_support,
    "Healthy life expectancy"                        AS health_life_expectancy,
    "Freedom to make life choices"                   AS freedom,
    -- DuckDB's CSV type inference does not treat the literal "N/A" (UAE's row) as NULL the way
    -- pandas does by default — it infers the whole column as VARCHAR. Cast explicitly.
    TRY_CAST(NULLIF("Perceptions of corruption", 'N/A') AS DOUBLE) AS corruption_perception,
    Generosity                                       AS generosity,
    NULL::DOUBLE                                     AS dystopia_residual
FROM read_csv('data/raw/2018.csv', header = true, columns = {
    'Overall rank': 'BIGINT', 'Country or region': 'VARCHAR', 'Score': 'DOUBLE',
    'GDP per capita': 'DOUBLE', 'Social support': 'DOUBLE', 'Healthy life expectancy': 'DOUBLE',
    'Freedom to make life choices': 'DOUBLE', 'Generosity': 'DOUBLE',
    'Perceptions of corruption': 'VARCHAR'
});

CREATE OR REPLACE TABLE y2019 AS
SELECT
    "Country or region"                              AS country,
    NULL::VARCHAR                                    AS region_placeholder,
    2019                                              AS year,
    "Overall rank"                                    AS rank,
    Score                                              AS happiness_score,
    "GDP per capita"                                  AS gdp_per_capita,
    "Social support"                                  AS social_support,
    "Healthy life expectancy"                          AS health_life_expectancy,
    "Freedom to make life choices"                     AS freedom,
    "Perceptions of corruption"                        AS corruption_perception,
    Generosity                                         AS generosity,
    NULL::DOUBLE                                       AS dystopia_residual
FROM read_csv('data/raw/2019.csv', header = true);

-- Step 4-5: backfill region for 2017-2019 from the map, then union all 5 years
CREATE OR REPLACE TABLE panel AS
SELECT country, region, year, rank, happiness_score, gdp_per_capita, social_support,
       health_life_expectancy, freedom, corruption_perception, generosity, dystopia_residual
FROM y2015
UNION ALL
SELECT country, region, year, rank, happiness_score, gdp_per_capita, social_support,
       health_life_expectancy, freedom, corruption_perception, generosity, dystopia_residual
FROM y2016
UNION ALL
SELECT y.country, r.region, y.year, y.rank, y.happiness_score, y.gdp_per_capita, y.social_support,
       y.health_life_expectancy, y.freedom, y.corruption_perception, y.generosity, y.dystopia_residual
FROM y2017 y LEFT JOIN region_map r ON y.country = r.country
UNION ALL
SELECT y.country, r.region, y.year, y.rank, y.happiness_score, y.gdp_per_capita, y.social_support,
       y.health_life_expectancy, y.freedom, y.corruption_perception, y.generosity, y.dystopia_residual
FROM y2018 y LEFT JOIN region_map r ON y.country = r.country
UNION ALL
SELECT y.country, r.region, y.year, y.rank, y.happiness_score, y.gdp_per_capita, y.social_support,
       y.health_life_expectancy, y.freedom, y.corruption_perception, y.generosity, y.dystopia_residual
FROM y2019 y LEFT JOIN region_map r ON y.country = r.country;

-- Sanity checks — should be 782 rows, 165 countries, 1 null corruption_perception
SELECT count(*) AS total_rows, count(DISTINCT country) AS unique_countries FROM panel;
SELECT count(*) AS null_corruption FROM panel WHERE corruption_perception IS NULL;

-- Export for the Analyze phase
COPY panel TO 'data/processed/happiness_panel_sql.parquet' (FORMAT parquet);
