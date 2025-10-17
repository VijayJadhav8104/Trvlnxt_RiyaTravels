CREATE Procedure [dbo].[GetBookIdByOrderId]   
@OrderId  varchar(30)  
AS  
  
BEGIN  
Select pkid  from tblBookMaster where orderId=@OrderId  
    
END  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetBookIdByOrderId] TO [rt_read]
    AS [dbo];

