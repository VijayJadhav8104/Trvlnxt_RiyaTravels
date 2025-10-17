
CREATE PROCEDURE [dbo].[DeleteCacheAPISession]
	
	@SessionToken varchar(200)
	
AS
BEGIN
	
	delete from [AllAppLogs].[dbo].CacheAPISession where SessionToken=@SessionToken;
	delete from [AllAppLogs].[dbo].CacheLogs where LogKey=@SessionToken;
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeleteCacheAPISession] TO [rt_read]
    AS [dbo];

