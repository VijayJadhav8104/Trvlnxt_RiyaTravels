-- =============================================
-- Author:		WS HD
-- Create date: 09.11.2022
-- Description:	Get Address From OU Master
-- =============================================
CREATE PROCEDURE AgentAttributeMappingOU_GetAddressByID
	@OUID Int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT TOP 1 [Address] FROM mAgentAttributeMappingOU WHERE Id = @OUID
END