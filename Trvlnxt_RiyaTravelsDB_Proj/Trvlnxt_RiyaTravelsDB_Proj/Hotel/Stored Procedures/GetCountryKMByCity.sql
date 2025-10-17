CREATE PROCEDURE Hotel.GetCountryKMByCity
@City VARCHAR(100)
AS
BEGIN
	SELECT Country,KM FROM Hotel.HotelCountrySearch WITH (NOLOCK) WHERE IsActive=1 AND City=@City
END
