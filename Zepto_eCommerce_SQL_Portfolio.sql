use zepto_SQL_project;

--get the structures of the table 
sp_columns zepto_eCommerce;

-- get null value
select *
from zepto_eCommerce
where name is null;

--different product categories
select DISTINCT category 
from zepto_eCommerce
order by category;

--products in stock vs out of stock
select outOfStock, COUNT(outOfStock) as ProductCount
from zepto_eCommerce
group by outOfStock;

--product with price = 0
select * 
from zepto_eCommerce
where mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto_eCommerce
WHERE mrp = 0;

--convert pase to rupees
UPDATE zepto_eCommerce
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select mrp, discountedSellingPrice from zepto_eCommerce;

/*
Business insights questions:
1) Find the top 10 best-value product based on the discount percentage.
2) What are the Products with High MRP but Out of Stock
3) Calculate Estimated Revenue for each category.
4) Find all products where HRP is greater than 500 rupees and discount is less than 10%.
5) Identify the top 5 categories offering the highest average discount percentage
6) Find the price per gram for products above 100g and sort by best value.
7) Group the products into categories like Low, Medium, Bulk
8) What is the Total Inventory weight Per Category
*/

--1) Find the top 10 best-value product based on the discount percentage.
Select distinct TOP(10) name, mrp, discountPercent
from zepto_eCommerce
order by discountPercent desc;

--2) What are the Products with High MRP but Out of Stock
SELECT DISTINCT name, mrp
FROM zepto_eCommerce
WHERE outOfStock = 1 and mrp > 300
order by mrp desc;

--3) Calculate Estimated Revenue for each category.
SELECT category, SUM(discountedSellingPrice * availableQuantity) as total_revenue
FROM zepto_eCommerce
Group by category
order by total_revenue;

--4) Find all products where MRP is greater than 500 rupees and discount is less than 10%.
Select distinct name, mrp, discountPercent
FROM zepto_eCommerce
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp desc, discountPercent desc;

--5) Identify the top 5 categories offering the highest average discount percentage
SELECT DISTINCT TOP(5) category, AVG(discountPercent) as AverageDiscount
FROM zepto_eCommerce
GROUP BY category
ORDER BY AverageDiscount DESC;

--6) Find the price per gram for products above 100g and sort by best value.
SELECT distinct(name), weightInGms, discountedSellingPrice,
Round(discountedSellingPrice/weightInGms,2) As price_per_grm
From zepto_eCommerce
Where weightInGms >= 100
order by price_per_grm;


--7) Group the products into categories like Low, Medium, Bulk
Select distinct(name), weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
From zepto_eCommerce;

--8) What is the Total Inventory weight Per Category
Select category, SUM(weightInGms * availableQuantity) As total_weight
From zepto_eCommerce
Group by Category
Order by total_weight;
