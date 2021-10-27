select*
from PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--select*
--from PortfolioProject..CovidVaccinations
--order by 3,4

--1. Selecting data that is supposed to be used
Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

--Total cases  vs total deaths
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercent
from PortfolioProject..CovidDeaths
Where location like '%India%'
Where continent is not null
order by 1,2


--Total cases vs Population
Select Location, date, total_cases, population, (total_cases/population)*100 as CovidPercent
from PortfolioProject..CovidDeaths
Where location like '%India%'
Where continent is not null
order by 1,2

--Countries with Highest Covid Rate
Select Location,  MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population))*100 as PopulationInfectedPercent
from PortfolioProject..CovidDeaths
Where continent is not null
--Where location like '%India%'
Group by Location, population
order by PopulationInfectedPercent desc


--Countries with Highest CovidDeath Rate
Select Location,  MAX(cast(total_deaths as int)) as HighestDeathCount, population
from PortfolioProject..CovidDeaths
Where continent is not null
--Where location like '%India%'
Group by Location, population
order by HighestDeathCount desc

--Continents with Highest CovidDeath Rate
Select continent,  MAX(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
Where continent is not null
--Where location like '%India%'
Group by continent
order by HighestDeathCount desc


--Global Numbers
Select  SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercent
from PortfolioProject..CovidDeaths

Where continent is not null
--group by date
order by 1,2

Select   SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercent
from PortfolioProject..CovidDeaths

Where continent is not null
order by 1,2

--Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 order by 2,3

 --Total Population vs Vaccinations in India
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 and dea.location like '%India%'
 order by 2,3



 --Total Population vs Vaccinations, 
 
 
 --USE CTE
 With PopvsVac (Continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
 as(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 )
 Select*, (RollingPeopleVaccinated/population)*100
 From PopvsVac

 --TEMP TABLE

 DROP Table if exists #PercentPopulationVaccinated
 Create Table #PercentPopulationVaccinated
 (
 continent nvarchar(255),
 location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )


 Insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 --Where dea.continent is not null


 Select*, (RollingPeopleVaccinated/population)*100
 From #PercentPopulationVaccinated



 --for viz
 Create view PercentPopulationVaccinated as 
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
-- order by 2,3

Select *
From PercentPopulationVaccinated


Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths 
where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


--Countries with Highest Covid Rate
Select Location, date,  MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population))*100 as PopulationInfectedPercent
from PortfolioProject..CovidDeaths
Where continent is not null
--Where location like '%India%'
Group by Location, population, date
order by PopulationInfectedPercent desc