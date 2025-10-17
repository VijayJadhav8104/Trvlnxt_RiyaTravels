CREATE PROCEDURE [dbo].[GetAirlineCountry_ForVerify]
	@FromSector Varchar(10)
	,@ToSector Varchar(10)
AS
BEGIN
	
	DECLARE @CommonCarrier TABLE
	(
		Carrier VARCHAR(50)
	)

	INSERT INTO @CommonCarrier 
	VALUES ('Amadeus')
	, ('AmadeusNDC')
	, ('AerTicket')
	, ('Sabre')
	, ('SabreNDC')
	, ('EYNDC')
	, ('XMLAGENCY')
	, ('VerteilNDC')
	, ('PKFares')
	, ('STS')
	, ('GFNDC')

	SELECT DISTINCT Carrier, 0 AS IsDefault FROM tblAirlineSectors
	WHERE fromSector = @FromSector
	AND ToSector = @ToSector
	AND IsActive = 1

	UNION ALL

	SELECT Carrier, 1 AS IsDefault FROM @CommonCarrier
	
END