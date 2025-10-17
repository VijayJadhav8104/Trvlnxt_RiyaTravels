CREATE PROC UpdateAgentBalanceStatement
	@AgentBalanceDT AgentBalanceDT READONLY
AS
BEGIN
	SET NOCOUNT ON;

	Select * INTO #mt from @AgentBalanceDT

	UPDATE t1
	SET t1.OpenBalance = t2.OpenBalance, t1.TranscationAmount= t2.TranscationAmount,t1.CloseBalance=t2.CloseBalance
	FROM #mt t2 
	JOIN tblAgentBalance t1 ON t1.PKID = t2.PKID
	WHERE t1.PKID = t2.PKID

	DROP TABLE #mt
END