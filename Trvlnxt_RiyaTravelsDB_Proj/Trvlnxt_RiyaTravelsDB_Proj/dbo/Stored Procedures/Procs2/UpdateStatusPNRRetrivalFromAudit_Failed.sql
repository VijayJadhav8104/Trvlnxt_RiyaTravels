CREATE Procedure UpdateStatusPNRRetrivalFromAudit_Failed   --UpdateStatusPNRRetrivalFromAudit '1','2','6CN5OH',''      
@ID int,        
@Status varchar(10),          
@TicketNumber varchar(50),         
@ErrorMessage varchar(MAX)         
AS          
Begin          
Update PNRRetrivalFromAudit_Failed SET IsBookMasterInserted = @Status,IsBookMasterInsertedOn = GETDATE(),ErrorMessage = @ErrorMessage       
where ID = @ID and TicketNumber = @TicketNumber          
END