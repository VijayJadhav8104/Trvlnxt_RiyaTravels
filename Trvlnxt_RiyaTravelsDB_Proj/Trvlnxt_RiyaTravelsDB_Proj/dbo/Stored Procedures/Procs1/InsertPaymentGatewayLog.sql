  
  
CREATE PROCEDURE [dbo].[InsertPaymentGatewayLog]  
 -- Add the parameters for the stored procedure here  
  @OrderID VARCHAR(30),  
  @Request varchar(max)=null,  
  @Response varchar(max)=null,  
  @RequestDate Datetime=null,  
  @ResponseDate Datetime=null,  
  @Country varchar(20)=null,  
  @Flag   int -- 0 for Insert and 1 for Update  
    
AS  
BEGIN  
  if(@Flag=0)   
  begin  
   insert into PaymentGatewayLog  
   (OrderID,Request,Country,RequestDate)  
   values(@OrderID,@Request,@Country,@RequestDate)  
  end  
  else  
  begin  
   update PaymentGatewayLog  
   set Response=@Response, ResponseDate=@ResponseDate  
   where OrderID=@OrderID  
     
  end  
END  
  
  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertPaymentGatewayLog] TO [rt_read]
    AS [dbo];

