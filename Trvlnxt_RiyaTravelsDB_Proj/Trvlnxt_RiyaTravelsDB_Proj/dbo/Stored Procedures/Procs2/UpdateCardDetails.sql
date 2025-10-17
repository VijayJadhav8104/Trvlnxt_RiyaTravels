CREATE PROC [dbo].[UpdateCardDetails]
@BankName	VARCHAR(200),
@CardType	VARCHAR(50),
@CardNumber	VARCHAR(20),
@ExpiryDate	VARCHAR(10),
@UpdatedBy INT,
@pkid INT,
@CardTypeCode VARCHAR(10),
@MarketPoint VARCHAR(30),
@UserType VARCHAR(10)
AS
BEGIN
	BEGIN TRAN
				UPDATE tblCardMaster SET BankName=@BankName,CardType=@CardType,CardNumber=@CardNumber
				,ExpiryDate=@ExpiryDate,InsertedBy=@UpdatedBy,UpdatedDate=GETDATE(),
				CardTypeCode =@CardTypeCode, MarketPoint=@MarketPoint, UserType=@UserType
				WHERE pkid=@pkid
	COMMIT TRAN
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateCardDetails] TO [rt_read]
    AS [dbo];

