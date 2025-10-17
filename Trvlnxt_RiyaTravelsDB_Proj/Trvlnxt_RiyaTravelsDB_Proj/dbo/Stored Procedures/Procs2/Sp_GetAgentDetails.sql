CREATE PROCEDURE [dbo].[Sp_GetAgentDetails]
	@AgentId int
AS
BEGIN
	SELECT 
	AL.userid
	, AgencyName
	, Password
	, AddrAddressLocation
	, AddrCity
	, isnull(AddrState,'') as AddrState
	, isnull(AddrZipOrPostCode,'') AS AddrZipOrPostCode
	, AddrLandlineNo
	, AddrMobileNo
	, ISNULL(AddrEmail,'') AS AddrEmail
	, ISNULL(AddrPropDirectPartner,'') AS AddrPropDirectPartner
	, AL.UserName
	, AL.BookingCountry
	, al.UserTypeID
	, com.Value as 'UserType'
	, ISNULL(b.AutoTicketing,0) AS AutoTicketing
	, ISNULL(b.PaymentMode,'') AS PaymentMode
	, ISNULL(b.CustomerType,'') AS CustomerType
	,ISNULL(AL.OTPRequired,0) AS OTPRequired
	FROM B2BRegistration B
	INNER JOIN AgentLogin AL ON AL.UserID=B.FKUserID
	INNER JOIN mCommon com ON al.UserTypeID=com.ID
	WHERE  al.userid=@AgentId
	--AND B.status=1
	--AND AL.IsActive = 1
	--AL.AgentApproved=1  AND

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAgentDetails] TO [rt_read]
    AS [dbo];

