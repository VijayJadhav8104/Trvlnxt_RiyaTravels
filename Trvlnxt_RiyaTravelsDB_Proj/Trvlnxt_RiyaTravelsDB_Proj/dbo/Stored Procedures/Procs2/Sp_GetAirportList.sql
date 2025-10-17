CREATE Procedure [dbo].[Sp_GetAirportList]
AS
BEGIN
	SELECT AirportId
		, AirportName 
	FROM AirportType WITH(NOLOCK)
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAirportList] TO [rt_read]
    AS [dbo];

