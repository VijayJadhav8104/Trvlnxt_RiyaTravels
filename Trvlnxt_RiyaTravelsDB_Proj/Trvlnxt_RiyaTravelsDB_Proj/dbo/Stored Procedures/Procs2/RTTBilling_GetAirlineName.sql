CREATE PROCEDURE RTTBilling_GetAirlineName
	@AirlineCode Varchar(5)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT TOP 1 _NAME AS AirlineName FROM AirlinesName WHERE _CODE = @AirlineCode
END