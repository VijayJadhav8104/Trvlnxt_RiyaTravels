



create Proc [dbo].[Update_tblBookMaster_InProcessAgent]

@ID int

as
begin

Update tblBookMaster
set AgentAction=1
where pkId=@ID


end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Update_tblBookMaster_InProcessAgent] TO [rt_read]
    AS [dbo];

