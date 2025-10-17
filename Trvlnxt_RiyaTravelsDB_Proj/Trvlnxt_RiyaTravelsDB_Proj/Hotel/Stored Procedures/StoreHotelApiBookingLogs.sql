-- =============================================                  
-- Author:  <Akash Singh>                  
-- Create date: <17-11-2022>                  
-- Description: <Insert Hotel Booking Apis Logs>                  
-- =============================================                  
 CREATE Proc [hotel].StoreHotelApiBookingLogs                   
 @URL varchar(200)='',                  
 @Request varchar(max)='',                  
 @Response varchar(max)='',                   
 @Header varchar(max)='',                  
 @MethodName varchar(max)='',                
 @CorrelationId varchar(max)='',              
 @AgentId varchar(200)='',           
 @BookingId varchar(100)='',        
 @Timmer varchar(max)='',      
 @IP varchar(100)='' ,  
 @token varchar(500)='',
 @BookingPortal varchar(50)=''
 AS                  
 BEGIN                  
                      
    insert into [AllAppLogs].[Hotel].[HotelApiBookingLogs](URL,Request,Response,Header,InsertedDate,CorrelationId,AgentId,BookingId,Timmer,IP,Token,BookingPortal)                   
                      values  (@URL,@Request,@Response,@Header,GetDate(),@CorrelationId,@AgentId,@BookingId,@Timmer,@IP,@token,@BookingPortal)                  
              
  END 