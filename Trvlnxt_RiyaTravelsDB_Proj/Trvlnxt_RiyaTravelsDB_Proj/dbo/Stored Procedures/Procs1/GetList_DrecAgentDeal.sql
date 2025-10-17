



CREATE proc [dbo].[GetList_DrecAgentDeal]

@ID int

as
begin

SELECT
A.ID,
DealID,
AgentID,
InsertdDate,
InsertedBy,
A.Flag
FROM  Agent_Deal A
LEFT JOIN Flight_Deal B on B.ID = A.DealID
where A.DealID = @ID

END



select * from B2BRegistration


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_DrecAgentDeal] TO [rt_read]
    AS [dbo];

