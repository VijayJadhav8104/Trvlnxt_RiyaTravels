--Proc_GetLoginAgentDetails 33435
CREATE procedure Proc_GetLoginAgentDetails
@AgentId int=null
As	
Begin
	Select isnull(AL.AgentLogoNew ,'') as AgentLogoNew,isnull(AL.MobileNumber,'') as MobileNumber,isnull(BR.AddrEmail,'') as AddrEmail  from 
	agentLogin AL
	Left join
	B2BRegistration BR
	On BR.FKUserID=AL.UserID
	where UserID=@AgentId
END