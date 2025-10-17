CREATE Procedure [dbo].[GetPaymentCommissionByOrderId]  
@ProductType varchar(40)='',  
@OrderId  varchar(40)=''  
AS  
  
BEGIN  
select ModeOfPayment,ConvenienFeeInPercent,TotalCommission  
,AmountBeforeCommission,AmountWithCommission from B2BMakepaymentCommission where ProductType=@ProductType and OrderId=@OrderId     
END  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPaymentCommissionByOrderId] TO [rt_read]
    AS [dbo];

