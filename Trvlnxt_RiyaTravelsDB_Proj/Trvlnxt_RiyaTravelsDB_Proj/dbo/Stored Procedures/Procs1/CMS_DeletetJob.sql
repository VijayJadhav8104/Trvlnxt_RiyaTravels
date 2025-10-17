
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_DeletetJob]
	-- Add the parameters for the stored procedure here
	@id bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
   
	delete from CMS_JOB where PKID=@id
	
	
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_DeletetJob] TO [rt_read]
    AS [dbo];

