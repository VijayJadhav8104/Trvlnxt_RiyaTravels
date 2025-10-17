CREATE PROCEDURE [dbo].[ViewPNR_InsertPassengerBookDetail]
	@fkBookMaster BigInt
	,@paxID int
	,@paxType Varchar(50) = NULL
	,@airPNR Varchar(50) = NULL
	,@totalFare decimal(18,4)
	,@basicFare decimal(18,4)
	,@totalTax decimal(18,4)
	,@isReturn Bit
	,@YRTax decimal(18,2)
	,@YQTax decimal(18,2)
	,@JNTax decimal(18,2)
	,@K7Tax decimal(18,2)
	,@ExtraTax decimal(18,2)
	,@INTax decimal(18,2) =0.0
	,@OCTax decimal(18,2) =0.0
	,@YMTax decimal(18,2) =0.0
	,@WOTax decimal(18,2) =0.0
	,@OBTax decimal(18,2) =0.0
	,@RFTax decimal(18,2) =0.0
	,@ticketNo Varchar(200) = null
	,@ticketnumber Varchar(200) = null
	,@MarkOn Varchar(20) = null
	,@BFC decimal(18,2) =0
	,@Markup decimal(18,2)
	,@GST decimal(18,2)
	,@ServiceFee decimal(18,2)
	,@VendorServiceFee decimal(18,2)
	,@DiscountGST decimal(18,2) =0.0
	,@DiscountTDS decimal(18,2) =0.0
	,@Discount decimal(18,2) =0.0
	,@MCOAmount decimal(18,2)
	,@AirlineFee decimal(18,2) =0.0
	,@AirlineGST decimal(18,2)=0.0
	,@Baggage Varchar(50) = NULL
	,@EMDNo Varchar(50) = NULL
	,@EMDAirLineCode Varchar(50) = NULL
	,@RefundAmount decimal(18,2)=0.0
AS
BEGIN
	SET NOCOUNT ON;
	
    DECLARE  @paxFName Varchar(20) = '',@PaxTypes Varchar(20) = '' , @paxLName Varchar(20) = '', @title Varchar(20) = '',@dateOfBirth DateTime = NULL,
	           @gender Varchar(20) = NULL,@PanNumber varchar(20)='',@Nationalty varchar(20)='', @OrderID Varchar(50) = ''
 	SELECT  @paxFName = paxFName,
	        @PaxTypes = paxType,
	        @paxLName = paxLName,@title=title,
			@dateOfBirth = dateOfBirth,@gender =gender,
			@PanNumber =PanNumber, @Nationalty = nationality
			FROM tblPassengerBookDetails WHERE pid=@paxID

    DECLARE @TaxDescription NVARCHAR(MAX) = ''

   SET @TaxDescription = 
    CASE WHEN @YQTax > 0 THEN 'YQ:' + CAST(@YQTax AS VARCHAR) + ';' ELSE '' END +
    CASE WHEN @YRTax > 0 THEN 'YR:' + CAST(@YRTax AS VARCHAR) + ';' ELSE '' END +
    CASE WHEN @K7Tax > 0 THEN 'IN:' + CAST(@K7Tax AS VARCHAR) + ';' ELSE '' END +
    CASE WHEN @JNTax > 0 THEN 'JN:' + CAST(@JNTax AS VARCHAR) + ';' ELSE '' END +
    CASE WHEN @INTax > 0 THEN 'IN:' + CAST(@INTax AS VARCHAR) + ';' ELSE '' END +
    CASE WHEN @OCTax > 0 THEN 'OC:' + CAST(@OCTax AS VARCHAR) + ';' ELSE '' END +
    CASE WHEN @YMTax > 0 THEN 'YM:' + CAST(@YMTax AS VARCHAR) + ';' ELSE '' END +
    CASE WHEN @WOTax > 0 THEN 'WO:' + CAST(@WOTax AS VARCHAR) + ';' ELSE '' END +
    CASE WHEN @OBTax > 0 THEN 'OB:' + CAST(@OBTax AS VARCHAR) + ';' ELSE '' END +
    CASE WHEN @RFTax > 0 THEN 'RF:' + CAST(@RFTax AS VARCHAR) + ';' ELSE '' END +
    CASE WHEN @ExtraTax > 0 THEN 'ExtraTax:' + CAST(@ExtraTax AS VARCHAR) ELSE '' END

    INSERT INTO tblPassengerBookDetails (fkBookMaster
	,paxType
	,paxFName
	,paxLName
	,inserteddate
	,title
	,dateOfBirth
	,gender
	,YQ
	,airPNR
	,totalFare
	,basicFare
	,totalTax
	,isReturn
	,YRTax
	,JNTax
	,INTax
	,OCTax
	,YMTax
	,WOTax
	,OBTax
	,RFTax
	,ExtraTax
	,DiscriptionTax
	,BookingStatus
	,TicketNumber
	,ticketNum
	,BFC
	,MarkOn
	,B2BMarkup
	,GST
	,ServiceFee
	,PanNumber
	,nationality
	,K7Tax
	,Discount
	,DiscountGST
	,DiscountTDS
	,VendorServiceFee
	,MCOAmount
	,AirlineFee
	,AirlineGST
	,baggage
	,EMDNumber
	,EMDAirLineCode
	,OPID)
	VALUES (@fkBookMaster
	,@PaxTypes
	,@paxFName
	,@paxLName
	,GETDATE()
	,@title
	,@dateOfBirth
	,@gender
	,ISNULL(@YQTax,'0')
	,@airPNR
	,@totalFare
	,@basicFare
	,@totalTax
	,@isReturn
	,@YRTax
	,@JNTax
	,@INTax
	,@OCTax
	,@YMTax
	,@WOTax
	,@OBTax
	,@RFTax
	,@ExtraTax
	,@TaxDescription
	,1 --@BookingStatus
	,@ticketnumber
	,@ticketNo
	,@BFC
	,@MarkOn
	,@Markup
	,@GST
	,@ServiceFee
	,@PanNumber
	,@Nationalty
	,@K7Tax
	,@Discount
	,@DiscountGST
	,@DiscountTDS
	,@VendorServiceFee
	,@MCOAmount
	,@AirlineFee
	,@AirlineGST
	,@Baggage
	,@EMDNo
	,@EMDAirLineCode
	,@paxID)

	UPDATE tblPassengerBookDetails SET RefundAmount = @RefundAmount  WHERE pid=@paxID

	DECLARE @Passengerid INT;

	SET @Passengerid = SCOPE_IDENTITY();

   SELECT @OrderID = orderid FROM tblBookMaster WHERE pkId=@fkBookMaster

   IF EXISTS (SELECT 1 FROM mAttrributesDetails WHERE fkPassengerid = @paxID)
   BEGIN
    INSERT INTO mAttrributesDetails (
        fkPassengerid,
        OrderID,
        JobCodeBookingGivenBy,
        VesselName,
        ReasonofTravel,
        TravelRequestNumber,
        BudgetCode,
        EmpDimession,
        SwonNo,
        TravelerType,
        Location,
        Department,
        Grade,
        Bookedby,
        Designation,
        Chargeability,
        NameofApprover,
        ReferenceNo,
        TR_POName,
        RankNo,
        AType,
        BookingReceivedDate,
        paxvisa,
        Changedcostno,
        Travelduration,
        TASreqno,
        Companycodecc,
        Traveltype,
        Projectcode,
        CostCenter,
        OBTCno,
        PanCardno,
        DEVIATION_APPROVER_NAME_AND_EMPCODE,
        LOWEST_LOGICAL_FARE_1,
        LOWEST_LOGICAL_FARE_2,
        LOWEST_LOGICAL_FARE_3,
        RoleBand,
        EmpLocation,
        VerticalLocation,
        Horizontal,
        Vertical,
        BTANO,
        RequestID,
        FareRule,
        FareType,
        EmpIDTRAVELOFFICER,
        Remarks,
        CarbonFootprint,
        CurrencyConversionRate,
        ProjectName,
        PID,
        UID,
        Account,
        CostCentre,
        ConcurID,
        ApproverName,
        GESSRECEIVEDDATE,
        TicketType,
        DEVIATIONAPPROVER,
        EMPLOYEESPOSITION,
        TRAVELCOSTREIMBURSABLE,
        BillingEntityName,
        Issuancedate,
        TripPurpose,
        ProjectNo,
        TravelReason,
        GDSPNR,
        PaxName,
        SectorNo,
        CreatedOn,
		CreatedBy,
		SeamanValue
    )
    SELECT
        @Passengerid,
        @OrderID,
        JobCodeBookingGivenBy,
        VesselName,
        ReasonofTravel,
        TravelRequestNumber,
        BudgetCode,
        EmpDimession,
        SwonNo,
        TravelerType,
        Location,
        Department,
        Grade,
        Bookedby,
        Designation,
        Chargeability,
        NameofApprover,
        ReferenceNo,
        TR_POName,
        RankNo,
        AType,
        BookingReceivedDate,
        paxvisa,
        Changedcostno,
        Travelduration,
        TASreqno,
        Companycodecc,
        Traveltype,
        Projectcode,
        CostCenter,
        OBTCno,
        PanCardno,
        DEVIATION_APPROVER_NAME_AND_EMPCODE,
        LOWEST_LOGICAL_FARE_1,
        LOWEST_LOGICAL_FARE_2,
        LOWEST_LOGICAL_FARE_3,
        RoleBand,
        EmpLocation,
        VerticalLocation,
        Horizontal,
        Vertical,
        BTANO,
        RequestID,
        FareRule,
        FareType,
        EmpIDTRAVELOFFICER,
        Remarks,
        CarbonFootprint,
        CurrencyConversionRate,
        ProjectName,
        PID,
        UID,
        Account,
        CostCentre,
        ConcurID,
        ApproverName,
        GESSRECEIVEDDATE,
        TicketType,
        DEVIATIONAPPROVER,
        EMPLOYEESPOSITION,
        TRAVELCOSTREIMBURSABLE,
        BillingEntityName,
        Issuancedate,
        TripPurpose,
        ProjectNo,
        TravelReason,
        GDSPNR,
        PaxName,
        SectorNo,
        GETDATE(),
		CreatedBy,
		SeamanValue

    FROM mAttrributesDetails
    WHERE fkPassengerid = @paxID;
  END

	SELECT @Passengerid;
	
END