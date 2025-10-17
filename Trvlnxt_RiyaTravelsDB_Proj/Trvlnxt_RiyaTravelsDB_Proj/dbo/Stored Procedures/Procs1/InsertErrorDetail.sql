
CREATE PROCEDURE [dbo].[InsertErrorDetail] 
	@unqPNR int,
	@startTime  varchar(20),
	@queCount	int,
	@pnrInserted int,
	@endTime  varchar(20),
	@errMsg int,
	@stackTrace varchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	INSERT INTO AmadeusErrorLog
              (unqPNR, startTime, queCount, pnrInserted, endTime, errMsg,stackTrace)
       VALUES
              (@unqPNR, @startTime, @queCount, @pnrInserted, @endTime, @errMsg, @stackTrace)
END
