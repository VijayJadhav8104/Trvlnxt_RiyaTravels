-- =============================================
-- Author:		Hardik
-- Create date: 09.08.2023
-- Description:	Save Holiday Inquiry
-- =============================================
CREATE PROCEDURE [dbo].[HolidayInquiry_Insert] 
	@AgentID Int
	,@MainAgentID Int = NULL
	,@AgentName Varchar(50)
	,@AgentPhoneNo Varchar(50)
	,@AgentEmailID Varchar(150)
	,@TotalNoOfNights Int = 0
	,@Adult Int
	,@Child Int
	,@ChildAge Varchar(50)
	,@FileName Varchar(50)
	,@HotelCategory Varchar(500) = NULL
	,@HotelRoomType  Varchar(500) = NULL
	,@PaxNationalityID Int
	,@ServicesNames Varchar(500) = NULL
	,@ServiceIDs Varchar(500) = NULL
	,@Remarks NVarchar(MAX) = NULL
	,@WebsiteName Varchar(50)
	,@InquiryNumber Varchar(50) = NULL
	,@TravelDateFrom DateTime
	,@TravelDateTo DateTime
	,@FromCity Varchar(50)
	,@DestinationNames NVarchar(500) = NULL
	,@QueryType Varchar(10)
	,@ClientFirstName Varchar(50)  = NULL
	,@ClientLastName Varchar(50)  = NULL
	,@ClientEmail Varchar(50)  = NULL
	,@ClientMobile Varchar(50)  = NULL
	,@SelfAssign Varchar(10) = NULL
	,@PackageIDF Varchar(10) = NULL
	,@PackageName Varchar(750) = NULL
	,@OUTVAL Int OUTPUT
	,@OUTMSG Varchar(100) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	-- For display agent created inquiry to MainAgent
	IF (@MainAgentID = 0)
	BEGIN
		SELECT @MainAgentID = ParentAgentID FROM AgentLogin WHERE UserID = @AgentID
	END

	INSERT INTO HolidayInquiry (AgentID
	,MainAgentID
	,AgentName
	,AgentPhoneNo
	,AgentEmailID
	,TotalNoOfNights
	,Adult
	,Child
	,ChildAge
	,FileName
	,HotelCategory
	,HotelRoomType
	,Remarks
	,InquiryDateTime
	,WebsiteName
	,InquiryNumber
	,InquiryStatus
	,InquiryStatusIDTMS
	,PaxNationalityID
	,ServicesNames
	,ServiceIDs
	,TravelDateFrom
	,TravelDateTo
	,FromCity
	,DestinationNames
	,QueryType
	,ClientFirstName
	,ClientLastName
	,ClientEmail
	,ClientMobile
	,SelfAssign
	,PackageIDF
	,PackageName)
	VALUES (@AgentID
	,@MainAgentID
	,@AgentName
	,@AgentPhoneNo
	,@AgentEmailID
	,@TotalNoOfNights
	,@Adult
	,@Child
	,@ChildAge
	,@FileName
	,@HotelCategory
	,@HotelRoomType
	,@Remarks
	,GETDATE()
	,@WebsiteName
	,@InquiryNumber
	,'OPEN'
	,200 --Active
	,@PaxNationalityID
	,@ServicesNames
	,@ServiceIDs
	,@TravelDateFrom
	,@TravelDateTo
	,@FromCity
	,@DestinationNames
	,@QueryType
	,@ClientFirstName
	,@ClientLastName
	,@ClientEmail
	,@ClientMobile
	,@SelfAssign
	,@PackageIDF
	,@PackageName)	
    
	SET @OUTVAL = SCOPE_IDENTITY()
	SET @OUTMSG = 'We have received your query. Our team will get back to you shortly.'

END