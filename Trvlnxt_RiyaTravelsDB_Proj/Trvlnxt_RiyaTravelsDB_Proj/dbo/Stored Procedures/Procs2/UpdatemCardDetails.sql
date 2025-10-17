CREATE PROC [dbo].[UpdatemCardDetails]  
@BankName VARCHAR(200),  
@CardType VARCHAR(50),  
@CardNumber VARCHAR(1000),  
@ExpiryDate VARCHAR(500),  
@UpdatedBy INT,  
@pkid INT,  
@CardTypeCode VARCHAR(10),  
@MarketPoint VARCHAR(30),  
@UserType VARCHAR(10),  
@StreetAddress VARCHAR(300),  
@City VARCHAR(100),  
@State VARCHAR(100),  
@Country VARCHAR(100),  
@PostalCode VARCHAR(30),  
@CardHolderName VARCHAR(200),  
@VerificationCode VARCHAR(300)=null,  
@maskfield varchar(1000),  
@Configuration VARCHAR(50)=null  
AS  
BEGIN  
 BEGIN TRAN  
    UPDATE mCardDetails SET BankName=@BankName,CardType=@CardType,CardNumber=@CardNumber  
    ,ExpiryDate=@ExpiryDate,UpdatedBy=@UpdatedBy,UpdatedDate=GETDATE(),  
    CardTypeCode =@CardTypeCode, MarketPoint=@MarketPoint, UserType=@UserType,  
    StreetAddress=@StreetAddress,City=@City,  
    State=@State,Country=@Country,PostalCode=@PostalCode,CardHolderName=@CardHolderName,VerificationCode=@VerificationCode,[MaskCardNumber]=@maskfield  
    ,[Configuration]=@Configuration  
    WHERE pkid=@pkid  
 COMMIT TRAN  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdatemCardDetails] TO [rt_read]
    AS [dbo];

