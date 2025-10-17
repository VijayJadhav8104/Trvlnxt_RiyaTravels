-- =============================================                            
-- Author:  <Ketan Hiranandani>                            
-- Create date: <10-06-2024>        
-- Modified date: <14-06-2024>       
-- Modified Reason: Add HotelId condition too      
-- Description: <Get Price Check Logs before booking for static>                            
-- =============================================                            
 CREATE PROC GetMyPriceCheckCache                      
 @MethodName VARCHAR(200)='',                            
 @token VARCHAR(200)='',      
 @HotelId VARCHAR(100)=''      
 AS                           
 BEGIN        
         
 SELECT ID,Token,Request, Response,HotelID,ProviderID,ProviderHotelID,MethodName FROM [AllAppLogs].[dbo].hotelapilogs WITH (NOLOCK) WHERE MethodName=@MethodName And Token=@token AND HotelID=@HotelId ORDER BY ID DESC        
        
 END        
        
 --GetMyPriceCheckCache 'MyPriceCheck','ce12d685-12b1-4808-8521-c561b6f48e03','15339135'   
 --select hotelid,providerid,token from AllAppLogs.dbo.hotelapilogs with (nolock) where hotelid is not null and hotelid !='' order by InsertedDate desc