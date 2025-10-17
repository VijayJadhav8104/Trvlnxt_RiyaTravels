-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: < 07/Aug,2018,>
-- Description:	< Get All Blog Point Data For Edit Option... ,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllPointBlogData]
	-- Add the parameters for the stored procedure here
	
	@Id nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from BlogTemplateDetails where BlogId=@Id 
	order by OrderNumber asc

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllPointBlogData] TO [rt_read]
    AS [dbo];

