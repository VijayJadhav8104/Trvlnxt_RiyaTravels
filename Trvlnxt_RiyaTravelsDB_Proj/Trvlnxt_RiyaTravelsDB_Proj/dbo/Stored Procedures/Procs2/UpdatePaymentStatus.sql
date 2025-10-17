
CREATE PROCEDURE [dbo].[UpdatePaymentStatus]
@ORDERID VARCHAR(30)
AS BEGIN

	UPDATE paymentmaster SET order_status = 'Success' 
	WHERE order_id=@ORDERID

END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdatePaymentStatus] TO [rt_read]
    AS [dbo];

