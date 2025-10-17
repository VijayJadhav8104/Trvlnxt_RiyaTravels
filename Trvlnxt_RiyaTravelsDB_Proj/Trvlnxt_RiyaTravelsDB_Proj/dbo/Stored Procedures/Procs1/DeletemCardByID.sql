CREATE PROC [dbo].[DeletemCardByID]
@pkid INT
AS
BEGIN
	BEGIN TRAN
				UPDATE mCardDetails SET Status=0 WHERE pkid=@pkid;
	COMMIT TRAN
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeletemCardByID] TO [rt_read]
    AS [dbo];

