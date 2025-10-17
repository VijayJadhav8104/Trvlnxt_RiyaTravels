-- =============================================
-- Author:		<JD>
-- Create date: <31.08.2023>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllHolidayInquiries]
	@AgentID Int = NULL
	,@MainAgentID Int = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (ORDER BY InquiryDateTime DESC) AS SrNo
	, HolidayInquiryIDP
	, AgentID
	, AgentName
	, AgentPhoneNo
	, AgentEmailID
	, TotalNoOfNights
	, Adult
	, Child
	, ChildAge
	, HotelCategory
	, HotelRoomType
	, ServiceIDs
	, ServicesNames
	, Remarks
	, WebsiteName
	, FromCity
	, DestinationNames
	, QueryType
	, FORMAT(TravelDateFrom, 'dd/MM/yyyy') AS TravelDateFrom
	, FORMAT(TravelDateTo, 'dd/MM/yyyy') AS TravelDateTo
	, TotalNoOfNights
	, FORMAT(InquiryDateTime, 'dd/MM/yyyy hh:mm tt') AS InquiryDate
	, ISNULL(InquiryNumber, '') AS InquiryNumber
	, ISNULL(InquiryStatus, '') AS InquiryStatus
	, TMSEmployeeCode_Assign
	, TMSUserID_Assign
	, FileName
	, ISNULL(UPPER(mUser.FullName), '') AS SalesPeronName
	, ISNULL(UPPER(PackageName), 'Customised Package') AS PackageName
	FROM HolidayInquiry
	LEFT OUTER JOIN B2BRegistration ON B2BRegistration.FKUserID = HolidayInquiry.AgentID AND HolidayInquiry.QueryType = 'Agent'
	LEFT OUTER JOIN mUser ON mUser.EmployeeNo = B2BRegistration.SalesPersonId
	WHERE (@AgentID = 0 OR @AgentID IS NULL OR AgentID = @AgentID)
	AND (@MainAgentID = 0 OR @MainAgentID IS NULL OR (MainAgentID = @MainAgentID OR AssignTMSUserID = @MainAgentID))
	ORDER BY InquiryDateTime DESC
END