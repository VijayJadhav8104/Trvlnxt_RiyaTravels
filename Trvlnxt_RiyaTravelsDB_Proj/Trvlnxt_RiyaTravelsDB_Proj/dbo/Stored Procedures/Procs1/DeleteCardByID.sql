CREATE PROC [dbo].[DeleteCardByID]
@pkid INT
AS
BEGIN
	BEGIN TRAN
				UPDATE tblCardMaster SET Status=0 WHERE pkid=@pkid;
	COMMIT TRAN
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeleteCardByID] TO [rt_read]
    AS [dbo];

