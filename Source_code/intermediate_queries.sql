--Intermediate SQL Queries

--1.Total Revenue per Pizza Category
SELECT pizza_category, SUM(total_price) AS total_revenue
FROM pizza_sales
GROUP BY pizza_category;

--2.Orders with Unique Pizza Names 
SELECT order_id ,pizza_name
FROM pizza_sales
GROUP BY order_id,pizza_name
HAVING COUNT(DISTINCT pizza_name) = COUNT(pizza_name);


--3.Average Order Value by Pizza Size
SELECT pizza_size, AVG(total_price) AS avg_order_value
FROM pizza_sales
WHERE YEAR(order_date) = 2015
GROUP BY pizza_size;

--4.Ingredient Co-Occurrence
WITH IngredientPairs AS (
    SELECT i1.pizza_ingredients AS ingredient1, i2.pizza_ingredients AS ingredient2
    FROM pizza_sales i1
    JOIN pizza_sales i2 ON i1.order_id = i2.order_id AND i1.pizza_ingredients < i2.pizza_ingredients
)
, RankedPairs AS (
    SELECT ingredient1, ingredient2, COUNT(*) AS co_occurrences,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rownum
    FROM IngredientPairs
    GROUP BY ingredient1, ingredient2
)
SELECT ingredient1, ingredient2, co_occurrences
FROM RankedPairs
WHERE rownum <= 5;



--5.Revenue Growth by Month
SELECT YEAR(order_date) AS year, MONTH(order_date) AS month,
    SUM(total_price) AS monthly_revenue,
    LAG(SUM(total_price)) OVER (ORDER BY YEAR(order_date), MONTH(order_date)) AS previous_month_revenue
FROM pizza_sales
WHERE YEAR(order_date) = 2015
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

--6.pizza names and their ingredients for pizzas with a unit price above the average unit price for their respective categories
SELECT ps.pizza_name, ps.pizza_ingredients
FROM pizza_sales AS ps
INNER JOIN (
    SELECT pizza_category, AVG(unit_price) AS avg_unit_price
    FROM pizza_sales
    GROUP BY pizza_category
) AS avg_prices
ON ps.pizza_category = avg_prices.pizza_category
WHERE ps.unit_price > avg_prices.avg_unit_price;

--7.Determine the percentage of  pizzas ctegory wise out of all pizzas sold
SELECT
    pizza_category,
    FORMAT(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM pizza_sales), '0.00') AS category_percentage
FROM pizza_sales
GROUP BY pizza_category;

--8.List the top 10 pizza names with the highest total sales (quantity * unit price)
SELECT pizza_name, total_sales
FROM (
    SELECT
        pizza_name,
        SUM(quantity * unit_price) AS total_sales,
        ROW_NUMBER() OVER (ORDER BY SUM(quantity * unit_price) DESC) AS row_num
    FROM pizza_sales
    GROUP BY pizza_name
) AS ranked
WHERE row_num <= 10;

--9.Find the month with the highest total revenue
--Method 1
SELECT TOP 1
    DATEPART(MONTH, order_date) AS month,
    format(SUM(total_price),'0.00') AS total_revenue
FROM pizza_sales
GROUP BY DATEPART(MONTH, order_date)
ORDER BY total_revenue DESC;
--Method 2
SELECT TOP 1
    DATENAME(MONTH, order_date) AS month_name,
    Format(SUM(total_price),'0.00') AS total_revenue
FROM pizza_sales
GROUP BY DATENAME(MONTH, order_date)
ORDER BY total_revenue DESC;

--10.Day of the week with the highest total sales
SELECT TOP 1
    DATENAME(WEEKDAY, order_date) AS day_of_week,
    SUM(total_price) AS total_sales
FROM pizza_sales
GROUP BY DATENAME(WEEKDAY, order_date)
ORDER BY total_sales DESC;

--11. Week  with the highest total sales
SELECT TOP 1
    DATEPART(WK, order_date) AS week_number,
    SUM(total_price) AS total_sales
FROM pizza_sales
GROUP BY DATEPART(WK, order_date)
ORDER BY total_sales DESC;

--12.pizza with the highest total price in each pizza category
WITH RankedPizzas AS (
    SELECT
        pizza_id,
        pizza_name,
        total_price,
        pizza_category,
        ROW_NUMBER() OVER (PARTITION BY pizza_category ORDER BY total_price DESC) AS category_rank
    FROM pizza_sales
)
SELECT pizza_id, pizza_name, total_price, pizza_category
FROM RankedPizzas
WHERE category_rank = 1;
