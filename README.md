# Covid19-Analysis


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
