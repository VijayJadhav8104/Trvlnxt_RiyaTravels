
CREATE proc [dbo].[UpdateGDSAndAirlinePNR]
          @GDSPNR  varchar(20),
		  @AirlinePNR varchar(20),
		  @OrderID varchar(50)  
AS
BEGIN
	UPDATE tblBookMaster SET GDSPNR=@GDSPNR where orderId=@OrderID
	UPDATE tblBookItenary SET airlinePNR=@AirlinePNR where orderId=@OrderID
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateGDSAndAirlinePNR] TO [rt_read]
    AS [dbo];

