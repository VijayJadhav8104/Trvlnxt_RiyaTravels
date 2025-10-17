-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE UpdatefailedpaymentStatus  
  @OrderId varchar(20)   
AS  
BEGIN  
  Update Paymentmaster set order_status = 'Pending',payment_mode= 'Pending' WHERE order_id=@OrderID   
END  