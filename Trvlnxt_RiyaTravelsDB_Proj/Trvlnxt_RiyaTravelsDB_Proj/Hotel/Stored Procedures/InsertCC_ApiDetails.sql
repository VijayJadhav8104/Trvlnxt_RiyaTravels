-- =============================================          
-- Author:  Akash singh          
-- Create date: 18 Jan 2023          
-- Description: Save Credit Card Deatils genrated through Booking API            
-- =============================================          
CREATE PROCEDURE [Hotel].InsertCC_ApiDetails          
          
@BookingID varchar(100)=''          
,@Email varchar(100)=''          
,@Phone varchar(100)=''          
,@BillingAddress varchar(MAX)=''          
,@NameOnCard varchar(100)=''          
,@Number varchar(100)=''           
,@ExpiryMonth int =0          
,@ExpiryYear int =0          
,@Cvv int =0          
,@IsUser varchar(100)=''       
,@Amount varchar(100)=''      
,@Currency varchar(100)=''   
,@CardType varchar(150)=''  
,@Roe decimal(18,2)=1          
AS          
BEGIN          
             
   Insert into [RiyaTravels].[Hotel].[tblApiCreditCardDeatils]           
              (BookingId, Email, Phone, BillingAddress, NameOnCard, number, ExpiryMonth, ExpiryYear, Cvv, IsUser,InsertedDate,Amount,Currency,CardType,AppliedRoe)          
 values(@BookingID, @email, @Phone, @BillingAddress, @NameOnCard, @Number, @ExpiryMonth, @ExpiryYear, @Cvv, @IsUser, GetDate(),@Amount,@Currency,@CardType,@Roe)          
          
END 