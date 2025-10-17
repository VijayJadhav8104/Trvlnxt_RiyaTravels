CREATE PROC GetAgentBalanceStatement
	@ICUST NVARCHAR(500),@TransactionDate DATETIME
AS
BEGIN
	SET NOCOUNT ON;
	--'CUSTAE1234'
	Select B.PKID,B.CreatedOn,B.OpenBalance,B.TranscationAmount,B.CloseBalance,B.TransactionType from B2BRegistration R
	JOIN tblAgentBalance B ON R.FKUserID=B.AgentNo Where Icast=@ICUST AND B.CreatedOn>=@TransactionDate
	order by B.CreatedOn DESC
END
