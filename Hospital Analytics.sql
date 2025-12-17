USE hospital_db;
SET SQL_SAFE_UPDATES = 0;

-- =======================================================
-- STEP 0: DATA CLEANING (Run this once)
-- =======================================================

-- 1. Fix Typo in Encounter Class

UPDATE encounters
SET ENCOUNTERCLASS = 'urgent care'
WHERE ENCOUNTERCLASS = 'urgentcare';

-- 2. Remove Numbers from Patient Names

UPDATE patients

SET First = REGEXP_REPLACE(First, '[0-9]+', ''),
Last  = REGEXP_REPLACE(Last, '[0-9]+', '')
WHERE First REGEXP '[0-9]' OR Last REGEXP '[0-9]';


-- =======================================================
-- OBJECTIVE 1: ENCOUNTERS OVERVIEW
-- =======================================================

-- a. How many total encounters occurred each year?

SELECT 
YEAR(Start) AS 'Year',
COUNT(Id) AS 'Total Encounter'
FROM encounters
GROUP BY YEAR(Start)
ORDER BY YEAR(Start) ASC;

-- b. For each year, what percentage of all encounters belonged to each encounter class?

SELECT 
YEAR(Start) AS Year,EncounterClass,COUNT(Id) AS Class_Count,
CONCAT(ROUND(
COUNT(Id) * 100.0 / SUM(COUNT(Id)) OVER(PARTITION BY YEAR(Start)), 2), '%') AS 'Encounter Rate'
FROM encounters
GROUP BY YEAR(Start), EncounterClass
ORDER BY Year ASC, EncounterClass;

-- c. What percentage of encounters were over 24 hours versus under 24 hours?

SELECT 
CONCAT(ROUND(
SUM(CASE WHEN TIMESTAMPDIFF(HOUR, Start, Stop) < 24 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2), '%') AS 'Under 24 Hours',
CONCAT(ROUND(
SUM(CASE WHEN TIMESTAMPDIFF(HOUR, Start, Stop) >= 24 THEN 1 ELSE 0 END) 
/ COUNT(*) * 100, 
2), '%') AS 'Over 24 Hours'
FROM encounters;

-- =======================================================
-- OBJECTIVE 2: COST & COVERAGE INSIGHTS
-- =======================================================

-- a. How many encounters had zero payer coverage?
SELECT 
COUNT(Id) AS 'Total Zero Coverage',
CONCAT(ROUND(
COUNT(Id) / (SELECT COUNT(*) FROM encounters) * 100, 
2), '%') AS 'Zero Coverage Rate'
FROM encounters  
WHERE PAYER_COVERAGE = 0;

-- b. Top 10 most frequent procedures and average base cost?
SELECT 
DESCRIPTION,
COUNT(DESCRIPTION) AS 'Total Procedure',
ROUND(AVG(BASE_COST), 2) AS 'Average Base Cost'
FROM procedures
GROUP BY DESCRIPTION
ORDER BY COUNT(DESCRIPTION) DESC
LIMIT 10;

-- c. Top 10 procedures with the highest average base cost?

SELECT 
DESCRIPTION AS 'Procedure',
ROUND(AVG(BASE_COST), 2) AS Average_BaseCost,
COUNT(DESCRIPTION) AS 'Total Performed'
FROM procedures
GROUP BY DESCRIPTION
ORDER BY Average_BaseCost DESC
LIMIT 10;

-- d. Average total claim cost broken down by payer?

SELECT 
p.Name AS Payer_Name,
ROUND(AVG(e.TOTAL_CLAIM_COST), 2) AS 'Average Total Claim'
FROM encounters e
JOIN payers p ON e.Payer = p.Id
GROUP BY p.Name
ORDER BY AVG(e.TOTAL_CLAIM_COST) DESC;

-- =======================================================
-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS
-- =======================================================

-- a. How many unique patients were admitted each quarter over time?

SELECT 
YEAR(Start) AS 'Year',
CONCAT('Q', QUARTER(Start)) AS 'Quarter',
COUNT(DISTINCT PATIENT) AS 'Unique_Patients'
FROM encounters
GROUP BY YEAR(Start), CONCAT('Q', QUARTER(Start))
ORDER BY YEAR(Start) ASC;

-- b. How many patients were readmitted within 30 days?

SELECT 
COUNT(DISTINCT PATIENT) AS 'No. Unique Patients Readmitted < 30 days'
FROM (
SELECT patient,
DATEDIFF(start, LAG(date(start)) OVER(PARTITION BY patient ORDER BY date(start) ASC)) AS diff,
ENCOUNTERCLASS
FROM encounters 
) AS d
WHERE (diff BETWEEN 1 AND 30) 
AND ENCOUNTERCLASS = 'inpatient';


-- c. Which patients had the most readmissions?

SELECT 
CONCAT(p.Prefix, ' ', REGEXP_REPLACE(p.First, '[0-9]+', ''), ' ', REGEXP_REPLACE(p.Last, '[0-9]+', '')) AS Patient_Name,
COUNT(e.Id) - 1 AS Estimated_Readmissions
FROM patients p
JOIN encounters e ON p.Id = e.Patient
WHERE e.EncounterClass = 'inpatient'
GROUP BY p.Id
HAVING COUNT(e.Id) > 1 
ORDER BY Estimated_Readmissions DESC
LIMIT 10;



