
CREATE Procedure [dbo].[API_UpdateB2BMakepaymentCommission]   
@OrderId  varchar(30)
,@PkID  varchar(30)  
AS  
  
BEGIN  

update B2BMakepaymentCommission set fkbookId = @PkID where OrderId = @OrderId
    
END  