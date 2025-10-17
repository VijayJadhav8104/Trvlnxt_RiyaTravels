CREATE PROC [dbo].[GetCardDetailsById]
@pkid INT
AS
BEGIN
	SELECT * FROM tblCardMaster WHERE pkid=@pkid AND Status=1;
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetCardDetailsById] TO [rt_read]
    AS [dbo];

