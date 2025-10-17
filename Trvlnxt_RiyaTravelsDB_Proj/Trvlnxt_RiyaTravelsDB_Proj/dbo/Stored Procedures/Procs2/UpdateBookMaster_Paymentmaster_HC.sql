CREATE proc [dbo].[UpdateBookMaster_Paymentmaster_HC]      
@IATACommission decimal(10,2)= 0.0,      
@PLBCommission decimal(10,2)= 0.0,  
@B2BMarkup decimal(10,2)= 0.0,      
@BFC int = 0,      
@MCOAmount decimal(10,2)= 0.0,      
@serviceCharge decimal(10,2)= 0.0,      
@GST decimal(10,2)= 0.0,      
@GDSPNR varchar(10) = '',  
@RiyaPNR varchar(10) = '',  
@OrderId varchar(50) = '',  
@amount decimal(10,2)= 0.0,
@MainAgentId int = 0
    
As      
BEGIN      
      
Update tblBookMaster set IATACommission = @IATACommission,PLBCommission = @PLBCommission,B2BMarkup = @B2BMarkup,BFC = @BFC      
,MCOAmount = @MCOAmount,ServiceFee = @serviceCharge,GST = @GST, MainAgentId= @MainAgentId    
where pkid in (Select top 1 pkid from tblBookMaster where GDSPNR = @GDSPNR AND riyaPNR = @RiyaPNR AND orderId = @OrderId)     
      
update Paymentmaster set amount = @amount , mer_amount = @amount where order_id = @OrderId  
      
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateBookMaster_Paymentmaster_HC] TO [rt_read]
    AS [dbo];

