
CREATE PROCEDURE [dbo].[UpdateTFBookingRefSTS]
@OrderId			varchar(20),
@TFBookingRef		varchar(100)
AS BEGIN

	UPDATE tblBookMaster SET TFBookingRef = @TFBookingRef
	WHERE orderId = @OrderId  

END

