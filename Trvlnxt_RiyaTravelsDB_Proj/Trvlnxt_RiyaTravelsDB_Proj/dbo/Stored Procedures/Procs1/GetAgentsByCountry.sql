
CREATE	 PROC [dbo].[GetAgentsByCountry]
@Country varchar(10)

AS
BEGIN
		SELECT B.AgencyName FROM B2BRegistration B
INNER JOIN AgentLogin A ON A.UserID=B.FKUserID
 where A.BookingCountry=@Country AND A.AgentApproved=1
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAgentsByCountry] TO [rt_read]
    AS [dbo];

