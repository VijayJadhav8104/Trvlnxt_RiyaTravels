-- =============================================
-- Author:		Hardik Deshani
-- Create date: 27.03.2023
-- Description:	Get Dial Code by Country Code
-- =============================================
CREATE PROCEDURE Country_GetCountryCode
	@CountryCode Varchar(5)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT TOP 1 code AS DialCode FROM Country (NOLOCK) WHERE A1 = @CountryCode
END