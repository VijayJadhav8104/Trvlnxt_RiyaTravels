CREATE PROC DisableGroupById    
@Id INT    
AS    
BEGIN    
 UPDATE HotelApiClients SET Status = CASE     
             WHEN Status=1 then 0     
             WHEN Status=0 then 1    
               END    
    where Id=@Id    
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DisableGroupById] TO [rt_read]
    AS [dbo];

