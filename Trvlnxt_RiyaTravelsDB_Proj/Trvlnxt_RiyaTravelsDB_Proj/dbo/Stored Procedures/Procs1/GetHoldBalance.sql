
CREATE PROCEDURE [dbo].[GetHoldBalance] -- 'RT20201130165300515'
--@UserId				int, 
@orderid			varchar(30)
AS 
BEGIN 
	
	
	


	SELECT p.amount , isnull (P.IsHold,0) IsHold,payment_mode  from Paymentmaster  p join tblBookMaster t  on t.orderid= p.order_id 
	where order_id  = @orderid 
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetHoldBalance] TO [rt_read]
    AS [dbo];

