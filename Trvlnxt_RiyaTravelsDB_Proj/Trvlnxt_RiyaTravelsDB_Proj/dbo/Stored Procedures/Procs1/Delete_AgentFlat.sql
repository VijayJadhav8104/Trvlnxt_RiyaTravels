

create proc [dbo].[Delete_AgentFlat]
@ID int

as
begin

Delete from Agent_Flat where FlatD = @ID

end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Delete_AgentFlat] TO [rt_read]
    AS [dbo];

