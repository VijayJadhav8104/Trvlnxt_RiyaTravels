-- =============================================
-- Author:		Hardik
-- Create date: 01.08.2023
-- Description:	Update Booking Status
-- =============================================
CREATE PROCEDURE [dbo].[BookMaster_UpdateBookingStatusManualTicketing]
	@OrderID Varchar(50)
	,@AirlinePNR Varchar(10)
	,@GDSPNR Varchar(10)
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE tblBookMaster SET BookingStatus = 1, IsBooked = 1 
	WHERE pkId IN (
		SELECT tblBookMaster.pkId FROM tblBookItenary with (nolock)
		INNER JOIN tblBookMaster with (nolock) ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
		WHERE (airlinePNR = @AirlinePNR OR tblBookMaster.GDSPNR = @GDSPNR) 
		AND BookingStatus = 0 
		AND IsBooked = 0 AND 
		BookingSource = 'Manual Ticketing'
		AND tblBookMaster.orderId = @OrderID
	)
	
END