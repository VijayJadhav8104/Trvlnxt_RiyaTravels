CREATE PROCEDURE [dbo].[RTTBilling_UpdateSelfBalance]
	@UserId Int
	,@Balance decimal(18,2)
	,@TransactionType varchar(10)
	,@AgentNo Int
	,@BookingRef varchar(50) = NULL
AS 
BEGIN   

	DECLARE @Amt decimal(18,2), @CountryID Int

	SELECT @Amt = AgentBalance, @CountryID = CountryId FROM mUserCountryMapping WHERE UserID = @UserId

	IF (@TransactionType = 'Debit')
	BEGIN
		INSERT INTO tblSelfBalance (UserId
		,BookingRef
		,OpenBalance
		,TranscationAmount
		,CloseBalance
		,CreatedBy
		,TransactionType)
		VALUES (@UserId
		,@BookingRef
		,@Amt
		,@Balance
		,(@Amt-@Balance)
		,@UserId
		,@TransactionType)

		UPDATE mUserCountryMapping SET AgentBalance = (@Amt - @Balance) 
		WHERE UserID = @UserId 
		AND CountryId = @CountryID

	END
  
END