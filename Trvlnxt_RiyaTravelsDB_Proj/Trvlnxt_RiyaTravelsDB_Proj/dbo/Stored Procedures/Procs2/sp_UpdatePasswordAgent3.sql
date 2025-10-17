CREATE PROCEDURE [dbo].[sp_UpdatePasswordAgent3]
    @EmailID  varchar(500),
	@UserName  varchar(500),
	@Password  varchar(300)
AS
BEGIN
	UPDATE mUser 
	SET Password=@Password
	Where EmailID=@EmailID and UserName=@UserName

	SELECT 1;
END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UpdatePasswordAgent3] TO [rt_read]
    AS [dbo];

