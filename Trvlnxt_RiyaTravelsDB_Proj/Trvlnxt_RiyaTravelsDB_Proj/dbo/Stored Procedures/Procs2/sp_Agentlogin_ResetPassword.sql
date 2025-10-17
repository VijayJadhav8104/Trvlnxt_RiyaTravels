
CREATE PROCEDURE [dbo].[sp_Agentlogin_ResetPassword] ---'anita@gmail.com','deactive',1
@UserName varchar(50),
@Flag varchar(50),
@IsActive tinyint,
@pwd varchar(50)=null
AS BEGIN
    IF(@Flag='Password')
    BEGIN
	UPDATE AgentLogin set [Password] = @pwd,ResetPwdFlag=1 --B2C@123 encripted password 
	WHERE UserName = @UserName
	END
	ELSE IF(@Flag='DeActive')		
	BEGIN
	 IF(@IsActive=0)
	 BEGIN
	 UPDATE AgentLogin set [IsActive] = 1  --B2C@123 encripted password 
	 WHERE UserName = @UserName
	 END
	 ELSE IF(@IsActive=1)
	 BEGIN
	 UPDATE AgentLogin set [IsActive] = 0  --B2C@123 encripted password 
	 WHERE UserName = @UserName
	 END
	END

END





 



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_Agentlogin_ResetPassword] TO [rt_read]
    AS [dbo];

