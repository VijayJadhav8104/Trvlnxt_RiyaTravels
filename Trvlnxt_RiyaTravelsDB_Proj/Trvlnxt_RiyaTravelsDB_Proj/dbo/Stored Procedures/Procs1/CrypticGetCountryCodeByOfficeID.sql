CREATE PROCEDURE CrypticGetCountryCodeByOfficeID
	@OfficeId varchar(20)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT TOP 1 Value AS CountryCode FROM mVendorCredential
	WHERE OfficeID = @OfficeId
	AND FieldName = 'COUNTRYCODE'

END
