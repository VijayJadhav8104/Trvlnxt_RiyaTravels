CREATE PROC [dbo].[GetCountryByCode]
	@CountryCode VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	Select top 1 CountryName,Currency  from mCountry Where CountryCode=@CountryCode
END