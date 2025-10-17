CREATE PROCEDURE [dbo].[sp_UpdatePasswordAgent]
	@UserName  varchar(500),
	@Password  varchar(300)
AS
BEGIN
	UPDATE AgentLogin 
	SET Password=@Password
	Where UserName=@UserName

	SELECT 1;
END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UpdatePasswordAgent] TO [rt_read]
    AS [dbo];

