
CREATE PROCEDURE [dbo].[UpdateTicketMail]
@orderid varchar (50),
@flag bit
AS BEGIN
	
	
	Update tblBookMaster set TicketMail=@flag
	where orderId = @orderid
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateTicketMail] TO [rt_read]
    AS [dbo];

