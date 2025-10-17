CREATE proc [dbo].[UpdatePassengerDetails]    
@IATACommission decimal(10,2)= 0.0,    
@PLBCommission decimal(10,2)= 0.0,    
@DropnetCommission decimal(10,2)= 0.0,    
@B2BMarkup decimal(10,2)= 0.0,    
@BFC int = 0,    
@MCOAmount decimal(10,2)= 0.0,    
@serviceCharge decimal(10,2)= 0.0,    
@GST decimal(10,2)= 0.0,    
@Pid int = 0
  
As    
BEGIN    
    
Update tblPassengerBookDetails set IATACommission = @IATACommission,PLBCommission = @PLBCommission,DropnetCommission = @DropnetCommission    
,B2BMarkup = @B2BMarkup,BFC = @BFC,MCOAmount = @MCOAmount,ServiceFee = @serviceCharge,GST = @GST    
where pid = @Pid
    
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdatePassengerDetails] TO [rt_read]
    AS [dbo];

