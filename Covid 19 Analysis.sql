Create Database Porfolio_Project;

Select * from covid19deaths;
Select * from covidvaccinations;

#### Filtering Usebale Data ####
Select Location, date, total_cases,new_cases, total_deaths, population 
from covid19deaths order by 1;

### Total Cases vs Total deaths -- Likelihood of dying if we contract Covid in India
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As Death_Percentage
from covid19deaths Where Location Like "%india%"
order by Death_Percentage desc;

### Total Cases vs Population -- Showing percenatge of population that got covid 
Select Location, date, total_cases,Population, (total_cases/population)*100 As PercentPopulationInfected
from covid19deaths Where Location Like "%india%"
order by PercentPopulationInfected Desc;

### Showing countries with Highest infected rate compared to population
Select Location,Population,max(total_cases) As TotalInfectionCount, max((total_cases/population))*100 As PercentPopulationInfected
from covid19deaths 
Where continent is Not Null
Group By Location
order by TotalInfectionCount Desc;

### Showing Continents with Highest People died per population
Select Continent , max(total_deaths) As TotalDeaths
from covid19deaths 
Where continent is  Not Null
Group By continent
order by TotalDeaths Desc;

# Global Numbers
Select sum(new_cases) as TotalNewCase, sum(new_deaths)TotalNewDeath, Sum(new_deaths)/Sum(new_cases) *100 as DeathPercentage
from covid19_deaths 
Where continent is Not Null
#Group By Date
order by 1 ;

## Total Population Vs Vaccination
Select Cd.continent, Cd.location, Cd.date, Cd.population, Cv.new_vaccinations
from covid19_deaths Cd
Join covidvaccinations Cv
ON Cd.location = Cv.location
and  Cd.date= Cv.date
Where Cd.Continent is Not Null
Order by Cd.location ;

## Total Population Vs Vaccination - RollingSum
Select Cd.continent, Cd.location, Cd.date, Cd.population, Cv.new_vaccinations,
sum(Cv.new_vaccinations) Over (Partition By Cd.location Order by cd.location, cd.date) as RollingPeopleVaccinated
from covid19_deaths Cd
Join covidvaccinations Cv
ON Cd.location = Cv.location
and  Cd.date= Cv.date
Where Cd.Continent is Not Null
Order by Cd.location ;

## Total Population Vs Vaccination - RollingSum & %RollingPeopleVaccinated ## Using CTE ##

With PopVsVac(Continent, location, date, population,new_vaccinations,RollingPeopleVaccinated)
as
(
Select Cd.continent, Cd.location, Cd.date, Cd.population, Cv.new_vaccinations,
sum(Cv.new_vaccinations) Over (Partition By Cd.location Order by cd.location, cd.date) as RollingPeopleVaccinated
from covid19_deaths Cd
Join covidvaccinations Cv
ON Cd.location = Cv.location
and  Cd.date= Cv.date
Where Cd.Continent is Not Null
#Order by Cd.location ;
)
Select *, (RollingPeopleVaccinated/population)*100 As PercentRollingPeopleVaccinated
From PopVsVac;

##### Using TEMP
Drop Table if exists PercentPopVsVac;
Create Table PercentPopVsVac
(
continent VARCHAR(255),
location VARCHAR(255),
population numeric,
new_vaccinations VARCHAR(255),
RollingPeopleVaccinated numeric
);
Insert Into PercentPopVsVac
(
Select Cd.continent, Cd.location, Cd.population, Cv.new_vaccinations,
sum(Cv.new_vaccinations) Over (Partition By Cd.location Order by cd.location, cd.date) as RollingPeopleVaccinated
from covid19_deaths Cd
Join covidvaccinations Cv
ON Cd.location = Cv.location
and  Cd.date= Cv.date
Where Cd.Continent is Not Null
#Order by Cd.location ;
);
Select *, (RollingPeopleVaccinated/Population)*100
From PercentPopVsVac;

## Creating Views for Visualisation

Create view ContinentwithMaxDeath as 
Select Continent , max(total_deaths) As TotalDeaths
from covid19deaths 
Where continent is  Not Null
Group By continent
order by TotalDeaths Desc;

Select * from ContinentwithMaxDeath;

