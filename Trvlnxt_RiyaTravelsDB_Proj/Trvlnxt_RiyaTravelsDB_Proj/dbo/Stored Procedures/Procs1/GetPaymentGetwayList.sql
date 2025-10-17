  
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE GetPaymentGetwayList  
   
AS  
BEGIN   
   select PG_Id,Name from PaymentGatewayMaster where IsActive=1    
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPaymentGetwayList] TO [rt_read]
    AS [dbo];

