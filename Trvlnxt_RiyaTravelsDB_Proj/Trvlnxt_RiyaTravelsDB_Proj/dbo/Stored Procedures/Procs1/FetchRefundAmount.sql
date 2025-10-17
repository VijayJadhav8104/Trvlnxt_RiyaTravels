
			----	[dbo].[FetchRefundAmount] 'Z23R73', '38Y48B'

CREATE PROCEDURE [dbo].[FetchRefundAmount]
@RiyaPNR varchar(8),
@GDSPNR varchar(8)
AS BEGIN

	
	SELECT BM.OrderId, P.tracking_id, b.RefundAmount, BM.RemainingRefund
	FROM CancellationHistory b
	JOIN BookMaster BM ON BM.OrderId = B.OrderId
	JOIN Paymentmaster P ON P.order_id = B.OrderId
	WHERE BM.GDSPNR=@GDSPNR AND b.RiyaPNR = @RiyaPNR AND B.IsActive=1
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchRefundAmount] TO [rt_read]
    AS [dbo];

