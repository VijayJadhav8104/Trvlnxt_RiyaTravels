
CREATE PROCEDURE [dbo].[AspNet_SqlCacheUpdateChangeIdStoredProcedure] 
             @tableName NVARCHAR(450) 
         AS

         BEGIN 
             UPDATE dbo.AspNet_SqlCacheTablesForChangeNotification WITH (ROWLOCK) SET changeId = changeId + 1 
             WHERE tableName = @tableName
         END
   





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AspNet_SqlCacheUpdateChangeIdStoredProcedure] TO [rt_read]
    AS [dbo];

