USE [Northwind]

DROP TABLE IF EXISTS [dbo].[User_data], [dbo].[App_data], [dbo].[App_time_spending];

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[User_data](
	[Phone_number] [nvarchar](10) NOT NULL,
	[Phone_brand] [nvarchar](30) NOT NULL,
	[Phone_model] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_User_data] PRIMARY KEY CLUSTERED 
(
	[Phone_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[App_data](
	[App_name] [nvarchar](50) NOT NULL,
	[Time_min] [int] NOT NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[App_time_spending](
	[Phone_number] [nvarchar](10) NOT NULL,
	[Phone_brand] [nvarchar](30) NOT NULL,
	[Phone_model] [nvarchar](20) NOT NULL,
	[App_name] [nvarchar](50) NOT NULL,
	[Time_min] [int] NOT NULL
) ON [PRIMARY]
GO

CREATE OR ALTER TRIGGER time_spend_app
ON App_time_spending
AFTER INSERT

AS
BEGIN
-- SQL Server doesn't have for each row and we use cursor
	DECLARE update_cursor CURSOR
		FOR
		SELECT * FROM INSERTED;

-- Declare variables
	DECLARE @App_name VARCHAR(50), @Time_min int, @Phone_number VARCHAR(10), @Phone_brand VARCHAR(30), @Phone_model VARCHAR(20), @Phone_nr_exist VARCHAR(10);

-- Open cursor
	OPEN update_cursor;
	
-- Fetch first cursor
	FETCH NEXT FROM update_cursor INTO @Phone_number, @Phone_brand, @Phone_model, @App_name, @Time_min;
	
-- Check if cursor got value
	WHILE @@FETCH_STATUS = 0
		BEGIN

-- Update the usage time in App_data table
			UPDATE [App_data]
			SET [App_data].[Time_min] = [App_data].[Time_min] + @Time_min
			WHERE [App_name] = @App_name;

-- Check if Phone_number exists, if not, insert
			SELECT @Phone_nr_exist = (SELECT count(*) FROM User_data WHERE Phone_number = @Phone_number);
			IF @Phone_nr_exist = 0
			BEGIN
				INSERT INTO [User_data]
				VALUES (@Phone_Number, @Phone_brand, @Phone_model);
			END

			FETCH NEXT FROM update_cursor INTO @Phone_number, @Phone_brand, @Phone_model, @App_name, @Time_min;
		END

	CLOSE update_cursor;
END


CREATE OR ALTER TRIGGER test
ON App_time_spending
AFTER UPDATE

AS

BEGIN

-- test usage of inserted and deleted table during BEFORE/AFTER UPDATE TRIGGERS
DECLARE update_cursor CURSOR
		FOR
		SELECT * FROM INSERTED;

	DECLARE @App_name VARCHAR(50), @Time_min int, @Phone_number VARCHAR(10), @Phone_brand VARCHAR(30), @Phone_model VARCHAR(20);

	OPEN update_cursor;
	FETCH NEXT FROM update_cursor INTO @Phone_number, @Phone_brand, @Phone_model, @App_name, @Time_min;
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT @Phone_model;



			FETCH NEXT FROM update_cursor INTO @Phone_number, @Phone_brand, @Phone_model, @App_name, @Time_min;
		END

	CLOSE update_cursor;

	DECLARE update_cursor2 CURSOR
		FOR
		SELECT * FROM DELETED;

	OPEN update_cursor2;
	FETCH NEXT FROM update_cursor2 INTO @Phone_number, @Phone_brand, @Phone_model, @App_name, @Time_min;
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT @Phone_model;



			FETCH NEXT FROM update_cursor2 INTO @Phone_number, @Phone_brand, @Phone_model, @App_name, @Time_min;
		END

	CLOSE update_cursor2;
END