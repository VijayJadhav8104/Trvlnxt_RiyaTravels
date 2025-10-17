CREATE Procedure [dbo].[Sp_GetAgentTypebyAgent]  
	@ALLUserType nvarchar(100) = null  
AS
BEGIN
	IF(@ALLUserType IS NOT NULL)  
	BEGIN  
		SELECT DISTINCT c.ID AS AgentId
				, C.Value AS UserType 
		FROM mUserTypeMapping UT WITH(NOLOCK)
		INNER JOIN mCommon C WITH(NOLOCK) ON C.ID=UT.UserTypeId AND IsActive=1 
		WHERE c.id IN (SELECT DATA FROM sample_split(@ALLUserType,','))  
	END  
	ELSE  
	BEGIN  
		SELECT DISTINCT c.ID AS AgentId
				, C.Value AS UserType 
		FROM mUserTypeMapping UT  WITH(NOLOCK)
		INNER JOIN mCommon C  WITH(NOLOCK) ON C.ID=UT.UserTypeId AND IsActive=1  
	END   
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAgentTypebyAgent] TO [rt_read]
    AS [dbo];

