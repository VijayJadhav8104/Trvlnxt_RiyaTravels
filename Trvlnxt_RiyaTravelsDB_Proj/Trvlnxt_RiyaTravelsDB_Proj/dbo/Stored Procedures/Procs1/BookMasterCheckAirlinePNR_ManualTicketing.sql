-- =============================================
-- Author:		Hardik
-- Create date: 28.07.2023
-- Description:	Check Order ID Already Exists
--				Change OR to AND in IF EXISTS Condition 29.11.2023 - Hardik
-- =============================================
CREATE PROCEDURE [dbo].[BookMasterCheckAirlinePNR_ManualTicketing]
	@AirlinePNR Varchar(10)
	,@GDSPNR Varchar(10)
	,@OUTVAL Int OUTPUT
	,@OUTMSG VARCHAR(250) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @RiyaPNR Varchar(10)

	IF EXISTS (SELECT BookingStatus FROM tblBookItenary WITH(NOLOCK)
	INNER JOIN tblBookMaster ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
	WHERE (airlinePNR = @AirlinePNR AND tblBookMaster.GDSPNR = @GDSPNR) AND BookingSource = 'Manual Ticketing')
	BEGIN
		SELECT TOP 1 @OUTVAL = BookingStatus
		, @RiyaPNR = tblBookMaster.riyaPNR 
		FROM tblBookItenary WITH(NOLOCK)
		INNER JOIN tblBookMaster WITH(NOLOCK) ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
		WHERE (airlinePNR = @AirlinePNR AND tblBookMaster.GDSPNR = @GDSPNR) AND BookingSource = 'Manual Ticketing'
	END
	ELSE
	BEGIN
		SET @OUTVAL = 99
	END

	SET @OUTMSG = 'NA'

	IF (@OUTVAL = 1)
	BEGIN
		SET @OUTMSG = 'Riya PNR already generated. Riya PNR is ' + @RiyaPNR
	END
	ELSE IF (@OUTVAL = 0)
	BEGIN
		BEGIN TRY
		BEGIN TRANSACTION
			-- Insert record from main table to history table
			INSERT INTO [dbo].[tblBookMasterHistory]([pkId],[orderId],[frmSector],[toSector],[fromAirport]
			,[toAirport],[airName],[operatingCarrier],[airCode],[equipment],[flightNo]
			,[isReturnJourney],[depDate],[arrivalDate],[riyaPNR],[taxDesc],[totalFare]
			,[totalTax],[basicFare],[deptTime],[canceledDate],[arrivalTime],[GDSPNR]
			,[IsBooked],[inserteddate],[IP],[TotalDiscount],[FlatDiscount],[CancellationCharge]
			,[ServiceCharge],[promoCode],[GovtTax],[mobileNo],[emailId],[returnFlag]
			,[travClass],[fromTerminal],[toTerminal],[TotalTime],[CounterCloseTime],[Remarks]
			,[YRTax],[INTax],[JNTax],[OCTax],[ExtraTax],[YQTax]
			,[UserID],[CommissionType],[ServiceChargeType],[FlatDiscountType],[CancellationChargeType],[FareSellKey]
			,[JourneySellKey],[IATACommission],[PLBCommission],[IATAPercent],[PLBPercent],[VendorCommissionPercent]
			,[VendorCommissionText],[IsIATAOnBasic],[IsPLBOnBasic],[GovtTaxPercent],[UniqueID],[BookingSource]
			,[SessionId],[LoginEmailID],[RegistrationNumber],[CompanyName],[CAddress],[CState]
			,[CContactNo],[CEmailID],[PromoDiscount],[TicketIssuanceError],[OfficeID],[Country]
			,[ROE],[AgentID],[AgentAction],[AgentDealDiscount],[TicketIssue],[SupplierCode]
			,[VendorCode],[TotalMarkup],[BookingType],[DisplayType],[CalculationType],[AgentMarkup]
			,[TicketMail],[journey],[inserteddate_old],[TrackID],[Vendor_No],[IATA],[FareType])
			SELECT 
			[pkId],[orderId],[frmSector],[toSector],[fromAirport]
			,[toAirport],[airName],[operatingCarrier],[airCode],[equipment],[flightNo]
			,[isReturnJourney],[depDate],[arrivalDate],[riyaPNR],[taxDesc],[totalFare]
			,[totalTax],[basicFare],[deptTime],[canceledDate],[arrivalTime],[GDSPNR]
			,[IsBooked],[inserteddate],[IP],[TotalDiscount],[FlatDiscount],[CancellationCharge]
			,[ServiceCharge],[promoCode],[GovtTax],[mobileNo],[emailId],[returnFlag]
			,[travClass],[fromTerminal],[toTerminal],[TotalTime],[CounterCloseTime],[Remarks]
			,[YRTax],[INTax],[JNTax],[OCTax],[ExtraTax],[YQTax]
			,[UserID],[CommissionType],[ServiceChargeType],[FlatDiscountType],[CancellationChargeType],[FareSellKey]
			,[JourneySellKey],[IATACommission],[PLBCommission],[IATAPercent],[PLBPercent],[VendorCommissionPercent]
			,[VendorCommissionText],[IsIATAOnBasic],[IsPLBOnBasic],[GovtTaxPercent],[UniqueID],[BookingSource]
			,[SessionId],[LoginEmailID],[RegistrationNumber],[CompanyName],[CAddress],[CState]
			,[CContactNo],[CEmailID],[PromoDiscount],[TicketIssuanceError],[OfficeID],[Country]
			,[ROE],[AgentID],[AgentAction],[AgentDealDiscount],[TicketIssue],[SupplierCode]
			,[VendorCode],[TotalMarkup],[BookingType],[DisplayType],[CalculationType],[AgentMarkup]
			,[TicketMail],[journey],[inserteddate_old],[Trackid],[Vendor_No],[IATA],[FareType]
			FROM [dbo].[tblBookMaster]
			WHERE pkId IN (
				SELECT tblBookMaster.pkId FROM tblBookItenary 
				INNER JOIN tblBookMaster ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
				WHERE (airlinePNR = @AirlinePNR AND tblBookMaster.GDSPNR = @GDSPNR) AND BookingStatus = 0 AND IsBooked = 0 AND BookingSource = 'Manual Ticketing'
			)

			-- Delete record from main table
			DELETE FROM tblBookMaster
			WHERE pkId IN (
				SELECT tblBookMaster.pkId FROM tblBookItenary WITH(NOLOCK)
				INNER JOIN tblBookMaster WITH(NOLOCK) ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
				WHERE (airlinePNR = @AirlinePNR AND tblBookMaster.GDSPNR = @GDSPNR) AND BookingStatus = 0 AND IsBooked = 0 AND BookingSource = 'Manual Ticketing'
			)
		
			COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
			SET @OUTVAL = -1 -- If get any error

			DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT, @ErrorState INT;
 
			SELECT @ErrorMessage = ERROR_MESSAGE(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE();

			-- Add Error Log 08.08.2023 by Hardik
			INSERT INTO [AllAppLogs].[dbo].mExceptionDetails (PageName,MethodName,ParameterList,GDSPNR,ExceptionMessage,StackTrace,Details,ExceptionDate)  
			VALUES ('BookMasterCheckAirlinePNR_ManualTicketing','BookMasterCheckAirlinePNR_ManualTicketing'
			,'Manual Ticketing',@AirlinePNR+'-'+@GDSPNR,@ErrorMessage,CONVERT(VARCHAR(50), @ErrorSeverity),CONVERT(VARCHAR(50), @ErrorState),GETDATE())  

			RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
			
			ROLLBACK TRANSACTION
		END CATCH
	END
	
END