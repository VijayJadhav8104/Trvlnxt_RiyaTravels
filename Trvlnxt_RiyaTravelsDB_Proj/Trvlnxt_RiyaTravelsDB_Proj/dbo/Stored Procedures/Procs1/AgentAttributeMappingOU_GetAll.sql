-- =============================================
-- Author:		WS HD
-- Create date: 09.11.2022
-- Description:	Get all OU Names For Display In Attributes Details
-- =============================================
CREATE PROCEDURE AgentAttributeMappingOU_GetAll
	@AgentID BigInt
AS
BEGIN
	SET NOCOUNT ON;

    SELECT Id, OUName FROM mAgentAttributeMappingOU WHERE AgentId = @AgentID AND IsActive = 1
END