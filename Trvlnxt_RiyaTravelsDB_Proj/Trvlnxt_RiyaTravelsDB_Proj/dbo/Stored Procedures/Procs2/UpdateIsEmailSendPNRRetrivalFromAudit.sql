CREATE Procedure UpdateIsEmailSendPNRRetrivalFromAudit   --UpdateStatusPNRRetrivalFromAudit '1','2','6CN5OH',''      
@ID int,        
@IsEmailSend bit,          
@TicketNumber varchar(50)        
AS          
Begin          
Update PNRRetrivalFromAudit SET IsEmailSend = @IsEmailSend 
where ID = @ID and TicketNumber = @TicketNumber          
END