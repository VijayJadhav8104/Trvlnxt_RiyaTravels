-- =============================================            
-- Author:  <Ketan Marade>            
-- Create date: <06-03-2023>            
-- Description: <Select Apis Logs>            
-- =============================================            
 Create Proc [dbo].[GetHotelApisLogs]             
 @MethodName varchar(200)='',            
 @token varchar(500)=''        
 AS            
 BEGIN            				  
	Select Response From [AllAppLogs].[dbo].hotelapilogs Where MethodName=@MethodName And Token=@token        
 END
