-- =============================================                
-- Author:  <Ketan Marade>                
-- Create date: <06-03-2023>                
-- Description: <Select Apis Logs>                
-- =============================================                
 CREATE Proc GetHotelApisLogs--'AvailabilityBlockingController','470159da-dc13-4561-ad50-906f2dcce09b'                 
 @MethodName varchar(200)='',                
 @token varchar(500)=''            
 AS                
 BEGIN                      
 Select top 1 ID,Token,Request, Response From [AllAppLogs].[dbo].hotelapilogs Where MethodName=@MethodName And Token=@token  
 
 order by ID desc
 END