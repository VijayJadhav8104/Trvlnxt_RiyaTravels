CREATE PROC sp_RBDMappingLog
	@ErrorMsg VARCHAR(MAX),@ReqJson VARCHAR(MAX),@DealMappingID INT=0
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO RBDMappingLog
	(ErrorMsg,ReqJson,DealMappingID,EntryDate)
	VALUES
	(@ErrorMsg,@ReqJson,@DealMappingID,GETDATE())
END
