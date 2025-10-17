CREATE PROCEDURE ReverseBalance
	@UserId	int,
	@Country varchar(10) = null,
	@RiyaPnr varchar(10)	
AS
	DECLARE @Amt decimal(18,2)=0
	,@PaymentMode varchar(15)
	,@CountryId INT
	,@MainAgentId INT
	,@OrderID Varchar(50)

	SELECT @CountryId = ID FROM mCountry WHERE CountryCode=@Country
		
	SELECT TOP 1 @Amt = p.amount
	, @PaymentMode=payment_mode
	, @MainAgentId=ISNULL( MainAgentId,0) 
	, @OrderID = order_id
	FROM Paymentmaster p JOIN tblBookMaster b ON p.order_id =b.orderid 
	WHERE b.riyaPNR = @RiyaPnr

	If(@PaymentMode = 'Check')
	BEGIN
		IF EXISTS (SELECT TOP 1 PKID FROM tblAgentBalance WHERE BookingRef = @OrderID AND TransactionType = 'Debit')
		BEGIN
			UPDATE AgentLogin SET AgentBalance=(AgentBalance + @Amt) WHERE UserID=@UserId

			SELECT AgentBalance FROM AgentLogin where UserID=@UserId 

			UPDATE tblBookMaster SET ClosedDate = GETDATE() WHERE orderId = @OrderID AND riyaPNR = @RiyaPnr
		END
	END
	ELSE If(@PaymentMode = 'Self Balance')
	BEGIN
		UPDATE mUserCountryMapping SET AgentBalance=(AgentBalance + @Amt)
  		WHERE UserID=@MainAgentId and  CountryId = @CountryId 
		
		SELECT  AgentBalance FROM mUserCountryMapping WHERE UserID=@MainAgentId and  CountryId = @CountryId 
	END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[ReverseBalance] TO [rt_read]
    AS [dbo];

