
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_DeleteTestImonial] 
	-- Add the parameters for the stored procedure here
	@id bigint
	--@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	delete from CMS_TestImonial where PKID=@id
	
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_DeleteTestImonial] TO [rt_read]
    AS [dbo];

