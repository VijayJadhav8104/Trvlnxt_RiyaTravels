CREATE PROC AddGroupUser  
@ClientId INT,  
@CompanyName VARCHAR(200),  
@CompanyUsername VARCHAR(200),  
@CompanyPassword NVARCHAR(200),  
@ClientNumber NVARCHAR(200),  
@CreatedBy INT  
AS  
BEGIN  
 INSERT INTO HotelApiClientsCompany(ClientId,CompanyName,CompanyUsername,CompanyPassword,CreatedBy,CreatedDate,Status,ClientNumber)  
 VALUES(@ClientId,@CompanyName,@CompanyUsername,@CompanyPassword,@CreatedBy,GETDATE(),1,@ClientNumber);  
 SELECT SCOPE_IDENTITY();  
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AddGroupUser] TO [rt_read]
    AS [dbo];

