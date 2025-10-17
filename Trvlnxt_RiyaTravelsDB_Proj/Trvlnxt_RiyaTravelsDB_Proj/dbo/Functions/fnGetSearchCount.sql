CREATE FUNCTION [dbo].[fnGetSearchCount]   
(     
    @Day int  
)  
  
RETURNS  int  
AS  
BEGIN  
   DECLARE @Count int  
   SELECt @Count=count(distinct CorrelationId) from allapplogs.dbo.hotelapilogs with (nolock) where InsertedDate between '2024-01-01 00:00:00.000' and '2024-12-31 23:59:59.287'
   and MethodName ='AvailabilityBlockingController' and BookingPortal='TNHAPI' and DAY(InsertedDate)=@Day  
  
    return @Count  
END  
  