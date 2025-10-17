-- =============================================          
-- Author:  <Aman Wagde>          
-- Create date: <14/02/2024>          
-- Description: To get Holiday Agency where country other than india      
-- [GetUTCAutoCompleteAgentName] 'Riya','UAE','Holiday'    
-- =============================================       
 CREATE PROCEDURE [dbo].[GetUTCAutoCompleteAgentNametest]               
  @AgentName varchar(200)='',     
  @Country varchar(200)='',    
  @UserType int     
AS          
BEGIN     
  select top 10 BR.Pkid as 'FKUserID',Icast+'-'+AgencyName as AgencyName    
  from B2BRegistration BR 
  left join agentLogin Al on br.FKUserID=al.UserID
  left join mCommon mc on al.userTypeID=mc.ID and Category='UserType'
   where 
      al.Country=@Country   
   and al.userTypeID=@UserType 
   and BR.Icast+'-'+BR.AgencyName  like '%'+@AgentName+'%'  
       
End    
    
  
  