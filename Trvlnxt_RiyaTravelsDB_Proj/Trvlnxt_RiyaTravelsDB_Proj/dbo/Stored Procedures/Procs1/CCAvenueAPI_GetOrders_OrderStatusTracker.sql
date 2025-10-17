
CREATE  PROCEDURE [dbo].[CCAvenueAPI_GetOrders_OrderStatusTracker]

AS BEGIN
	
	SELECT P.OrderId , P.tracking_id TrackingId  
	FROM  Paymentissuance P
	WHERE DATEDIFF(MI,P.inserteddt_dt,GETDATE()) >44 AND 
	(P.Status = 'Successful' OR P.Status = 'Success' or P.Status is null) 
	and p.OrderId is not null and p.Tracking_Id is not null AND  p.Tracking_Id !='0'
		order by inserteddt_dt desc
	
	
END













GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CCAvenueAPI_GetOrders_OrderStatusTracker] TO [rt_read]
    AS [dbo];

