-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: <Create Date,,>
-- Description:	<Final Blog Set Flag ,,>
-- =============================================
CREATE PROCEDURE [dbo].[FirstSetBlogFlag]
	-- Add the parameters for the stored procedure here
	@Bid nvarchar(max)
	

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	 update BlogMaster set Preview_Flag='A'				
		where Id=@Bid


END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FirstSetBlogFlag] TO [rt_read]
    AS [dbo];

