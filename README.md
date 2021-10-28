# Covid19-Analysis

![Tableau Visualization](Covid19_Tableau-Viz.jpeg)


### 1. Total cases  vs total deaths in India
For this, death percentage is calculated and inserted in a new column called DeathPercent along with the number of cases and deaths in the country.
   

```
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercent
from PortfolioProject..CovidDeaths
Where location like '%India%'
Where continent is not null
order by 1,2
```

#### 2. Total Population vs Vaccinations in India
For this, two datasets have been merged using the JOIN clause into a new table which gives insights about number of vaccinations done in India
```
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 and dea.location like '%India%'
 order by 2,3
 ```
#### 3. Total Population vs Vaccinations 
For this, Partition Bt clause is used to get the aggregate number of vaccinations given per day and loaction.

```
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 order by 2,3

```

#### 4. Total Population vs Vaccinations,
 For this, Common Table Expression (CTE) is used to calculate the number of people vaccinated.
 

```
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
 ```

####5.  Total Population vs Vaccinations,
For this, creating a temporary table and inserting data from the dataset is used to calculate the  the number of people vaccinated.

```
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


 Select*, (RollingPeopleVaccinated/population)*100
 From #PercentPopulationVaccinated

```


# Covid-19-Analysis-Visualization

SQL queiries have been  performed on Covid19 dataset and the outcome is  visualised  using Tablaeu. 

### 1. Global covid Numbers
For this, total cases, total deaths and death percentage  are presented in tabular form.
```
Select  SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercent
from PortfolioProject..CovidDeaths

Where continent is not null
--group by date
order by 1,2
```

### 2. Total Deaths
Here the total death count has been visualised in a bar graph.

```
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths 
where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

```




### 3.  Countries with Highest Covid Rate
For this, increase in the number of covid 19 cases in differetnt countries is represented with a line graph.
This graph also reprsents the forcasted covid19 infection count till March 2022.
```

Select Location, date,  MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population))*100 as PopulationInfectedPercent
from PortfolioProject..CovidDeaths
Where continent is not null
--Where location like '%India%'
Group by Location, population, date
order by PopulationInfectedPercent desc
```


### 4. Percent Population Infected
For this, map representation has been used to depict number of covid19 cases worldwide.
```
Select Location,  MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population))*100 as PopulationInfectedPercent
from PortfolioProject..CovidDeaths
Where continent is not null
--Where location like '%India%'
Group by Location, population
order by PopulationInfectedPercent desc
```

