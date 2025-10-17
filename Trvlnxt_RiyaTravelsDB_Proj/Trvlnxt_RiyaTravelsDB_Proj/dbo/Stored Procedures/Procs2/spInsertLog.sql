   CREATE proc spInsertLog (   @Title varchar(max),   @Detail Varchar(max)  )  
   As  Begin  
   select 1  END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertLog] TO [rt_read]
    AS [dbo];

