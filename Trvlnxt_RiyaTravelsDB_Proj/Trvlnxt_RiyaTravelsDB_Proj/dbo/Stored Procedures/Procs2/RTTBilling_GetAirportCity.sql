CREATE PROCEDURE RTTBilling_GetAirportCity
	@CityCode Varchar(5)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT TOP 1 NAME FROM tblAirportCity WHERE CODE = @CityCode
END