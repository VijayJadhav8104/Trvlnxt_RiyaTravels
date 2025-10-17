
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_ViewImonial]
	-- Add the parameters for the stored procedure here
	@id bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if(@id=0)
	begin
	select * from CMS_TestImonial where Status_ch <>'D'
	end
	else
	begin
	select * from CMS_TestImonial where Status_ch <>'D' and PKID=@id
	end
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_ViewImonial] TO [rt_read]
    AS [dbo];

