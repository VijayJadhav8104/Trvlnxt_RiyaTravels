
create proc [dbo].[Delete_AgentMarkup]
@ID int

as
begin

Delete from Agent_Markup where MarkupID = @ID

end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Delete_AgentMarkup] TO [rt_read]
    AS [dbo];

