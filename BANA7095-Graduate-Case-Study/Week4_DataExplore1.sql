USE BANA7095
GO

--- 1. Check data with similarity between Test and Control groups

SELECT DISTINCT [GroupName], Product, [State]
FROM Control_Data
INTERSECT
SELECT DISTINCT [GroupName], Product, [State]
FROM Test_Data

--- 2. Create new table for the data mentioned above

SELECT *
INTO Control_Data_sub
FROM Control_Data -- 40436
WHERE CONCAT([GroupName], Product, [State]) IN (
        SELECT DISTINCT CONCAT([GroupName], Product, [State])
        FROM Control_Data
        INTERSECT
        SELECT DISTINCT CONCAT([GroupName], Product, [State])
        FROM Test_Data
        ) -- 33334

SELECT *
INTO Test_Data_sub
FROM Test_Data -- 384412
WHERE CONCAT([GroupName], Product, [State]) IN (
        SELECT DISTINCT CONCAT([GroupName], Product, [State])
        FROM Control_Data
        INTERSECT
        SELECT DISTINCT CONCAT([GroupName], Product, [State])
        FROM Test_Data
        ) -- 278762

--- 3. Summary data

;WITH X AS (
        SELECT Quote_Month,
                Quote_Year,
                COUNT(DISTINCT [User_ID]) Control_Agent_Count,
                SUM(Quote_Count) Control_Quote_Count,
                SUM(Issued_Count) Control_Issued_Count,
                CAST(SUM(Quote_Count) AS NUMERIC)/COUNT(DISTINCT [User_ID]) Control_QPA,
                CAST(SUM(Issued_Count) AS NUMERIC)/COUNT(DISTINCT [User_ID]) Control_IPA
        FROM Control_Data_sub
        GROUP BY Quote_Month, Quote_Year
        ),
Y AS (
        SELECT Quote_Month,
                Quote_Year,
                COUNT(DISTINCT [User_ID]) Test_Agent_Count,
                SUM(Quote_Count) Test_Quote_Count,
                SUM(Issued_Count) Test_Issued_Count,
                CAST(SUM(Quote_Count) AS NUMERIC)/COUNT(DISTINCT [User_ID]) Test_QPA,
                CAST(SUM(Issued_Count) AS NUMERIC)/COUNT(DISTINCT [User_ID]) Test_IPA
        FROM Test_Data_sub
        GROUP BY Quote_Month, Quote_Year
        )

SELECT X.Quote_Month,
        X.Quote_Year,
        Control_QPA,
        Control_IPA,
        Test_QPA,
        Test_IPA
FROM X
JOIN Y
        ON X.Quote_Month = Y.Quote_Month
                AND X.Quote_Year = Y.Quote_Year
ORDER BY X.Quote_Year,
        X.Quote_Month
