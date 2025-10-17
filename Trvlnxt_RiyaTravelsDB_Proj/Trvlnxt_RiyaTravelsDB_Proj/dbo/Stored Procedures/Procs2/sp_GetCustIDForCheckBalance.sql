
CREATE procedure sp_GetCustIDForCheckBalance 
@AgentID int
as
begin
select Icast,AL.AgentBalance,AL.UserID from B2BRegistration B
INNER JOIN agentLogin AL ON AL.UserID=B.FKUserID
WHERE AL.AgentApproved=1 AND B.Status=1
AND AL.UserID=@AgentID
end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetCustIDForCheckBalance] TO [rt_read]
    AS [dbo];

