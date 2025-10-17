
CREATE  PROCEDURE [dbo].[CCAvenueAPI_Update_OrderStatusTracker]
@OrderId			varchar(30),
@Status				varchar(30)
AS BEGIN

	DECLARE @TrackingId	varchar(20)
	SET @TrackingId = (SELECT tRACKING_ID fROM Paymentmaster WHERE order_id = @OrderId);
	if(@TrackingId!='')
	BEGIN
	UPDATE Paymentmaster SET order_status = @Status
	WHERE order_id = @OrderId

	UPDATE Paymentissuance SET status = @Status WHERE tracking_id =@TrackingId

	END
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CCAvenueAPI_Update_OrderStatusTracker] TO [rt_read]
    AS [dbo];

