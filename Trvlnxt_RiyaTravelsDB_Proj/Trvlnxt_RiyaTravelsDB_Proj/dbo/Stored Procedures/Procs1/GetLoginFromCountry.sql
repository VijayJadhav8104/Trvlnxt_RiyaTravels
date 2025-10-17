CREATE PROC GetLoginFromCountry
AS
BEGIN
	SET NOCOUNT ON;
	Select UPPER(country) AS country,A1 from Country
END