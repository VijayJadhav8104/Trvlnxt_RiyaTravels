
CREATE PROCEDURE [dbo].[CMS_ViewBackgroundBanner]
@flag int,  -- for getting data in CMS as wll as front end
@Country varchar(2) =null		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
     
	 if (@flag=0)--B2C CMS
	 begin
	 SELECT pkid,BannerName,BannerURL,ExpiryDate,BannerOrder,FromDate,Country FROM CMS_BackgroundBanner 
	 ORDER BY bannerorder ASC
	 END
	 ELSE
	 BEGIN
	 SELECT getdate(),pkid,BannerName,BannerURL,ExpiryDate,BannerOrder,FromDate,Country	from CMS_BackgroundBanner WHERE fromdate <= getdate() and ExpiryDate >=GETDATE() and Country=@Country ORDER BY bannerorder ASC
	 END
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_ViewBackgroundBanner] TO [rt_read]
    AS [dbo];

