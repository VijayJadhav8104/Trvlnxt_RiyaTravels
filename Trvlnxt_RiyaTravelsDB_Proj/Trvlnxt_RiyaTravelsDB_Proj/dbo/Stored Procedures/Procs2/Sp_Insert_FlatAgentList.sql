



CREATE proc [dbo].[Sp_Insert_FlatAgentList]

@FlatID	int,
@AgentID	int,
@InsertedBy varchar(50)
as
begin


Insert into Agent_Flat
(
FlatD,
AgentID,
InsertdDate,
InsertedBy,
Flag
)
values
(
@FlatID,
@AgentID,
GETDATE(),
@InsertedBy,
1
)


end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_Insert_FlatAgentList] TO [rt_read]
    AS [dbo];

