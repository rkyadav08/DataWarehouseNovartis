USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DatabaseNovartis')
BEGIN
    ALTER DATABASE DatabaseNovartis SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DatabaseNovartis;
END;
GO

CREATE DATABASE DatabaseNovartis;
GO

USE DatabaseNovartis;
