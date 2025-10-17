-- =============================================
-- Author:		<Aditya Joshi>
-- Create date: <10/8/2024>
-- Description:	Procedure to get filtered holiday inquiries
-- =============================================
CREATE PROCEDURE [dbo].[GetAllHolidayInquiries_Filter_V2]
	@AgentID Int = NULL,
	@MainAgentID Int = NULL,
	@SearchField NVARCHAR(100) = NULL, -- Filter for AgentName, ClientFirstName, ClientLastName, ClientEmail, AgentEmailID, ClientMobile
	@InquiryNumber NVARCHAR(50) = NULL, -- Filter for Inquiry Number
	@Destination NVARCHAR(200) = NULL, -- Filter for Destination
	@TravelDateFrom DATE = NULL, -- Filter for TravelDateFrom
	@TravelDateTo DATE = NULL, -- Filter for TravelDateTo
	@InquiryDateTime DATETIME = NULL, -- Filter for InquiryDateTime
	@InquiryStatus NVARCHAR(50) = NULL -- Filter for InquiryStatus
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SalesPersonUserName NVARCHAR(100)

	IF @MainAgentID IS NOT NULL AND @MainAgentID != 0
	BEGIN
		SELECT @SalesPersonUserName = UserName 
		FROM mUser 
		WHERE ID = @MainAgentID
	END

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
	, ISNULL(UPPER(PackageName), 'Customised Package') AS PackageName
	FROM HolidayInquiry
	LEFT OUTER JOIN B2BRegistration ON B2BRegistration.FKUserID = HolidayInquiry.AgentID AND HolidayInquiry.QueryType = 'Agent'
	LEFT OUTER JOIN mUser ON mUser.EmployeeNo = B2BRegistration.SalesPersonId
	 WHERE 
        -- Condition for AgentID
        (@AgentID = 0 OR @AgentID IS NULL OR AgentID = @AgentID)
        
        -- Condition for MainAgentID or AssignTMSUserID
        AND (
            (@MainAgentID IS NULL OR @MainAgentID = 0) 
            OR (MainAgentID = @MainAgentID OR AssignTMSUserID = @MainAgentID)
            OR (AgentID IN (
                SELECT FKUserID 
                FROM B2BRegistration 
                WHERE SalesPersonId = @SalesPersonUserName
            ))
        )

        -- Filters for search fields
        AND (@SearchField IS NULL OR 
            LOWER(AgentName) LIKE '%' + LOWER(@SearchField) + '%' OR 
            LOWER(ClientFirstName) LIKE '%' + LOWER(@SearchField) + '%' OR 
            LOWER(ClientLastName) LIKE '%' + LOWER(@SearchField) + '%' OR 
            LOWER(ClientEmail) LIKE '%' + LOWER(@SearchField) + '%' OR 
            LOWER(AgentEmailID) LIKE '%' + LOWER(@SearchField) + '%' OR 
            LOWER(ClientMobile) LIKE '%' + LOWER(@SearchField) + '%')

        -- Filter for InquiryNumber
        AND (@InquiryNumber IS NULL OR InquiryNumber = @InquiryNumber)

        -- Filter for Destination
        AND (@Destination IS NULL OR DestinationNames LIKE '%' + @Destination + '%')

        -- Travel Date Filters (Overlapping dates)
        AND (
            -- Both TravelDateFrom and TravelDateTo are provided
            (@TravelDateFrom IS NOT NULL AND @TravelDateTo IS NOT NULL AND 
            (TravelDateFrom BETWEEN @TravelDateFrom AND @TravelDateTo OR 
            TravelDateTo BETWEEN @TravelDateFrom AND @TravelDateTo)) OR

            -- Only TravelDateFrom is provided
            (@TravelDateFrom IS NOT NULL AND @TravelDateTo IS NULL AND 
            (TravelDateFrom >= @TravelDateFrom OR TravelDateTo >= @TravelDateFrom)) OR

            -- Only TravelDateTo is provided
            (@TravelDateFrom IS NULL AND @TravelDateTo IS NOT NULL AND 
            (TravelDateFrom <= @TravelDateTo OR TravelDateTo <= @TravelDateTo)) OR

            -- Neither are provided
            (@TravelDateFrom IS NULL AND @TravelDateTo IS NULL)
        )

        -- Filter for InquiryDateTime
        AND (@InquiryDateTime IS NULL OR CONVERT(DATE, InquiryDateTime) = @InquiryDateTime)

        -- Filter for InquiryStatus
        AND (TRIM(LOWER(@InquiryStatus)) IS NULL OR TRIM(LOWER(InquiryStatus)) = TRIM(LOWER(@InquiryStatus)))

    ORDER BY InquiryDateTime DESC
END