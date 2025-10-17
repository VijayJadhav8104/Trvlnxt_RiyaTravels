      
CREATE PROCEDURE UpdateClientResponseByCorrelationCLientRequest      
@MethodName VARCHAR(200),      
@CorrelationId VARCHAR(150),      
@Response VARCHAR(MAX),    
@CityName VARCHAR(100)=NULL,  
@token VARCHAR (150)=NULL    
AS      
BEGIN      
 DECLARE @ID int      
 SELECT TOP 1 @ID=ID FROM [AllAppLogs].[dbo].HotelApiLogs WHERE MethodName=@MethodName AND CorrelationId=@CorrelationId ORDER BY ID DESC      
      
 UPDATE [AllAppLogs].[dbo].HotelApiLogs SET Response=@Response,CityName=@CityName,Token=@token WHERE ID=@ID      
END      
      
--select methodname,CorrelationId,Response,Request from [AllAppLogs].[dbo].HotelApiLogs where methodname like '%client%' and CorrelationId='fcd2592db7660190c9ff635290b6c2654e08bedcf5a95789'      
--select top 1 ID from [AllAppLogs].[dbo].HotelApiLogs WHERE MethodName= 'Clientrequest-AvailabilityBlocking-GetAvailabilityBlocking' and CorrelationId='fcd2592db7660190c9ff635290b6c2654e08bedcf5a95789' order by id desc      
--select response from [AllAppLogs].[dbo].HotelApiLogs where Id=62563