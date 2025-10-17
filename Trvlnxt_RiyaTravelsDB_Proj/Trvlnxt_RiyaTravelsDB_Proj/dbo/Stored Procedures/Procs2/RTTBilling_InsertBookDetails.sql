CREATE PROCEDURE [dbo].[RTTBilling_InsertBookDetails] 
	@orderId Varchar(30)
	,@riyaPNR Varchar(10)
	,@GDSPNR Varchar(30)
	,@mobileNo Varchar(20)
	,@emailId Varchar(50)
	,@UserID BigInt-- Login User ID
	,@LoginEmailID Varchar(50)-- Login User ID
	,@OfficeID Varchar(50)
	,@Country Varchar(2)-- Agent Country
	,@AgentROE decimal(18,10)-- 1
	,@ROE decimal(18,10)-- 1
	,@AgentID Varchar(50)
	,@journey char(1)-- O for OW, R for Return, M For multicity
	,@MainAgentId Int
	,@IssueDate DateTime
	,@IssueBy Int-- Login User ID
	,@BookedBy Int-- Login User ID
	,@AgentCurrency Varchar(30)
	,@TripType Varchar(50)
	,@IsMultiTST Bit
	
	,@returnFlag Bit-- 1-1 if return
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
	,@deptTime DateTime
	,@arrivalTime DateTime
	,@taxDesc Varchar(100)--YQ:1438;YR:13187;IN:221;K3:1734;P2:1167;YM:708
	,@totalFare decimal(18,4)-- all pax total amount segmetn wise all pax
	,@totalTax decimal(18,4)-- segment wise all pax
	,@basicFare decimal(18,4)
	,@VendorName Varchar(50) = NULL-- Indigo
	,@ValidatingCarrier Varchar(50)-- 6e
	
	,@YRTax decimal(18,4)
	,@INTax	decimal(18,4)
	,@JNTax	decimal(18,4)
	,@ExtraTax decimal(18,4)
	,@YQTax decimal(18,4)
	
	,@TotalEarning decimal(18,2)
	,@GST decimal(18,2)
	,@ServiceFee decimal(18,2)
	,@CounterCloseTime Int = NULL
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
	,GDSPNR
	,IsBooked -- 1 Confirmed
	,inserteddate
	,TotalDiscount -- 0
	,FlatDiscount -- 0
	,mobileNo
	,emailId
	,returnFlag -- 1-1 if return
	,YRTax
	,INTax
	,JNTax
	,ExtraTax
	,YQTax
	,UserID -- Login User ID
	,BookingSource -- Manual Ticketing
	,LoginEmailID -- Login User ID
	,OfficeID
	,Country -- Agent Country
	,AgentROE -- 1
	,ROE -- 1
	,AgentID
	,journey -- O for OW, R for Return, M For multicity
	,inserteddate_old
	,VendorName -- Indigo
	,MainAgentId
	,BookingStatus -- 1 for Confirmed
	,IssueBy -- Login User ID
	,IssueDate -- Current Date
	,BookedBy -- Login User ID
	,AgentCurrency
	,ValidatingCarrier -- 6e
	,TripType
	,IsMultiTST
	,TotalEarning
	,GST
	,ServiceFee
	,CounterCloseTime
	,ERPPush
	,deptTime
	,arrivalTime) -- 1 For Multicity and 0 for OW and RT
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
	,@GDSPNR
	,1 --@IsBooked 1 Confirmed
	,@IssueDate
	,0 --@TotalDiscount
	,0 --@FlatDiscount
	,@mobileNo
	,@emailId
	,@returnFlag -- 1-1 if return
	,@YRTax
	,@INTax
	,@JNTax
	,@ExtraTax
	,@YQTax
	,@UserID -- Login User ID
	,'Manual Ticketing' -- @BookingSource -- Manual Ticketing
	,@LoginEmailID -- Login User ID
	,@OfficeID
	,@Country -- Agent Country
	,@AgentROE -- 1
	,@ROE -- 1
	,@AgentID
	,@journey -- O for OW, R for Return, M For multicity
	,@IssueDate
	,@VendorName -- Indigo
	,@MainAgentId
	,1 --@BookingStatus -- 1 for Confirmed
	,@IssueBy
	,@IssueDate 
	--,GETDATE()
	,@BookedBy -- Login User ID
	,@AgentCurrency
	,@ValidatingCarrier -- 6e
	,@TripType
	,@IsMultiTST
	,@TotalEarning
	,@GST
	,@ServiceFee
	,@CounterCloseTime
	,1
	,@deptTime
	,@arrivalTime)
   
	SELECT SCOPE_IDENTITY();
END