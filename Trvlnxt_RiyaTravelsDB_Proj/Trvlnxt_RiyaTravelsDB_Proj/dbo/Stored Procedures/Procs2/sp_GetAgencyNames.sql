CREATE PROCEDURE [dbo].[sp_GetAgencyNames]    
	@GroupId VARCHAR(10) = null   
AS       
BEGIN
	SELECT PKID
			, AgencyName
			, CustomerCOde
			, FKUserID 
	FROM B2BRegistration WITH(NOLOCK)
	WHERE FKUserID IN (SELECT userid
						FROM AgentLogin WITH(NOLOCK) 
						Where groupid = @GroupId
						and GroupId in(3,9,18))

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetAgencyNames] TO [rt_read]
    AS [dbo];

