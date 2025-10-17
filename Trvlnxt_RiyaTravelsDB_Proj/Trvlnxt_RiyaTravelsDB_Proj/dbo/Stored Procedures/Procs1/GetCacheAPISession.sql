
CREATE PROCEDURE [dbo].[GetCacheAPISession]
	
	@SessionToken varchar(200)
	
AS
BEGIN
	
	select SessionData from [AllAppLogs].[dbo].CacheAPISession where SessionToken=@SessionToken;
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetCacheAPISession] TO [rt_read]
    AS [dbo];

