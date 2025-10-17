CREATE PROCEDURE [dbo].[RemoveCachedObjectFromDb]
@LogKey varchar(max)=NULL

AS
DELETE FROM [AllAppLogs].[dbo].CacheLogs where LogKey=@LogKey
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[RemoveCachedObjectFromDb] TO [rt_read]
    AS [dbo];

