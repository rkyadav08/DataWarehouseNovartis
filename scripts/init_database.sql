USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseNovartis')
BEGIN
    ALTER DATABASE DataWarehouseNovartis SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseNovartis;
END;
GO

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
