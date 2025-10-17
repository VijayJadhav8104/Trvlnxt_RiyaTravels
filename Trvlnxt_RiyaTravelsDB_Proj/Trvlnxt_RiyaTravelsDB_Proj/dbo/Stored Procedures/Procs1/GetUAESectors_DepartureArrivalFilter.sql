CREATE PROCEDURE GetUAESectors_DepartureArrivalFilter
	
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT CODE FROM tblAirportCity WHERE MainCode = 'DXB'
	FOR JSON PATH

END
