CREATE PROCEDURE [dbo].[ManualTicketing_GetOUNames]
	@AgentID BigInt
AS
BEGIN
	SET NOCOUNT ON;

    SELECT Id, OUName FROM mAgentAttributeMappingOU WHERE AgentId = @AgentID AND IsActive = 1
END