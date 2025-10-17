-- =============================================
-- Author:		Hardik
-- Create date: 10.10.2023
-- Description:	Update Holiday Inquiry Status From TMS
-- =============================================
CREATE PROCEDURE HolidayInquiry_UpdateStatusFromTMS
	@InquiryNumber Varchar(50)
	,@InquiryStatus Varchar(50)
	,@InquiryStatusIDTMS Int
	,@ClientFirstName Varchar(150) = NULL
	,@ClientLastName Varchar(150) = NULL
	,@ClientEmail Varchar(250) = NULL
	,@ClientMobile Varchar(50) = NULL
	,@OUTVAL Int OUTPUT
	,@OUTMSG Varchar(100) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE HolidayInquiry SET InquiryStatus = @InquiryStatus
	, InquiryStatusIDTMS = @InquiryStatusIDTMS
	, ClientFirstName = @ClientFirstName
	, ClientLastName = @ClientLastName
	, ClientEmail = @ClientEmail
	, ClientMobile = @ClientMobile
	WHERE InquiryNumber = @InquiryNumber

	SET @OUTVAL = 1
	SET @OUTMSG = 'Inquiry status updated successfully.'

END