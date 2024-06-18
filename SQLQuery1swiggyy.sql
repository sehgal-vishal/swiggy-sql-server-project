select * from dbo.swiggy

--1.we want ot know the total no. of restaurent according to city

Select City, COUNT(*) as restaurent_count
From dbo.swiggy
Group by City;

--2.AVG rating by city
Select city, AVG(avg_ratings) as avg_rating
From dbo.swiggy
Group By city;

--3.Top Rated Restaurents

Select Restaurant, Avg_ratings 
From dbo.swiggy
Order By Avg_ratings DESC;

--4.Finding the cities with the highest average rating and the most number of restaurants
SELECT city, AVG(Avg_ratings) as avg_city_rating, COUNT(*) as restaurant_count
FROM dbo.swiggy
GROUP BY city
ORDER BY avg_city_rating DESC, restaurant_count DESC;

--5.Finding the most popular food types in each city

Select Distinct City, Food_type, COUNT(*) as restaurent_count
From dbo.swiggy
Group By City, Food_type
Order By City, restaurent_count Desc;

--6.Analyze the average price and rating for each food type

Select Food_type, AVG(Price) as avg_price, AVG(avg_ratings) as avg_ratings
From dbo.swiggy
Group By Food_type;

--7.distribution of ratings among all restaurents

Select AVG(avg_ratings) as avg_ratings, COUNT(*) as restaurents_count
From dbo.swiggy
Group By Round(avg_ratings,5)
Order By restaurents_count desc;

--8.Finding the restaurants with the fastest delivery time in each city.
Select City, Restaurant, Delivery_time
From dbo.swiggy t1
Where Delivery_time=(Select MIN(Delivery_time) From dbo.swiggy t2 
Where t2.City=t1.City);

--9.Identified highly rated restaurants with above-average prices.

Select Restaurant, Avg_ratings, Price
From dbo.swiggy
Where Avg_ratings> (Select AVG(Avg_ratings) From dbo.swiggy) 
AND Price> (Select AVG(Price) From dbo.swiggy)
Order By Price desc;

--10.Analyzing trend of atings over time

Select DATEPART(YEAR, GETDATE()) as years, 
    DATEPART(MONTH, GETDATE()) as months, AVG(Avg_ratings) as avg_monthly_ratings
From dbo.swiggy
Group By DATEPART(YEAR, GETDATE()), DATEPART(MONTH, GETDATE())
Order By years, months; 

--11.Ranking restaurants within each city and area based on average ratings
SELECT city, area, Food_type, restaurant, avg_ratings,
       RANK() OVER (PARTITION BY city, area ORDER BY avg_ratings DESC) as rank_by_city_area
FROM dbo.swiggy;

--12.Quartiles for delivery time
SELECT NTILE(4) OVER (ORDER BY delivery_time) as delivery_time_quartile,
       city, area, restaurant, delivery_time
FROM dbo.swiggy;

--13.identifying areas where customers spent more on average
SELECT top 10 area, AVG(price) as avg_spending
FROM dbo.swiggy
GROUP BY area
ORDER BY avg_spending DESC;

--14.Calculating the percentage contribution of each restaurant in total ratings
SELECT restaurant,total_ratings,
       (total_ratings * 100.0) / SUM(total_ratings) OVER () as percentage_contribution
FROM dbo.swiggy;

--15.Compute a moving average of average ratings over a specified window
SELECT city, area, price, food_type, restaurant, Avg_ratings,
       AVG(Avg_ratings) OVER (ORDER BY id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg_rating
FROM dbo.swiggy;

--16.Creating a hierarchy of restaurants based on city and area
WITH RecursiveCTE AS (
   SELECT id, city, area, restaurant
   FROM dbo.swiggy 
   WHERE city = 'YourCity' AND area = 'YourArea'
   UNION ALL
   SELECT r.id, r.city, r.area, r.restaurant
   FROM dbo.swiggy r
   INNER JOIN RecursiveCTE c ON r.city = c.city AND r.area = c.area
)
SELECT * FROM RecursiveCTE;


--17.Calculating Average Price Difference Between Restaurants in the Same Area
SELECT r1.city, r1.area,
       AVG(ABS(r1.price - r2.price)) as avg_price_difference
FROM dbo.swiggy r1
JOIN dbo.swiggy r2 ON r1.area = r2.area AND r1.id <> r2.id
GROUP BY r1.city, r1.area;







 
