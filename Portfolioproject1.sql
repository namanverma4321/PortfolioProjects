use PortfolioProject

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercent
from PortfolioProject..CovidDeaths
where location like '%india%'


select location,date,Population,total_cases,(total_cases/population)*100 as CasesPercent
from PortfolioProject..CovidDeaths
where location like '%india%'


select location,Population,max(total_cases) as HighestInfectionCount,max(total_cases/population)*100 as PercentpopulationInfected
from PortfolioProject..CovidDeaths
group by location,population
order by max(total_cases/population)*100 desc


--Showing Countries with Highest Death Count per Population

select location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

select continent,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers
select date,Sum(new_cases)as total_cases,
sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/Sum(New_cases)*100 as DeathPercent
from PortfolioProject..CovidDeaths
where continent is not null
Group By date
order by 1,2

-- Let's break things down by continent

select location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc

--Total Global Numbers
select Sum(new_cases)as total_cases,
sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/Sum(New_cases)*100 as DeathPercent
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Looking at Total Population vs Vaccinations

with PopvsVac (Continent, location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations 
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.date=vac.date
	and dea.location=vac.location
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100
from PopvsVac

Drop Table if exists PercentPopulationVaccinated
create Table PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
rollingpeoplevaccinated numeric)

Insert into PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations 
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.date=vac.date
	and dea.location=vac.location
where dea.continent is not null


select *,(RollingPeopleVaccinated/population)*100
from PercentPopulationVaccinated

--Creating view to store data for later visualizations

Create view PercentPopulationVaccinate as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations 
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.date=vac.date
	and dea.location=vac.location
where dea.continent is not null


