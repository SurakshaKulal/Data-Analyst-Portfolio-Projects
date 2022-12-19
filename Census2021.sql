Select * from censusdataset1;
Select * from censusdataset2;

## Number of rows in Date Set 1 ##
Select Count(*) from censusdataset1; #640
Select Count(*) from censusdataset2; #35

## Filtering Data for Maharahstra & Karnataka ##
Select * from censusdataset1 where state in ("Maharashtra", "Karnataka" );

## Total Population for Maharahstra & Karnataka ##
Select State, sum(Population) as TotalPopulation from censusdataset2
where state in ("Maharashtra", "Karnataka" )
Group By State;

## Total Population of India ##
Select sum(Population) as TotalPopulation from censusdataset2 ;

## Average Literacy Rate of India ##
Select concat(round(avg(Literacy),2), "%") as AvgLiteracyRate from censusdataset1 ;

## Average Literacy Rate Statewise ##
Select State, concat(round(avg(Literacy),2), "%") as AvgLiteracyRate
from censusdataset1 
Group By State
Order by AvgLiteracyRate Desc;

## State with 2nd and 3rd most highest literacy rate ##
Select State, concat(round(avg(Literacy),2), "%") as AvgLiteracyRate
from censusdataset1 
Group By State
Order by AvgLiteracyRate Desc
Limit 1,2;

## Bottom 3 States with Lowest Literay Rate##
Select State, concat(round(avg(Literacy),2), "%") as AvgLiteracyRate
from censusdataset1 
Group By State
Order by AvgLiteracyRate
Limit 3;

## State with Literacy rate greater than 90% ##
Select State, concat(round(avg(Literacy),2), "%") as AvgLiteracyRate
from censusdataset1 
Group By State
having AvgLiteracyRate > 90
Order by AvgLiteracyRate Desc;

# Filter State starting with "A" 
Select * from censusdataset1 Where State like "A%"
Group By State;


## Joining both the datasets
Select cd1.state, cd1.district, cd1.Sex_ratio, Cd2.Population
from censusdataset1 cd1
Inner Join censusdataset2 cd2
on cd1.District = cd2.District;


# Calculating males and females
Select State, sum(Males) as Total_Males, Sum(Females) as Total_Females from
(Select State, district, round(Population/(Sex_Ratio+1),0) as Males, round((Population *Sex_Ratio)/(Sex_Ratio+1),0) as Females
from 
(Select cd1.state, cd1.district, cd1.Sex_ratio/1000 as Sex_Ratio, Cd2.Population
from censusdataset1 cd1
Inner Join censusdataset2 cd2
on cd1.District = cd2.District) as Cd) as d
Group By State;

# Calculation Total Literate & illiterate People
Select State, sum(Literate_People) as Total_LiteratePeople, Sum(illiterate_people) as Total_illiteratepeople
From
(Select State, district,  round(Literacy_Ratio*Population,0) as Literate_People , round((1-Literacy_Ratio)*Population,0) as illiterate_people
from 
(Select cd1.state, cd1.district, cd1.Literacy/100 as Literacy_Ratio , Cd2.Population
from censusdataset1 cd1
Inner Join censusdataset2 cd2
on cd1.District = cd2.District) as c) as a
Group By State;

# Calculating previous census data
Select Sum(PreviousCensuspopulation) as PreviousCensuspopulation , Sum(Currentpopulation) as Currentpopulation
from
(Select State, Sum(PreviousCensusPopulation) as PreviousCensuspopulation,Sum(CurrentPopulation) as Currentpopulation
from
(Select state, district, population as CurrentPopulation, round(population/(1+growthratio),0) as PreviousCensusPopulation
from
(Select cd1.state, cd1.district, cd1.growth as growthratio , Cd2.Population
from censusdataset1 cd1
Inner Join censusdataset2 cd2
on cd1.District = cd2.District) as b) as d
group By State) as f;

# Population Vs Area - Joining
Select q.* , r. Total_Area from (
Select "1" as Keyy, PreviousCensuspopulation, Currentpopulation
from
(Select Sum(PreviousCensuspopulation) as PreviousCensuspopulation , Sum(Currentpopulation) as Currentpopulation
from
(Select State, Sum(PreviousCensusPopulation) as PreviousCensuspopulation,Sum(CurrentPopulation) as Currentpopulation
from
(Select state, district, population as CurrentPopulation, round(population/(1+growthratio),0) as PreviousCensusPopulation
from
(Select cd1.state, cd1.district, cd1.growth as growthratio , Cd2.Population
from censusdataset1 cd1
Inner Join censusdataset2 cd2
on cd1.District = cd2.District) as b) as d
group By State) as f) as u ) as q 
Inner Join 
(Select "1" as Keyy, Total_Area from
(Select Sum(area_km2) as Total_Area from censusdataset2) as v) as r
on q.keyy = r.keyy; 

# Population Vs Area
Select round(total_area/PreviousCensuspopulation,5) as PreviousCensuspopulation_vs_Area , Round(total_area/Currentpopulation,5) as Currentpopulation_vs_area
from
(Select q.* , r. Total_Area from (
Select "1" as Keyy, PreviousCensuspopulation, Currentpopulation
from
(Select Sum(PreviousCensuspopulation) as PreviousCensuspopulation , Sum(Currentpopulation) as Currentpopulation
from
(Select State, Sum(PreviousCensusPopulation) as PreviousCensuspopulation,Sum(CurrentPopulation) as Currentpopulation
from
(Select state, district, population as CurrentPopulation, round(population/(1+growthratio),0) as PreviousCensusPopulation
from
(Select cd1.state, cd1.district, cd1.growth as growthratio , Cd2.Population
from censusdataset1 cd1
Inner Join censusdataset2 cd2
on cd1.District = cd2.District) as b) as d
group By State) as f) as u ) as q 
Inner Join 
(Select "1" as Keyy, Total_Area from
(Select Sum(area_km2) as Total_Area from censusdataset2) as v) as r
on q.keyy = r.keyy) as z;


## Window Function- Showing state wise Top 3 districts with highest literacy rate

Select h.* from 
(Select District, state, literacy, Rank() over (partition by state order by Literacy desc) as Rnk 
from censusdataset1) as h
where h.rnk in (1,2,3)
order by state; 

## Window Function- Showing state wise BOTTOM 3 districts with Lowest literacy rate
Select i.* from 
(Select District, state, literacy, Rank() over (partition by state order by Literacy) as Rnk 
from censusdataset1) as i
where i.rnk in (1,2,3)
order by state; 

