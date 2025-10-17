CREATE PROC UpdateGroupUser    
@CompanyName VARCHAR(200),    
@CompanyUsername VARCHAR(200),    
@CompanyPassword NVARCHAR(200),    
@ClientNumber NVARCHAR(200),    
@Id INT    
AS    
BEGIN    
 UPDATE HotelApiClientsCompany SET CompanyName=@CompanyName,CompanyUsername=@CompanyUsername,CompanyPassword=@CompanyPassword,ClientNumber=@ClientNumber    
 WHERE Id=@Id;    
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateGroupUser] TO [rt_read]
    AS [dbo];

