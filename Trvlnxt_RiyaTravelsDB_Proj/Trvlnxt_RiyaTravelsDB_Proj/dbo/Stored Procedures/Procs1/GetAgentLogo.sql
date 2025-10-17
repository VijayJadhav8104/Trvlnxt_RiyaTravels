--GetAgentLogo
CREATE PROC GetAgentLogo
AS
BEGIN
	SET NOCOUNT ON;
	Select B.Icast,AL.AgentLogoNew from agentLogin AL
	INNER JOIN B2BRegistration B ON AL.UserID=B.FKUserID 
	Where AgentLogoNew IS NOT NULL AND AgentLogoNew!='' order by AgentLogoNew ASC
END
