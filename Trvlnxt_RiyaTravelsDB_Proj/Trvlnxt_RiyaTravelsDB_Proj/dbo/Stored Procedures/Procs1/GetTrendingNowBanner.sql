CREATE procedure [dbo].[GetTrendingNowBanner] 
@country varchar(2)
as
begin
select PKID, BannerType, ImagePath, Heading, Description, ImageButtonText, 
ImageButtonURL, SpecialBannerDesc, CreatedDate, IsActive from tblTrendingNow where IsActive=1
and CAST(StartDate as date)<= CAST(GETDATE() as date) and CAST(EndDate as date)>= CAST(GETDATE() as date)
and Country=@country
order by BannerOrder  
end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetTrendingNowBanner] TO [rt_read]
    AS [dbo];

