
CREATE PROCEDURE [dbo].[sp_UserLoginCheckAgent] --'anita@gmail.com'
	@UserName varchar(500),
	@Password varchar(300)=null,
	@opr int=null,
	@Device VARCHAR(50)=null,
	@IPAddress VARCHAR(50)=null,
	@Browser VARCHAR(50)=null,
	@Country VARCHAR(2)=null
AS
BEGIN
	IF(EXISTS(SELECT * FROM AgentLogin WHERE UserName=@UserName AND IsB2BAgent=1))
	BEGIN
		SELECT UserID,UserName,FirstName,LastName,MobileNumber,NewsLetter,HomeNo,BookingCountry,
			Address,City,Country,Pincode,DrivingLicenceNo,Province,
			isnull(IsB2BAgent,0) as IsB2BAgent,isnull(AgentApproved,0) as AgentApproved ,ParentAgentID
		FROM AgentLogin
		WHERE UserName=@UserName;
	END
	ELSE
	BEGIN
		SELECT 0;
	END
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UserLoginCheckAgent] TO [rt_read]
    AS [dbo];

