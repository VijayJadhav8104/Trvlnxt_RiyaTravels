CREATE PROC [dbo].[GetCountryCodeByCountry]
	@Country VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	Select top 1 CountryCode,Currency  from mCountry Where CountryName=@Country
END