-- Exploratoring the layoffs_staging2 table --

SELECT *
FROM layoffs_staging2;

-- Determining the date range for the data --

SELECT MIN(`date`) AS start_date, 
	MAX(`date`) AS end_date
FROM layoffs_staging2;

-- Highest total laidoff --
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Companies with a 100% layoff --
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
ORDER BY total_laid_off DESC; 

-- Companies with the highest layoffs --
SELECT company, total_laid_off
FROM layoffs_staging2
ORDER BY total_laid_off DESC;

-- Industries that got affected the most --
SELECT industry, SUM(total_laid_off) AS sum_laidoff
FROM layoffs_staging2
GROUP BY industry
ORDER BY sum_laidoff DESC;

-- Countries by total laidoffs --
SELECT country, SUM(total_laid_off) AS sum_laidoff
FROM layoffs_staging2
GROUP BY country
ORDER BY sum_laidoff DESC;

-- Total layoffs by year --
SELECT YEAR(`date`), SUM(total_laid_off) AS sum_laidoff
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY sum_laidoff DESC;

-- Stage of the company by total layoffs --
SELECT stage, SUM(total_laid_off) AS sum_laidoff
FROM layoffs_staging2
GROUP BY stage
ORDER BY sum_laidoff DESC;

-- Month-by-month progression of layoffs (rolling total) --
WITH Rolling_sum AS
(SELECT SUBSTRING(`date`,1,7) AS `Month`,
	SUM(total_laid_off) AS sum_laidoff
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`,1,7) IS NOT NULL
    GROUP BY `Month`
    ORDER BY sum_laidoff
     )
    SELECT `Month`, sum_laidoff,
		SUM(sum_laidoff) OVER (ORDER BY `Month`) AS Rolling_Total
    FROM Rolling_sum;
  
  
    -- Total layoffs by company per year --
    SELECT company, 
			YEAR(`date`), 
			SUM(total_laid_off) AS sum_laidoff
	FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
    ORDER BY sum_laidoff DESC;
    
    -- Ranking the layoffs by Company --
    WITH Company_year (company, `year`, total_laid_off) AS
    (    
    SELECT company, 
			YEAR(`date`), 
			SUM(total_laid_off) AS sum_laidoff
	FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
    )
    SELECT *,
			DENSE_RANK() OVER(PARTITION BY `year` ORDER BY total_laid_off DESC) AS Ranking
    FROM Company_year
    WHERE `year` IS NOT NULL
    ORDER BY Ranking ASC;
    
    
    -- Ranking per company per year (top 5 companies per year)--
        WITH Company_year (company, `year`, total_laid_off) AS
    (    
    SELECT company, 
			YEAR(`date`), 
			SUM(total_laid_off) AS sum_laidoff
	FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
    ), Company_Year_Rank AS
   ( SELECT *,
			DENSE_RANK() OVER(PARTITION BY `year` ORDER BY total_laid_off DESC) AS Ranking
    FROM Company_year
    WHERE `year` IS NOT NULL
   )
   SELECT *
   FROM Company_Year_Rank
   WHERE Ranking<=5;
    
