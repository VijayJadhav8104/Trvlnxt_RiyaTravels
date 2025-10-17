
CREATE PROC [dbo].[CMS_GetBackgroundBanner] --'IN'
  @Country varchar(100),
  @Flag varchar(50)=null
  AS
  BEGIN
		
			SELECT BannerName,BannerURL FROM CMS_BackgroundBanner WHERE Country=@Country AND  Flag=@Flag	
			AND	CONVERT(date, FromDate)<=CONVERT(date,GETDATE()) AND CONVERT(date, ExpiryDate)>=CONVERT(date,GETDATE())
			order by BannerOrder
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_GetBackgroundBanner] TO [rt_read]
    AS [dbo];

