CREATE Procedure [ss].DeleteLatestSightSeeingCacheData          
@CacheKey varchar(200),  
@MethodName varchar(200)=null  
As          
Begin          
--Delete from [AllAppLogs].[dbo].HotelCacheData Where CacheKey=@CacheKey     
update [AllAppLogs].[SS].[SighseeingCacheData] Set CacheUpdateTime=GETDATE(),IsActive=0,MethodName='BookingProcess-FinalBooking' where CacheKey=@CacheKey and  IsActive=1   
      
End 