
CREATE PROCEDURE [dbo].[AspNet_SqlCachePollingStoredProcedure] AS
         SELECT tableName, changeId FROM dbo.AspNet_SqlCacheTablesForChangeNotification
         RETURN 0





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AspNet_SqlCachePollingStoredProcedure] TO [rt_read]
    AS [dbo];

