CREATE PROC [dbo].[GetALLAgents]
@searchagents varchar(100)=null
AS
BEGIN

SELECT PKID as UserID,AgencyName AS AgentName 
	FROM B2BRegistration WHERE Status=1 and AgencyName like @searchagents +'%'
	order by AgencyName asc


	--SELECT UserID,FirstName+' '+ISNULL(LastName,'') AS AgentName 
	--FROM AgentLogin WHERE IsActive=1 
	--order by FirstName asc
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetALLAgents] TO [rt_read]
    AS [dbo];

