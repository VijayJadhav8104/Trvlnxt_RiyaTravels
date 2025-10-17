

---------------------------------------------------------------------------------


CREATE PROC UpdateAgentBalance
	@agntBAL NUMERIC(18,2),@UserID INT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE AgentLogin SET AgentBalance=@agntBAL
	WHERE UserID=@UserID
END