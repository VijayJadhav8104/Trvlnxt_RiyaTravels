CREATE PROC AddGroupUserIP    
@ClientCompanyId INT,    
@IP VARCHAR(200),    
@CreatedBy INT    
AS    
BEGIN    
 INSERT INTO HotelApiClientsIPs(ClientCompanyId,IP,CreatedBy,CreatedDate,Status)    
 VALUES(@ClientCompanyId,@IP,@CreatedBy,GETDATE(),1);    
 SELECT SCOPE_IDENTITY();    
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AddGroupUserIP] TO [rt_read]
    AS [dbo];

