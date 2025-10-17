CREATE PROCEDURE InsertMakePaymentCommission      
 -- Add the parameters for the stored procedure here      
       
 @FkBookId int=0,      
 @ModeOfPayment varchar(100)=null,      
 @ConvenienFeeInPercent decimal(18,2)=0,      
 @TotalCommission decimal(18,2)=0,      
 @AmountBeforeCommission decimal(18,2)=0,      
 @AmountWithCommission decimal(18,2)=0,      
 @OrderId varchar(40)=null,  
 @ProductType varchar(40)=null ,
 @GSTOnPGCharge decimal(18,2)=0
   
AS      
BEGIN      
       
 insert into B2BMakepaymentCommission(      
           FkBookId,      
           ModeOfPayment,      
           ConvenienFeeInPercent,      
           TotalCommission,      
           AmountBeforeCommission,      
           AmountWithCommission,      
           ProductType,  
     OrderId,GSTOnPGCharge
     )   
           values(@FkBookId,      
           @ModeOfPayment,      
           @ConvenienFeeInPercent,      
           @TotalCommission,      
           @AmountBeforeCommission,      
           @AmountWithCommission,  
     @ProductType,  
     @OrderId,@GSTOnPGCharge
     )      
      
      
END 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertMakePaymentCommission] TO [rt_read]
    AS [dbo];

