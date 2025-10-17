    
CREATE PROCEDURE [dbo].[GetCacheLogFromDb]    
    
@LogKey varchar(300),
@cacheflag int =0
AS     
    
begin    
    
    
--select LogData from CacheLogs(nolock) where LogKey=@LogKey;    
    
	 if(@cacheflag=1)
	 begin
	 select LogData from [AllAppLogs].[dbo].CacheLogs(nolock) where LogKey=@LogKey;    
	 end
	 else
	 begin
	 select LogData from [AllAppLogs].[dbo].CacheLogs(nolock) where LogKey='1'; 
	 end

end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetCacheLogFromDb] TO [rt_read]
    AS [dbo];

