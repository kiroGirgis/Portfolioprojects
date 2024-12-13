/*

Welcome! I'm thrilled to share my work with you. In this project, I utilized publicly available data from the Our World in Data repository to analyze the global impact of the COVID-19 pandemic. 
This project serves as a demonstration of my ability to explore and analyze real-world datasets using SQL.

Project Overview
This project focuses on uncovering insights about the COVID-19 pandemic through exploratory data analysis. By writing and executing a series of SQL queries, I analyzed key aspects of the data to answer meaningful questions and extract actionable insights.
Below are the main objectives and findings of this project:
Key Objectives 
Mortality Analysis: Calculate the likelihood of death from COVID-19 in each country based on reported cases and fatalities. 
Global Mortality Rate: Determine the percentage of deaths worldwide in relation to confirmed COVID-19 cases.
Vaccination Progress: Measure how many people have been vaccinated globally and analyze vaccination rates across different countries.
Skills Demonstrated Data Exploration: Wrote advanced SQL queries to extract, clean, and analyze the dataset.
Data Visualization: Used SQL and other tools to identify trends and present key metrics effectively.
Problem-Solving: Addressed questions about global health trends and vaccination rates using data-driven approaches. 
Dataset: The data used in this project is sourced from the Our World in Data COVID-19 dataset, which provides comprehensive and up-to-date information on cases, deaths, testing, and vaccinations worldwide.
The dataset is publicly available and widely recognized for its reliability and accuracy.

Key Insights

Identified countries with the highest and lowest likelihood of COVID-19 fatalities.
Calculated the global COVID-19 mortality rate, providing insight into the pandemic's impact.
Analyzed vaccination trends, highlighting countries with the fastest and slowest vaccination rollouts. 
This project showcases the power of data analysis in understanding and responding to global challenges.
By analyzing the COVID-19 dataset, I was able to uncover key trends and patterns that provide valuable insights into the pandemic's impact and vaccination efforts worldwide.
Feel free to explore the queries, share your feedback, or reach out with any questions!

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
