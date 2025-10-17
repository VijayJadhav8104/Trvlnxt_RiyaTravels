


CREATE PROCEDURE [dbo].[DeleteUser]
@UserId		int,
@DeletedBy	int

AS BEGIN
	UPDATE adminMaster set Status = 0 ,DeletedDate = GETDATE(), DeletedBy =@DeletedBy
	WHERE Id = @UserId 

	UPDATE RoleAccess SET IsActive = 0 WHERE UserID = @UserId

	update UserCountryMapping set  IsActive = 0 WHERE UserID = @UserId
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeleteUser] TO [rt_read]
    AS [dbo];

