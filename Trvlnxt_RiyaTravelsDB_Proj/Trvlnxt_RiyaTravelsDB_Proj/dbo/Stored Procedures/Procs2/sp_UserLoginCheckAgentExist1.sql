CREATE PROCEDURE [dbo].[sp_UserLoginCheckAgentExist1]
	@UserName varchar(500),
	@Password varchar(300)=null,
	@opr int,
	@Device VARCHAR(50)=null,
	@IPAddress VARCHAR(50)=null,
	@Browser VARCHAR(50)=null,
	@Country VARCHAR(2)=null
AS
BEGIN

--declare
--    @UserName varchar(500)='hgasdf@sdjf.jshds',
--	@Password varchar(300)=null,
--	@opr int=2,
--	@Device VARCHAR(50)=null,
--	@IPAddress VARCHAR(50)=null,
--	@Browser VARCHAR(50)=null,
--	@Country VARCHAR(2)=null

	IF(EXISTS(SELECT * FROM mUser WHERE UserName=@UserName or EmailID=@UserName))
	BEGIN
		SELECT *
		FROM mUser
		WHERE UserName=@UserName or EmailID=@UserName;
	END
	
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UserLoginCheckAgentExist1] TO [rt_read]
    AS [dbo];

