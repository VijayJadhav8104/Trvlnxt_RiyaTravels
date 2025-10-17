CREATE PROC [dbo].[InsertmCardDetails]
@BankName	VARCHAR(200),
@CardType	VARCHAR(50),
@CardNumber	VARCHAR(1000),
@ExpiryDate	VARCHAR(500),
@CardTypeCode VARCHAR(10),
@MarketPoint VARCHAR(30),
@UserType VARCHAR(10),
@InsertedBy INT,
@StreetAddress VARCHAR(300),
@City VARCHAR(100),
@State VARCHAR(100),
@Country VARCHAR(100),
@PostalCode VARCHAR(30),
@CardHolderName VARCHAR(200),
@VerificationCode VARCHAR(500)=null,
@maskfield varchar(1000),
@Configuration	VARCHAR(50)=null
AS
BEGIN
	BEGIN TRAN
				INSERT INTO mCardDetails(BankName,CardType,CardNumber,ExpiryDate,InsertedBy,CardTypeCode,MarketPoint,UserType,StreetAddress,City,
				State,Country,PostalCode,CardHolderName,VerificationCode,[MaskCardNumber],[Configuration])
				VALUES(@BankName,@CardType,@CardNumber,@ExpiryDate,@InsertedBy,@CardTypeCode,@MarketPoint,@UserType,@StreetAddress,
				@City,@State,@Country,@PostalCode,@CardHolderName,@VerificationCode,@maskfield,@Configuration)
	COMMIT TRAN
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertmCardDetails] TO [rt_read]
    AS [dbo];

