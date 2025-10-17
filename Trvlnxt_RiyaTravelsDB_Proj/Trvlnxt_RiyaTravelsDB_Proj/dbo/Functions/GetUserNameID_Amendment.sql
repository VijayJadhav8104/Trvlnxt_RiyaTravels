CREATE FUNCTION [dbo].[GetUserNameID_Amendment]
(
	@UserID Int
)
RETURNS Varchar(50)
AS
BEGIN
	
	-- Declare the return variable here
	DECLARE @ResultVar Varchar(50)

	SELECT @ResultVar = ISNULL(UserName, '') FROM mUser WHERE Id = @UserID

	IF (@ResultVar IS NULL OR @ResultVar = '')
	BEGIN
	SELECT @ResultVar =ISNULL(UserName, '') FROM AgentLogin WHERE UserID = @UserID
	END

	-- Return the result of the function
	RETURN @ResultVar

END
