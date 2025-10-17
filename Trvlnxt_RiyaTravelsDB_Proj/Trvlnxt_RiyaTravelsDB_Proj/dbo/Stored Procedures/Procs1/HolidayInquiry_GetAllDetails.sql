-- =============================================
-- Author:		Hardik
-- Create date: 13.09.2023
-- Description:	Get Holiday Inquiry Details
-- =============================================
CREATE PROCEDURE HolidayInquiry_GetAllDetails
	@HolidayInquiryIDP Int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT HolidayInquiryIDP
	,AgentID
	,AgentName
	,AgentPhoneNo
	,AgentEmailID
	,FromCity
	,DestinationNames
	,TotalNoOfNights
	,Adult
	,Child
	,ChildAge
	,PaxNationalityID
	,FileName
	,HotelCategory
	,HotelRoomType
	,ServicesNames
	,ServiceIDs
	,Remarks
	,FORMAT(InquiryDateTime,'dd/MM/yyyy') AS InquiryDateTime
	,WebsiteName
	,ISNULL(InquiryNumber, 'NA') AS InquiryNumber
	,InquiryStatus
	,FORMAT(TravelDateFrom,'dd/MM/yyyy') AS TravelDateFrom
	,FORMAT(TravelDateTo,'dd/MM/yyyy') AS TravelDateTo
	,AssignTMSUserID
	,TMSEmployeeCode_Assign
	,TMSUserID_Assign
	,InquiryStatusIDTMS
	,ClientFirstName
	,ClientLastName
	,ClientMobile
	,ClientEmail
	,ISNULL(QueryType,'NA') AS QueryType
	,MainAgentID
	FROM HolidayInquiry
	WHERE HolidayInquiryIDP = @HolidayInquiryIDP

	SELECT HolidayTravelDetailIDP
	,HolidayInquieryIDF
	,FromCity
	,Destination
	,FORMAT(FromTravleDate,'dd/MM/yyyy') AS FromTravleDate
	,FORMAT(ToTravelDate,'dd/MM/yyyy') AS ToTravelDate
	,NoOfNights
	,CreatedDateTime
	FROM HolidayTravelDetail
	WHERE HolidayInquieryIDF = @HolidayInquiryIDP

END