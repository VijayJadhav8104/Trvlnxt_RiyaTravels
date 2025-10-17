-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_TJQFailRecDelete
	@id int = null
AS
BEGIN
	delete from PNRRetrivalFromAudit where Id = @id
END
