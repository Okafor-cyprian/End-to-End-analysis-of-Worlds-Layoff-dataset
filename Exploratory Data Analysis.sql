-- EXPLORATORY DATA ANALYSIS
select * from layoff_data;

-- Checking the maximum number and maximum percentage of layoffs
SELECT
	MAX(TOTAL_LAID_OFF),
	MAX(PERCENTAGE_LAID_OFF)
FROM
	LAYOFF_DATA;

-- Checking the companies that laidoff all of their staff
SELECT
	*
FROM
	LAYOFF_DATA
WHERE
	PERCENTAGE_LAID_OFF = 1
ORDER BY
	TOTAL_LAID_OFF DESC NULLS LAST;

SELECT
	*
FROM
	LAYOFF_DATA
WHERE
	PERCENTAGE_LAID_OFF = 1
ORDER BY
	FUNDS_RAISED_MILLIONS DESC NULLS LAST;

-- Checking the total number of layoff in each company
SELECT
	COMPANY,
	SUM(TOTAL_LAID_OFF)
FROM
	LAYOFF_DATA
GROUP BY
	COMPANY
ORDER BY
	2 DESC NULLS LAST;

-- Checking the total number of layoff in each industry from most to least
SELECT
	INDUSTRY,
	SUM(TOTAL_LAID_OFF)
FROM
	LAYOFF_DATA
GROUP BY
	INDUSTRY
ORDER BY
	2 DESC NULLS LAST;

-- Checking the total number of layoff in each country from most to least
SELECT
	COUNTRY,
	SUM(TOTAL_LAID_OFF)
FROM
	LAYOFF_DATA
GROUP BY
	COUNTRY
ORDER BY
	2 DESC NULLS LAST;

-- Checking the total number of layoff in each location from most to least
SELECT
	LOCATION,
	SUM(TOTAL_LAID_OFF)
FROM
	LAYOFF_DATA
GROUP BY
	LOCATION
ORDER BY
	2 DESC NULLS LAST;

-- Checking the total number of layoff in each company stage from most to least
SELECT
	STAGE,
	SUM(TOTAL_LAID_OFF)
FROM
	LAYOFF_DATA
GROUP BY
	STAGE
ORDER BY
	2 DESC NULLS LAST;

-- Checking the date range (when the layoffs started vs when it ended)
SELECT
	MIN(DATE) AS MINIMUM_DATE,
	MAX(DATE) AS MAXIMUM_DATE
FROM
	LAYOFF_DATA
	
-- Checking the Number of Layoff Per Year
SELECT
    EXTRACT(YEAR FROM DATE) AS DATE_OF_LAYOFF,
    SUM(TOTAL_LAID_OFF) AS TOTAL_LAID_OFF
FROM LAYOFF_DATA
GROUP BY EXTRACT(YEAR FROM DATE)
ORDER BY TOTAL_LAID_OFF DESC NULLS LAST;

-- Checking the Number of Layoff Per Month
SELECT
    EXTRACT(MONTH FROM DATE) AS MONTH_OF_LAYOFF,
    SUM(TOTAL_LAID_OFF) AS TOTAL_LAID_OFF
FROM LAYOFF_DATA
GROUP BY EXTRACT(MONTH FROM DATE)
ORDER BY 1 DESC NULLS LAST;

-- Checking the number of layoff in each year per company
select company, extract(year from date), sum(total_laid_off)
from layoff_data
group by 1, 2
order by 1;

-- Checking the number of layoff in each year per company ranked by year
WITH company_year (company, years, total_laid_off) AS (
    SELECT
        company,
        EXTRACT(YEAR FROM date) AS years,
        SUM(total_laid_off) AS total_laid_off
    FROM layoff_data
    GROUP BY company, EXTRACT(YEAR FROM date)
)
SELECT
    *,
    DENSE_RANK() OVER (
        PARTITION BY years
        ORDER BY years DESC nulls last
    ) AS ranking
FROM company_year
order by ranking asc;