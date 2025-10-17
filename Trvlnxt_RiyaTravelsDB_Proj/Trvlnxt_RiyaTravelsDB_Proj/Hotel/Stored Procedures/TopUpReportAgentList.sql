
        
-- =============================================                      
-- Author:  <Aman Wagde>                      
-- Create date: <22/02/2024>                      
-- Description: To get Holiday Agency where country other than india                  
-- [Hotel.GetHotelAiutoCompleteAgentList] 'Prod',,'2'                
-- =============================================                   
 CREATE PROCEDURE Hotel.TopUpReportAgentList                           
  @AgentName varchar(200)='',                 
  @UserType int                 
AS                      
BEGIN                 
  select top 10 BR.FKUserID as 'FKUserID',Icast+'-'+AgencyName as AgencyName                
  from B2BRegistration BR             
  left join agentLogin Al on br.FKUserID=al.UserID            
  left join mCommon mc on al.userTypeID=mc.ID and Category='UserType'            
   where             
                  
    al.userTypeID=@UserType             
   and  
   BR.Icast+'-'+BR.AgencyName  like '%'+@AgentName+'%'              
                   
End 