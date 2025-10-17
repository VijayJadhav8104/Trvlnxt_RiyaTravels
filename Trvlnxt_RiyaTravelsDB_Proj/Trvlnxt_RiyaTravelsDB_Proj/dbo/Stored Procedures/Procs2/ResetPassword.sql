


CREATE PROCEDURE [dbo].[ResetPassword]
@UserId		int

AS BEGIN
	UPDATE adminMaster set Password = '77BF29190F16FBB259E87E6A9E1510EBC6EB2C40'  --B2C@123 encripted password 
	WHERE Id = @UserId 

END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[ResetPassword] TO [rt_read]
    AS [dbo];

