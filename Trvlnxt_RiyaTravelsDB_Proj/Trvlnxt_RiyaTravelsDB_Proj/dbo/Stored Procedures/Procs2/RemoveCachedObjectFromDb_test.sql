create PROCEDURE [dbo].[RemoveCachedObjectFromDb_test]
@LogKey varchar(max)=NULL

AS
DELETE FROM cachelogs_test where LogKey=@LogKey
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[RemoveCachedObjectFromDb_test] TO [rt_read]
    AS [dbo];

