CREATE PROC GetCountryByCountryCode
	@country_code VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	Select top 1 CountryName from mCountry Where CountryCode=@country_code
END
