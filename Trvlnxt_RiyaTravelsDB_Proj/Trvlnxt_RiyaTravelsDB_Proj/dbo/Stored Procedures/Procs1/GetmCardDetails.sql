CREATE PROC [dbo].[GetmCardDetails]
AS
BEGIN
	SELECT BankName,CardType,CardNumber,ExpiryDate,MarketPoint,UserType,pkid,isnull(UpdatedDate,InsertedDate) as InsertDate,
	InsertedBy, U.UserName,
	CardTypeCode,StreetAddress,City,State,Country,PostalCode,CardHolderName,VerificationCode,[MaskCardNumber],Configuration
	 FROM mCardDetails C 
	 inner JOIN mUser U on U.ID=C.InsertedBy
	 WHERE Status=1;
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetmCardDetails] TO [rt_read]
    AS [dbo];

