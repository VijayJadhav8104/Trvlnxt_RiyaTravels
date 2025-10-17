
-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: <31/05/2018>
-- Description:	<Show All Tags ...,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTagsDetails]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	select * from tagsmaster

END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetTagsDetails] TO [rt_read]
    AS [dbo];

