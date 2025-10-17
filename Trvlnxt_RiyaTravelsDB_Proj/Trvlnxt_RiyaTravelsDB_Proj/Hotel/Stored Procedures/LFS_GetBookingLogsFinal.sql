     
-- =============================================      
-- Author:  Akash Singh      
-- Create date: 16 Jan 2025      
-- Description: TO get the perticuler booking logs by correlation id.      
-- EXEC [Hotel].LFS_GetBookingLogsFinal '764acc3b-c05c-47e0-9f91-8e2a3351ba97638748019546168238-HR5FWNA1QLLVGGHFBIGD30OC','41565321'   
-- =============================================      
CREATE PROCEDURE [Hotel].LFS_GetBookingLogsFinal      
 -- Add the parameters for the stored procedure here      
 @CorrelationId varchar(100)=null,  
 @HotelID varchar(50)=null  
AS      
BEGIN      
    
   select  top 1 Request,Response,Header,'AvailabilityClient' as 'LogType' from [AllAppLogs].dbo.HotelApiLogs       
   where CorrelationId=@CorrelationId      
   and MethodName='Clientrequest-AvailabilityBlocking-GetAvailabilityBlocking'  order by id desc    
      
   
   select top 1 Request,Response,Header,'AvailabilityBlocking' as 'LogType' from [AllAppLogs].dbo.HotelApiLogs       
   where CorrelationId=@CorrelationId      
   and MethodName='AvailabilityBlockingController'    
   order by id desc    
       
   select top 1 Request,Response,Header,'RoomsAndRatesClient' as 'LogType' from [AllAppLogs].dbo.HotelApiLogs       
   where CorrelationId=@CorrelationId      
   and MethodName='Clientrequest-RoomsAndRates-GetRoomsAndRates'   
   and Request like '%'+@HotelID+'%'   
   order by id desc    
       
   select top 1 Request,Response,Header,'RoomsAndRates' as 'LogType' from [AllAppLogs].dbo.HotelApiLogs       
   where CorrelationId=@CorrelationId     
   and MethodName='RoomsAndRatesController'     
   and URL like  '%'+@HotelID+'%'   
   order by id desc    
      
   select top 1 Request,Response,Header,'PriceCheckClient' as 'LogType' from [AllAppLogs].dbo.HotelApiLogs       
   where CorrelationId=@CorrelationId      
   and MethodName='Clientrequest-PriceCheck-GetPriceCheck' order by id desc     
      
   select top 1 Request,Response,Header,'PriceCheck' as 'LogType' from [AllAppLogs].dbo.HotelApiLogs       
   where CorrelationId=@CorrelationId      
   and MethodName='PriceCheckController'    
   order by id desc    
      
   select top 1 Request,Response,Header,'HotelBookingClient' as 'LogType' from [AllAppLogs].dbo.HotelApiLogs       
   where CorrelationId=@CorrelationId      
   and MethodName='Clientrequest-HotelBooking-HotelBooking'     
   order by id desc    
       
   select top 1 Request,Response,Header,'HotelBooking' as 'LogType' from [AllAppLogs].hotel.HotelApiBookingLogs       
   where CorrelationId=@CorrelationId    
   order by id desc    
      
END 