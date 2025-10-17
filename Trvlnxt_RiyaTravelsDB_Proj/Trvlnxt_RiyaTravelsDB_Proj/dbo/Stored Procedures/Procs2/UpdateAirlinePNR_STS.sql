
CREATE PROCEDURE [dbo].[UpdateAirlinePNR_STS]
@OrderId			varchar(20),
@AirlinePNR			varchar(30)

AS
BEGIN
	UPDATE tblBookItenary SET airlinePNR = @AirlinePNR 
	WHERE orderId = @OrderId 

END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateAirlinePNR_STS] TO [rt_read]
    AS [dbo];

