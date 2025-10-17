
CREATE PROCEDURE [dbo].[sp_UserLoginCheckAgentExist4] 
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
		SELECT EmailID as EmailId,UserName as Username,MobileNo as MobileNo
		FROM mUser
		WHERE UserName=@UserName or EmailID=@UserName;
	END
   else IF(EXISTS(SELECT * FROM agentLogin WHERE UserName=@UserName))
	BEGIN
		SELECT  b2b.AddrEmail as EmailID,agent.UserName as UserNames,agent.MobileNumber as MobileNo
		FROM B2BRegistration as b2b
		inner join agentLogin agent on agent.UserID=b2b.FKUserID		
		WHERE FKUserID = (SELECT UserID FROM agentLogin WHERE UserName=@UserName)
	END
	else IF(EXISTS(SELECT * FROM B2BRegistration WHERE AddrEmail=@UserName))
	BEGIN
	DECLARE @fkId int
	set @fkId=(SELECT FKUserID from B2BRegistration
	where  AddrEmail=@UserName)
	select a.UserName as UserNames,b.AddrEmail as EmailID,a.MobileNumber as MobileNo from agentLogin a 
	inner join B2BRegistration b on a.UserID=b.FKUserID
	where UserID=@fkId		
	  
	END
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UserLoginCheckAgentExist4] TO [rt_read]
    AS [dbo];

