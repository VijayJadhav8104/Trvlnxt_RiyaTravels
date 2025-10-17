CREATE PROC [dbo].[GetmCardDetailsSearch]     
@BankName varchar(100),    
@CardType varchar(50),    
@UserType varchar(25),    
@MarketPoint varchar(25)    
    
AS      
BEGIN      
 SELECT BankName,CardType,CardNumber,ExpiryDate,MarketPoint,UserType,pkid,isnull(UpdatedDate,InsertedDate) as InsertedDate,      
 InsertedBy, U.UserName,      
 CardTypeCode,StreetAddress,City,State,Country,PostalCode,CardHolderName,VerificationCode,[MaskCardNumber],Configuration      
  FROM mCardDetails C       
  inner JOIN mUser U on U.ID=C.InsertedBy      
  WHERE Status=1 and (BankName = @BankName or @BankName='')    
  and (CardTypeCode= @CardType or @CardType='')    
  and (MarketPoint = @MarketPoint or @MarketPoint='')    
  and (UserType=@UserType or @UserType='');      
END