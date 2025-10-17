CREATE PROCEDURE [dbo].[sp_UpdatePasswordAgentmUser_New]
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
	BEGIN
		UPDATE agentLogin   
		SET PasswordEncrypt=@Password  
		,PasswordExpiryDate = DATEADD(DAY, 45, GETDATE())
		Where UserName=@UserName  
		SELECT 1;  
	END

END







