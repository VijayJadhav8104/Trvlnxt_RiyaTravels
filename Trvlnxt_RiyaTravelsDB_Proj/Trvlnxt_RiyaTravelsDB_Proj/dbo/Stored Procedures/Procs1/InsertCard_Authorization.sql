

CREATE PROCEDURE [dbo].[InsertCard_Authorization]   
 -- Add the parameters for the stored procedure here  
@PaymentType varchar(50) =null,
@Booking_Reference_No varchar(50),  
@NameOfSalesPerson varchar(50),  
@CustomerName varchar(100),  
@CardHolderName varchar(100),  
@CardNo varchar(50),  
@Card_Expiry varchar(50),  
@Ticketed_Amount varchar(50),  
@NameOfPaxOtherCard varchar(500),  
@BillingAddress varchar(500),  
@WorkPhone_No varchar(20),  
@HomePhone_No varchar(20),  
@Mobile_No varchar(20),  
@EmailId varchar(100),  
@DriveryLicence_No varchar(100),  
@State varchar(100),  
@Uploaded_DocumentPath varchar(500) ,
@BookingCountry varchar(100),
@Browser varchar(50), 
@IP varchar(50), 
@Device varchar(50) ,
@RelationshipOfPaxOtherThenCard varchar(100) = null
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 Insert Into dbo.Card_Authorization ( PaymentType, 
 Booking_Reference_No,NameOfSalesPerson,CustomerName,CardHolderName,CardNo,Card_Expiry,Ticketed_Amount,  
NameOfPaxOtherCard,BillingAddress,WorkPhone_No,HomePhone_No,Mobile_No,EmailId,DriveryLicence_No,State,  
Uploaded_DocumentPath,dtSubmittedDate,BookingCountry,Browser,IP,Device ,RelationshipOfPaxOtherThenCard)  
values(  @PaymentType,
@Booking_Reference_No,  
@NameOfSalesPerson,  
@CustomerName,  
@CardHolderName,  
@CardNo,  
@Card_Expiry,  
@Ticketed_Amount,  
@NameOfPaxOtherCard,  
@BillingAddress,  
@WorkPhone_No,  
@HomePhone_No,  
@Mobile_No,  
@EmailId,  
@DriveryLicence_No,  
@State,  
@Uploaded_DocumentPath,  
GETDATE() ,
@BookingCountry,
@Browser,@IP,@Device ,@RelationshipOfPaxOtherThenCard
)  
END 



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertCard_Authorization] TO [rt_read]
    AS [dbo];

