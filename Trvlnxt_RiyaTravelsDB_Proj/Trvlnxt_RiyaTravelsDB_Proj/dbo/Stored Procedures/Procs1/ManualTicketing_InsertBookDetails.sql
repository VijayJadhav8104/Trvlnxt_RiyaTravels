CREATE PROCEDURE [dbo].[ManualTicketing_InsertBookDetails] 
	@orderId Varchar(30)
	,@frmSector Varchar(50)
	,@toSector Varchar(50)
	,@fromAirport Varchar(150)
	,@toAirport Varchar(150)
	,@airName Varchar(150) -- Airline Name
	,@operatingCarrier Varchar(50) -- 6e
	,@airCode Varchar(10) -- 6e
	,@flightNo Varchar(10)
	,@isReturnJourney Bit-- 0 from OW, 1 for return
	,@depDate DateTime
	,@arrivalDate DateTime
	,@riyaPNR Varchar(10)
	,@taxDesc Varchar(100)--YQ:1438;YR:13187;IN:221;K3:1734;P2:1167;YM:708
	,@totalFare decimal(18,4)-- all pax total amount segmetn wise all pax
	,@totalTax decimal(18,4)-- segment wise all pax
	,@basicFare decimal(18,4)
	,@deptTime DateTime
	,@arrivalTime DateTime
	,@GDSPNR Varchar(30)
	,@mobileNo Varchar(20)
	,@emailId Varchar(50)
	,@returnFlag Bit-- 1-1 if return
	,@fromTerminal Varchar(20) = NULL
	,@toTerminal Varchar(20) = NULL
	,@TotalTime Varchar(10) = NULL-- Flying Hours
	,@YRTax decimal(18,4)
	,@INTax	decimal(18,4)
	,@JNTax	decimal(18,4)
	,@OCTax	decimal(18,4)
	,@ExtraTax decimal(18,4)
	,@YQTax decimal(18,4)
	,@UserID BigInt-- Login User ID
	,@IATACommission Int
	,@PLBCommission Int
	,@LoginEmailID Varchar(50)-- Login User ID
	,@OfficeID Varchar(50)
	,@Country Varchar(2)-- Agent Country
	,@AgentROE decimal(18,10)-- 1
	,@ROE decimal(18,10)-- 1
	,@AgentID Varchar(50)
	,@journey char(1)-- O for OW, R for Return, M For multicity
	,@FareType Varchar(50) = NULL-- NULL
	,@VendorName Varchar(50) = NULL-- Indigo
	,@MainAgentId Int
	,@IssueBy Int-- Login User ID
	,@IssueDate DateTime
	,@BookedBy Int-- Login User ID
	,@YMTax decimal(18,2)
	,@WOTax	decimal(18,2)
	,@OBTax	decimal(18,2)
	,@RFTax	decimal(18,2)
	,@AgentCurrency Varchar(30)
	,@ValidatingCarrier Varchar(50)-- 6e
	,@TripType Varchar(50)
	,@IsMultiTST Bit
	,@BFC decimal(18,2)
	,@TotalEarning decimal(18,2)
	,@GST decimal(18,2)
	,@ServiceFee decimal(18,2)
	,@B2BMarkup decimal(18,2) = NULL
	,@TotalMarkup decimal(18,2) = NULL
	,@CounterCloseTime Int = NULL
	,@B2bFareType Int = NULL
	,@K7Tax	decimal(18,2) = NULL
	,@TourCode	Varchar(50) = NULL
	--,@OUTVAL BigInt OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO tblBookMaster (orderId
	,frmSector
	,toSector
	,fromAirport
	,toAirport
	,airName -- Indigo
	,operatingCarrier -- 6e
	,airCode --6e
	,flightNo
	,isReturnJourney -- 0 from OW, 1 for return
	,depDate
	,arrivalDate
	,riyaPNR
	,taxDesc --YQ:1438;YR:13187;IN:221;K3:1734;P2:1167;YM:708
	,totalFare -- all pax total amount segmetn wise all pax
	,totalTax -- segment wise all pax
	,basicFare
	,deptTime
	,arrivalTime
	,GDSPNR
	,IsBooked -- 1 Confirmed
	,inserteddate
	,TotalDiscount -- 0
	,FlatDiscount -- 0
	,mobileNo
	,emailId
	,returnFlag -- 1-1 if return
	,fromTerminal
	,toTerminal
	,TotalTime -- Flying Hours
	,YRTax
	,INTax
	,JNTax
	,OCTax
	,ExtraTax
	,YQTax
	,UserID -- Login User ID
	,IATACommission
	,PLBCommission
	,BookingSource -- Manual Ticketing
	,LoginEmailID -- Login User ID
	,OfficeID
	,Country -- Agent Country
	,AgentROE -- 1
	,ROE -- 1
	,AgentID
	,journey -- O for OW, R for Return, M For multicity
	,inserteddate_old
	,FareType -- NULL
	,VendorName -- Indigo
	,MainAgentId
	,BookingStatus -- 1 for Confirmed
	,IssueBy -- Login User ID
	,IssueDate -- Current Date
	,BookedBy -- Login User ID
	,YMTax
	,WOTax
	,OBTax
	,RFTax
	,AgentCurrency
	,ValidatingCarrier -- 6e
	,TripType
	,IsMultiTST
	,BFC
	,TotalEarning
	,GST
	,ServiceFee
	,TotalMarkup
	,B2BMarkup
	,CounterCloseTime
	,B2bFareType
	,K7Tax
	,TourCode) -- 1 For Multicity and 0 for OW and RT
	VALUES (@orderId
	,@frmSector
	,@toSector
	,@fromAirport
	,@toAirport
	,@airName -- Indigo
	,@operatingCarrier -- 6e
	,@airCode --6e
	,@flightNo
	,@isReturnJourney -- 0 from OW, 1 for return
	,@depDate
	,@arrivalDate
	,@riyaPNR
	,@taxDesc --YQ:1438;YR:13187;IN:221;K3:1734;P2:1167;YM:708
	,@totalFare -- all pax total amount segmetn wise all pax
	,@totalTax -- segment wise all pax
	,@basicFare
	,@deptTime
	,@arrivalTime
	,@GDSPNR
	,0 --@IsBooked 1 Confirmed
	,GETDATE()
	,0 --@TotalDiscount
	,0 --@FlatDiscount
	,@mobileNo
	,@emailId
	,@returnFlag -- 1-1 if return
	,@fromTerminal
	,@toTerminal
	,@TotalTime -- Flying Hours
	,@YRTax
	,@INTax
	,@JNTax
	,@OCTax
	,@ExtraTax
	,@YQTax
	,@UserID -- Login User ID
	,@IATACommission
	,@PLBCommission
	,'Manual Ticketing' -- @BookingSource -- Manual Ticketing
	,@LoginEmailID -- Login User ID
	,@OfficeID
	,@Country -- Agent Country
	,@AgentROE -- 1
	,@ROE -- 1
	,@AgentID
	,@journey -- O for OW, R for Return, M For multicity
	,GETDATE()
	,@FareType -- NULL
	,@VendorName -- Indigo
	,@MainAgentId
	,0 --@BookingStatus -- 1 for Confirmed
	,@IssueBy
	,@IssueDate 
	--,GETDATE()
	,@BookedBy -- Login User ID
	,@YMTax
	,@WOTax
	,@OBTax
	,@RFTax
	,@AgentCurrency
	,@ValidatingCarrier -- 6e
	,@TripType
	,@IsMultiTST
	,@BFC
	,@TotalEarning
	,@GST
	,@ServiceFee
	,@TotalMarkup
	,@B2BMarkup
	,@CounterCloseTime
	,@B2bFareType
	,@K7Tax
	,@TourCode)
   
	SELECT SCOPE_IDENTITY();
END