CREATE PROCEDURE SaveDataToCache    
@CacheKey VARCHAR(1700),     
@CachedData VARCHAR(MAX),    
@ExpirationDate DATETIME,    
@LocationId VARCHAR(150),
@LocationType VARCHAR(200)=NULL
AS    
BEGIN    
 DELETE FROM AllappLogs.Hotel.CacheItems WHERE CacheKey=@CacheKey    
    
 INSERT INTO AllappLogs.Hotel.CacheItems (CacheKey, CachedData, ExpirationDate, LocationId, LocationType)     
 VALUES (@CacheKey, @CachedData, /*@ExpirationDate*/DATEADD(HOUR, 24, GETDATE()), @LocationId, @LocationType)    
END 
