CREATE PROCEDURE FlightSearchLog_Get
	@CacheKey Varchar(500)
	,@FromIndex Int
	,@ToIndex Int
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT TOP 1 LogData FROM FlightSearchLog
	WHERE CacheKey = @CacheKey
	AND FromIndex >= @FromIndex AND ToIndex <= @ToIndex

END
