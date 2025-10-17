CREATE proc [dbo].[ChangePassword_UserProfile]

@CurrentPassword varchar(50),
@NewPassword varchar(50),
@userid int


as
begin

declare @Pwd varchar(50)

select @Pwd = Password from UserLogin where UserID=@userid

if(@Pwd = @CurrentPassword)
begin
update UserLogin
set Password = @NewPassword
where UserID = @userid

end


end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[ChangePassword_UserProfile] TO [rt_read]
    AS [dbo];

