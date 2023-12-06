/* 
--Question 1: How many accidents have occurred in urban areas versus rural areas?
--Question 2.1: Which day of the week has the highest number of accidents?
--Question 2.2: witch light condition in an accidents with the day of the week?
--Question 2.3: Calculate the accidents , considering Day and LightConditions:
--Question 3: What is the average age of vehicles involved in accidents based on their type?
--Question 4: Can we identify any trends in accidents based on the age of vehicles involved?
--Question 5: Are there any specific weather conditions that contribute to severe accidents?
--Question 6: Do accidents often involve impacts on the left-hand side of vehicles?
--Question 7: Are there any relationships between journey purposes and the severity of accidents?
--Question 8: Calculate the average age of vehicles involved in accidents , considering Day light and point of impact:
*/



--Question 1: How many accidents have occurred in urban areas versus rural areas?
SELECT 
	COUNT(accidentIndex) AS Total_accidents ,
	Area
FROM 
	[dbo].[accident]
GROUP BY 
	Area


--Question 2.1: Which day of the week has the highest number of accidents?
SELECT 
	COUNT(accidentIndex) AS Days_of_accident ,
	"Day"
FROM 
	[dbo].[accident]
GROUP BY 
	"Day"
ORDER BY 
	Days_of_accident DESC


--Question 2.2: witch light condition in an accidents with the day of the week?
DECLARE @DAY varchar(50)
SET @DAY = 'Friday' -- Friday , Thursday , Wednesday , Tuesday , Monday , Saturday , Sunday

SELECT 
	COUNT(accidentIndex) AS Days_of_accident ,
	"Day" ,
	LightConditions
FROM 
	[dbo].[accident]
WHERE 
	"Day" = @DAY 
GROUP BY 
	"Day", 
	LightConditions
ORDER BY
	Days_of_accident DESC

--Question 2.3: Calculate the accidents , considering Day and LightConditions:
SELECT 
	COUNT(accidentIndex) AS Days_of_accident ,
	"Day", LightConditions
FROM 
	[dbo].[accident]
GROUP BY 
	"Day", LightConditions
ORDER BY
	"Day" DESC


--Question 3: What is the average age of vehicles involved in accidents based on their type?
SELECT 
	COUNT(AccidentIndex) AS 'Total Accident' ,
	AVG(AgeVehicle) AS  'Average Age' ,
	VehicleType
FROM 
	[dbo].[vehicle]
WHERE 
	AgeVehicle IS NOT NULL
GROUP BY 
	VehicleType
ORDER BY 
	'Total Accident' DESC


--Question 4: Can we identify any trends in accidents based on the age of vehicles involved?
SELECT 
	COUNT(AccidentIndex) AS 'Total Accident' ,
	AVG(AgeVehicle) AS  'Average Age' , 
	AgeGroup
FROM(
	SELECT
		[AccidentIndex],
		[AgeVehicle],
		CASE
			WHEN [AgeVehicle] BETWEEN 0 AND 5 THEN 'New'
			WHEN [AgeVehicle] BETWEEN 6 AND 10 THEN 'Regular'
			ELSE 'Old'
		END AS AgeGroup
	FROM [dbo].[vehicle]
) AS SubQuery
GROUP BY 
	AgeGroup
ORDER BY
	[Total Accident] DESC


--Question 5: Are there any specific weather conditions that contribute to severe accidents?
SELECT 
	COUNT(AccidentIndex) AS TotalAccidents,
	WeatherConditions
FROM 
	[dbo].[accident]
WHERE 
	Severity = 'Fatal'
GROUP BY 
	WeatherConditions,
	Severity
ORDER BY
	TotalAccidents DESC


--Question 6: Do accidents often involve impacts on the left-hand side of vehicles?
SELECT
    COUNT(AccidentIndex) AS TotalAccidents,
    SUM(CASE WHEN [LeftHand] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(AccidentIndex) AS PercentageLeftHanded,
    SUM(CASE WHEN [LeftHand] = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(AccidentIndex) AS PercentageRightHanded
FROM
    [dbo].[vehicle]
--Another approach 
SELECT
    COUNT(AccidentIndex) AS TotalAccidents,
    [LeftHand]
FROM
    [dbo].[vehicle]
GROUP BY
    [LeftHand]
HAVING
	[LeftHand] IS NOT NULL



--Question 7: Are there any relationships between journey purposes and the severity of accidents?
SELECT 
	V.[JourneyPurpose], 
	COUNT(A.[Severity]) AS 'Total Accident',
	CASE 
		WHEN COUNT(A.[Severity]) BETWEEN 0 AND 1000 THEN 'Low'
		WHEN COUNT(A.[Severity]) BETWEEN 1001 AND 3000 THEN 'Moderate'
		ELSE 'High'
	END AS 'Level'
FROM 
	[dbo].[accident] A
JOIN 
	[dbo].[vehicle] V ON A.[AccidentIndex] = V.[AccidentIndex]
GROUP BY 
	V.[JourneyPurpose]
ORDER BY 
	'Total Accident' DESC;


--Question 8: Calculate the average age of vehicles involved in accidents , considering Day light and point of impact:
DECLARE @Impact varchar(100)
DECLARE @Light varchar(100)
SET @Impact = 'Offside' -- Did not impact, Nearside, Front, Offside, Back
SET @Light = 'Darkness' -- Daylight, Darkness

SELECT 
	A.[LightConditions], 
	V.[PointImpact], 
	AVG(V.[AgeVehicle]) AS 'Average Vehicle Year'
FROM 
	[dbo].[accident] A
JOIN 
	[dbo].[vehicle] V ON A.[AccidentIndex] = V.[AccidentIndex]
GROUP BY 
	V.[PointImpact], A.[LightConditions]
HAVING 
	V.[PointImpact] = @Impact AND A.[LightConditions] = @Light

