 CREATE PROC DisableClientById    
 @ClientId INT    
 AS    
 BEGIN UPDATE HotelApiClientsCompany SET Status=0 WHERE Id=@ClientId;    
 END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DisableClientById] TO [rt_read]
    AS [dbo];

