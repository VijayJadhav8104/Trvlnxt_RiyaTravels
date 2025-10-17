CREATE PROC UpdateGroupUserIP    
@IP VARCHAR(200),    
@Id INT    
AS    
BEGIN    
 UPDATE HotelApiClientsIPs SET IP=@IP WHERE Id=@Id;    
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateGroupUserIP] TO [rt_read]
    AS [dbo];

