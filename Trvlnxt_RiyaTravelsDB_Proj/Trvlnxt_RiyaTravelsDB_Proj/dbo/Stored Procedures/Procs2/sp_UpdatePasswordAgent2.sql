CREATE PROCEDURE [dbo].[sp_UpdatePasswordAgent2]
	@UserName  varchar(500),
	@Password  varchar(300)
AS
BEGIN
   	IF(EXISTS(SELECT * FROM mUser WHERE EmailID=@UserName)) 
	UPDATE mUser 
	SET Password=@Password
	Where EmailID=@UserName
   else IF(EXISTS(SELECT * FROM agentLogin WHERE UserName=@UserName))
   UPDATE agentLogin 
	SET Password=@Password
	Where UserName=@UserName
	SELECT 1;
END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UpdatePasswordAgent2] TO [rt_read]
    AS [dbo];

