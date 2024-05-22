-- Creating Projects database --
CREATE DATABASE Projects;

-- Table was imported from a csv file into MySQL --

-- Checking out the table --
SELECT * FROM layoffs LIMIT 10;

-- creating a duplicate table to keep the raw file --
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- Querying new table --
SELECT *
FROM layoffs_staging;

-- 1. Removing duplicates --
-- identifying duplicate rows --

SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS 
(SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, 
			percentage_laid_off, `date`, stage, 
            country, funds_raised_millions) AS row_num
FROM layoffs_staging 
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Creating a second duplicate table to enable the safe removal of duplicate rows --
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, 
			percentage_laid_off, `date`, stage, 
            country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Deleting Duplicate rows --
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

-- 2. Standardizing the Data column by column--
-- deleting whitespaces in the company column --

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- industry column --
SELECT DISTINCT (industry)
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'crypto%' ;

-- standardizing the crpto industry name --
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'crypto%';

-- country column --
SELECT DISTINCT (country)
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) AS trimmed_country
FROM layoffs_staging2
ORDER BY country;

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

-- changing the data type for the date column from text to date --
SELECT `date`, 
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT `date`
FROM layoffs_staging2;

-- 3. Dealing with null or blank values --
-- checking for blanks or nulls in imputable columns --
SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL 
	OR industry='';
    
-- Checking if some of the companies had multiple rows i.e. laid offs--
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- Imputing industry name by inference of other records of the same company --
SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
AND t1.location= t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- converting blanks to nulls in the industry column --
UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';

-- imputing null values in the industry column --

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- 4. Removing irrelevant columns -- 
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Deleting the rows from the previous query --
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Dropping the row_num column --
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;