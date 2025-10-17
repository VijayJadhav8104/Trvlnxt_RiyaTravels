
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetCancellationCharges]
	@PNR varchar(20) = NULL
AS
BEGIN
	SELECT ISNULL(sum(CancellationCharge),0) as CancellationCharge FROM tblPassengerBookDetails WHERE fkBookMaster = (SELECT TOP 1 pkId FROM tblBookItenary b WHERE b.airlinePNR=@PNR)
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetCancellationCharges] TO [rt_read]
    AS [dbo];

