
CREATE PROCEDURE [dbo].[GetServiceChargeLCC]
	
AS
BEGIN
	SELECT SectorType,AirCode,amount 
	FROM ServiceCharges 
	WHERE AirCode in ('SG','G8','6E') AND IsActive=1

	--Discount
END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetServiceChargeLCC] TO [rt_read]
    AS [dbo];

