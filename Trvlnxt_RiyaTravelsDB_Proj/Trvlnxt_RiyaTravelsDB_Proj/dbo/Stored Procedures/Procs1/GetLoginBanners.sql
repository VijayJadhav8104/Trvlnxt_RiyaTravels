CREATE procedure [dbo].[GetLoginBanners]

as
begin
 select * from mLoginBanners where IsActive=1 ORDER BY BannerPosition
end