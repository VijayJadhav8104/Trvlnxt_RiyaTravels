
CREATE PROC [dbo].[UpdateBookingFailedOrPendingStatus]
 @OrderId varchar(50),
 @BookingStatus INT,
 @Error varchar(500)

AS
BEGIN

UPDATE tblBookMaster set bookingstatus=@BookingStatus,TicketIssuanceError=@Error where orderId=@OrderId;

END



