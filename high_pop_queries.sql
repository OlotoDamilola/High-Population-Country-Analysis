CREATE TABLE high_pop_details AS
SELECT 
	   RANK() OVER(ORDER BY size DESC) AS pop_rank,
       country_code, country_name AS country, continent, gov_form, indep_year,
	   name AS language,
	   size, fertility_rate,
	   gdp_percapita, income_group
FROM populations p
INNER JOIN countries c 
ON p.country_code = c.code
INNER JOIN languages l 
ON p.country_code = l.code
INNER JOIN economies e 
ON p.country_code = e.code
WHERE e.year = 2010 
GROUP BY country_code
LIMIT 7;

CREATE TABLE details_per_year AS 
SELECT e.code, country_name AS country,
	   ROUND(MAX(CASE WHEN e.year = '2010' THEN e.gdp_percapita ELSE NULL END),2) AS 'gdp_2010',
       ROUND(MAX(CASE WHEN e.year = '2015' THEN e.gdp_percapita ELSE NULL END),2) AS 'gdp_2015',
       ROUND(MAX(CASE WHEN p.year = '2010' THEN p.fertility_rate ELSE NULL END),2) AS 'fert_2010',
       ROUND(MAX(CASE WHEN p.year = '2015' THEN p.fertility_rate ELSE NULL END),2) AS 'fert_2015',
       ROUND(MAX(CASE WHEN e.year = '2010' THEN e.unemployment_rate ELSE NULL END),2) AS 'unemp_2010',
       ROUND(MAX(CASE WHEN e.year = '2015' THEN e.unemployment_rate ELSE NULL END),2) AS 'unemp_2015'
FROM economies e
INNER JOIN countries c 
USING(code)
INNER JOIN populations p 
ON e.code = p.country_code
GROUP BY code
ORDER BY code;
