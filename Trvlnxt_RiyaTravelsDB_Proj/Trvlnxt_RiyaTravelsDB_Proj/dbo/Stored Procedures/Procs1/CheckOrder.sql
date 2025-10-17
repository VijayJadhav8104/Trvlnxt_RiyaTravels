-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CheckOrder] 
	-- Add the parameters for the stored procedure here
	@Order int = null,
	@Country varchar(50)= null,
	@Id int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if not exists( select BannerOrder,Country from CMS_BackgroundBanner where BannerOrder=@Order and Country=@Country and IsActive=1 and PKID != @Id) 
	begin
		select 1 as MyFlag;
	end
	else
	begin
		select 0 as MyFlag;
	end



END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CheckOrder] TO [rt_read]
    AS [dbo];

