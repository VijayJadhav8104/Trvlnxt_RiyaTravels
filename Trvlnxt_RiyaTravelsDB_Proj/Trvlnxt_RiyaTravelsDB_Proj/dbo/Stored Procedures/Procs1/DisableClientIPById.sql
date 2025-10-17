CREATE PROC DisableClientIPById    
 @IPId INT    
 AS    
 BEGIN UPDATE hotelApiClientsIPs SET Status=0 WHERE Id=@IPId;    
 END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DisableClientIPById] TO [rt_read]
    AS [dbo];

