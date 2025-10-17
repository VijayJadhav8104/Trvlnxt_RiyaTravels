CREATE PROCEDURE [dbo].[GetCarrierByAirCode]
	@Aircode Varchar(5)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT TOP 1 type  FROM AirlineCode_Console 
	WHERE AirlineCode = @Aircode 

END
