CREATE PROCEDURE [SS].[SS_CheckAgentAccess]      
 @AgentID INT = NULL      
AS      
BEGIN      
 IF EXISTS (      
   SELECT TOP 1 *      
   FROM dbo.mAgentMapping      
   WHERE AgentID = @AgentID      
    AND MenuID = 1209
	
	--(      
 --    SELECT TOP 1 Id      
 --    FROM mMenu      
 --    WHERE MenuName = 'Sightseeing'      
 --     AND Module = 'trvlnxt'      
 --     AND isActive = 1      
 --    )      
   )      
 BEGIN      
  SELECT 1 as Access;      
 END      
 ELSE      
 BEGIN      
  SELECT 0 as Access;      
 END      
END 