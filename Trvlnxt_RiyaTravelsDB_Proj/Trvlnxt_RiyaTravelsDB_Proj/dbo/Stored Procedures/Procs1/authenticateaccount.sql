
CREATE PROCEDURE [dbo].[authenticateaccount] --'ashvini.gawde@gmail.com','pass1234'
	-- Add the parameters for the stored procedure here
	@userID varchar(100),
	@passwd varchar(128)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT count(*) From [dbo].[Account_login] where [Email]=@userID  and [passwords]=@passwd
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[authenticateaccount] TO [rt_read]
    AS [dbo];

