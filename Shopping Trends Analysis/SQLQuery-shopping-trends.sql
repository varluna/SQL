/*
--Q1: how many item in each catagory where sold ?
--Q2: What are the most frequently purchased item/categories?
--Q3: What is the demographic distribution of our customers purchasing based on age, gender and Frequency of Purchases?
--Q4.1: Are there seasonal trends in purchasing behavior?
--Q4.2: find the max and min item purchased based on the season
--Q5: is there a relationship between the item purchased by the season?
--Q6: What is the average transaction value for different customer segments?
--Q7: How many customers are repeat buyers, and what is the average frequency of their purchases?
--Q8: Average rating per items for each catagory/item?
*/

--Q1: how many item in each catagory where sold ?
SELECT 
	[Category],
	COUNT([Item_Purchased]) AS 'Purchased Items'
FROM
	[dbo].[shopping_trends]
GROUP BY 
	Category

--Q2: What are the most frequently purchased item/categories?
SELECT 
	[Category],
	Item_Purchased,
	COUNT([Item_Purchased]) AS 'Purchased Items'
FROM
	[dbo].[shopping_trends]
GROUP BY 
	Category, Item_Purchased
ORDER BY 
	 'Purchased Items' DESC


--Q3: What is the demographic distribution of our customers purchasing based on age, gender and Frequency of Purchases
SELECT 
    COUNT([Item_Purchased]) AS 'Purchased Items',
	[Category],
    AVG([Age]) AS 'Average Age',
    [Gender],
	[Frequency_of_Purchases]
FROM
    [dbo].[shopping_trends]
GROUP BY 
    [Gender],[Category],[Frequency_of_Purchases]
ORDER BY 
    'Purchased Items' DESC;


--Q4.1: Are there seasonal trends in purchasing behavior?:
--use [CustomerShoppingTrends]
--CREATE VIEW Purches_per_seasons AS

SELECT 
	Item_Purchased,
	COUNT([Item_Purchased]) AS 'Purchased Items',
	[Season]
FROM 
	[dbo].[shopping_trends]
GROUP BY 
	 Item_Purchased,[Season]
ORDER BY 
	  [Season] , 'Purchased Items' DESC

--Q4.2: find the max and min item purchased based on the season
DECLARE @Season varchar(50)
SET @Season = 'Fall' -- Winter . Fall . Spring . Summer

SELECT *
FROM 
	[dbo].[vPurchesSeasons]
WHERE [Season] = @Season AND
	[Purchased Items] = (SELECT MAX([Purchased Items]) FROM [dbo].[vPurchesSeasons] WHERE [Season] = @Season)

UNION

SELECT *
FROM 
	[dbo].[vPurchesSeasons]
WHERE [Season] = @Season AND
	[Purchased Items] = (SELECT MIN([Purchased Items]) FROM [dbo].[vPurchesSeasons] WHERE [Season] = @Season)



--Q5: is there a relationship between the item purchased by the season?
DECLARE @item varchar(50)
SET @item = 'Jewelry' --

SELECT *
FROM 
	[dbo].[vPurchesSeasons]
WHERE
	[Item_Purchased] = @item


--Q6: What is the average transaction value for different customer segments?
SELECT AVG([Age])AS 'Average age',AVG([Purchase_Amount_USD])AS 'transaction value'
FROM [dbo].[shopping_trends]
GROUP BY  Age
ORDER BY 'transaction value' DESC

--Q7: How many customers are repeat buyers, and what is the average frequency of their purchases?
SELECT 
	frequency,
	AVG([Previous_Purchases]) AS 'average frequency',
	COUNT(Customer_ID) AS Customers
FROM (
	SELECT
		[Previous_Purchases],
		Customer_ID,
		CASE
			WHEN [Previous_Purchases] BETWEEN 0 AND 15 THEN 'Low'
			WHEN [Previous_Purchases] BETWEEN 16 AND 30 THEN 'Regular'
			ELSE 'Frequent'
		END AS frequency
	FROM [dbo].[shopping_trends]
) AS SubQuery
GROUP BY 
	frequency
	ORDER BY Customers

--Q8: Average rating per items for each catagory/item?
SELECT 
	[Category],
	Item_Purchased,
	COUNT([Review_Rating]) AS RatingCount,
	AVG([Review_Rating]) AS AvgRating
FROM
	[dbo].[shopping_trends]
GROUP BY 
	[Category], Item_Purchased
ORDER BY 
	[Category], Item_Purchased