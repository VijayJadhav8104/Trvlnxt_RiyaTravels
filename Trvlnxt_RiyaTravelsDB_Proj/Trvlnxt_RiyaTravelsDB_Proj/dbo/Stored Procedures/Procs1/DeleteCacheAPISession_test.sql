
CREATE PROCEDURE [dbo].[DeleteCacheAPISession_test]
	
	@SessionToken varchar(200)
	
AS
BEGIN
	
	delete from [AllAppLogs].[dbo].CacheAPISession where SessionToken=@SessionToken;
	delete from [AllAppLogs].[dbo].cachelogs_test where LogKey=@SessionToken;
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeleteCacheAPISession_test] TO [rt_read]
    AS [dbo];

