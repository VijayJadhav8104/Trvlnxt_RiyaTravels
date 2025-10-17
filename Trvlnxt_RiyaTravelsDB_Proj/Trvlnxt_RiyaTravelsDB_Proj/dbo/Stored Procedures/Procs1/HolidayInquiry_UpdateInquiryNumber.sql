-- =============================================
-- Author:		Hardik
-- Create date: 13.09.2023
-- Description:	Update Holiday Inquiry Number
-- =============================================
CREATE PROCEDURE HolidayInquiry_UpdateInquiryNumber
	@HolidayInquiryIDP Int
	,@InquiryNumber Varchar(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE HolidayInquiry SET InquiryNumber = @InquiryNumber WHERE HolidayInquiryIDP = @HolidayInquiryIDP
END