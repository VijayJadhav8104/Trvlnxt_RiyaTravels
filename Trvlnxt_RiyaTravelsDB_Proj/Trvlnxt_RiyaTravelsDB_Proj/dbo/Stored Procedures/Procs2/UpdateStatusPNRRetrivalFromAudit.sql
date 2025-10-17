CREATE Procedure UpdateStatusPNRRetrivalFromAudit   --UpdateStatusPNRRetrivalFromAudit '1','2','6CN5OH',''      
@ID int,        
@Status varchar(10),          
@TicketNumber varchar(50),         
@ErrorMessage varchar(MAX)         
AS          
Begin          
Update PNRRetrivalFromAudit SET IsBookMasterInserted = @Status,IsBookMasterInsertedOn = GETDATE(),ErrorMessage = @ErrorMessage       
where ID = @ID and TicketNumber = @TicketNumber    

if LEN(@TicketNumber) >= 10
begin 
	update tblBookMaster set TicketIssuanceError = @ErrorMessage 
	where pkId in (Select fkBookMaster from tblPassengerBookDetails where TicketNumber = @TicketNumber OR ticketNum = @TicketNumber)
end
else 
begin
	update tblBookMaster set TicketIssuanceError = @ErrorMessage 
	where GDSPNR = @TicketNumber
end

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateStatusPNRRetrivalFromAudit] TO [rt_read]
    AS [dbo];

