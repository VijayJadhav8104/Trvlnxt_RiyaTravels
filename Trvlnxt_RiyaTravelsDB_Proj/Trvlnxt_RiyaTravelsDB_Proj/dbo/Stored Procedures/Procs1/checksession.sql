
CREATE PROCEDURE [dbo].[checksession]
	@checksession varchar(50),
	@ID INT
	AS
BEGIN
	SET NOCOUNT ON;
   
	Select SessionID  From adminMaster where ID = @ID and SessionID = @checksession
	
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[checksession] TO [rt_read]
    AS [dbo];

