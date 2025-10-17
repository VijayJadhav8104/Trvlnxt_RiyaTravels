
create proc [dbo].[GetAllCountryFlag]
AS
BEGIN
		BEGIN
			SELECT Id,CountryName from countryFlag
		END
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllCountryFlag] TO [rt_read]
    AS [dbo];

