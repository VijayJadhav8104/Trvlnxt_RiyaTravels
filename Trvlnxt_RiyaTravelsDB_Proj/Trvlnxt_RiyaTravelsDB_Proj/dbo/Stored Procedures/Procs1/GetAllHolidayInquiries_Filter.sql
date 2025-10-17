-- =============================================
-- Author:		<Aditya Joshi>
-- Create date: <10/8/2024>
-- Description:	Procedure to get filtered holiday inquiries
-- =============================================
CREATE PROCEDURE [dbo].[GetAllHolidayInquiries_Filter]
	@AgentID Int = NULL,
	@MainAgentID Int = NULL,
	@SearchField NVARCHAR(100) = NULL, -- Filter for AgentName, ClientFirstName, ClientLastName, ClientEmail, AgentEmailID, ClientMobile
	@InquiryNumber NVARCHAR(50) = NULL, -- Filter for Inquiry Number
	@Destination NVARCHAR(200) = NULL, -- Filter for Destination
	@TravelDate DATE = NULL, -- Filter for TravelDateFrom
	@InquiryDateTime DATETIME = NULL, -- Filter for InquiryDateTime
	@InquiryStatus NVARCHAR(50) = NULL -- Filter for InquiryStatus
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
	, ISNULL(UPPER(mUser.FullName), ' ') AS SalesPersonName
	FROM HolidayInquiry
	LEFT OUTER JOIN B2BRegistration ON B2BRegistration.FKUserID = HolidayInquiry.AgentID AND HolidayInquiry.QueryType = 'Agent'
	LEFT OUTER JOIN mUser ON mUser.EmployeeNo = B2BRegistration.SalesPersonId
	WHERE (@AgentID = 0 OR @AgentID IS NULL OR AgentID = @AgentID)
	AND (@MainAgentID = 0 OR @MainAgentID IS NULL OR (MainAgentID = @MainAgentID OR AssignTMSUserID = @MainAgentID))
	
	-- Filters
	AND (@SearchField IS NULL OR 
		LOWER(AgentName) LIKE '%' + LOWER(@SearchField) + '%' OR 
		LOWER(ClientFirstName) LIKE '%' + LOWER(@SearchField) + '%' OR 
		LOWER(ClientLastName) LIKE '%' + LOWER(@SearchField) + '%' OR 
		LOWER(ClientEmail) LIKE '%' + LOWER(@SearchField) + '%' OR 
		LOWER(AgentEmailID) LIKE '%' + LOWER(@SearchField) + '%' OR 
		LOWER(ClientMobile) LIKE '%' + LOWER(@SearchField) + '%')

	AND (@InquiryNumber IS NULL OR InquiryNumber = @InquiryNumber)
	AND (@Destination IS NULL OR DestinationNames LIKE '%' + @Destination + '%')
	AND (@TravelDate IS NULL OR (@TravelDate >= CONVERT(DATE, TravelDateFrom) AND @TravelDate <= CONVERT(DATE, TravelDateTo)))
	AND (@InquiryDateTime IS NULL OR CONVERT(DATE, InquiryDateTime) = @InquiryDateTime)
	AND (TRIM(LOWER(@InquiryStatus)) IS NULL OR TRIM(LOWER(InquiryStatus)) = TRIM(LOWER(@InquiryStatus)))
	
	ORDER BY InquiryDateTime DESC
END
