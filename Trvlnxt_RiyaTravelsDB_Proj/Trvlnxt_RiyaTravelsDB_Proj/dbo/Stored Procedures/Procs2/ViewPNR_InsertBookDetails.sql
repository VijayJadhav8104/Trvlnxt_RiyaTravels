CREATE PROCEDURE [dbo].[ViewPNR_InsertBookDetails] 
	@orderId Varchar(30)
	,@frmSector Varchar(50)
	,@toSector Varchar(50)
	,@fromAirport Varchar(150)= null
	,@toAirport Varchar(150)= null
	,@airName Varchar(150) = NULL -- Airline Name
	,@operatingCarrier Varchar(50) = NULL-- 6e
	,@airCode Varchar(10) = NULL -- 6e
	,@flightNo Varchar(10) = NULL
	,@depDate DateTime
	,@arrivalDate DateTime
	,@riyaPNR Varchar(10)
	,@deptTime DateTime
	,@arrivalTime DateTime
	,@GDSPNR Varchar(30) = NULL
	,@returnFlag Bit-- 1-1 if return
	,@fromTerminal Varchar(20) = NULL
	,@toTerminal Varchar(20) = NULL
	,@OfficeID Varchar(50)= null
	,@ROE decimal(18,10) =0.0-- 1
	,@AgentID Varchar(50)
	,@MainAgentId Int
	,@BookedBy Int-- Login User ID
	,@ValidatingCarrier Varchar(50)= NULL-- 6e
	,@ParentOrderId Varchar(50)
	,@YQTax decimal(18,4)=0.0
	,@YRTax decimal(18,4)=0.0
	,@K7Tax	decimal(18,4)=0.0
	,@JNTax	decimal(18,4)=0.0
	,@ExtraTax decimal(18,4)=0.0
	,@INTax decimal(18,2) =0.0
	,@OCTax decimal(18,2) =0.0
	,@YMTax decimal(18,2) =0.0
	,@WOTax decimal(18,2) =0.0
	,@OBTax decimal(18,2) =0.0
	,@RFTax decimal(18,2) =0.0
	,@TotalFare decimal(18,4)=0.0
	,@TotalTax decimal(18,4)=0.0
	,@BasicFare decimal(18,4)=0.0
	,@Discount decimal(18,4) =0.0
	,@DiscountGST decimal(18,4)=0.0
	,@DiscountTDS decimal(18,4)=0.0
	,@ServiceFee decimal(18,4)=0.0
	,@VendorServiceFee decimal(18,4)=0.0
	,@GST decimal(18,4) =0.0
	,@BFC decimal(18,4) =0
	,@Markup decimal(18,4)=0.0
	,@taxDesc Varchar(250) = NULL
	,@Remark Varchar(250) =  null
	,@BookingFrom Varchar(20) =  null
	,@NetFare decimal(18,4) =0
	
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @isReturnJourney Bit, @mobileNo Varchar(20) = '', @emailId Varchar(20) = '',@CounterCloseTime INT =0,
	@Country Varchar(20) = '', @AgentROE decimal(18,10),@journey char(1),@VendorName Varchar(50),@FareType Varchar(50),@AgentCurrency Varchar(30)

 	SELECT  @isReturnJourney = isReturnJourney,
	        @mobileNo = mobileNo,@emailId=emailId,
			@Country = Country,@AgentROE =AgentROE,
			@journey =journey, @VendorName = VendorName,
			@FareType = FareType ,@AgentCurrency = AgentCurrency,@CounterCloseTime = CounterCloseTime
			FROM tblBookMaster WHERE Riyapnr=@riyaPNR and returnFlag =@returnFlag

	DECLARE @B2BFareType INT =0;

      IF @Markup <> 0
        BEGIN
        SET @B2BFareType = 2;
        END

	INSERT INTO tblBookMaster (orderId
	,frmSector
	,toSector
	,fromAirport
	,toAirport
	,airName -- Indigo
	,operatingCarrier -- 6e
	,airCode --6e
	,flightNo
	,depDate
	,arrivalDate
	,riyaPNR
	,deptTime
	,arrivalTime
	,GDSPNR
	,IsBooked -- 1 Confirmed
	,inserteddate
	,FlatDiscount -- 0
	,returnFlag -- 1-1 if return
	,fromTerminal
	,toTerminal
	,UserID -- Login User ID
	,BookingSource -- Manual Ticketing
	,OfficeID
	,ROE -- 1
	,AgentID
	,inserteddate_old
	,MainAgentId
	,BookingStatus -- 1 for Confirmed
	,IssueBy -- Login User ID
	,IssueDate -- Current Date
	,BookedBy -- Login User ID
	,ValidatingCarrier
	,ParentOrderId
	,isReturnJourney
	,mobileNo
	,emailId
	,Country
	,AgentROE
	,journey
	,FareType
	,VendorName
	,TripType
	,AgentCurrency
	,BasicFare
	,totalTax
	,totalFare
	,YQTax
	,YRTax
	,JNTax
	,K7Tax
	,ExtraTax
	,INTax
	,OCTax
	,YMTax
	,WOTax
	,OBTax
	,RFTax
	,TotalDiscount
	,DiscountGstTDS
	,ServiceFee
	,TotalVendorServiceFee
	,GST
	,BFC
	,B2BMarkup
	,taxDesc
	,Remark
	,BookingFrom
	,NetAmount
	,GrossFare
	,CounterCloseTime
	,B2BFareType) -- 1 For Multicity and 0 for OW and RT
	VALUES (@orderId
	,@frmSector
	,@toSector
	,@fromAirport
	,@toAirport
	,@airName -- Indigo
	,@airName -- 6e
	,@airCode --6e
	,@flightNo
	,@depDate
	,@arrivalDate
	,@riyaPNR
	,@deptTime
	,@arrivalTime
	,@GDSPNR
	,1 --@IsBooked 1 Confirmed
	,GETDATE()
	,0 --@FlatDiscount
	,@returnFlag -- 1-1 if return
	,@fromTerminal
	,@toTerminal
	,@AgentID
	,'Web' -- @BookingSource -- Manual Ticketing
	,@OfficeID
	,@ROE -- 1
	,@AgentID
	,GETDATE()
	,@MainAgentId
	,1 --@BookingStatus -- 1 for Confirmed
	,@AgentID
	,GETDATE()
	,@BookedBy -- Login User ID
	,@ValidatingCarrier
	,@ParentOrderId
	,@isReturnJourney
	,@mobileNo
	,@emailId
	,@Country
	,@AgentROE
	,@journey
	,@FareType
	,@VendorName
	,@journey
	,@AgentCurrency
	,@BasicFare
	,@TotalTax
	,@TotalFare
	,@YQTax
	,@YRTax
	,@JNTax
	,@K7Tax
	,@ExtraTax
	,@INTax
	,@OCTax
	,@YMTax
	,@WOTax
	,@OBTax
	,@RFTax
	,@Discount
	,@DiscountTDS
	,@ServiceFee
	,@VendorServiceFee
	,@GST
	,@BFC
	,@Markup
	,@taxDesc
	,@Remark
	,@BookingFrom
	,@NetFare
	,@NetFare
	,@CounterCloseTime
	,@B2BFareType)
   
	SELECT SCOPE_IDENTITY();
END