USE BANA7095
GO

--- 1. Examine email data

SELECT COUNT(1), -- 339255
        COUNT(DISTINCT [Email Address]), -- 219301
        COUNT(DISTINCT [User Id]) -- 326572
FROM Mail_info

SELECT COUNT(1), -- 72964
        COUNT(DISTINCT [Email Address]), -- 61425
        COUNT(DISTINCT [User Id]) -- 68112
FROM Mail_info
WHERE [User Id] IN (
        SELECT DISTINCT [User_ID]
        FROM Isrn_Master
        )

--- 2. Report conflicting data
-- 2.1. List of User_ID having email both in and out of Control list
                        
CREATE INDEX IDX_EMAIL
ON Control_Group([User Email])

CREATE INDEX IDX_EMAIL
ON Mail_info([Email Address])
GO

SELECT *,
        CASE WHEN [Email Address] IN (SELECT DISTINCT [User Email] FROM Control_Group) THEN 'Yes'
        ELSE 'No'
        END AS [In Control list]
FROM Mail_info
WHERE [User Id] IN (
        SELECT DISTINCT [User_ID]
        FROM Control_Group
        INTERSECT
        SELECT DISTINCT [User Id]
        FROM Mail_info
        WHERE [Email Address] NOT IN (SELECT DISTINCT [User Email] FROM Control_Group)
        )
ORDER BY [User Id]

-- 2.2. Quote data with User_ID in the list above

SELECT *
FROM Isrn_Master
WHERE [User_ID] IN (
        SELECT DISTINCT [User_ID]
        FROM Control_Group
        INTERSECT
        SELECT DISTINCT [User Id]
        FROM Mail_info
        WHERE [Email Address] NOT IN (
                SELECT DISTINCT [User Email]
                FROM Control_Group
                )
        ) -- 420
ORDER BY Quote_Year, Quote_Month, [User_ID] -- 2372
