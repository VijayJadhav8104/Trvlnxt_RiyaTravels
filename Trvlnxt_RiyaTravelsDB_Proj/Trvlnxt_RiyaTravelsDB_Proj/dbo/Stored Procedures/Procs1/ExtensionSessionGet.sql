-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE ExtensionSessionGet

 @id varchar (20)
	
AS
BEGIN
	
	SELECT SessionData from ExtensionSessions where id=@id
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[ExtensionSessionGet] TO [rt_read]
    AS [dbo];

