



CREATE proc [dbo].[Sp_Insert_DealAgentList]

@DealID	int,
@AgentID	int,
@InsertedBy varchar(50)

as
begin

--if exists (select * from Agent_Deal where DealID = 1)
--begin

--delete from Agent_Deal where DealID= DealID

--end
--else
--begin



Insert into Agent_Deal
(
DealID,
AgentID,
InsertdDate,
InsertedBy,
Flag
)
values
(
@DealID,
@AgentID,
GETDATE(),
@InsertedBy,
1
)

End
--end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_Insert_DealAgentList] TO [rt_read]
    AS [dbo];

