CREATE PROCEDURE [dbo].[sp_UpdatePasswordAgentmUSer]
@EmailID  varchar(500),
	@UserName  varchar(500),
	@Password  varchar(300)
AS
BEGIN
 --  	IF(EXISTS(SELECT * FROM mUser WHERE EmailID=@EmailID)) 
	--UPDATE mUser 
	--SET Password=@Password
	--Where EmailID=@EmailID and UserName=@UserName
 --   else
	IF(EXISTS(SELECT * FROM agentLogin WHERE UserName=@UserName))
    UPDATE agentLogin 
	SET Password=@Password
	Where UserName=@UserName
	SELECT 1;
END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UpdatePasswordAgentmUSer] TO [rt_read]
    AS [dbo];

