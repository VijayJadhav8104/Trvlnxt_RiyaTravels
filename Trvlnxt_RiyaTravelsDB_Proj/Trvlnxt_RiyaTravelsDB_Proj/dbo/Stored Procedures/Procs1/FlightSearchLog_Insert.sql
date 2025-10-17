CREATE PROCEDURE FlightSearchLog_Insert
	@CacheKey Varchar(500)
	,@LogData NVarchar(MAX)
	,@DepDate DateTime
	,@TravelFrom Varchar(10)
	,@TravelTo Varchar(10)
	,@FromIndex Int
	,@ToIndex Int
	,@APIName Varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO FlightSearchLog (CacheKey, LogData, DepDate, TravelFrom, TravelTo, FromIndex, ToIndex, APIName)
	VALUES (@CacheKey, @LogData, @DepDate, @TravelFrom, @TravelTo, @FromIndex, @ToIndex, @APIName)

END
