-- =============================================
-- Author:		<JD>
-- Create date: <28.08.2023>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HolidayTravelDetail_Insert]
	@HolidayInquieryIDF Int
	, @FromCity Varchar(50) = NULL
	, @Destination nvarchar(MAX)
	, @TravelDate DateTime
	, @TravelDate2 DateTime
	, @NoOfNights Int
	, @OUTVAL Int OUTPUT
	, @OUTMSG Varchar(100) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	Insert INTO HolidayTravelDetail(HolidayInquieryIDF, FromCity, Destination, FromTravleDate, ToTravelDate, NoOfNights)
	VALUES(@HolidayInquieryIDF, @FromCity, @Destination, @TravelDate, @TravelDate2, @NoOfNights)

	SET @OUTVAL = 1
	SET @OUTMSG = 'We have received your query. Our team will get back to you shortly.'

END