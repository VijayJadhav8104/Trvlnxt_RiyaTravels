CREATE PROCEDURE GetAPIAuthenticationMaster  
@AgentID varchar(20)  
AS  
BEGIN

 select APIKey from APIAuthenticationMaster where AgentID = @AgentID and [Status] = 1

 union

 select APIKey from APIAuthenticationMaster_Internal where AgentID = @AgentID and [Status] = 1

END 