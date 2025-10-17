


CREATE PROCEDURE [dbo].[UpdatePassword]
@Password			varchar(128),
@OldPassword		varchar(128),
@UserId				int
AS BEGIN
	IF(@OldPassword ='')
		BEGIN
			UPDATE adminMaster SET Password = @Password WHERE Id = @UserId
		END
	ELSE
		BEGIN
			UPDATE adminMaster SET Password = @Password WHERE Id = @UserId AND Password = @OldPassword
		END
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdatePassword] TO [rt_read]
    AS [dbo];

