
CREATE PROCEDURE [dbo].[sp_DeactiveOUDetails]
    -- Add the parameters for the stored procedure here
    @AgentId int
AS
BEGIN
    Update mAgentAttributeMappingOU 
    set IsActive=0
    where AgentId=@AgentId
END