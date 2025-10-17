
CREATE proc sp_GetAgencyList
@SearchKey varchar(100),
@Country varchar(100)
AS
BEGIN
		SELECT A.userid as ID ,(AgencyName + ' - ' +  Icast) as 'DisplayName'
		FROM B2BRegistration B
		INNER JOIN AgentLogin A ON A.UserID=B.FKUserID
		WHERE	(AgencyName LIKE
 '%'+@SearchKey +'%' or  Icast LIKE '%'+@SearchKey +'%') 
 		AND A.BookingCountry in  ( select DATA from sample_split(@Country,',') )  AND A.AgentApproved=1
		AND B.Status=1
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetAgencyList] TO [rt_read]
    AS [dbo];

