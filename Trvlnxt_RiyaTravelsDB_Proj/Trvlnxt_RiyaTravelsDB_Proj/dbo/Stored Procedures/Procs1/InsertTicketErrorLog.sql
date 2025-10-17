

CREATE PROCEDURE [dbo].[InsertTicketErrorLog]
@OrderId			varchar(50)  = NULL,
@GDSPNR				varchar(10)  = NULL,
@Error				varchar(2000) = NULL

AS BEGIN

	UPDATE tblBookMaster SET TicketIssuanceError = @Error
	WHERE orderId = @OrderId AND (@GDSPNR = @GDSPNR OR (@GDSPNR = NULL or @GDSPNR is null))

END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertTicketErrorLog] TO [rt_read]
    AS [dbo];

