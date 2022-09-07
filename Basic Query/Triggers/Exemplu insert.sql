USE [Northwind]
GO

DELETE FROM [App_time_spending]

INSERT INTO [dbo].[App_time_spending]
           ([Phone_number]
           ,[Phone_brand]
           ,[Phone_model]
           ,[App_name]
           ,[Time_min])
     VALUES
			('1234567891', 'Iph', 'XR', 'Facebook', 10),
			('1234567891', 'Iph', 'XR', 'Facebook', 20),
			('1234567890', 'Iph', 'XR', 'Facebook', 30),
			('1234567890', 'Iph', 'XR', 'Instagram', 10),
			('1234567890', 'Iph', 'XR', 'Instagram', 20)