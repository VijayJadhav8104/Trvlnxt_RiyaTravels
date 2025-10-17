
create proc [dbo].[Delete_AgentPromoCode]
@ID int

as
begin

Delete from Agent_Promocode where PromoID = @ID

end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Delete_AgentPromoCode] TO [rt_read]
    AS [dbo];

