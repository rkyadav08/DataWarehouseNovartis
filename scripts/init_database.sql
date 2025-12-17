USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseNovartis')
BEGIN
    ALTER DATABASE DataWarehouseNovartis SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseNovartis;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouseNovartis;
GO

USE DataWarehouseNovartis;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
