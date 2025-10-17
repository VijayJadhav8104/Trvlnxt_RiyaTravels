CREATE PROCEDURE [dbo].[UdspGetmAgentAttributeMappingByAgentId]   
	@AgentID INT 
AS
BEGIN
	SELECT AttributeId
			, IsMandate
			, Attributes
			, Value
			, AttributeType 
	FROM mAgentAttributeMapping    
	INNER JOIN mAttributes on mAgentAttributeMapping.AttributeId = mAttributes.ID  
	WHERE AgenId = @AgentID OR AgenId IN (SELECT ParentAgentID FROM agentLogin WHERE userid = @AgentID)  
	ORDER BY SequenceOrder ASC
 end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UdspGetmAgentAttributeMappingByAgentId] TO [rt_read]
    AS [dbo];

