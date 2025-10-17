
CREATE PROCEDURE [dbo].[CMS_InsertBanner]
	-- Add the parameters for the stored procedure here
	@BannerName VARCHAR(100),
	@BannerURL varchar(100),
	@ExpiryDate datetime,
	@BannerOrder int,
	@FromDate   datetime,
	@Country    varchar(2)
AS
BEGIN
	
	SET NOCOUNT ON;


	 if not exists(select PKID from CMS_DealsBanner where BannerName=@BannerName and Country=@Country)

	 begin
		insert into CMS_DealsBanner(BannerName,BannerURL,ExpiryDate,BannerOrder,FromDate,Country) 
		values(@BannerName,@BannerURL,@ExpiryDate,@BannerOrder,@FromDate,@Country)
		select 1
	end
	else
		begin
		select 2
		end
	
END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_InsertBanner] TO [rt_read]
    AS [dbo];

