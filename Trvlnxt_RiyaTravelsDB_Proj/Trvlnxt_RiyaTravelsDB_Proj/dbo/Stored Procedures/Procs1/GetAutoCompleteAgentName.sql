-- =============================================        
-- Author:  <Author,,Name>        
-- Create date: <Create Date,,>        
-- Description: <Description,,>        
-- =============================================        
CREATE PROCEDURE [dbo].[GetAutoCompleteAgentName]         
 -- Add the parameters for the stored procedure here        
 @AgentName varchar(200)=''        
AS        
BEGIN        
         
 --select top 50 PKID,AgencyName from B2BRegistration         
 --where AgencyName like '%'+@AgentName+'%'        
  select top 50 FKUserID,Icast+'-'+' '+ AgencyName as AgencyName  from B2BRegistration         
 where   
 --AgencyName like '%'+@AgentName+'%'        
    (AgencyName LIKE '%'+@AgentName +'%' or  Icast LIKE '%'+@AgentName +'%')      
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAutoCompleteAgentName] TO [rt_read]
    AS [dbo];

