
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_ViewBanner]
@flag int,  -- for getting data in CMS as wll as front end
@Country varchar(2) =null		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
     
	 if (@flag=0)--B2C CMS
	 begin
		SELECT pkid, BannerName,BannerURL,ExpiryDate,BannerOrder,FromDate,Country from CMS_DealsBanner 
		order by bannerorder asc
	 end
	 ELSE
	 BEGIN
	 SELECT getdate(),pkid, BannerName,BannerURL,ExpiryDate,BannerOrder,FromDate,Country from CMS_DealsBanner 
		WHERE  fromdate <= getdate() and ExpiryDate >=GETDATE() and Country=@Country 
	 order by bannerorder asc
	 END
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_ViewBanner] TO [rt_read]
    AS [dbo];

