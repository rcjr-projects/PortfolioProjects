
/*
OBJECTIVE: 

In this project I have analyzed the stock prices of crude oil, natural gas, heating oil, RBOB gasoline and brent crude oil. In doing so, this will allow
valuable market insights which will enable stakeholders to make informed decisions regarding production, pricing and risk management, helping to optimize operations 
and remain competitive in a market influenced by the fluctuations in energy commodity prices. 

*/

-- Data Cleaning 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 

--Standardize Date Format


--In this query I made a new column (date_converted) in order to remove the timestamp from the original date column  
SELECT date, CONVERT(DATE,date)
FROM fuel_data

ALTER TABLE fuel_data 
ADD date_converted Date; 

UPDATE fuel_data 
SET date_converted = CONVERT(DATE,date)


-- Created a day column  

ALTER TABLE fuel_data
ADD day VARCHAR(20) ;

UPDATE fuel_data 
SET day = SUBSTRING(date_converted3,1,CHARINDEX(' ',date_converted3));

-- Created a month column

ALTER TABLE fuel_data
ADD month VARCHAR(20) ;

UPDATE fuel_data 
SET month = REPLACE (SUBSTRING(date_converted3,CHARINDEX(' ',date_converted3), CHARINDEX(' ',date_converted3) +1), ' ','');


-- Created a year column 

ALTER TABLE fuel_data
ADD year VARCHAR(20) ;

UPDATE fuel_data 
SET year = REPLACE(RIGHT(date_converted3,LEN(date_converted3)-CHARINDEX (' ', date_converted3)-3), ' ','');



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Rounded the open_price column to two decimal places to make the data more legible 

UPDATE fuel_data 
SET open_price = ROUND(open_price,2)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Rounded the high price column to two decimal places to make the data more legible 

UPDATE fuel_data 
SET high = ROUND(high,2)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Rounded the low price column to two decimal places to make the data more legible 

UPDATE fuel_data 
SET low = ROUND(low,2)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Rounded the close_price column to two decimal places to make the data more legible

UPDATE fuel_data 
SET close_price = ROUND(close_price,2)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--End product 
SELECT * FROM fuel_data



-- Data Exploration 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 /*
The average closing price of crude oil for the months of 2023 is ranked in this query. This query aims to show how the current state of crude oil is doing. 
Based on this data, we can infer that there may be a decline in the price of crude oil between January 2023 and June 2023. 
This decline may result from a fall in demand for crude oil during these months as many people aren't traveling. The price had increased dramatically after June, reaching a peak of 89.43 on average in September.
Again, a variety of factors may contribute to this significant increase, but travel is certainly one of them. 
Even though there was a significant increase from June to September, the average price of crude oil decreased by a few dollars in October. 
Seasonal considerations may be responsible for this; when winter draws near, people tend to travel less, which lowers the demand for crude oil. 
We have to take caution when it comes to market risks. For example, Hurricane season is still ongoing which can possibly affect crude oil production. 
Crude oil prices in 2024 may take a hit if we ignore this issue along with other risks. 

*/


SELECT month , ROUND(AVG(close_price),2) as avg_closeprice, DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE year = '2023' AND commodity = 'Crude Oil' 
GROUP BY month, year
order by avg_closeprice desc





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Utilizing the case statement to identify seasonal trends for crude oil within 2023

SELECT month ,
CASE WHEN month in ('Dec','Jan','Feb') THEN 'Summer'
	 WHEN month in ('Mar','Apr','May') THEN 'Spring'
	 WHEN month in ('Jun','Jul','Aug') THEN 'Summer'
ELSE 'Fall'
END as Season,
ROUND(AVG(close_price),2) as avg_closeprice, DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE year = '2023' AND commodity = 'Crude Oil' 
GROUP BY month, year
order by avg_closeprice desc




-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
The average closing price of crude oil for the past 23 years is ranked in this query. Analyzing this data over the past 23 years provides valuable insight into the evolution of crude oil.
Analyzing the different years of when crude oil performed well allows us to research what events happened during those years that enabled crude oil to perform well. With this insight, we 
can look out for these events and try our best to capitalize if these events were to happen again. The same goes for analyzing the years when crude oil performed the worst. 
We can look at what events took place within those years and come up with ideas on how to avoid these risks to the best of our ability. 

*/

SELECT year, ROUND(AVG(close_price),2) as avg_closeprice , DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE commodity = 'Crude Oil'
GROUP BY year
order by avg_closeprice desc, year 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
The year-over-year growth is calculated in this query for crude oil over the past 23 years. Analyzing the year-over-year growth percentage of crude oil provides valuable insight and information for stakeholders.
With this information, we can identify the overall trend in crude oil prices. After inspecting the year-over-year growth, it seems like crude oil price are very volatile which is valuable information when it comes
to risk assessment and management. Analyzing this year's year-over-year growth percentage, it seems like there has been negative growth compared to last year. 
Of course, this decrease in growth can be due to many factors, which is why it is important to understand what factors are contributing to this decrease in growth. 
This information can also offer insights on whether fossils fuels are still being relied on or if reliance is starting to shift towards renewable resources. 

*/


WITH cte as (
select year,  ROUND(AVG(close_price),2) as avg_closeprice,
row_number() OVER (order by year ) as rn1 
FROM  fuel_data
WHERE commodity = 'Crude Oil'
GROUP BY year
)

SELECT t1.year, t1.avg_closeprice,
ROUND (COALESCE ((t1.avg_closeprice - t2.avg_closeprice)*1.0/t2.avg_closeprice,0)*100,2) as year_over_year_growth_percentage
FROM cte t1
LEFT JOIN cte t2 ON  t1.rn1 = t2.rn1+1


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
The average closing price of heating oil for the months of 2023 is ranked in this query. This query aims to show how the current state of heating oil is doing.
Based on this data, we can infer that the price of heating oil has remained stable throughout the year 2023. Of course, we can see the price of heating oil was lower 
during the spring and summer time, which is predictable due to the warmer weather we experience throughout those times. By looking at this information we can conclude
that the demand for heating oil is low during the spring and summer as compared to the fall and winter time. With this information, we can prepare risk management strategies to mitigate 
financial losses that can occur in the spring and summer. 

*/




SELECT month , ROUND(AVG(close_price),2) as avg_closeprice, DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank] 
FROM fuel_data
WHERE year = '2023' AND commodity = 'Heating Oil'
GROUP BY month, year
order by avg_closeprice desc


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Utilizing the case statement to identify seasonal trends for Heating Oil within 2023

SELECT month ,
CASE WHEN month in ('Dec','Jan','Feb') THEN 'Summer'
	 WHEN month in ('Mar','Apr','May') THEN 'Spring'
	 WHEN month in ('Jun','Jul','Aug') THEN 'Summer'
ELSE 'Fall'
END as Season,
ROUND(AVG(close_price),2) as avg_closeprice, DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE year = '2023' AND commodity = 'Heating Oil' 
GROUP BY month, year
order by avg_closeprice desc


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
The average closing price of heating oil for the past 23 years is ranked in this query. Analyzing this data over the past 23 years provides valuable insight into the evolution of heating oil.
Overall it seems like the price of heating oils has had its ups and downs within the past couple of years. Some factors contributing to these trends could include the supply of crude oil, an increase in unpredictable weather
and the economic condition.  

*/

SELECT year, ROUND(AVG(close_price),2) as avg_closeprice , DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE commodity = 'Heating Oil'
GROUP BY year
order by avg_closeprice desc, year 


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
The year-over-year growth is calculated in this query for heating oil over the past 23 years. Analyzing the year-over-year growth percentage of heating oil provides valuable insight and information for stakeholders.
With this information, we can identify the overall trend in heating oil prices. After inspecting the year-over-year growth, it seems like heating oil is following the same trends as crude oil which is valuable information when it comes
to risk assessment and management. With this information, we can conclude that although heating oil is a by-product of crude oil there is some type of correlation with crude oil due to similar trends in the market. 
This means there is a high chance the same positive and negative events that affect crude oil will also affect heating oil which is necessary to understand for risk assessment and risk strategies.


*/

WITH cte as (
select year,  ROUND(AVG(close_price),2) as avg_closeprice,
row_number() OVER (order by year ) as rn1 
FROM  fuel_data
WHERE commodity = 'Heating Oil'
GROUP BY year
)

SELECT t1.year, t1.avg_closeprice,
ROUND (COALESCE ((t1.avg_closeprice - t2.avg_closeprice)*1.0/t2.avg_closeprice,0)*100,2) as year_over_year_growth_percentage
FROM cte t1
LEFT JOIN cte t2 ON  t1.rn1 = t2.rn1+1



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
The average closing price of natural gas for the months of 2023 is ranked in this query. This query aims to show how the current state of natural gas is doing.
Based on this data, we can infer that the price of natural oil has remained stable throughout the year 2023 with the exception of Jan when the price of natural gas peaked at 3.42.
Although prices have remained stable there is a chance of either a upward or downward trend within the future which can give us a better understanding on how natural gas is doing in the market. 

*/

SELECT month , ROUND(AVG(close_price),2) as avg_closeprice, DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank] 
FROM fuel_data
WHERE year = '2023' AND commodity = 'Natural Gas'
GROUP BY month, year
order by avg_closeprice desc


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Utilizing the case statement to identify seasonal trends for Natural Gas within 2023

SELECT month ,
CASE WHEN month in ('Dec','Jan','Feb') THEN 'Summer'
	 WHEN month in ('Mar','Apr','May') THEN 'Spring'
	 WHEN month in ('Jun','Jul','Aug') THEN 'Summer'
ELSE 'Fall'
END as Season,
ROUND(AVG(close_price),2) as avg_closeprice, DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE year = '2023' AND commodity = 'Natural Gas' 
GROUP BY month, year
order by avg_closeprice desc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
The average closing price of natural gas for the past 23 years is ranked in this query. Analyzing this data over the past 23 years provides valuable insight into the evolution of natural gas.
Overall it seems like the price of natural gas has seen more downs than ups within the past couple of years. Although there was a huge spike in the year 2022 this was due to the drop in the U.S 
supply of natural gas kept in storage was the driving factor to caused this spike in 2022. Now in 2023, the average close price is ranked 20/23 which is a significant decrease within just one year. 
This data gives insight into how poor the natural gas market is performing right now and how urgent it is to prepare risk management and assessments before this gets worse. 

*/

SELECT year, ROUND(AVG(close_price),2) as avg_closeprice , DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE commodity = 'Natural Gas'
GROUP BY year
order by avg_closeprice desc, year 


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*

The year-over-year growth is calculated in this query for natural gas over the past 23 years. Analyzing the year-over-year growth percentage of heating oil provides valuable insight and information for stakeholders.
With this information, we can identify the overall trend in natural prices. Natural gas has taken a big hit this year. This is a serious issue that needs to be addressed as soon as possible to mitigate 
any further financial damages. This significant decrease in performance it probably due to the drop in demand for natural gas not only in the U.S. but globally. The increase in temperatures has eroded energy demand causing 
inventories to swell above usual levels and prices to plunge more. 

*/

WITH cte as (
select year,  ROUND(AVG(close_price),2) as avg_closeprice,
row_number() OVER (order by year ) as rn1 
FROM  fuel_data
WHERE commodity = 'Natural Gas'
GROUP BY year
)

SELECT t1.year, t1.avg_closeprice,
ROUND (COALESCE ((t1.avg_closeprice - t2.avg_closeprice)*1.0/t2.avg_closeprice,0)*100,2) as year_over_year_growth_percentage
FROM cte t1
LEFT JOIN cte t2 ON  t1.rn1 = t2.rn1+1


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
The average closing price of RBOB gasoline for the months of 2023 is ranked in this query. This query aims to show how the current state of RBOB gasoline is doing.
Inspecting the data we can conclude within the year 2023 the price of RBOB gasoline has not fluctuated that much which is a good sign, but there should still be 
some risk assessment and management strategies  to further understand what could happen in the future.

*/

SELECT month , ROUND(AVG(close_price),2) as avg_closeprice, DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank] 
FROM fuel_data
WHERE year = '2023' AND commodity = 'RBOB Gasoline'
GROUP BY month, year
order by avg_closeprice desc



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Utilizing the case statement to identify seasonal trends for RBOB Gasoline within 2023

SELECT month ,
CASE WHEN month in ('Dec','Jan','Feb') THEN 'Summer'
	 WHEN month in ('Mar','Apr','May') THEN 'Spring'
	 WHEN month in ('Jun','Jul','Aug') THEN 'Summer'
ELSE 'Fall'
END as Season,
ROUND(AVG(close_price),2) as avg_closeprice, DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE year = '2023' AND commodity = 'RBOB Gasoline' 
GROUP BY month, year
order by avg_closeprice desc




-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
The average closing price of RBOB gasoline for the past 23 years is ranked in this query. Analyzing this data over the past 23 years provides valuable insight into the evolution of RBOB gasoline.
Overall it seems like the price of RBOB gasoline has been fairly stable with minimal increases and decreases through the years. Although the average close price is ranked at 6 which is still pretty good considering 
the current economic state. We can use this data to perform more analysis on the subject to further understand the direction of RBOB gasoline.

*/
SELECT year, ROUND(AVG(close_price),2) as avg_closeprice , DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE commodity = 'RBOB Gasoline'
GROUP BY year
order by avg_closeprice desc, year 

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
The year-over-year growth is calculated in this query for RBOB gasoline over the past 23 years. Analyzing the year-over-year growth percentage of RBOB gasoline provides valuable insight and information for stakeholders.
After inspecting the data, it seems like in 2023 we had a 12 percent decrease which isn't terrible, but we would need to further analyze the situation to discover what is causing this decrease and how we can mitigate 
any further losses.

*/

WITH cte as (
select year,  ROUND(AVG(close_price),2) as avg_closeprice,
row_number() OVER (order by year ) as rn1 
FROM  fuel_data
WHERE commodity = 'RBOB Gasoline'
GROUP BY year
)

SELECT t1.year, t1.avg_closeprice,
ROUND (COALESCE ((t1.avg_closeprice - t2.avg_closeprice)*1.0/t2.avg_closeprice,0)*100,2) as year_over_year_growth_percentage
FROM cte t1
LEFT JOIN cte t2 ON  t1.rn1 = t2.rn1+1


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
The average closing price of Brent crude oil for the months of 2023 is ranked in this query. This query aims to show how the current state of RBOB gasoline is doing.
After inspecting this data it seems like Brent crude oil is going in an upward trajectory similar to crude oil. There could be some type of correlation between these two.
Maybe the same economic or political events are affecting these two in the same way which is why this data is valuable to give these types of insight.


*/ 

SELECT month , ROUND(AVG(close_price),2) as avg_closeprice, DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank] 
FROM fuel_data
WHERE year = '2023' AND commodity = 'Brent Crude Oil'
GROUP BY month, year
order by avg_closeprice desc



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Utilizing the case statement to identify seasonal trends for Brent Crude Oil within 2023

SELECT month ,
CASE WHEN month in ('Dec','Jan','Feb') THEN 'Summer'
	 WHEN month in ('Mar','Apr','May') THEN 'Spring'
	 WHEN month in ('Jun','Jul','Aug') THEN 'Summer'
ELSE 'Fall'
END as Season,
ROUND(AVG(close_price),2) as avg_closeprice, DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE year = '2023' AND commodity = 'Brent Crude Oil' 
GROUP BY month, year
order by avg_closeprice desc



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
The average closing price of Brent Crude oil for the past 23 years is ranked in this query. Analyzing this data over the past 23 years provides valuable insight into the evolution of Brent Crude oil gasoline.



*/

SELECT year, ROUND(AVG(close_price),2) as avg_closeprice , DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE commodity = 'Brent Crude Oil'
GROUP BY year
order by avg_closeprice desc, year 

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
The year-over-year growth is calculated in this query for Brent crude oil over the past 23 years. Analyzing the year-over-year growth percentage of Brent crude oil provides valuable insight and information for stakeholders.
After inspecting the data, it seems like it is experiencing a downward trend within the past 2 years. Because of this, we would need to further analyze the situation to discover what is causing this decrease and how we can mitigate 
any further losses. Luckily Brent crude oil and crude oil are influenced by similar market dynamics such as supply and demand which will make the analysis easy when looking at the effects these events have caused.

*/


WITH cte as (
select year,  ROUND(AVG(close_price),2) as avg_closeprice,
row_number() OVER (order by year ) as rn1 
FROM  fuel_data
WHERE commodity = 'Brent Crude Oil'
GROUP BY year
)

SELECT t1.year, t1.avg_closeprice,
ROUND (COALESCE ((t1.avg_closeprice - t2.avg_closeprice)*1.0/t2.avg_closeprice,0)*100,2) as year_over_year_growth_percentage
FROM cte t1
LEFT JOIN cte t2 ON  t1.rn1 = t2.rn1+1


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Retrives the 5 highest average closing prices for crude oil with their respective year  
SELECT TOP 5 year , ROUND(AVG(close_price),2) as Average_closing_price
FROM fuel_data
WHERE commodity = 'Crude Oil'
GROUP BY year 
ORDER BY Average_closing_price desc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Retrives the 5 lowest average closing prices for crude oil with their respective year  
SELECT TOP 5 year , ROUND(AVG(close_price),2) as Average_closing_price
FROM fuel_data
WHERE commodity = 'Crude Oil'
GROUP BY year 
ORDER BY Average_closing_price asc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Retrives the 5 highest average closing prices for Natural Gas with their respective year  
SELECT TOP 5 year , ROUND(AVG(close_price),2) as Average_closing_price
FROM fuel_data
WHERE commodity = 'Natural Gas'
GROUP BY year 
ORDER BY Average_closing_price desc



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Retrives the 5 lowest average closing prices for Natural Gas with their respective year  
SELECT TOP 5 year , ROUND(AVG(close_price),2) as Average_closing_price
FROM fuel_data
WHERE commodity = 'Natural Gas'
GROUP BY year 
ORDER BY Average_closing_price asc




-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Retrives the 5 highest average closing prices for Heating Oil with their respective year  
SELECT TOP 5 year , ROUND(AVG(close_price),2) as Average_closing_price
FROM fuel_data
WHERE commodity = 'Heating Oil'
GROUP BY year 
ORDER BY Average_closing_price desc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Retrives the 5 lowest average closing prices for Heating Oil with their respective year  
SELECT TOP 5 year , ROUND(AVG(close_price),2) as Average_closing_price
FROM fuel_data
WHERE commodity = 'Heating Oil'
GROUP BY year 
ORDER BY Average_closing_price asc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Retrives the 5 highest average closing prices for RBOB Gasoline with their respective year  
SELECT TOP 5 year , ROUND(AVG(close_price),2) as Average_closing_price
FROM fuel_data
WHERE commodity = 'RBOB Gasoline'
GROUP BY year 
ORDER BY Average_closing_price desc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Retrives the 5 lowest average closing prices for RBOB Gasoline with their respective year  
SELECT TOP 5 year , ROUND(AVG(close_price),2) as Average_closing_price
FROM fuel_data
WHERE commodity = 'RBOB Gasoline'
GROUP BY year 
ORDER BY Average_closing_price asc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Retrives the 5 highest average closing prices for Brent Crude Oil with their respective year  
SELECT TOP 5 year , ROUND(AVG(close_price),2) as Average_closing_price
FROM fuel_data
WHERE commodity = 'Brent Crude Oil'
GROUP BY year 
ORDER BY Average_closing_price desc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Retrives the 5 lowest average closing prices for Brent Crude Oil with their respective year  
SELECT TOP 5 year , ROUND(AVG(close_price),2) as Average_closing_price
FROM fuel_data
WHERE commodity = 'Brent Crude Oil'
GROUP BY year 
ORDER BY Average_closing_price asc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Utilizing the case statement to identify seasonal trends for Crude Oil within the last 23 years 

SELECT month, year,
CASE WHEN month in ('Dec','Jan','Feb') THEN 'Summer'
	 WHEN month in ('Mar','Apr','May') THEN 'Spring'
	 WHEN month in ('Jun','Jul','Aug') THEN 'Summer'			
END as Season,
ROUND(AVG(close_price),2) as avg_closeprice, DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE  commodity = 'Crude Oil' 
GROUP BY month, year
order by closeprice_rank asc


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Utilizing the case statement to identify seasonal trends for Natural Gas within the last 23 years 

SELECT month, year,
CASE WHEN month in ('Dec','Jan','Feb') THEN 'Summer'
	 WHEN month in ('Mar','Apr','May') THEN 'Spring'
	 WHEN month in ('Jun','Jul','Aug') THEN 'Summer'
ELSE 'Fall'
END as Season,
ROUND(AVG(close_price),2) as avg_closeprice, DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE  commodity = 'Natural Gas' 
GROUP BY month, year
order by closeprice_rank asc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Utilizing the case statement to identify seasonal trends for Brent Crude Oil within the last 16 years 

SELECT month, year,
CASE WHEN month in ('Dec','Jan','Feb') THEN 'Summer'
	 WHEN month in ('Mar','Apr','May') THEN 'Spring'
	 WHEN month in ('Jun','Jul','Aug') THEN 'Summer'
ELSE 'Fall'
END as Season,
ROUND(AVG(close_price),2) as avg_closeprice, DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE  commodity = 'Brent Crude Oil' 
GROUP BY month, year
order by closeprice_rank asc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Utilizing the case statement to identify seasonal trends for Heating Oil within the last 23 years 

SELECT month, year,
CASE WHEN month in ('Dec','Jan','Feb') THEN 'Summer'
	 WHEN month in ('Mar','Apr','May') THEN 'Spring'
	 WHEN month in ('Jun','Jul','Aug') THEN 'Summer'
ELSE 'Fall'
END as Season,
ROUND(AVG(close_price),2) as avg_closeprice, DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE  commodity = 'Heating Oil' 
GROUP BY month, year
order by closeprice_rank asc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Utilizing the case statement to identify seasonal trends for RBOB Gasoline within the last 23 years 

SELECT month, year,
CASE WHEN month in ('Dec','Jan','Feb') THEN 'Summer'
	 WHEN month in ('Mar','Apr','May') THEN 'Spring'
	 WHEN month in ('Jun','Jul','Aug') THEN 'Summer'
ELSE 'Fall'
END as Season,
ROUND(AVG(close_price),2) as avg_closeprice, DENSE_RANK() OVER (ORDER BY ROUND(AVG(close_price),2) desc ) AS [closeprice_rank]
FROM fuel_data
WHERE  commodity = 'RBOB Gasoline' 
GROUP BY month, year
order by closeprice_rank asc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 



