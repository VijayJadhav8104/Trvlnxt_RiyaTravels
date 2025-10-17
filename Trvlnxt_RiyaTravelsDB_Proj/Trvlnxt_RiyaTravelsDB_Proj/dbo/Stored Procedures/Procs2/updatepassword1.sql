CREATE PROCEDURE updatepassword1 --'IN','B2B'  
@Id int,
@EncryptedPassword nvarchar(300)
AS  
BEGIN  

  update AgentLogin set EncryptedPassword=@EncryptedPassword where UserID=@Id
 
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[updatepassword1] TO [rt_read]
    AS [dbo];

