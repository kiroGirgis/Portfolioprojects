/*

COVID-19 Data Exploration in SQL WorkBench
SKills USED: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, and converting data Types
Author: Kirolos Girgis

*/

SELECT country,
	   date,
       total_cases,
	   new_cases,
       total_deaths,
       population
FROM Data_Exploration.covid_deaths;

-- Exploring what percentage of the population had died due to COVID-19 int the United States
SELECT country,
	   date,
       total_cases,
	   total_cases,
       total_deaths,
       (total_deaths / total_cases) * 100 AS Deathpercentage
FROM Data_Exploration.covid_deaths
WHERE country LIKE '%United states%';

-- Exploring what percentage of the entire population had gotten COVID-19 in the United States
SELECT country,
	   date,
       population,
       total_cases,
       (total_cases / population) * 100 AS casePercentage
FROM Data_Exploration.covid_deaths
WHERE country LIKE '%United states%';

-- Looking at countries with the Highest infection rates compared to their population
SELECT country,
       population,
       MAX(total_cases),
       MAX((total_cases/population)) * 100 AS CasePercentage
FROM Data_Exploration.covid_deaths
GROUP BY country, population
ORDER BY CasePercentage DESC;

-- Looking at countries with the highest death count per population
SELECT country,
	   MAX(total_deaths) AS DeathCountTotal
FROM Data_Exploration.covid_deaths
WHERE continent IS NOT NULL
GROUP BY country  
ORDER BY DeathCountTotal DESC;

-- Showing the continents with the highest death counts

SELECT continent,
	   MAX(total_deaths) AS DeathCountTotal
FROM Data_Exploration.covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent  
ORDER BY DeathCountTotal DESC;

-- looking at global numbers of cases and death percentage across the entire world by date

SELECT date,
	   SUM(new_cases) AS total_cases,
       SUM(new_deaths) AS total_deaths,
       SUM(new_deaths)/ SUM(new_cases) * 100 AS DeathPercentage
FROM Data_Exploration.covid_deaths
WHERE continent IS NOT NULL
GROUP BY date;

-- Looking at the total number of cases and the death percentage of the pandemic over all

SELECT SUM(new_cases) AS total_cases,
       SUM(new_deaths) AS total_deaths,
       SUM(new_deaths)/ SUM(new_cases) * 100 AS DeathPercentage
FROM Data_Exploration.covid_deaths
WHERE continent IS NOT NULL;

-- Joining the covid death table with the covid vacinations table and Looking at the total population VS vacinations

WITH PopvsVac (continent, country, date, population, new_vaccinations, RollingPeopleVaccinated)
AS(
SELECT covid_deaths.continent,
	   covid_deaths.country,
       covid_deaths.date,
       covid_deaths.population,
       covid_vacinations.new_vaccinations,
       SUM(CAST(covid_vacinations.new_vaccinations AS double)) OVER (PARTITION BY covid_deaths.country, covid_deaths.date) AS RollingPeopleVaccinated
FROM Data_Exploration.covid_deaths
JOIN Data_Exploration.covid_vacinations
	 ON covid_deaths.Country = covid_vacinations.country
     AND covid_deaths.date = covid_vacinations.date
WHERE covid_deaths.continent IS NOT NULL
)
SELECT *
FROM PopvsVac;


-- creating a view to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS 
SELECT covid_deaths.continent,
	   covid_deaths.country,
       covid_deaths.date,
       covid_deaths.population,
       covid_vacinations.new_vaccinations,
       SUM(CAST(covid_vacinations.new_vaccinations AS double)) OVER (PARTITION BY covid_deaths.country, covid_deaths.date) AS RollingPeopleVaccinated
FROM Data_Exploration.covid_deaths
JOIN Data_Exploration.covid_vacinations
	 ON covid_deaths.Country = covid_vacinations.country
     AND covid_deaths.date = covid_vacinations.date
WHERE covid_deaths.continent IS NOT NULL;
