



CREATE proc [dbo].[Sp_Insert_PromoAgentList]

@PromoID	int,
@AgentID	int,
@InsertedBy varchar(50)
as
begin


Insert into Agent_Promocode
(
PromoID,
AgentID,
InsertdDate,
InsertedBy,
Flag
)
values
(
@PromoID,
@AgentID,
GETDATE(),
@InsertedBy,
1
)


end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_Insert_PromoAgentList] TO [rt_read]
    AS [dbo];

