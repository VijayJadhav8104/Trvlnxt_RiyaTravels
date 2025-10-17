-- =============================================
-- Author:      Aditya
-- Create date: 01.07.2024
-- Description: To Get Agent Login Details by AgentID
-- =============================================
CREATE PROCEDURE [dbo].[AgentLogin_GetByAgentLogo]
    @AgentID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Top 1
		al.AgentLogoNew as logo
	   ,br.Icast as CustID
    FROM B2BRegistration br
    INNER JOIN AgentLogin al ON al.UserID = br.FKUSERID
    WHERE al.UserID = @AgentID;

END