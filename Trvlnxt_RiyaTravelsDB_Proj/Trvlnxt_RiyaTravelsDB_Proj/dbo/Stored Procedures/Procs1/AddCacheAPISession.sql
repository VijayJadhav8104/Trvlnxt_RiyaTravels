
CREATE PROCEDURE [dbo].[AddCacheAPISession]
	
	@SessionToken varchar(200),
	@SessionData varchar(max)
AS
BEGIN

if exists (select Id from [AllAppLogs].[dbo].CacheAPISession with (updlock,serializable) where SessionToken = @SessionToken)    
begin    
   update [AllAppLogs].[dbo].CacheAPISession  set SessionData=@SessionData, UpdatedDate=Getdate()   
   where SessionToken = @SessionToken    
end    
else    
begin 
	
	INSERT INTO [AllAppLogs].[dbo].CacheAPISession(SessionToken,SessionData) values(@SessionToken,@SessionData);

end
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AddCacheAPISession] TO [rt_read]
    AS [dbo];

