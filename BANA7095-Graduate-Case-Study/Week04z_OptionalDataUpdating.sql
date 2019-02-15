--- 1. Create Ref table

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

--- 2. Update info from Ref table and delete inconsistent data

DECLARE @T8BLE TABLE (Table_Name VARCHAR(20))

INSERT INTO @T8BLE
VALUES
('Control_Data'),
('Control_Data_sub'),
('Test_Data'),
('Test_Data_sub'),
('Other_Data'),
('Isrn_Master')

DECLARE @N4ME VARCHAR(20)

DECLARE TB_C CURSOR FOR
SELECT Table_name FROM @T8BLE

OPEN TB_C
FETCH NEXT FROM TB_C INTO @N4ME

WHILE @@FETCH_STATUS = 0
BEGIN
        EXEC('ALTER TABLE ' + @N4ME + '
                ADD Product_Type VARCHAR(20)')

        EXEC('UPDATE TB
                SET Product_Type = RP.Product_Type
                FROM ' + @N4ME + ' TB
                JOIN Ref_Product RP
                        ON TB.Product = RP.Product')

        IF @N4ME LIKE 'Control%'
                EXEC('DELETE FROM ' + @N4ME + '
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
                                )
                        ')

        FETCH NEXT FROM TB_C INTO @N4ME
END

CLOSE TB_C
DEALLOCATE TB_C
