CREATE PROC DeleteGroupById    
@Id INT    
AS    
BEGIN    
 BEGIN TRAN    
    UPDATE HotelApiClients SET IsDeleted=1 WHERE Id=@Id;    
    UPDATE HotelApiClientsCompany SET Status=0 WHERE ClientId=@Id;    
    UPDATE HotelApiClientsIPs SET Status=0 WHERE ClientCompanyId IN(    
    SELECT Id FROM HotelApiClientsCompany WHERE ClientId=@Id)    
 COMMIT TRAN    
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeleteGroupById] TO [rt_read]
    AS [dbo];

