CREATE PROCEDURE [dbo].[UpdateGDSPNR]
@OrderId			varchar(30),
@GDSPNR				varchar(10),
@FromSector			varchar(20),
@ToSector			varchar(20),
@AERTicketTicketingDate Datetime=null,
@AERTicketFareTicketingDate Datetime=null,
@AERTicketFlowID	varchar(100)=null
AS BEGIN

	UPDATE tblBookMaster SET GDSPNR = @GDSPNR 
							,AERTicketTicketingDate=@AERTicketTicketingDate
							,AERTicketFareTicketingDate=@AERTicketFareTicketingDate
							,AERTicketFlowID=@AERTicketFlowID
	WHERE orderId = @OrderId AND frmSector = @FromSector and toSector = @ToSector

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateGDSPNR] TO [rt_read]
    AS [dbo];

