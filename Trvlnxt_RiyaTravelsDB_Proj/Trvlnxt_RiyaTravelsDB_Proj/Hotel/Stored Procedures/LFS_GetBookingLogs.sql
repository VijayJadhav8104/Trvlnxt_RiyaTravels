  
-- =============================================  
-- Author:  Akash Singh  
-- Create date: 16 Jan 2025  
-- Description: TO get the perticuler booking logs by correlation id.  
-- =============================================  
CREATE PROCEDURE [Hotel].LFS_GetBookingLogs  
 -- Add the parameters for the stored procedure here  
 @CorrelationId varchar(100)=null  
AS  
BEGIN  
   
   
   select  top 1 Request,Response,Header,'AvailabilityClient' as 'LogType' from [AllAppLogs].dbo.HotelApiLogs   
 where CorrelationId=@CorrelationId  
 and MethodName='Clientrequest-AvailabilityBlocking-GetAvailabilityBlocking'  
  
   UNION ALL   
  
   select top 1 Request,Response,Header,'AvailabilityBlocking' as 'LogType' from [AllAppLogs].dbo.HotelApiLogs   
 where CorrelationId=@CorrelationId  
 and MethodName='AvailabilityBlockingController'  
  
   UNION ALL  
  
   select top 1 Request,Response,Header,'RoomsAndRatesClient' as 'LogType' from [AllAppLogs].dbo.HotelApiLogs   
 where CorrelationId=@CorrelationId  
 and MethodName='Clientrequest-RoomsAndRates-GetRoomsAndRates'  
  
   UNION ALL  
  
   select top 1 Request,Response,Header,'RoomsAndRates' as 'LogType' from [AllAppLogs].dbo.HotelApiLogs   
 where CorrelationId=@CorrelationId  
 and MethodName='RoomsAndRatesController'  
  
   UNION ALL  
  
   select top 1 Request,Response,Header,'PriceCheckClient' as 'LogType' from [AllAppLogs].dbo.HotelApiLogs   
 where CorrelationId=@CorrelationId  
 and MethodName='Clientrequest-PriceCheck-GetPriceCheck'  
  
   Union ALL  
  
   select top 1 Request,Response,Header,'PriceCheck' as 'LogType' from [AllAppLogs].dbo.HotelApiLogs   
 where CorrelationId=@CorrelationId  
 and MethodName='PriceCheckController'  
  
   UNION ALL  
  
 select top 1 Request,Response,Header,'HotelBookingClient' as 'LogType' from [AllAppLogs].dbo.HotelApiLogs   
 where CorrelationId=@CorrelationId  
 and MethodName='Clientrequest-HotelBooking-HotelBooking'  
  
 Union ALL  
  
 select top 1 Request,Response,Header,'HotelBooking' as 'LogType' from [AllAppLogs].hotel.HotelApiBookingLogs   
 where CorrelationId=@CorrelationId  
  
END  