
CREATE PROCEDURE [dbo].[GetPaymentDetails]
@OrderId		varchar(30)
AS BEGIN
	SELECT *  FROM [Paymentmaster]
	WHERE order_id = @OrderId
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPaymentDetails] TO [rt_read]
    AS [dbo];

