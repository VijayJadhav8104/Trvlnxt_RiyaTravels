
CREATE PROCEDURE [dbo].[sp_UserLoginCheckAgentExist]
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

	IF(EXISTS(SELECT * FROM AgentLogin WHERE UserName=@UserName))
	BEGIN
		SELECT UserID,UserName,FirstName,LastName,MobileNumber,NewsLetter,HomeNo,BookingCountry,
			Address,City,Country,Pincode,DrivingLicenceNo,Province,
			isnull(IsB2BAgent,0) as IsB2BAgent,isnull(AgentApproved,0) as AgentApproved 
		FROM AgentLogin
		WHERE UserName=@UserName;
	END
	
END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UserLoginCheckAgentExist] TO [rt_read]
    AS [dbo];

