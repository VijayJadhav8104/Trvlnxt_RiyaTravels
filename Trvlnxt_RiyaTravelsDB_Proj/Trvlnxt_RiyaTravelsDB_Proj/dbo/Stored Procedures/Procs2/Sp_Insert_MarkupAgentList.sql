


CREATE proc [dbo].[Sp_Insert_MarkupAgentList]

@MarkupID	int,
@AgentID	int,
@InsertedBy varchar(50)
as
begin


Insert into Agent_Markup
(
MarkupID,
AgentID,
InsertdDate,
InsertedBy,
Flag
)
values
(
@MarkupID,
@AgentID,
GETDATE(),
@InsertedBy,
1
)


end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_Insert_MarkupAgentList] TO [rt_read]
    AS [dbo];

