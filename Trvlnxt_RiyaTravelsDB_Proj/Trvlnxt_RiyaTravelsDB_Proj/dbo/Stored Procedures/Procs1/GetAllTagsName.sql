﻿-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: <06/06/2018>
-- Description:	<Final All Tags Name And Id,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllTagsName] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select Id,TagName from TagsMaster
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllTagsName] TO [rt_read]
    AS [dbo];

