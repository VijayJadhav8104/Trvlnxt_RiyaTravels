CREATE proc [dbo].[Proc_ChnagePassword1]

@UserID int ,
@OldPassword varchar(500)=null,
@EncryptOldPassword varchar(500)=null,
@NewPassword varchar(500),
@userlevel int=null,
@NewPasswordEncrypt VARCHAR(500) = NULL

AS
BEGIN

  if(@OldPassword !='')
	begin
		if Exists (select * from AgentLogin where UserID = @UserID 
		 AND(PasswordEncrypt IS NOT NULL AND PasswordEncrypt = @EncryptOldPassword 
          OR PasswordEncrypt IS NULL AND Password = @OldPassword)
		  --and Password = @OldPassword
		)
			BEGIN
				Update AgentLogin
				set --Password= @NewPassword , 
				ResetPwdFlag = 0,
				PasswordEncrypt =@NewPasswordEncrypt,
                PasswordExpiryDate = DATEADD(DAY, 45, GETDATE()) -- Set the password expiry date to 45 days from the current date
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
				set -- Password= @NewPassword ,
				ResetPwdFlag = 0,
				PasswordEncrypt =@NewPasswordEncrypt,
                PasswordExpiryDate = DATEADD(DAY, 45, GETDATE()) -- Set the password expiry date to 45 days from the current date
				where UserID= @UserID
	end
	end

END