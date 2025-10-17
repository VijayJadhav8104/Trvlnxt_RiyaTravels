-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[About_Get] 
	-- Add the parameters for the stored procedure here
	@PageName nvarchar(100),
	@CountryName nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	----
    -- Insert statements for procedure here
	if(@PageName = 'About us')
		begin
			select * from CMS_PageContent where PageName='About us' and Country=@CountryName
		end
	
	else
		begin
			select * from CMS_PageContent where PageName='Disclaimer' and Country=@CountryName
		end

END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[About_Get] TO [rt_read]
    AS [dbo];

