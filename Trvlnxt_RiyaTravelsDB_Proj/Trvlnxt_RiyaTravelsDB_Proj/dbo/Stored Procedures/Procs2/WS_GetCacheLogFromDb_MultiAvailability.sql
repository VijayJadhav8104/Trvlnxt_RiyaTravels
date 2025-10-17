CREATE PROCEDURE [dbo].[WS_GetCacheLogFromDb_MultiAvailability]
	@LogKey varchar(300),
	@SelectedFrom Varchar(5),
	@cacheflag Int = 1
AS       
BEGIN
  
	IF(@cacheflag=1)
	BEGIN
		SELECT LogData FROM CacheLogs_MultiAvailability(NOLOCK) WHERE LogKey = @LogKey AND SelectedFrom = @SelectedFrom;    
	END
	ELSE
	BEGIN
		SELECT LogData FROM CacheLogs_MultiAvailability(NOLOCK) WHERE LogKey='1' AND SelectedFrom = @SelectedFrom; 
	END
  
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[WS_GetCacheLogFromDb_MultiAvailability] TO [rt_read]
    AS [dbo];

