CREATE proc [dbo].[UpdateBookMaster_PassengerDetails_Paymentmaster]      
@IATACommission decimal(10,2)= 0.0,      
@PLBCommission decimal(10,2)= 0.0,      
@DropnetCommission decimal(10,2)= 0.0,      
@B2BMarkup decimal(10,2)= 0.0,      
@BFC int = 0,      
@MCOAmount decimal(10,2)= 0.0,      
@serviceCharge decimal(10,2)= 0.0,      
@GST decimal(10,2)= 0.0,      
@GDSPNR varchar(10),      
@RiyaPNR varchar(10),      
@OrderId varchar(100),      
@amount varchar(50) = '0'  ,    
@airLinePNR varchar(10) = '',    
@arrivalDate varchar(50) = '',      
@travClass varchar(50) = '',
@MainAgentId int = 0
As      
BEGIN      
      
Update tblPassengerBookDetails set IATACommission = @IATACommission,PLBCommission = @PLBCommission,DropnetCommission = @DropnetCommission      
,B2BMarkup = @B2BMarkup,BFC = @BFC,MCOAmount = @MCOAmount,ServiceFee = @serviceCharge,GST = @GST      
where fkBookMaster in (Select pkid from tblBookMaster where GDSPNR = @GDSPNR AND riyaPNR = @RiyaPNR AND orderId = @OrderId)      
      
Update tblBookMaster set IATACommission = @IATACommission,PLBCommission = @PLBCommission,B2BMarkup = @B2BMarkup,BFC = @BFC      
,MCOAmount = @MCOAmount,ServiceFee = @serviceCharge,GST = @GST ,arrivalDate= @arrivalDate
--, MainAgentId= @MainAgentId    
where GDSPNR = @GDSPNR AND riyaPNR = @RiyaPNR AND orderId = @OrderId      
      
update Paymentmaster set amount = @amount , mer_amount = @amount where order_id = @OrderId      
      
      
update tblBookItenary set airlinePNR=@airLinePNR,cabin=@travClass    
where pkId in( select top 1 pkId from tblBookItenary where  orderId = @OrderId order by pkId)    
    
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateBookMaster_PassengerDetails_Paymentmaster] TO [rt_read]
    AS [dbo];

