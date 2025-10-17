CREATE PROCEDURE [dbo].[RTTBilling_UpdateCheckBalance]
	@UserId Int
	,@Balance decimal(18,2)
	,@TransactionType varchar(10)
	,@AgentNo Int
	,@BookingRef varchar(50) = NULL
AS  BEGIN   

	Declare @Amt decimal(18,2)=0, @Parentid INT

	SELECT @Parentid = ParentAgentID FROM AgentLogin WHERE UserID = @UserId

	IF (@Parentid IS NOT NULL)
	BEGIN
		SELECT @Amt = AgentBalance FROM AgentLogin WHERE UserID = @Parentid
		
		SET @AgentNo = @Parentid
	END
	ELSE
	BEGIN
		SELECT @Amt = AgentBalance FROM AgentLogin WHERE UserID = @UserId
	END

	--BELOW IF CONDITION ADDED ON 07-01-2022
	IF(@AgentNo = 0 OR @AgentNo IS NULL )
	BEGIN
		SELECT @AgentNo = AgentID FROM tblBookMaster WHERE orderId=@BookingRef
	END

	IF (@TransactionType = 'Debit')
	BEGIN
		UPDATE tblAgentBalance SET IsActive = 0 WHERE AgentNo = @AgentNo AND IsActive = 1

		INSERT INTO tblAgentBalance (AgentNo,OpenBalance,TranscationAmount,CloseBalance,IsActive,TransactionType,BookingRef)
		VALUES (@AgentNo,@Amt,@Balance,(@Amt - @Balance),1,@TransactionType,@BookingRef)

		UPDATE AgentLogin SET AgentBalance = (@Amt - @Balance) WHERE UserID = @AgentNo 

		SELECT AgentBalance FROM AgentLogin WHERE UserID = @UserId 
	END
  
	IF (@TransactionType = 'Credit')
	BEGIN
		UPDATE tblAgentBalance SET IsActive = 0 WHERE AgentNo = @AgentNo AND IsActive = 1 

		INSERT INTO tblAgentBalance (AgentNo,OpenBalance,TranscationAmount,CloseBalance,IsActive,TransactionType,BookingRef,CreatedBy,Remark)
		VALUES (@AgentNo,@Amt,@Balance,(@Amt + @Balance),1,@TransactionType,@BookingRef,@AgentNo,'payment recieved')
  
		UPDATE AgentLogin SET AgentBalance = (@Amt + @Balance) WHERE UserID = @AgentNo 

		SELECT AgentBalance FROM AgentLogin WHERE UserID = @UserId
	END
END