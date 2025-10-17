CREATE PROC [dbo].[GetCardDetails]
AS
BEGIN
	SELECT BankName,CardType,CardNumber,ExpiryDate,MarketPoint,UserType,pkid,isnull(UpdatedDate,InsertedDate) as InsertDate,
	InsertedBy, U.UserName,
	CardTypeCode
	 FROM tblCardMaster C 
	 inner JOIN mUser U on U.ID=C.InsertedBy
	 WHERE Status=1;
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetCardDetails] TO [rt_read]
    AS [dbo];

