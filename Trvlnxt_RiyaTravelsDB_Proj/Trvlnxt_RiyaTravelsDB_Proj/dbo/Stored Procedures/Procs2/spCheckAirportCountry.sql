


CREATE PROCEDURE [dbo].[spCheckAirportCountry]
    @depFrom VARCHAR(10),
    @depTo VARCHAR(10)
AS
BEGIN
    SELECT * 
    FROM tblAirportCity 
    WHERE CODE IN (@depFrom, @depTo) 
      AND country = 'SA';
END;


