  
-- ===================================================================================================  
-- Author:  Amruta P  
-- Create date: 12 JUN 2023  
-- Description: Insert data for indigo into temp_indigo_coupon_details table  
-- ===================================================================================================  
  
CREATE PROCEDURE [dbo].[USP_AddIndigoCoupoStatus]  
 @coupon_status varchar(100),  
 @pnr varchar(100),  
 @officeid varchar(100) 
 ,@segmentName varchar(100) 
 ,@passanger_name varchar(max) 
   
AS  
BEGIN  
INSERT INTO [dbo].[temp_indigo_coupon_details]  
           ([pnr]  
           ,[officeid]  
           ,[coupon_status]
		   ,[segmentName]
		   ,[passanger_name],
		   [createdDateTime])
     VALUES  
           (@pnr,@officeid,@coupon_status,@segmentName,@passanger_name,SYSDATETIME())  
  
  
END