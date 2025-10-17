
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_ViewJob]
	-- Add the parameters for the stored procedure here
	@id bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from 
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@id=0)
    Begin
	SELECT * from CMS_JOB 
	End
	else
	Begin
	SELECT * from CMS_JOB where PKID=@id
	End
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_ViewJob] TO [rt_read]
    AS [dbo];

