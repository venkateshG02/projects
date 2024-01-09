select*
from SQLproject..CovidDeaths
where continent is not null
order by 3,4

--select*
--from SQLproject..CovidVaccinations
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from SQLproject..CovidDeaths
order by 1,2

--looking at TOTAL cases vs deaths
--shows likelihood of dying if you contract covid in your country

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from SQLproject..CovidDeaths
where location like '%india%'
order by 1,2

--looking at total cases vs population
--shows what percentage of population got covid

select location,date,population,total_cases,(total_cases/population)*100 as percentpopulationinfected
from SQLproject..CovidDeaths
--where location like '%india%'
order by 1,2

--Looking at countries with highest infection rate compared to population

select location,population,max(total_cases) as highestinfecttioncount,max(total_cases/population)*100 as percentpopulationinfected
from SQLproject..CovidDeaths
--where location like '%india%'
group by location,population
order by percentpopulationinfected desc

--showing continent with death count per population


select continent, max(cast(total_deaths as int)) as TotalDeathCount
from SQLproject..CovidDeaths
--where location like '%india%'
where continent is not  null
group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

select date,sum(new_cases) as total_cases,sum(cast(new_deaths as int))as total_deaths,SUM(cast(new_deaths as int))/SUM
(new_cases)*100 as deathpercentage
from SQLproject..CovidDeaths
--where location like '%india%'
where continent is not null
group by date
order by 1,2

--total cases in global
select sum(new_cases) as total_cases,sum(cast(new_deaths as int))as total_deaths,SUM(cast(new_deaths as int))/SUM
(new_cases)*100 as deathpercentage
from SQLproject..CovidDeaths
--where location like '%india%'
where continent is not null
--group by date
order by 1,2

--joining the 2 table

select *
from SQLproject..CovidDeaths dea
join SQLproject..CovidVaccinations vacci
on dea.location=vacci.location
and dea.date=vacci.date

--Looking at Total Population vs Vaccinations

select dea.continent,dea.location,dea.date,dea.population,vacci.new_vaccinations,
m(convert(int,vacci.new_vaccinations))over (partition by dea.location order by dea.location,
dea.date) as rollingpeoplevaccinated
from SQLproject..CovidDeaths dea
join SQLproject..CovidVaccinations vacci
on dea.location=vacci.location
and dea.date=vacci.date
where dea.continent is not null
order by 2,3

--use CTE

with popvsvacci(continent,location,date,populations,new_vaccinations,rollingpeoplevaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vacci.new_vaccinations,
sum(convert(int,vacci.new_vaccinations))over (partition by dea.location order by dea.location,
dea.date) as rollingpeoplevaccinated
from SQLproject..CovidDeaths dea
join SQLproject..CovidVaccinations vacci
on dea.location=vacci.location
and dea.date=vacci.date
where dea.continent is not null
--order by 2,3
)
select*,(rollingpeoplevaccinated/populations)*100
from popvsvacci

--TEMP TABLE

DROP TABLE if exists #Percentpopulationvaccinated
create table #Percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
rollingpeoplevaccinated numeric
)

insert into #Percentpopulationvaccinated
select dea.continent,dea.location,dea.date,dea.population,vacci.new_vaccinations,
sum(convert(int,vacci.new_vaccinations))over (partition by dea.location order by dea.location,
dea.date) as rollingpeoplevaccinated
from SQLproject..CovidDeaths dea
join SQLproject..CovidVaccinations vacci
on dea.location=vacci.location
and dea.date=vacci.date
--where dea.continent is not null
--order by 2,3

select*,(rollingpeoplevaccinated/population)*100 
from #Percentpopulationvaccinated

--creating view to store data later visualizations

create view Percentpopulationvaccinated as
select dea.continent,dea.location,dea.date,dea.population,vacci.new_vaccinations,
sum(convert(int,vacci.new_vaccinations))over (partition by dea.location order by dea.location,
dea.date) as rollingpeoplevaccinated
from SQLproject..CovidDeaths dea
join SQLproject..CovidVaccinations vacci
on dea.location=vacci.location
and dea.date=vacci.date
where dea.continent is not null
--order by 2,3

select*
from Percentpopulationvaccinated







