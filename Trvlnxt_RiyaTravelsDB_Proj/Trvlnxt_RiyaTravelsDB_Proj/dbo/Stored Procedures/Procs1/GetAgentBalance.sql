
CREATE PROC GetAgentBalance
	@ICUST NVARCHAR(500)
AS
BEGIN
	SET NOCOUNT ON;
	--'CUSTAE1234'	

	Select top 1 L.AgentBalance,L.UserID from AgentLogin L
	JOIN B2BRegistration R ON L.UserID=R.FKUserID
	WHERE R.Icast=@ICUST
END