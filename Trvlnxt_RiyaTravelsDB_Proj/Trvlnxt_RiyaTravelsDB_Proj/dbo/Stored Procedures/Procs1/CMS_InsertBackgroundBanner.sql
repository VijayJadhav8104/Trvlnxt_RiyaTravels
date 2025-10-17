CREATE PROC [dbo].[CMS_InsertBackgroundBanner]
@BannerName VARCHAR(100)= null,
@BannerURL varchar(100)= null,
@ExpiryDate datetime = null,
@BannerOrder int = null,
@FromDate   datetime = null,
@Country    varchar(2) = null,
@Flag varchar(50) = null,
@Action varchar(50)=null,
@Id int = null
AS
BEGIN
	
	SET NOCOUNT ON;

	if(@Action='Insert')
	begin
		 IF NOT EXISTS(select PKID from CMS_BackgroundBanner where BannerName=@BannerName and Country=@Country and Flag=@Flag)
		 BEGIN
		INSERT INTO CMS_BackgroundBanner(BannerName,BannerURL,ExpiryDate,BannerOrder,FromDate,Country,CreatedDate,IsActive,Flag) 
		values(@BannerName,@BannerURL,@ExpiryDate,@BannerOrder,@FromDate,@Country,GETDATE(),1,@Flag)
		SELECT 1
		END
		ELSE
		BEGIN
		SELECT 0
		END
	End
	Else If(@Action='Update')
	begin
		update CMS_BackgroundBanner set  BannerName = case @BannerName when 'Null' then BannerName else @BannerName End
										,BannerURL=@BannerURL
										,ExpiryDate=@ExpiryDate
										,BannerOrder=@BannerOrder
										,FromDate=@FromDate
										,Country=@Country
										,Flag=@Flag
								  where PKID=@Id
	End

	Else If(@Action='View')
	begin
		select * from CMS_BackgroundBanner where PKID=@Id
	End

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_InsertBackgroundBanner] TO [rt_read]
    AS [dbo];

