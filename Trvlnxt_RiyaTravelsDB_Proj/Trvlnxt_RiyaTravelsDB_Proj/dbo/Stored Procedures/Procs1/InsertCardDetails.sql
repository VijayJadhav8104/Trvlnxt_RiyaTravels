
 CREATE PROC [dbo].[InsertCardDetails]
@BankName	VARCHAR(200),
@CardType	VARCHAR(50),
@CardNumber	VARCHAR(20),
@ExpiryDate	VARCHAR(10),
@CardTypeCode VARCHAR(10),
@MarketPoint VARCHAR(30),
@UserType VARCHAR(10),
@InsertedBy INT
AS
BEGIN
	BEGIN TRAN
				INSERT INTO tblCardMaster(BankName,CardType,CardNumber,ExpiryDate,InsertedBy,CardTypeCode,MarketPoint,UserType)
				VALUES(@BankName,@CardType,@CardNumber,@ExpiryDate,@InsertedBy,@CardTypeCode,@MarketPoint,@UserType)
	COMMIT TRAN
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertCardDetails] TO [rt_read]
    AS [dbo];

