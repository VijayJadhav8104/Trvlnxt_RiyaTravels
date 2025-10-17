      
create PROCEDURE [dbo].[GetCacheLogFromDb_test]      
      
@LogKey varchar(300),  
@cacheflag int =0  
AS       
      
begin      
      
      
--select LogData from CacheLogs(nolock) where LogKey=@LogKey;      
      
  if(@cacheflag=1)  
  begin  
  select LogData from cachelogs_test(nolock) where LogKey=@LogKey;      
  end  
  else  
  begin  
  select LogData from cachelogs_test(nolock) where LogKey='1';   
  end  
  
end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetCacheLogFromDb_test] TO [rt_read]
    AS [dbo];

