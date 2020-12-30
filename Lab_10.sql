USE master
GO

IF EXISTS(SELECT * FROM sys.databases WHERE NAME = 'test')
	DROP DATABASE test
GO

CREATE DATABASE test
GO

USE test
GO

CREATE TABLE Toys (
	ProductCode varchar(5),
	Name varchar(30),
	Category varchar(30),
	Manufacturer varchar(40),
	AgeRange varchar(15),
	UnitPrice money,
	NetWeight int,
	QtyOnHand int
	CONSTRAINT PK_ProductCode PRIMARY KEY (ProductCode)
)
GO

INSERT INTO Toys VALUES
	(1,'A','Nhom 3+','ABC','3+',1000000,508,25),
	(2,'B','Nhom 5+','ABC','5+',2000000,206,43),
	(3,'C','Nhom 18+','ABC','18+',4000000,560,46),
	(4,'E','Nhom 5+','ABC','5+',3000000,440,32),
	(5,'B','Nhom 18+','ABC','18+',5000000,100,76),
	(6,'G','Nhom 5+','ABC','5+',9000000,630,24),
	(7,'H','Nhom 10+','ABC','10+',5000000,170,65),
	(8,'I','Nhom 5+','ABC','5+',7000000,207,32),
	(9,'J','Nhom 3+','ABC','3+',3000000,404,25),
	(10,'K','Nhom 20+','ABC','20+',6000000,280,45),
	(11,'L','Nhom 5+','ABC','5+',2000000,430,23),
	(12,'M','Nhom 5+','ABC','5+',7000000,950,21),
	(13,'N','Nhom 18+','ABC','18+',9000000,130,55),
	(14,'O','Nhom 5+','ABC','5+',3000000,380,27),
	(15,'P','Nhom 3+','ABC','3+',6000000,260,56)
GO

CREATE PROCEDURE sp_HeavyToys
	@Weight int
AS
	SELECT * FROM Toys WHERE NetWeight >= @Weight
GO

EXEC sp_HeavyToys 500
GO

CREATE PROCEDURE sp_PriceIncrease
	@Increase money
AS
	UPDATE Toys SET UnitPrice+=@Increase
GO

EXEC sp_PriceIncrease 10
GO

CREATE PROCEDURE sp_QtyOnHand
	@qty int
AS
	UPDATE Toys SET QtyOnHand+=@qty
GO

EXEC sp_QtyOnHand -5
GO
SELECT * FROM Toys
GO

EXEC sp_helptext 'sp_HeavyToys'
SELECT * FROM sys.sql_modules
SELECT OBJECT_DEFINITION(OBJECT_ID('sp_HeavyToys'))
GO

EXEC sp_depends 'sp_HeavyToys'
EXEC sp_depends 'sp_PriceIncrease'
EXEC sp_depends 'sp_QtyOnHand'
GO

ALTER PROC sp_PriceIncrease
	@Increase money
AS
	BEGIN
		UPDATE Toys SET UnitPrice+=@Increase
		EXEC sp_PriceIncrease 10
		SELECT * FROM Toys
	END
GO

ALTER PROC sp_PriceIncrease
	@Increase money
AS
	BEGIN
		UPDATE Toys SET UnitPrice+=@Increase
		SELECT * FROM Toys
	END
GO

ALTER PROC sp_QtyOnHand
	@qty int
AS
	BEGIN
		UPDATE Toys SET QtyOnHand+=@qty
		SELECT * FROM Toys
	END
GO

CREATE PROCEDURE sp_SpecificPriceIncrease
AS
	BEGIN
		UPDATE Toys SET UnitPrice += QtyOnHand
		SELECT * FROM Toys
	END
GO

ALTER PROCEDURE sp_SpecificPriceIncrease
AS
	BEGIN
		UPDATE Toys SET UnitPrice += QtyOnHand
		SELECT COUNT(UnitPrice) AS AffectedColumn FROM Toys
	END
GO

ALTER PROCEDURE sp_SpecificPriceIncrease
AS
	BEGIN
		UPDATE Toys SET UnitPrice += QtyOnHand
		SELECT COUNT(UnitPrice) AS AffectedColumn FROM Toys
		EXEC sp_HeavyToys
	END
GO

ALTER PROCEDURE sp_HeavyToys
	@Weight int
AS
	BEGIN TRY
		SELECT * FROM Toys WHERE NetWeight >= @Weight
	END TRY
	BEGIN CATCH
		PRINT 'Error in processing the procedure!!'
	END CATCH
GO

ALTER PROCEDURE sp_PriceIncrease
	@Increase money
AS
	BEGIN TRY
		UPDATE Toys SET UnitPrice+=@Increase
		SELECT * FROM Toys	
	END TRY
	BEGIN CATCH
		PRINT 'Error in processing the procedure!!'
	END CATCH
GO

ALTER PROCEDURE sp_QtyOnHand
	@qty int
AS
	BEGIN TRY
		UPDATE Toys SET QtyOnHand+=@qty
		SELECT * FROM Toys
	END TRY
	BEGIN CATCH
		PRINT 'Error in processing the procedure!!'
	END CATCH
GO

ALTER PROCEDURE sp_SpecificPriceIncrease
AS
	BEGIN TRY
		UPDATE Toys SET UnitPrice += QtyOnHand
		SELECT COUNT(UnitPrice) AS AffectedColumn FROM Toys
		EXEC sp_HeavyToys
	END TRY
	BEGIN CATCH
		PRINT 'Error in processing the procedure!!'
	END CATCH
GO


DROP PROCEDURE sp_HeavyToys
DROP PROCEDURE sp_PriceIncrease
DROP PROCEDURE sp_QtyOnHand
DROP PROCEDURE sp_SpecificPriceIncrease
GO
