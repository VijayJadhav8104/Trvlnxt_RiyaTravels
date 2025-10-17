-- =============================================
-- Author:		Hardik Deshani
-- Create date: 05.07.2023
-- Description:	Add Agent Topup Payment Log
-- =============================================
CREATE PROCEDURE AgentTopupPaymentGatewayLog_InsertUpdate
	@UserID Int
	,@TransactionID Varchar(50)
	,@RPGTxnID Varchar(50) = NULL
	,@RPGStatus Varchar(50) = NULL
	,@RPGFailMessage Varchar(50) = NULL
	,@RequestLog Varchar(MAX) = NULL
	,@ResponseLog Varchar(MAX) = NULL
	,@RequestDate DateTime = NULL
	,@ResponseDate DateTime = NULL
	,@Flag Int --0 Insert, 1 Update
AS
BEGIN
	
	IF (@Flag = 0) 
	BEGIN
		INSERT INTO AgentTopupPaymentGatewayLog (UserID,TransactionID,RequestLog,RequestDate)
		VALUES(@UserID,@TransactionID,@RequestLog,@RequestDate)
	END
	ELSE
	BEGIN
		UPDATE AgentTopupPaymentGatewayLog SET 
		ResponseLog = @ResponseLog
		, ResponseDate = @ResponseDate
		WHERE TransactionID = @TransactionID

		UPDATE AgentTopupLog SET RPGTxnID = @RPGTxnID
		, RPGStatus = @RPGStatus
		, RPGFailMessage = @RPGFailMessage
		WHERE TransactionID = @TransactionID
	END
END