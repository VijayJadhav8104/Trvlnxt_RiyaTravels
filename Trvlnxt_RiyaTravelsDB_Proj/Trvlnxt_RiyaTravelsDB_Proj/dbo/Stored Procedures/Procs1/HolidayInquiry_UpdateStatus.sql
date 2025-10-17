-- =============================================
-- Author:		Hardik
-- Create date: 25.09.2023
-- Description:	Update Holiday Inquiry Status
-- =============================================
CREATE PROCEDURE HolidayInquiry_UpdateStatus
	@HolidayInquiryIDP BigInt
	,@InquiryStatusIDTMS Int
	,@InquiryStatus Varchar(50)
	,@ClientFirstName Varchar(150) = NULL
	,@ClientLastName Varchar(150) = NULL
	,@ClientEmail Varchar(250) = NULL
	,@ClientMobile Varchar(50) = NULL
	,@AgentID Int
	,@MainAgentID Int
	,@InquiryNo Varchar(50)
	,@OUTVAL Int OUTPUT
	,@OUTMSG Varchar(200) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @HolidayInquiry_AgentID Int, @AgentEmail Varchar(200)

	SELECT TOP 1 @HolidayInquiry_AgentID = AgentID FROM HolidayInquiry WHERE InquiryNumber = @InquiryNo

	SELECT TOP 1 @AgentEmail = AddrEmail FROM B2BRegistration WHERE FKUserID = @HolidayInquiry_AgentID

    UPDATE HolidayInquiry SET InquiryStatus = @InquiryStatus
	, InquiryStatusIDTMS = @InquiryStatusIDTMS
	, ClientFirstName = @ClientFirstName
	, ClientLastName = @ClientLastName
	, ClientEmail = @ClientEmail
	, ClientMobile = @ClientMobile
	, UpdatedAgentID = @HolidayInquiry_AgentID
	, UpdatedMainAgentID = @MainAgentID
	WHERE HolidayInquiryIDP = @HolidayInquiryIDP

	SET @OUTVAL = 1
	SET @OUTMSG = 'Status updated successfully.-' + ISNULL(@AgentEmail,'NA')
END
