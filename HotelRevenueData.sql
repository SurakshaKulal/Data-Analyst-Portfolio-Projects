Select * from hotelrevenue;
 
#Revenue
Select ((stays_in_weekend_nights + stays_in_week_nights)*adr) as Revenue from hotelrevenue;

# Revenue by Year
Select arrival_date_year, round(sum(((stays_in_weekend_nights + stays_in_week_nights)*adr)),2)  as Revenue 
from hotelrevenue
Group By arrival_date_year;

# Revenue by Year and Hotel Type
Select arrival_date_year, Hotel,  round(sum(((stays_in_weekend_nights + stays_in_week_nights)*adr)),2)  as Revenue 
from hotelrevenue
Group By arrival_date_year, Hotel
Order by Hotel;

# Joining Reveue Table with Market segment & Meal cost to get discount & Cost Details 

Select * from hotelrevenue hr
Left Join hotel_Marketsegment ms
on hr.market_segment = ms.market_segment
Left Join hotel_mealcost mc
on hr.meal = mc.meal;

## Creating View for Visualisation
create view RevenueByYear as
Select arrival_date_year, round(sum(((stays_in_weekend_nights + stays_in_week_nights)*adr)),2)  as Revenue 
from hotelrevenue
Group By arrival_date_year;

create view RevenueByYearandHotel as
Select arrival_date_year, Hotel,  round(sum(((stays_in_weekend_nights + stays_in_week_nights)*adr)),2)  as Revenue 
from hotelrevenue
Group By arrival_date_year, Hotel
Order by Hotel;



