USE BANA7095
GO

--- 0. Create Ref tables
CREATE TABLE Ref_Product (
        Product VARCHAR(20),
        Product_Type VARCHAR(20)
        )
GO

INSERT INTO Ref_Product
VALUES
('BOAT', 'Watercraft'),
('Collector Vehicle', 'Collector Vehicle'),
('CV', 'Collector Vehicle'),
('DWELLING FIRE', 'Site Built'),
('EARTHQUAKE', 'Site Built'),
('HOMEOWNER 4', 'Site Built'),
('HOMEOWNERS', 'Site Built'),
('JET SKI', 'Watercraft'),
('Manufactured Housing', 'Manufactured Home'),
('MOBILE HOME', 'Manufactured Home'),
('MOTORCYCLE', 'Motorsports'),
('Motorsports', 'Motorsports'),
('Renters', 'Renters'),
('Site Built Dwelling', 'Site Built'),
('Watercraft', 'Watercraft')

--- 1. Get clean data
-- 1.1. Create new master table
CREATE TABLE Isrn_Master (
        [System] VARCHAR(10),
        Mkt_Channel VARCHAR(20),
        GroupName VARCHAR(20),
        Product VARCHAR(20),
        [State] CHAR(2),
        Quote_Month INT,
        Quote_Year INT,
        Quote_Count INT,
        Issued_Count INT,
        [User_ID] VARCHAR(30)
        )
GO

-- 1.2. Insert Cleaned data to the newly created master table
INSERT INTO Isrn_Master
SELECT *
FROM Insurance_Master
WHERE Product IS NOT NULL
        AND Product <> 'Not Known'
        AND Product <> 'Missing short text:'
        AND [Year (Quote Create Date)] <> '9000'
        AND [Blend Managing Group Name] <> 'TEST'

-- 1.3. Add new infor to the master table
ALTER TABLE Isrn_Master
ADD Dist_Channel VARCHAR(30)

UPDATE IM
SET Dist_Channel = RC. Dist_Channel
FROM Isrn_Master IM
JOIN Ref_Channel RC
        ON IM.Mkt_Channel = RC.Mkt_Channel

ALTER TABLE Isrn_Master
ADD Product_Type VARCHAR(20)

UPDATE IM
SET Product_Type = RP.Product_Type
FROM Isrn_Master IM
JOIN Ref_Product RP
        ON IM.Product = RP.Product

-- 1.4. Divide data into groups
SELECT *
INTO Control_Data
FROM Isrn_Master
WHERE [User_ID] IN (SELECT [User_ID] FROM Control_Group)

SELECT *
INTO Test_Data
FROM Isrn_Master
WHERE NOT([User_ID] IN (SELECT [User_ID] FROM Control_Group))
        AND GroupName IN (SELECT GroupName FROM Test_Managing_Group_List)
        AND [State] IN (SELECT [State] FROM Test_State_List)

SELECT *
INTO Other_Data
FROM Isrn_Master
WHERE NOT([User_ID] IN (SELECT [User_ID] FROM Control_Group))
        AND (NOT(GroupName IN (SELECT GroupName FROM Test_Managing_Group_List))
                OR NOT([State] IN (SELECT [State] FROM Test_State_List)))
