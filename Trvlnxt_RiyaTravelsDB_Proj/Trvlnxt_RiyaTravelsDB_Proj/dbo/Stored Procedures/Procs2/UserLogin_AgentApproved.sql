

CREATE proc [dbo].[UserLogin_AgentApproved]
@ID int=null,
@flag int=null
as
begin

update Agentlogin
set AgentApproved= @flag
where UserID= @ID 

update Agentlogin
set AgentApproved= @flag
where ParentAgentID= @ID 



end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UserLogin_AgentApproved] TO [rt_read]
    AS [dbo];

