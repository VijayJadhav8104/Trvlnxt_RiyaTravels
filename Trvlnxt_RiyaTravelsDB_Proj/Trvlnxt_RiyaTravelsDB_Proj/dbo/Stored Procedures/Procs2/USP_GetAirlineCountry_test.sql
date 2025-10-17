
CREATE PROC [dbo].[USP_GetAirlineCountry_test]--  exec USP_GetAirlineCountry_test  'LHR','TF','BOM'
	@fromsector Varchar(10)
	, @Carrier Varchar(10)
	, @ToSectors Varchar(5) = NULL
 AS
 BEGIN
 
	IF @Carrier IN ('QP', 'I5', 'IX', 'SG', 'G8', '6E', 'J9', 'G9', 'TF', '3L', 'FZ', 'OV', '8D', 'FT', 'PA','OAPI','5J')
	BEGIN
		SELECT * FROM tblAirlineSectors
		WHERE Carrier = @Carrier
		AND fromSector = @fromsector
		AND ToSector = @ToSectors
		AND IsActive = 1
	END
	ELSE
	BEGIN
		SELECT * FROM tblAirlineCountry
		WHERE Carrier = @Carrier
		AND CountryCode = (SELECT TOP 1 COUNTRY FROM tblAirportCity WHERE CODE = @fromsector)
	END
 END
--select * from tblAirlineSectors where Carrier='6e' and fromSector='blr'