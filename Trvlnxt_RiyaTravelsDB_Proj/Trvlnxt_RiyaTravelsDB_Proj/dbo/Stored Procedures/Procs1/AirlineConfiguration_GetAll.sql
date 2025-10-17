CREATE PROCEDURE AirlineConfiguration_GetAll
	
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT AirlineIDP
	, AirlineName
	, AirlineCode
	, AirlineFilterName
	, AirlineAPITimeoutSec
	, IsActive
	FROM AirlineConfiguration WHERE IsActive = 1
	FOR JSON PATH

END
