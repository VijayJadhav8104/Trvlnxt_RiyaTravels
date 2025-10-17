CREATE Procedure Proc_SetCacheData              
@CacheKey varchar(200),              
@CacheData varchar(MAX),     
@MethodName varchar(200)=null    
As              
Begin              
          
if Exists(Select id from [AllAppLogs].[dbo].HotelCacheData Where CacheKey=@CacheKey and IsActive=1)          
Begin          
          
          
update [AllAppLogs].[dbo].HotelCacheData Set CacheData=@CacheData, CacheUpdateTime=GETDATE(),IsActive=1,MethodName=@MethodName where CacheKey=@CacheKey          
            
End          
          
Else          
          
Begin          
insert into [AllAppLogs].[dbo].HotelCacheData(CacheKey,CacheData,CacheTime,IsActive,MethodName)              
Values(@CacheKey,@CacheData,DATEADD(minute,30,GETDATE()),1,@MethodName)             
          
End          
End 