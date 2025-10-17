
CREATE PROCEDURE [dbo].[AspNet_SqlCacheQueryRegisteredTablesStoredProcedure] 
         AS
         SELECT tableName FROM dbo.AspNet_SqlCacheTablesForChangeNotification   





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AspNet_SqlCacheQueryRegisteredTablesStoredProcedure] TO [rt_read]
    AS [dbo];

