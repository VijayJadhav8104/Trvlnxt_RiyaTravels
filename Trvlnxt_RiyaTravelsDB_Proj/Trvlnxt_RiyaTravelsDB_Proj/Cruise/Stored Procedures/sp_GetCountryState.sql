CREATE PROC [Cruise].[sp_GetCountryState]
AS
BEGIN
	SELECT * FROM COUNTRY

	SELECT * FROM mState WHERE status = 1
END
