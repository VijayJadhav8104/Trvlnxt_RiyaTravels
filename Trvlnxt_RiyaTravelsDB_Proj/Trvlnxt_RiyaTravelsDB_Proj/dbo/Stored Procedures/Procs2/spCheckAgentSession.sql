
CREATE PROCEDURE [dbo].[spCheckAgentSession]
	@checksession varchar(50),
	@ID INT
	AS
BEGIN
	SET NOCOUNT ON;
   
	Select *  From AgentLogin where UserID = @ID and SessionID = @checksession
	
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spCheckAgentSession] TO [rt_read]
    AS [dbo];

