CREATE Procedure DeleteLatestCacheData        
@CacheKey varchar(200),
@MethodName varchar(200)=null
As        
Begin        
--Delete from [AllAppLogs].[dbo].HotelCacheData Where CacheKey=@CacheKey   
update [AllAppLogs].[dbo].HotelCacheData Set CacheUpdateTime=GETDATE(),IsActive=0,MethodName=@MethodName where CacheKey=@CacheKey and  IsActive=1 
    
End      