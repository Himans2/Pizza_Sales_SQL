--1.Total Revenue: Calculates the total revenue generated from pizza orders

SELECT SUM(total_price) AS total_revenue
FROM pizza_sales;

--2.Most Popular Pizza Names: Find the top 5 most ordered pizza names

SELECT TOP 5 pizza_name, COUNT(pizza_name) AS order_count
FROM pizza_sales
GROUP BY pizza_name
ORDER BY order_count DESC;

--3.Average Order Quantity: Calculate the average quantity of pizzas per order
SELECT AVG(quantity) AS avg_order_quantity
FROM pizza_sales;

--4.Order Size Distribution: Determine the percentage distribution of order sizes (e.g. small, medium, large)
SELECT pizza_size, COUNT(pizza_size) AS size_count,
    ROUND((COUNT(pizza_size) * 100.0 / (SELECT COUNT(*) FROM pizza_sales)), 2) AS percentage
FROM pizza_sales
GROUP BY pizza_size;

--5.Frequently Used Ingredients: Find the top 5 most frequently used pizza ingredients
SELECT TOP 5 pizza_ingredients, COUNT(pizza_ingredients) AS ingredient_count
FROM pizza_sales
GROUP BY pizza_ingredients
ORDER BY ingredient_count DESC;

--6.Order Trends Over Time: Analyze the monthly order volume for the past year
SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, order_date), 0) AS month_start,
    COUNT(order_id) AS order_count
FROM pizza_sales
WHERE YEAR(order_date) = 2015
GROUP BY DATEADD(MONTH, DATEDIFF(MONTH, 0, order_date), 0)
ORDER BY month_start;


--7.High-Value Orders: List the top 5 orders with the highest total prices
SELECT TOP 5 pizza_name,order_id, total_price
FROM pizza_sales
ORDER BY total_price DESC;


--8.Orders with the Most Quantity: Find the top 5 orders with the highest total quantity of pizzas
SELECT TOP 5 pizza_name,order_id, SUM(quantity) AS total_quantity
FROM pizza_sales
GROUP BY order_id,pizza_name
ORDER BY total_quantity DESC;


--9.Daily Order Trends: Analyze daily order volume for the last 30 days
SELECT CAST(order_date AS DATE) AS order_day, COUNT(order_id) AS order_count
FROM pizza_sales
WHERE order_date >= '2015-12-01' AND order_date < '2016-01-01'
GROUP BY CAST(order_date AS DATE)
ORDER BY order_day;


--10.Ingredient Usage Trends: Analyze the frequency of ingredient usage over time
SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, order_date), 0) AS month_start, 
       pizza_ingredients, 
       COUNT(pizza_ingredients) AS ingredient_count
FROM pizza_sales
WHERE order_date >= '2015-01-01' AND order_date < '2016-01-01'
GROUP BY DATEADD(MONTH, DATEDIFF(MONTH, 0, order_date), 0), pizza_ingredients
ORDER BY month_start, ingredient_count DESC;
