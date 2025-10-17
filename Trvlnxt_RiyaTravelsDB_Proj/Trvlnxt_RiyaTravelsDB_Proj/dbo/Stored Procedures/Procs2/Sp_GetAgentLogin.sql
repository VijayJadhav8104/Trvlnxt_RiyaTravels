CREATE PROCEDURE [Sp_GetAgentLogin] --'IN','B2B'    
   
AS    
BEGIN    
  
  Select * from AgentLogin  
   
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAgentLogin] TO [rt_read]
    AS [dbo];

