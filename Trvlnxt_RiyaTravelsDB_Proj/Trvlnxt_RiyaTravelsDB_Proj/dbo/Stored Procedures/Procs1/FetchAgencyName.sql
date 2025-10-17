
CREATE Proc [dbo].[FetchAgencyName]

AS BEGIN
	
	SELECT PKID, AgencyName FROM B2BRegistration where Icast IS NOT NULL ORDER BY AgencyName

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchAgencyName] TO [rt_read]
    AS [dbo];

