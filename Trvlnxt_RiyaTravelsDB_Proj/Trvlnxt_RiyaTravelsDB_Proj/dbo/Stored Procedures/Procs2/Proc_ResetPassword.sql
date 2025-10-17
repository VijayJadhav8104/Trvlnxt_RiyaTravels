CREATE proc [dbo].[Proc_ResetPassword]

@UserID int ,
@OldPassword varchar(500)=null,
@NewPassword varchar(500),
@userlevel int=null


AS
BEGIN

if(@OldPassword !='')
	begin
		if Exists (select * from AgentLogin where UserID = @UserID and Password = @OldPassword)
			BEGIN
				Update AgentLogin
				set Password= @NewPassword , ResetPwdFlag = 0
				where UserID= @UserID
			END
	end
	else
	begin
	if(@userlevel=1)

	begin
		Update mUser
				set Password= @NewPassword , isResetPassword = 0
				where ID= @UserID

	end
	else if(@userlevel=2)

	begin
		Update agentLogin
				set Password= @NewPassword , ResetPwdFlag = 0
				where UserID= @UserID
	end
	end

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Proc_ResetPassword] TO [rt_read]
    AS [dbo];

