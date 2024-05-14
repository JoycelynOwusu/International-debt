## International debt Statistics
In this project, I explored and analyzed international debt data collected by The World Bank using PostgreSQL. The dataset contains information about the amount of debt (in USD) owed by developing countries across several categories. I provided answers to questions like:

What is the total amount of debt that is owed by the countries listed in the dataset?
Which country owes the maximum amount of debt and what does that amount look like?
What is the average amount of debt owed by countries across different debt indicators?
Below is a basic schema of the database you will be working with:

## debt_indicators table  
Column Definition	and Data Type  
country_name	  -  Name of the country	varchar  
country_code    - Code representing the country	varchar  
indicator_name  -	Description of the debt indicator	varchar  
indicator_code  -	Code representing the debt indicator	varchar  
debt            -	Value of the debt indicator for the given country (in current US dollars)	float
