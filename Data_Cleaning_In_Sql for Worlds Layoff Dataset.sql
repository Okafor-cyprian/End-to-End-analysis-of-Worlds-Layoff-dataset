-- DATA CLEANING PROJECT

-- STEPS
-- 1. REMOVE DUPLICATES
-- 2. STANDARDIZE THE DATA
-- 3. HANDLE NULL/BLANK VALUES
-- 4. REMOVE UNNECESSARY COLUMNS

SELECT
	*
FROM
	WORLDS_LAYOFFS

-- Step 1 Removing Duplicates
-- Discover the duplicate rows by using the row_num windows function
WITH
	FIRST_CTE AS (
		SELECT
			*,
			ROW_NUMBER() OVER (
				PARTITION BY
					(
						COMPANY,
						LOCATION,
						INDUSTRY,
						TOTAL_LAID_OFF,
						PERCENTAGE_LAID_OFF,
						DATE,
						STAGE,
						COUNTRY,
						FUNDS_RAISED_MILLIONS
					)
			)
		FROM
			WORLDS_LAYOFFS
	)
SELECT
	*
FROM
	FIRST_CTE
WHERE
	ROW_NUMBER > 1;

-- I created a new table (layoff_data) which has an extra column for the row_number, directly in postgre sql default workspace without using query to store the values result of the CTE, as well as preserve the original table
INSERT INTO
	LAYOFF_DATA
SELECT
	*,
	ROW_NUMBER() OVER (
		PARTITION BY
			(
				COMPANY,
				LOCATION,
				INDUSTRY,
				TOTAL_LAID_OFF,
				PERCENTAGE_LAID_OFF,
				DATE,
				STAGE,
				COUNTRY,
				FUNDS_RAISED_MILLIONS
			)
	)
FROM
	WORLDS_LAYOFFS;

-- Deleting the duplicate rows
DELETE FROM LAYOFF_DATA
WHERE
	ROW_NUMBER > 1;

-- Confirming that the duplicate values have been deleted
SELECT
	*
FROM
	LAYOFF_DATA
WHERE
	ROW_NUMBER > 1;

-- STEP 2 STANDARDIZING THE DATA
SELECT
	*
FROM
	LAYOFF_DATA;

-- Removing unnecessary space from the company column
UPDATE LAYOFF_DATA
SET
	COMPANY = TRIM(COMPANY)
	
-- Side note: some of the cells in the industry columns have inconsistency issues (Crypto and Cryptocurrency industry)
SELECT
	*
FROM
	LAYOFF_DATA
WHERE
	INDUSTRY LIKE 'Crypto%'

-- Fixing the inconsistency with the Crypto and Cryptocurrency cells in the industry column
UPDATE LAYOFF_DATA
SET
	INDUSTRY = 'Crypto'
WHERE
	INDUSTRY LIKE 'Crypto%';

-- Checking for other inconsistency issues
SELECT DISTINCT
	COUNTRY
FROM
	LAYOFF_DATA
ORDER BY
	COUNTRY;

-- The country column has some inconsistency issues
SELECT DISTINCT
	COUNTRY,
	TRIM(
		TRAILING '.'
		FROM
			COUNTRY
	)
FROM
	LAYOFF_DATA
ORDER BY
	COUNTRY;

-- Fixing the inconsistency issues in the country column
UPDATE LAYOFF_DATA
SET
	COUNTRY = TRIM(
		TRAILING '.'
		FROM
			COUNTRY
	)
WHERE
	COUNTRY LIKE 'United States%'

-- Confirm the inconsistency issues are fixed
SELECT DISTINCT
	COUNTRY
FROM
	LAYOFF_DATA;

-- STEP 3 HANDLING NULL VALUES

SELECT
	*
FROM
	LAYOFF_DATA
WHERE
	INDUSTRY IS NULL
	OR INDUSTRY = '';

-- Set empty values to null
UPDATE LAYOFF_DATA
SET
	INDUSTRY = NULL
WHERE
	INDUSTRY = '';
	
-- Use Self Join to Check for values to populate the null/empty values
SELECT
	L1.INDUSTRY,
	L2.INDUSTRY
FROM
	LAYOFF_DATA AS L1
	JOIN LAYOFF_DATA AS L2 ON L1.COMPANY = L2.COMPANY
WHERE
	L1.INDUSTRY IS NULL
	AND L2.INDUSTRY IS NOT NULL;

-- Populate the null values 
UPDATE LAYOFF_DATA AS L1
SET
	INDUSTRY = L2.INDUSTRY
FROM
	LAYOFF_DATA AS L2
WHERE
	L1.COMPANY = L2.COMPANY
	AND (L1.INDUSTRY IS NULL)
	AND L2.INDUSTRY IS NOT NULL;

-- Check if the Null values have been populated
SELECT
	*
FROM
	LAYOFF_DATA
WHERE
	INDUSTRY IS NULL;

-- STEP 5 REMOVE THE UNNECESSARY ROWS COLUMNS
-- Check for the unnecessary columns
SELECT
	*
FROM
	LAYOFF_DATA
WHERE
	TOTAL_LAID_OFF IS NULL
	AND PERCENTAGE_LAID_OFF IS NULL
-- Remove unnecessary rows
DELETE FROM LAYOFF_DATA
WHERE
	TOTAL_LAID_OFF IS NULL
	AND PERCENTAGE_LAID_OFF IS NULL

-- Remove unnecessary columns
ALTER TABLE LAYOFF_DATA
DROP COLUMN ROW_NUMBER