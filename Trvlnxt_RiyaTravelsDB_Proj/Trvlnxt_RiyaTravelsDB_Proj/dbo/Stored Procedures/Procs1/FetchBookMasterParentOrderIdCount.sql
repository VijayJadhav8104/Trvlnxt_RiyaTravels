
CREATE PROC [dbo].[FetchBookMasterParentOrderIdCount]  
@OrderId varchar(30)  

AS BEGIN   
  
SELECT COUNT(DISTINCT orderId) FROM tblBookMaster WHERE orderId=@OrderId  OR ParentOrderId=@OrderId
  
END  