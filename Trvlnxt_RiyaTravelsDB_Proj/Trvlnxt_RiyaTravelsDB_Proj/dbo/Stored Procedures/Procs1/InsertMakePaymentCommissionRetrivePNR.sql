-- =============================================      
-- Author:  <Author,,Name>      
-- Create date: <Create Date,,>      
-- Description: <Description,,>      
-- =============================================      
CREATE PROCEDURE InsertMakePaymentCommissionRetrivePNR      
 -- Add the parameters for the stored procedure here      
       
 @FkBookId int=0,      
 @ModeOfPayment varchar(100)=null,      
 @ConvenienFeeInPercent decimal(18,2)=0,      
 @TotalCommission decimal(18,2)=0,      
 @AmountBeforeCommission decimal(18,2)=0,      
 @AmountWithCommission decimal(18,2)=0,      
 @OrderId varchar(40)=null,  
 @ProductType varchar(40)=null  
   
AS      
BEGIN      
 If NOT Exists(Select  FkBookId from B2BMakepaymentCommission where FkBookId=@FkBookId)      
 Begin       
	insert into B2BMakepaymentCommission(      
           FkBookId,      
           ModeOfPayment,      
           ConvenienFeeInPercent,      
           TotalCommission,      
           AmountBeforeCommission,      
           AmountWithCommission,      
           ProductType,  
     OrderId  
     )   
           values(@FkBookId,      
           @ModeOfPayment,      
           @ConvenienFeeInPercent,      
           @TotalCommission,      
           @AmountBeforeCommission,      
           @AmountWithCommission,  
     @ProductType,  
     @OrderId  
     )  
	 END
	 ELSE
	 BEGIN
	 Select  FkBookId from B2BMakepaymentCommission where FkBookId=@FkBookId
	 END
      
      
END 