
CREATE PROCEDURE [dbo].[UpdateGDSPNR_InternationalReturnSTS]
@OrderId			varchar(50),
@GDSPNR				varchar(50)
AS BEGIN

	UPDATE tblBookMaster SET GDSPNR = @GDSPNR 
	WHERE orderId = @OrderId  

END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateGDSPNR_InternationalReturnSTS] TO [rt_read]
    AS [dbo];

