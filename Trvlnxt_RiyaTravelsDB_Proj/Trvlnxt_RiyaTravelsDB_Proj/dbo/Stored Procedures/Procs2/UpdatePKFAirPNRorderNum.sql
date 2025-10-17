-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[UpdatePKFAirPNRorderNum] 
	@OrderId varchar(30),
	@AirPNR varchar(200),
	@orderNum varchar(200),
	@isReturnJourney int
AS

BEGIN	
	UPDATE tblBookMaster SET PKForderNum = @orderNum
	WHERE orderId = @OrderId AND returnFlag=@isReturnJourney

	UPDATE tblBookItenary SET airlinePNR = @AirPNR 
	WHERE orderId = @OrderId and isReturnJourney=@isReturnJourney

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdatePKFAirPNRorderNum] TO [rt_read]
    AS [dbo];

