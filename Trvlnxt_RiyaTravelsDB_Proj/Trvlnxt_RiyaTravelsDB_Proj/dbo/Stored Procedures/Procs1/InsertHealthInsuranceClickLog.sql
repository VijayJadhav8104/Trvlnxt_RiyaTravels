




CREATE PROCEDURE [dbo].[InsertHealthInsuranceClickLog]
@IP			varchar(50),
@Location varchar(50),
@BannerName nvarchar(100), @InquiryType  nvarchar(100)

AS BEGIN

	INSERT INTO HealthInsuranceClickLog (IpAddress, Location,CreatedDate,BannerName,InquiryType)
	VALUES(@IP, @Location,getdate(),@BannerName,@InquiryType)

END

