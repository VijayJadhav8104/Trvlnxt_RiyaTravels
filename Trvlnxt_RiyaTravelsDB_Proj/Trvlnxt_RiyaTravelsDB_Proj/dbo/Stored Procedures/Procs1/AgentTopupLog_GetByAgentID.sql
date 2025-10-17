-- =============================================
-- Author:		Hardik
-- Create date: 25.07.2023
-- Description:	To Get Agent Wise Transaction Details of Agent Topup
-- =============================================
CREATE PROCEDURE AgentTopupLog_GetByAgentID
	@AgentID Int
	,@PaymentGatewayMode Varchar(100) = NULL
	,@Status Varchar(50) = NULL
	,@TransactionDateFrom DateTime = NULL
	,@TransactionDateTo DateTime = NULL
AS
BEGIN
	SET NOCOUNT ON;

    SELECT ROW_NUMBER() OVER (ORDER BY EntryDate DESC) AS SrNo
	, Amount
	, EntryDate
	, TransactionID
	, RPGStatus
	, RPGFailMessage
	, PaymentGatewayMode
	, (CASE WHEN AgentTopupLog.ParentAgentID > 0 THEN AgentLogin.UserName ELSE 'NA' END) AS SubUserName
	FROM AgentTopupLog
	LEFT OUTER JOIN AgentLogin ON AgentLogin.UserID = AgentTopupLog.UserID
	WHERE (AgentTopupLog.UserID = @AgentID OR AgentTopupLog.ParentAgentID = @AgentID)
	AND (@PaymentGatewayMode IS NULL OR @PaymentGatewayMode = '' OR PaymentGatewayMode = @PaymentGatewayMode)
	AND (@Status IS NULL OR @Status = '' OR @Status = 'All' OR AgentTopupLog.RPGStatus = @Status)
	AND (@TransactionDateFrom IS NULL OR CAST(EntryDate AS DATE) >= CAST(@TransactionDateFrom AS DATE))
	AND (@TransactionDateTo IS NULL OR CAST(EntryDate AS DATE) <= CAST(@TransactionDateTo AS DATE))
	ORDER BY EntryDate DESC
END