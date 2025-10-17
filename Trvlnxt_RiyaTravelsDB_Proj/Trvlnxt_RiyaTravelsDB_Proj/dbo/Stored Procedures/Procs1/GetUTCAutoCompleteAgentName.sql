-- =============================================        
-- Author:  <Akash Singh>        
-- Create date: <23/03/2022>        
-- Description: To get Holiday Agency where country other than india    
-- [GetUTCAutoCompleteAgentName] 'Riya','UAE','Holiday'  
-- =============================================     
 CREATE PROCEDURE [dbo].[GetUTCAutoCompleteAgentName]             
  @AgentName varchar(200)='',   
  @Country varchar(200)='',  
  @UserType varchar(200)=''   
AS        
BEGIN   
  select top 50 BR.Pkid as 'FKUserID',Icast+'-'+AgencyName as AgencyName  
  from B2BRegistration BR  
  left join (Select Userid,userTypeID,Value from  agentLogin AL left join mCommon MC on AL.userTypeID=MC.ID)  ALMC on ALmc.UserID=Br.FKUserID  
   where BR.AgencyName like '%'+@AgentName+'%'   
   and BR.Country=@Country 
   and ALMC.Value=@UserType  
End  
  
  
  --select top 500 FKUserID,AgencyName,br.country,mc.Value  
  --from B2BRegistration BR  
  --join agentLogin AL on AL.UserID=Br.FKUserID  
  --join mCommon mc on AL.userTypeID=mc.id    
  --where  
  --  BR.Country='UAE' and  
  --  MC.Value='Holiday'  
  
  --left join (Select Userid,userTypeID,Value from  agentLogin AL left join mCommon MC on AL.userTypeID=MC.ID)  ALMC on ALmc.UserID=Br.FKUserID  
  -- where  
  --  --BR.Country='USA'  
  --  ALMC.Value='Holiday'  
  
  --  RIYA TRAVEL & TOURISM LLC-RI D
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetUTCAutoCompleteAgentName] TO [rt_read]
    AS [dbo];

