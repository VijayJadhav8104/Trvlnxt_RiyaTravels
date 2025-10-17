CREATE PROCEDURE [dbo].[AddCacheLogToDB_MultiAvailability]  
	@LogKey varchar(200) = NULL  
	,@LogData varchar(max) = NULL
	,@DepartureDate date = NULL
	,@APIName varchar(200) = NULL
	,@fromSec varchar(50) = NULL
	,@toSec varchar(50) = NULL
	,@isReturn varchar(10) = NULL
	,@SelectedFrom varchar(5) = NULL
AS
BEGIN
	IF EXISTS (SELECT Id FROM CacheLogs_MultiAvailability WITH (UPDLOCK,SERIALIZABLE) WHERE LogKey = @LogKey AND SelectedFrom = @SelectedFrom)
	BEGIN  
		UPDATE CacheLogs_MultiAvailability SET LogData = @LogData WHERE LogKey = @LogKey AND SelectedFrom = @SelectedFrom
	END  
	ELSE  
	BEGIN  
		INSERT INTO CacheLogs_MultiAvailability (LogKey,LogData,DepartureDate,APIName,FromSector,ToSector,IsReturn,SelectedFrom)
		VALUES (@LogKey, @LogData,@DepartureDate,@APIName,@fromSec,@toSec,@isReturn,@SelectedFrom)  
	END
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AddCacheLogToDB_MultiAvailability] TO [rt_read]
    AS [dbo];

