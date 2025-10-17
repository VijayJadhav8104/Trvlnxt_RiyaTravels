CREATE PROCEDURE GetPaymentStatus
(  
      @GDSPNR VARCHAR(100)  
)  
AS  
--DECLARE @ResultValue VARCHAR(100) = null   
BEGIN 
--set @ResultValue = (
select payment_mode from Paymentmaster p join tblBookMaster b on P.order_id= B.orderId where GDSPNR = @GDSPNR and BookingStatus = 3
--)

END
--RETURN @ResultValue 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPaymentStatus] TO [rt_read]
    AS [dbo];

