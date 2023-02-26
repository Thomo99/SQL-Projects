SELECT * 
FROM coviddeaths
order by 3,4;


--SELECT DATA TO START WITH
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covidDeaths
ORDER BY 1,2;


-- LIKELIHOOD OF DYING IF YOU CONTRACT COVID (CASES VS DEAD)
SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS deathPercentage
FROM covidDeaths
WHERE location like 'Australia'
and continent is not null 
ORDER BY 1,2;

--Total Cases Vs Population
SELECT location, date, population, total_cases,(total_deaths/population)*100 AS percentPopulation
FROM covidDeaths
WHERE location like 'Australia'
and continent is not null 
ORDER BY 1,2;

--Countries with highest infection rate
SELECT location, population, MAX(total_cases) as highestInfectionCount, MAX((total_cases/population))*100 AS percentPopulationInfected
FROM covidDeaths
WHERE population+total_cases IS NOT NULL
GROUP BY location, population
ORDER BY  percentPopulationInfected DESC;

-- Countries with highest death count per poulation
SELECT location, population, (COUNT(total_deaths)/population)*100 AS deathRate
FROM covidDeaths
WHERE population + total_deaths IS NOT NULL
GROUP BY location, population
ORDER BY deathRate DESC

--Showing continents with the highest death count
SELECT continent, MAX(total_deaths) as deathCount
FROM covidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY deathCount DESC

-- Global Case numbers
SELECT SUM(new_cases) as totalCases, SUM(new_deaths) as totalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as deathRate
FROM covidDeaths;

--Total Population vs Vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rollingVaccinationCount
FROM covidDeaths dea
JOIN vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND new_vaccinations IS NOT NULL;

--CTE calculate % of people vaccinated per location
WITH percentRollingVaccination  AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rollingVaccinationCount
FROM covidDeaths dea
JOIN vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND new_vaccinations IS NOT NULL
)
SELECT continent, location, population, date, new_vaccinations, rollingvaccinationcount, (rollingvaccinationcount/population)*100 AS rollingVaccinationPercentage
From percentRollingVaccination;

--View for Tableau

CREATE VIEW percentRollingVaccination AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rollingVaccinationCount
FROM covidDeaths dea
JOIN vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND new_vaccinations IS NOT NULL









