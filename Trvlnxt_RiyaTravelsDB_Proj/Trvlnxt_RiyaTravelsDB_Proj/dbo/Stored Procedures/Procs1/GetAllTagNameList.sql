
-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: <31/05/2018>
-- Description:	<Bind Tag Dropdown list on AddNewBlog page...,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllTagNameList]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	select * from TagsMaster

END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllTagNameList] TO [rt_read]
    AS [dbo];

