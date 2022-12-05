-- Covid 19 Data Exploration


-- IN VIETNAM
-- Total Cases vs Total Deaths 
Select 
  location
  , date
  , total_cases
  , total_deaths
  ,(total_deaths/total_cases)*100 AS DeathPercentage
FROM [Ngoc_Project].[dbo].[COVIDDeaths] 
WHERE location = 'Vietnam'
ORDER BY date desc
-- Total Cases vs Population 
Select 
  location
  , date 
  , population
  , total_cases
  , (total_cases/population)*100 AS CasesPercentage
FROM [Ngoc_Project].[dbo].[COVIDDeaths] 
WHERE location = 'Vietnam'
ORDER BY date desc

--  Date with Highest Infection Rate compared to Population 
Select 
  location
  , date
  ,MAX(total_cases) AS HighestInfectionCount
  ,MAX((total_cases/population)*100) AS PercentPopulationInfected 
FROM [Ngoc_Project].[dbo].[COVIDDeaths] 
WHERE location = 'Vietnam'
GROUP BY location, date
ORDER BY PercentPopulationInfected desc 

-- Dates with the Highest Death count per Population 

SELECT
  location
  , date
  ,MAX(CAST(Total_deaths AS INT)) AS Total_DeathCount
From [Ngoc_Project].[dbo].[COVIDDeaths] 
WHERE location = 'Vietnam'
GROUP BY Location, date, total_deaths
ORDER BY Total_DeathCount DESC


-- IN THE WORLD
SELECT 
  SUM(new_cases) AS total_cases
  , SUM(CAST(new_deaths AS INT)) AS total_deaths
  , SUM(CAST(new_deaths AS INT))/SUM(New_Cases)*100 AS DeathPercentage
FROM [Ngoc_Project].[dbo].[COVIDDeaths]
WHERE continent IS NOT NULL


 -- USE CTE to perform Total Population vs Deaths
WITH PopvsDea 
( Continent
  , Location
  ,Date
  ,Population
  ,New_deaths
  ,RollingPeopleDeaths )
   AS
(
SELECT
     vac.continent
	 ,vac.location
	 ,vac.date
	 ,vac.population
	 ,dea.new_deaths
	 ,SUM (CAST(dea.new_deaths AS INT)) OVER (PARTITION BY vac.location) AS RollingPeopleDeaths
FROM [Ngoc_Project].[dbo].[COVIDDeaths] AS dea
JOIN [Ngoc_Project].[dbo].[COVIDVaccination] AS vac
   ON vac.location = dea.location
   AND vac.date = dea.date 
 WHERE vac.continent IS NOT NULL )
 SELECT *
  ,  ( (RollingPeopleDeaths/ population)*100) AS DeathPercentage
 FROM PopvsDea
 -- Create new table to perform percent deaths

DROP Table if exists #PercentPopulationDeaths
Create Table #PercentPopulationDeaths
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_deaths numeric,
RollingPeopleDeaths numeric
)

Insert into #PercentPopulationDeaths
SELECT
     vac.continent
	 ,vac.location
	 ,vac.date
	 ,vac.population
	 ,dea.new_deaths
	 ,SUM (CAST(dea.new_deaths AS INT)) OVER (PARTITION BY vac.location) AS RollingPeopleDeaths
FROM [Ngoc_Project].[dbo].[COVIDDeaths] AS dea
JOIN [Ngoc_Project].[dbo].[COVIDVaccination] AS vac
   ON vac.location = dea.location
   AND vac.date = dea.date 
 WHERE vac.continent IS NOT NULL 
 SELECT *
  , (RollingPeopleDeaths/population)*100

From #PercentPopulationDeaths


-- Create view

Create View PercentPopulationDeaths AS
SELECT
     vac.continent
	 ,vac.location
	 ,vac.date
	 ,vac.population
	 ,dea.new_deaths
	 ,SUM (CAST(dea.new_deaths AS INT)) OVER (PARTITION BY vac.location) AS RollingPeopleDeaths
FROM [Ngoc_Project].[dbo].[COVIDDeaths] AS dea
JOIN [Ngoc_Project].[dbo].[COVIDVaccination] AS vac
   ON vac.location = dea.location
   AND vac.date = dea.date 
 WHERE vac.continent IS NOT NULL 


 



























