

CREATE PROCEDURE [dbo].[sp_UpdatePassword]
	@UserName  varchar(500),
	@Password  varchar(300)
AS
BEGIN
	UPDATE UserLogin 
	SET Password=@Password
	Where UserName=@UserName

	SELECT 1;
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UpdatePassword] TO [rt_read]
    AS [dbo];

