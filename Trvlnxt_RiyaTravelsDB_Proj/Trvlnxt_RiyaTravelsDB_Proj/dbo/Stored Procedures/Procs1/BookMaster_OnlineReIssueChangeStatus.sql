CREATE PROCEDURE BookMaster_OnlineReIssueChangeStatus
	@ItineraryIDs Varchar(200)
	,@RiyaPNR Varchar(50)
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE tblBookMaster 
	SET BookingStatus = 1 
	WHERE pkID IN (SELECT fkBookMaster FROM tblBookItenary WHERE pkId IN (SELECT Item FROM dbo.SplitString(@ItineraryIDs, ',')))
	AND riyaPNR = @RiyaPNR
	AND BookingStatus = 7

END