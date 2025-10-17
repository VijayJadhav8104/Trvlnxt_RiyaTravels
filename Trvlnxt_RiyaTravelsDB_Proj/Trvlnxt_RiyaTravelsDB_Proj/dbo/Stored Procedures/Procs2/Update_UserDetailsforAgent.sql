

create proc [dbo].[Update_UserDetailsforAgent]

@ID int ,
@B2BCheck Bit

as
begin

Update UserLogin
set IsB2BAgent= @B2BCheck
where UserID= @ID


end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Update_UserDetailsforAgent] TO [rt_read]
    AS [dbo];

