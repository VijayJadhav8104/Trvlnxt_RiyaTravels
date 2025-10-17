-- =============================================                      
-- Author:  Akash                     
-- Create date: <12-May-2025>                      
-- Description: <Select Room Rates Client API Apis Logs>      
--  'Clientrequest-RoomsAndRates-GetRoomsAndRates','7619382b-ae27-40e6-b9d0-de01eda56cca','15076695'  
-- =============================================                      
 CREATE Proc  Hotel.GetHotelApisLogsByHotelId --'AvailabilityBlockingController','470159da-dc13-4561-ad50-906f2dcce09b'                       
 @MethodName varchar(200)='',                      
 @token varchar(500)='',  
 @HotelId varchar=''  
 AS                      
 BEGIN                            
 Select top 1 ID,Token,Request, Response From [AllAppLogs].[dbo].hotelapilogs with(nolock)   
 Where MethodName=@MethodName And   
       Token=@token and  
    Request like '%'+@HotelId+'%'  
       
 order by ID desc      
 END