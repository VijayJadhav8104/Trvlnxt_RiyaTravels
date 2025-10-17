



create proc [dbo].[Delete_AgentDeal]
@ID int

as
begin

Delete from Agent_Deal where DealID = @ID

end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Delete_AgentDeal] TO [rt_read]
    AS [dbo];

