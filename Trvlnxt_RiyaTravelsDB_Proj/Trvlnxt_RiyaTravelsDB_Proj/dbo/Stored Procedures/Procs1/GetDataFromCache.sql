CREATE PROCEDURE GetDataFromCache
@CacheKey VARCHAR(1700) 
AS
BEGIN
	SELECT CachedData FROM AllappLogs.Hotel.CacheItems WHERE CacheKey = @CacheKey AND ExpirationDate > GETDATE()
END
