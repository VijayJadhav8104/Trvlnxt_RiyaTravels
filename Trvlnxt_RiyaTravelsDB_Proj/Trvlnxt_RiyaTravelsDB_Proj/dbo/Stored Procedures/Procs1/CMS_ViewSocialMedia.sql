
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_ViewSocialMedia]
	-- Add the parameters for the stored procedure here
	@type char(1),
	@id bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@id=0)
    begin
	SELECT * from CMS_SocialRelease where type_ch=@type
	end
	else
	begin
	select * from CMS_SocialRelease where PKID_in=@id
	end
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_ViewSocialMedia] TO [rt_read]
    AS [dbo];

