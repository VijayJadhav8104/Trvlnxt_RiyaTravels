-- =============================================
-- Author:		Hardik Deshani
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE AgentTopup_UpdateAgentBalance
	@UserID Int
	,@Balance Numeric(18,2)
	,@BookingRef Varchar(50) = NULL
	,@ConvenienceFeeCharge Numeric(18,2)
	,@ConvenienceFeeCalculated Numeric(18,2)
AS
BEGIN

	SET NOCOUNT ON;

    DECLARE @Amt decimal(18,2) = 0, @BalanceAndFee decimal(18,2)
	
	SET @BalanceAndFee = @Balance + ISNULL(@ConvenienceFeeCalculated,0)

	DECLARE @ParentAgentID Int

	-- If user parent id found = sub user done this txn we will addd Parent ID in agent balance
	-- And sub user id add in Reference
	SELECT @ParentAgentID = ISNULL(ParentAgentID,0) FROM AgentLogin WHERE UserID = @UserID

	IF (@ParentAgentID > 0)
	BEGIN
		-- Open Balance Before Credit
		SELECT @Amt = AgentBalance FROM AgentLogin WHERE UserID = @ParentAgentID

		-- Credit
		INSERT INTO tblAgentBalance (AgentNo,BookingRef,PaymentMode,OpenBalance,TranscationAmount,CloseBalance,CreatedOn,CreatedBy,IsActive,TransactionType,Remark,Reference)    
		VALUES (@ParentAgentID,@BookingRef,'PaymentGateway',@Amt,@BalanceAndFee,(@Amt + @BalanceAndFee),GETDATE(),@ParentAgentID,1,'Credit','Agent Topup',CONVERT(Varchar(10), @UserID))

		-- Update Agent Balance
		UPDATE AgentLogin SET AgentBalance = (@Amt + @BalanceAndFee) WHERE UserID = @ParentAgentID

		-- Open Balance Before Debit
		SELECT @Amt = AgentBalance FROM AgentLogin WHERE UserID = @ParentAgentID

		-- Debit
		INSERT INTO tblAgentBalance (AgentNo,BookingRef,PaymentMode,OpenBalance,TranscationAmount,CloseBalance,CreatedOn,CreatedBy,IsActive,TransactionType,Remark,Reference)    
		VALUES (@ParentAgentID,@BookingRef,'PaymentGateway',@Amt,@ConvenienceFeeCalculated,(@Amt - @ConvenienceFeeCalculated),DATEADD(SS, 3,GETDATE()),@ParentAgentID,1,'Debit','Agent Topup Convenience Fee ' + CONVERT(VARCHAR(20), @ConvenienceFeeCharge) +'%',CONVERT(Varchar(10), @UserID))

		-- Update Agent Balance
		UPDATE AgentLogin SET AgentBalance = (@Amt - @ConvenienceFeeCalculated) WHERE UserID = @ParentAgentID
	END
	ELSE
	BEGIN
		-- Open Balance Before Credit
		SELECT @Amt = AgentBalance FROM AgentLogin WHERE UserID = @UserID

		-- Credit
		INSERT INTO tblAgentBalance (AgentNo,BookingRef,PaymentMode,OpenBalance,TranscationAmount,CloseBalance,CreatedOn,CreatedBy,IsActive,TransactionType,Remark)    
		VALUES (@UserID,@BookingRef,'PaymentGateway',@Amt,@BalanceAndFee,(@Amt + @BalanceAndFee),GETDATE(),@UserID,1,'Credit','Agent Topup')

		-- Update Agent Balance
		UPDATE AgentLogin SET AgentBalance = (@Amt + @BalanceAndFee) WHERE UserID = @UserID

		-- Open Balance Before Debit
		SELECT @Amt = AgentBalance FROM AgentLogin WHERE UserID = @UserID

		-- Debit
		INSERT INTO tblAgentBalance (AgentNo,BookingRef,PaymentMode,OpenBalance,TranscationAmount,CloseBalance,CreatedOn,CreatedBy,IsActive,TransactionType,Remark)    
		VALUES (@UserID,@BookingRef,'PaymentGateway',@Amt,@ConvenienceFeeCalculated,(@Amt - @ConvenienceFeeCalculated),DATEADD(SS, 3,GETDATE()),@UserID,1,'Debit','Agent Topup Convenience Fee ' + CONVERT(VARCHAR(20), @ConvenienceFeeCharge) +'%')

		-- Update Agent Balance
		UPDATE AgentLogin SET AgentBalance = (@Amt - @ConvenienceFeeCalculated) WHERE UserID = @UserID
   END

END