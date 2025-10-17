
--Proc_GetAgentLogo'33435'     
CREATE Procedure Proc_GetAgentLogo       
@AgentId int=null      
As      
Begin      
 Select AgentLogoNew from agentLogin        
 Where  UserID =@AgentId    
End
