Select *
From SQLDataExploration..CovidDeaths
where continent is not NULL
order by 3,4

--Select * 
--From SQLDataExploration..CovidVaccination
--order by 3,4 

--Selecting the required data

Select location, date, total_cases, new_cases, total_deaths, population
From SQLDataExploration..CovidDeaths
where continent is not NULL
order by 1,2


--Looking at total_cases vs total_deaths

Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as death_rate
From SQLDataExploration..CovidDeaths
Where location like '%india%'

order by 1,2

--Total Cases vs total population
Select location,date,total_cases,population, (total_cases/population)*100 as positivity_rate
From SQLDataExploration..CovidDeaths
Where location like '%india%'
order by 1,2

--Most affected country
Select location,population,max(total_cases)as Highest_Infected_Count, max(total_cases/population)*100 as positivity_rate
From SQLDataExploration..CovidDeaths
where continent is not NULL
Group by location, population
order by Highest_Infected_Count desc

--Death by country

Select location, max(cast(total_deaths as bigint)) as TotalDeathCount
From SQLDataExploration..CovidDeaths
where continent is not NULL
Group by location 
order by TotalDeathCount desc

--Analysing by continent

Select continent, max(cast(total_deaths as bigint)) as TotalDeathCount
From SQLDataExploration..CovidDeaths
where continent is not NULL
Group by continent 
order by TotalDeathCount desc

Select location, max(cast(total_deaths as bigint)) as TotalDeathCount
From SQLDataExploration..CovidDeaths
where continent is NULL
group by location
order by TotalDeathCount desc


--Global Numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as bigint)) as total_deaths, (sum(cast(new_deaths as bigint))/sum(new_cases))*100 as daily_death_by_daily_case
from SQLDataExploration..CovidDeaths
where continent is not null

select *
from SQLDataExploration..CovidDeaths dea
join SQLDataExploration..CovidVaccination vacc
  on dea.location=vacc.location and dea.date =vacc.date

--total population vs vaccination
select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, sum(cast(new_vaccinations as bigint)) over (partition by dea.location order by dea.date, dea.location) 
from SQLDataExploration..CovidDeaths dea
join SQLDataExploration..CovidVaccination vacc
  on dea.location=vacc.location and dea.date =vacc.date
where dea.continent like '%europe%'
--order by 1,2,3



--Temp Table
drop table if exists #PercentPeopleVaccinated
Create Table #PercentPeopleVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPeopleVaccinated
select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, sum(cast(new_vaccinations as bigint)) over (partition by dea.location order by dea.date, dea.location) as RollingPeopleVaccinated
from SQLDataExploration..CovidDeaths dea
join SQLDataExploration..CovidVaccination vacc
  on dea.location=vacc.location and dea.date =vacc.date
where dea.continent is not null
--order by 1,2,3

Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPeopleVaccinated

--Creating Views

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations, sum(cast(new_vaccinations as bigint)) over (partition by dea.location order by dea.date, dea.location) as RollingPeopleVaccinated
from SQLDataExploration..CovidDeaths dea
join SQLDataExploration..CovidVaccination vacc
  on dea.location=vacc.location and dea.date =vacc.date
where dea.continent is not null