-- =============================================
-- Author:		Bansi
-- Create date: <20.02.2025>
-- Description:	For View PNR
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetViewPNRDetails]
	 @RiyaPNR Varchar(20) = NULL
	, @Currency Varchar(10)
AS
BEGIN
    DECLARE @OrderID Varchar(50) = NULL
	
	SELECT TOP 1 @OrderID = orderId FROM tblBookMaster 
	WHERE riyaPNR = @RiyaPNR
	ORDER BY pkId 

	DECLARE @BasicB2BMARKUP DECIMAL(18, 2)= 0, @TaxB2BMARKUP DECIMAL(18, 2)= 0

	IF EXISTS(SELECT TOP 1 pkId FROM tblBookMaster WHERE (orderId= @OrderID or ParentOrderId =@OrderID) AND B2bFareType= 1)
	BEGIN
		SET @BasicB2BMARKUP = (SELECT TOP 1 B2BMarkup FROM tblBookMaster WHERE orderId= @orderId or ParentOrderId =@OrderID)
	END
	ELSE IF EXISTS(SELECT TOP 1 pkId FROM tblBookMaster WHERE (orderId= @OrderID or ParentOrderId =@OrderID) AND (B2bFareType= 2 or B2bFareType= 3))
	BEGIN
		SET @TaxB2BMARKUP = (SELECT TOP 1 B2BMarkup FROM tblBookMaster WHERE orderId= @orderId or ParentOrderId =@OrderID)
	END

	DECLARE @BasicFaremarkup DECIMAL(18, 2)= 0, @TotalTaxmarkup DECIMAL(18, 2)= 0

	IF EXISTS(SELECT TOP 1 pkId FROM tblPassengerBookDetails 
	INNER JOIN tblBookMaster ON tblBookMaster.pkId=tblPassengerBookDetails.fkBookMaster WHERE (tblBookMaster.orderId= @OrderID or ParentOrderId =@OrderID) AND (tblPassengerBookDetails.MarkOn= 'Markup on Base' or tblPassengerBookDetails.MarkOn = '' ))
	BEGIN
		SET @BasicFaremarkup = (SELECT TOP 1 BFC FROM tblBookMaster WHERE orderId= @orderId or ParentOrderId =@OrderID)
	END
	ELSE IF EXISTS(SELECT TOP 1 pkId FROM tblPassengerBookDetails INNER JOIN tblBookMaster ON tblBookMaster.pkId=tblPassengerBookDetails.fkBookMaster WHERE (tblBookMaster.orderId= @OrderID or ParentOrderId =@OrderID) AND (tblPassengerBookDetails.MarkOn = 'Markup on Tax'))
	BEGIN
		SET @TotalTaxmarkup = (SELECT TOP 1 BFC FROM tblBookMaster WHERE orderId= @orderId or ParentOrderId =@OrderID)
	END

    --Agency Details
    SELECT TOP 1
	FORMAT(
    CASE 
        WHEN tblBookMaster.IssueDate IS NULL THEN tblBookMaster.inserteddate
        ELSE tblBookMaster.IssueDate
    END,
    'dd-MMM-yyyy HH:mm',
    'en-US'
  ) AS BookingDate
	,tblBookMaster.emailId AS TravelerEmailID
	,tblBookMaster.mobileNo AS MobileNumber
	--,ISNULL(tblBookMaster.BookingSource,'') AS BookingType
	,(CASE  WHEN tblBookMaster.BookingSource = 'API' THEN ISNULL(tblBookMaster.SubBookingSource, '') 
      ELSE ISNULL(tblBookMaster.BookingSource,'') END) AS BookingType
	,ISNULL(B2BRegistration.AgencyName,'') AS ClientName
	,'+' + B2BRegistration.AddrMobileNo
    + CASE 
     WHEN B2BRegistration.AddrLandlineNo IS NOT NULL 
         AND B2BRegistration.AddrLandlineNo <> '' 
         AND B2BRegistration.AddrLandlineNo <> B2BRegistration.AddrMobileNo
     THEN '/' + B2BRegistration.AddrLandlineNo
     ELSE ''
     END AS ClientNumber
	--,B2BRegistration.AddrMobileNo AS ClientNumber
	,B2BRegistration.AddrEmail AS EmailID
	,ISNULL(tblBookMaster.BookingStatus,0) AS BookingStatus
	,ISNULL(tblBookMaster.HoldText,'') AS HoldText	
	,ISNULL(AgentLogin.AgentLogoNew,'') AS AgentLogo
	,ISNULL(B2BRegistration.CustomerCOde,'') AS ICUST
	,ISNULL(tblBookMaster.MainAgentId,0) AS MainAgentId
	,ISNULL(tblBookMaster.VendorName,0) AS VendorName
	,ISNULL(tblBookMaster.OfficeID,0) AS OfficeID
	,ISNULL(tblBookMaster.airCode,0) AS AirCode
	,ISNULL(tblBookMaster.agentid,0) AS AgentId
	,ISNULL(mUser.FullName,0) AS UserName
	,ISNULL(tblBookMaster.CompanyName,'') AS CompanyName	
	,ISNULL(tblBookMaster.RegistrationNumber,'') AS GST_No
	, ISNULL(ISNULL(B2BRegistration.AddrAddressLocation, '') + ',' + ISNULL(B2BRegistration.AddrCity, '') + ',' +ISNULL(B2BRegistration.AddrState, '') + '-' + ISNULL(B2BRegistration.AddrZipOrPostCode, ''), '') AS AgencyAddress

	-- START RMS/ATTRIBUTE 
	,(SELECT 
	Distinct(CASE WHEN tblPassengerBookDetails.title IS NOT NULL AND tblPassengerBookDetails.title <> '' 
        THEN tblPassengerBookDetails.title + '. ' ELSE '' END
        + tblPassengerBookDetails.paxFName + ' ' + ISNULL(tblPassengerBookDetails.paxLName, '') + ' ') AS PaxName
   , (SELECT 
            Attribute, 
            Value
           FROM mAttrributesDetails
           CROSS APPLY (
            VALUES
			('Job Code/Booking Given by', JobCodeBookingGivenBy), 
			('Vessel name', VesselName),
			('Reason of travel', ReasonofTravel),
			('Travel request number', TravelRequestNumber),
			('Budget code', BudgetCode),
			('Employee ID', EmpDimession),
			('Swon no', SwonNo),
			('Traveller Type', TravelerType),
			('Location', Location),
			('Department', Department),
			('Grade', Grade),
			('Booked by', Bookedby),
			('Designation', Designation),
			('Chargeability', Chargeability),
			('Name of approver', NameofApprover),
			('Reference No.', ReferenceNo),
			('TR/PO name', TR_POName),
			('Rank', RankNo),
			('Type', AType),
			('Booking received date', BookingReceivedDate),
			('Is PAX Holding VISA?', paxvisa),
			('Changed Cost Centre', Changedcostno),
			('Travel Duration', Travelduration),
			('TAS Request Number', TASreqno),
			('Company code CC', Companycodecc),
			('Travel Type', Traveltype),
			('Project Code', Projectcode),
			('Cost center', CostCenter),
			('OBTC Number', OBTCno),
			('PAN Card Number', PanCardno),
			('Deviation Approver name and  EMP CODE', DEVIATION_APPROVER_NAME_AND_EMPCODE),
			('Lowest Logical Fare 1', LOWEST_LOGICAL_FARE_1),
			('Lowest Logical Fare 2', LOWEST_LOGICAL_FARE_2),
			('Lowest Logical Fare 3', LOWEST_LOGICAL_FARE_3),
			('Role Band', RoleBand),
			('Emp Location', EmpLocation),
			('Vertical Location', VerticalLocation),
			('Horizontal', Horizontal),
			('Vertical', Vertical),
			--('OU Name', OUNameIDF),
			('BTA NO', BTANO),
			('Request No', RequestID),
			('Fare Rule', FareRule),
			('Fare Type', FareType),
			('Travel Officer', EmpIDTRAVELOFFICER),
			('Remarks', Remarks),
			('Carbon Footprint', CarbonFootprint),
			('Currency Conversion Rate', CurrencyConversionRate),
			('Project Name', ProjectName),
			('PID', PID),
			('UID', UID),
			('Account', Account),
			('Cost Centre', CostCentre),
			('Concur ID', ConcurID),
			('Approver Name', ApproverName),
			('GESS-RECEIVED-DATE', GESSRECEIVEDDATE),
			('Ticket Type', TicketType),
			('EmpID-TRAVEL OFFICER', EmpIDTRAVELOFFICER),
			('DEVIATION APPROVER', DEVIATIONAPPROVER),
			('EMPLOYEES POSITION BILLIABLE TO CLIENT', EMPLOYEESPOSITION),
			('TRAVEL COST REIMBURSABLE BY CLIENT', TRAVELCOSTREIMBURSABLE),
			('Billing Entity Name', BillingEntityName),
			('Issuance Date', Issuancedate),
			('TripPurpose', TripPurpose),
			('ProjectNo', ProjectNo),
			('TravelReason', TravelReason)
        ) AS Data(Attribute, Value)
        WHERE mAttrributesDetails.fkPassengerid = tblPassengerBookDetails.pid
        AND Value IS NOT NULL AND Value <> ''
        FOR JSON PATH) AS PaxWiseAttributes
        FROM tblPassengerBookDetails
        INNER JOIN tblBookMaster 
        ON tblBookMaster.pkId = tblPassengerBookDetails.fkBookMaster
        WHERE tblBookMaster.OrderID LIKE @OrderID + '%' 
		AND tblBookMaster.returnFlag =0
        FOR JSON PATH) AS PaxAttributes
		-- END RMS/ATTRIBUTE

    -- START ONWARD/RETURN FLIGHT DETAIL
	 , (SELECT  BookMasterItenary.airName AS VendorName
	           ,BookMasterItenary.airCode AS AirCode
			,tblBookItenary.flightNo AS FlightNo
			,tblBookItenary.frmSector AS FromSector
			,tblBookItenary.toSector AS ToSector
		    ,tblBookItenary.fromAirport AS FromAirport
		    ,tblBookItenary.toAirport AS ToAirport
		    ,tblBookItenary.fromTerminal AS FromTerminal
			,tblBookItenary.toTerminal AS ToTerminal
			,BookMasterItenary.journey AS Journey
			,tblBookItenary.pkid AS ItenaryID	
			,BookMasterItenary.pkid AS BookMasterID
			,BookMasterItenary.returnFlag AS ReturnFlag		
           ,ISNULL(BookMasterItenary.ParentOrderId, BookMasterItenary.orderid) AS OrderId
             ,ISNULL(tblBookItenary.cabin, '') AS CabinClass
             ,ISNULL(tblBookItenary.farebasis, '') AS FareBasis	
			
			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(BookMasterItenary.basicFare,0) * BookMasterItenary.AgentROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(BookMasterItenary.basicFare,0)) AS DECIMAL(10, 2))
				END) AS BasicFare
				
			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(BookMasterItenary.basicFare,0) * BookMasterItenary.AgentROE) + CASE WHEN ISNULL(BookMasterItenary.basicFare, 0) != 0 THEN @BasicB2BMARKUP+ISNULL(BookMasterItenary.TotalLonServiceFee, 0) + @BasicFaremarkup ELSE 0 END AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(BookMasterItenary.basicFare,0)) + CASE WHEN ISNULL(BookMasterItenary.basicFare, 0) != 0 THEN @BasicB2BMARKUP+ISNULL(BookMasterItenary.TotalLonServiceFee, 0) + @BasicFaremarkup ELSE 0 END AS DECIMAL(10, 2))
				END) AS BasicFareWithAll

			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(BookMasterItenary.TotalTax,0) * BookMasterItenary.AgentROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(BookMasterItenary.TotalTax,0)) AS DECIMAL(10, 2))
				END) AS TotalTax
			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(BookMasterItenary.TotalTax,0) * BookMasterItenary.AgentROE) +@TaxB2BMARKUP 
					+CASE WHEN ISNULL(BookMasterItenary.TotalTax, 0) != 0 THEN @TotalTaxmarkup +ISNULL(BookMasterItenary.TotalVendorServiceFee, 0) + ISNULL(B2BMakepaymentCommissionI.TotalCommission,0) ELSE 0 END  AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(BookMasterItenary.TotalTax,0))
					+ CASE WHEN ISNULL(BookMasterItenary.TotalTax, 0) != 0 THEN @TaxB2BMARKUP + @TotalTaxmarkup +ISNULL(BookMasterItenary.TotalVendorServiceFee, 0) + ISNULL(B2BMakepaymentCommissionI.TotalCommission,0) ELSE 0 END AS DECIMAL(10, 2))
				END) AS TotalTaxWithAll

			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(BookMasterItenary.totalFare,0) * BookMasterItenary.AgentROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(BookMasterItenary.totalFare,0)) AS DECIMAL(10, 2))
				END) AS totalFare

			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((((ISNULL(BookMasterItenary.totalFare,0) * BookMasterItenary.AgentROE)  
					+ CASE WHEN ISNULL(BookMasterItenary.totalFare, 0) != 0 THEN BookMasterItenary.B2BMarkup +ISNULL(BookMasterItenary.TotalLonServiceFee, 0)+ BookMasterItenary.BFC + BookMasterItenary.ServiceFee + BookMasterItenary.GST ELSE 0 END) - ISNULL(BookMasterItenary.TotalEarning,0)) AS DECIMAL(10, 2))
					ELSE CAST((((ISNULL(BookMasterItenary.totalFare,0)) 
					+ CASE WHEN ISNULL(BookMasterItenary.totalFare, 0) != 0 THEN BookMasterItenary.B2BMarkup +ISNULL(BookMasterItenary.TotalLonServiceFee, 0) + BookMasterItenary.BFC + BookMasterItenary.ServiceFee + BookMasterItenary.GST ELSE 0 END) - ISNULL(BookMasterItenary.TotalEarning,0))  AS DECIMAL(10, 2))
				END) AS totalFareWithAll

			,ISNULL(BookMasterItenary.ROE,0) AS ROE
			,ISNULL(BookMasterItenary.ServiceFee,0) AS ServiceFee
			,ISNULL(BookMasterItenary.GST,0) AS GST		
			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(BookMasterItenary.ExtraTax,0) * BookMasterItenary.AgentROE * BookMasterItenary.ROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(BookMasterItenary.ExtraTax,0) * BookMasterItenary.ROE) AS DECIMAL(10, 2))
				END) AS ExtraTax
			,ISNULL(BookMasterItenary.TotalEarning,0) AS Discount
			,tblBookItenary.Via AS Via
			,FORMAT(tblBookItenary.deptTime, 'dd-MMM-yyyy HH:mm', 'en-US') AS DepDate
            ,FORMAT(tblBookItenary.arrivalTime, 'dd-MMM-yyyy HH:mm', 'en-US')  AS ArrivalDate
                 ,ISNULL(CONVERT(char(5), tblBookItenary.deptTime, 108),'') AS DeptTime
		     , ISNULL(CONVERT(char(5), tblBookItenary.arrivalTime, 108),'') AS ArrivalTime
			 , (SELECT (CASE 
                   WHEN tblPassengerBookDetails.title IS NOT NULL AND tblPassengerBookDetails.title <> '' 
                   THEN tblPassengerBookDetails.title + '. ' 
                   ELSE '' 
                   END
                   + tblPassengerBookDetails.paxFName + ' ' 
                   + ISNULL(tblPassengerBookDetails.paxLName, '') + ' ') AS PaxName
		--	, (SELECT (ISNULL(tblPassengerBookDetails.title,'') + '. ' + tblPassengerBookDetails.paxFName + ' ' + ISNULL(tblPassengerBookDetails.paxLName,'') + ' ') AS PaxName
		     ,CASE 
               WHEN tblPassengerBookDetails.paxType = 'LBR' OR  tblPassengerBookDetails.paxType = 'IIT'  THEN 'ADULT'
                ELSE ISNULL(tblPassengerBookDetails.paxType, '')
               END AS PaxType		     
			 ,ISNULL(tblBookMaster.GDSPNR, 'NA') AS GDSPNR
		     ,ISNULL(tblPassengerBookDetails.ticketNum,'') AS TicketNumber
		     ,ISNULL(tblPassengerBookDetails.baggage,'') AS Baggage
		     ,tblBookMaster.returnFlag AS ReturnFlag
			 ,ISNULL(tblBookItenary.airlinePNR,'') AS AirlinePNR
	         ,ISNULL(tblBookItenary.cabin, '') AS CabinClass
             ,ISNULL(tblBookItenary.farebasis, '') AS FareBasis	
			  ,(CASE WHEN tblBookMaster.BookingStatus = 6 
                    THEN ISNULL(tblPassengerBookDetails.BookingStatus, 1) ELSE tblBookMaster.BookingStatus
                 END) AS BookingStatus 

			 ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.basicFare,0) * tblBookMaster.AgentROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.basicFare,0)) AS DECIMAL(10, 2))
				END) AS BasicFare

				 ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.basicFare,0) * tblBookMaster.AgentROE) + 
                   + (CASE WHEN tblBookMaster.B2bFareType IN (1) THEN tblPassengerBookDetails.B2BMarkup ELSE 0 END)
				    + (CASE WHEN tblBookMaster.B2bFareType IN (1) THEN ISNULL(CAST(NULLIF(tblPassengerBookDetails.ParentB2BMarkup, '') AS DECIMAL(18,2)), 0) ELSE 0 END)
				   + (CASE WHEN ISNULL(tblPassengerBookDetails.MarkOn, '') = 'Markup on Base' THEN tblPassengerBookDetails.BFC ELSE 0 END)
				   + ISNULL(tblPassengerBookDetails.LonServiceFee, 0) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.basicFare,0)) 
                   + (CASE WHEN tblBookMaster.B2bFareType IN (1) THEN tblPassengerBookDetails.B2BMarkup ELSE 0 END) 
				    + (CASE WHEN tblBookMaster.B2bFareType IN (1) THEN ISNULL(CAST(NULLIF(tblPassengerBookDetails.ParentB2BMarkup, '') AS DECIMAL(18,2)), 0) ELSE 0 END)
				    + (CASE WHEN ISNULL(tblPassengerBookDetails.MarkOn, '') = 'Markup on Base' THEN tblPassengerBookDetails.BFC ELSE 0 END)
					+ ISNULL(tblPassengerBookDetails.LonServiceFee, 0) AS DECIMAL(10, 2))
				END) AS BasicFareWithAll

			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.totalTax,0) * tblBookMaster.AgentROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.totalTax,0)) AS DECIMAL(10, 2))
				END) AS TotalTax

			 ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.totalTax,0) * tblBookMaster.AgentROE)
				  + (CASE WHEN tblBookMaster.B2bFareType IN (2, 3) THEN tblPassengerBookDetails.B2BMarkup ELSE 0 END)
				   + (CASE WHEN tblBookMaster.B2bFareType IN (2, 3) THEN ISNULL(CAST(NULLIF(tblPassengerBookDetails.ParentB2BMarkup, '') AS DECIMAL(18,2)), 0) ELSE 0 END)
                  + (CASE WHEN tblPassengerBookDetails.MarkOn = 'Markup on Tax' THEN tblPassengerBookDetails.BFC ELSE 0 END)
				   AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.totalTax,0)) 
                    + (CASE WHEN tblBookMaster.B2bFareType IN (2, 3) THEN tblPassengerBookDetails.B2BMarkup ELSE 0 END)
					 + (CASE WHEN tblBookMaster.B2bFareType IN (2, 3) THEN ISNULL(CAST(NULLIF(tblPassengerBookDetails.ParentB2BMarkup, '') AS DECIMAL(18,2)), 0) ELSE 0 END)
					+ (CASE WHEN tblPassengerBookDetails.MarkOn = 'Markup on Tax' THEN tblPassengerBookDetails.BFC ELSE 0 END)
					 AS DECIMAL(10, 2))
				END) AS TotalTaxWithAll

			  ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.totalFare,0) * tblBookMaster.AgentROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.totalFare,0)) AS DECIMAL(10, 2))
				END) AS TotalFare


			  ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.totalFare,0) * tblBookMaster.AgentROE) + ISNULL(tblPassengerBookDetails.LonServiceFee, 0) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.totalFare,0)) + ISNULL(tblPassengerBookDetails.LonServiceFee, 0) AS DECIMAL(10, 2))
				END) AS TotalFareWithAll

				,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.totalFare,0) * tblBookMaster.AgentROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.totalFare,0)) AS DECIMAL(10, 2))
				END) AS NetFare
				
				,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((((ISNULL(tblPassengerBookDetails.totalFare,0) * tblBookMaster.AgentROE)
					 +tblPassengerBookDetails.B2BMarkup +ISNULL(CAST(tblPassengerBookDetails.ParentB2BMarkup AS DECIMAL(18,2)), 0) +tblPassengerBookDetails.BFC + tblPassengerBookDetails.ServiceFee
					 +tblPassengerBookDetails.GST+ ISNULL(tblPassengerBookDetails.VendorServiceFee,0)+ ISNULL(tblPassengerBookDetails.LonServiceFee, 0)
					 + (ISNULL(tblPassengerBookDetails.AirlineFee,0)* tblBookMaster.ROE)+ ISNULL(tblPassengerBookDetails.AirlineGST,0))-(ISNULL(tblPassengerBookDetails.PLBCommission, 0)+ISNULL(tblPassengerBookDetails.IATACommission, 0)+ISNULL(tblPassengerBookDetails.DropnetCommission, 0))) AS DECIMAL(10, 2))
					ELSE CAST((((ISNULL(tblPassengerBookDetails.totalFare,0))
					+tblPassengerBookDetails.B2BMarkup +ISNULL(CAST(tblPassengerBookDetails.ParentB2BMarkup AS DECIMAL(18,2)), 0) +tblPassengerBookDetails.BFC + tblPassengerBookDetails.ServiceFee
					+tblPassengerBookDetails.GST+ ISNULL(tblPassengerBookDetails.VendorServiceFee,0)+ ISNULL(tblPassengerBookDetails.LonServiceFee, 0)
					+ (ISNULL(tblPassengerBookDetails.AirlineFee,0)* tblBookMaster.ROE)+ ISNULL(tblPassengerBookDetails.AirlineGST,0))-(ISNULL(tblPassengerBookDetails.PLBCommission, 0)+ISNULL(tblPassengerBookDetails.IATACommission, 0)+ISNULL(tblPassengerBookDetails.DropnetCommission, 0))) AS DECIMAL(10, 2))
				END) AS NetFareWithAll

				,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.totalFare,0) * tblBookMaster.AgentROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.totalFare,0)) AS DECIMAL(10, 2))
				END) AS GrossFare

				,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST(((ISNULL(tblPassengerBookDetails.totalFare,0) * tblBookMaster.AgentROE )
					 +tblPassengerBookDetails.B2BMarkup +ISNULL(CAST(tblPassengerBookDetails.ParentB2BMarkup AS DECIMAL(18,2)), 0) +tblPassengerBookDetails.BFC + tblPassengerBookDetails.ServiceFee
					 +tblPassengerBookDetails.GST+ISNULL(tblPassengerBookDetails.VendorServiceFee,0)+ ISNULL(tblPassengerBookDetails.LonServiceFee, 0)
					 +( ISNULL(tblPassengerBookDetails.AirlineFee,0)* tblBookMaster.ROE)+ ISNULL(tblPassengerBookDetails.AirlineGST,0)) AS DECIMAL(10, 2))
					ELSE CAST(((ISNULL(tblPassengerBookDetails.totalFare,0))
					+tblPassengerBookDetails.B2BMarkup +ISNULL(CAST(tblPassengerBookDetails.ParentB2BMarkup AS DECIMAL(18,2)), 0) +tblPassengerBookDetails.BFC + tblPassengerBookDetails.ServiceFee
					+tblPassengerBookDetails.GST+ISNULL(tblPassengerBookDetails.VendorServiceFee,0)+ ISNULL(tblPassengerBookDetails.LonServiceFee, 0)
					+ (ISNULL(tblPassengerBookDetails.AirlineFee,0)* tblBookMaster.ROE)+ ISNULL(tblPassengerBookDetails.AirlineGST,0)) AS DECIMAL(10, 2))
				END) AS GrossFareWithAll
             
		     ,ISNULL(tblPassengerBookDetails.ServiceFee,0) AS ServiceFee
		     ,ISNULL(tblPassengerBookDetails.GST,0) AS GST
			  ,ISNULL(CAST(tblPassengerBookDetails.ParentB2BMarkup AS DECIMAL(18,2)), 0) AS ParentB2BMarkup
		  
		  --,ISNULL(tblPassengerBookDetails.AirlineFee,0) AS AirlineFee
			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.AirlineFee,0) * tblBookMaster.AgentROE * tblBookMaster.ROE)  AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.AirlineFee,0) * tblBookMaster.ROE) AS DECIMAL(10, 2))
				END) AS AirlineFee
			,ISNULL(tblPassengerBookDetails.AirlineGST,0) AS AirlineGST
			  ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.YQ,0) * tblBookMaster.AgentROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.YQ,0)) AS DECIMAL(10, 2))
				END) AS YQTax
			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.YRTax,0) * tblBookMaster.AgentROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.YRTax,0)) AS DECIMAL(10, 2))
				END) AS YRTax
			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.JNTax,0) * tblBookMaster.AgentROE ) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.JNTax,0)) AS DECIMAL(10, 2))
				END) AS JNTax
			 ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.K7Tax,0) * tblBookMaster.AgentROE) AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.K7Tax,0)) AS DECIMAL(10, 2))
				END) AS K7Tax
		     ,ISNULL(tblPassengerBookDetails.PLBCommission, 0)+ISNULL(tblPassengerBookDetails.IATACommission, 0)+ISNULL(tblPassengerBookDetails.DropnetCommission, 0) AS Discount
		     ,ISNULL(tblPassengerBookDetails.DiscountGST,0) AS DiscountGST
		     ,ISNULL(tblPassengerBookDetails.DiscountTDS,0) AS DiscountTDS
		     ,ISNULL(tblPassengerBookDetails.B2BMarkup,0)+ISNULL(CAST(tblPassengerBookDetails.ParentB2BMarkup AS DECIMAL(18,2)), 0) AS Markup
			 ,ISNULL(tblPassengerBookDetails.MarkOn,'') AS MarkOn
			 ,ISNULL(tblPassengerBookDetails.BFC,0) AS BFC
		     --,ISNULL(tblPassengerBookDetails.MCOAmount,0) AS MCOAmount
			 ,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(tblPassengerBookDetails.MCOAmount,0) * tblBookMaster.AgentROE)  AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(tblPassengerBookDetails.MCOAmount,0)) AS DECIMAL(10, 2))
				END) AS MCOAmount
		    ,ISNULL(tblPassengerBookDetails.WOTax,0) AS WOTax
		    ,(ISNULL(tblPassengerBookDetails.VendorServiceFee,0)+ ISNULL(tblPassengerBookDetails.LonServiceFee, 0)) AS VendorServiceFee

			,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency
		 			THEN CAST(((ISNULL(tblPassengerBookDetails.INTax, 0)
					 + ISNULL(tblPassengerBookDetails.OCTax, 0)
					 + ISNULL(tblPassengerBookDetails.ExtraTax, 0)
					 + ISNULL(tblPassengerBookDetails.YMTax, 0)
					 + ISNULL(tblPassengerBookDetails.WOTax, 0)
					 + ISNULL(tblPassengerBookDetails.OBTax, 0)
					 + ISNULL(tblPassengerBookDetails.RFTax, 0)) * tblBookMaster.AgentROE) AS Numeric(18, 2))
									
		 		ELSE CAST(((ISNULL(tblPassengerBookDetails.INTax, 0)
					 + ISNULL(tblPassengerBookDetails.OCTax, 0)
					 + ISNULL(tblPassengerBookDetails.ExtraTax, 0)
					 + ISNULL(tblPassengerBookDetails.YMTax, 0)
					 + ISNULL(tblPassengerBookDetails.WOTax, 0)
					 + ISNULL(tblPassengerBookDetails.OBTax, 0)
					 + ISNULL(tblPassengerBookDetails.RFTax, 0))) AS Numeric(18, 2))
		 	         END) AS XTTax
		
		     ,ISNULL(tblBookMaster.ROE,0) AS ROE
		     ,ISNULL(B2BMakepaymentCommission.TotalCommission,0) AS PGCharges
		     ,Paymentmaster.payment_mode AS PaymentMode
		     ,tblBookMaster.VendorName AS Supplier
		     ,tblBookMaster.OfficeID AS PCC
		     ,tblBookMaster.PricingCode AS PricingCode
		     ,tblBookMaster.TourCode AS TourCode
		     ,tblPassengerBookDetails.pid AS PassengerBookID 
		     ,tblBookMaster.pkid AS BookMasterID
		     ,BookItenaryPassenger.pkid AS BookItenaryID
		     ,ISNULL(tblPassengerBookDetails.FrequentFlyNo,'') AS FFNNumber
		     ,ISNULL(BookItenaryPassenger.CarbonEmission,'') AS CarbonEmission
		    , (SELECT STUFF((SELECT '/' + CAST(tblPassengerBookDetailsbook.pid AS VARCHAR)
					FROM tblPassengerBookDetails tblPassengerBookDetailsbook WITH(NOLOCK)
					 JOIN tblBookMaster bm2 ON bm2.pkId = tblPassengerBookDetailsbook.fkBookMaster
					WHERE (tblPassengerBookDetailsbook.paxFName + tblPassengerBookDetailsbook.paxLName) = (tblPassengerBookDetails.paxFName + tblPassengerBookDetails.paxLName) and
					bm2.returnFlag = tblBookMaster.returnFlag AND
					bm2.BookingStatus = 18 and riyaPNR =@RiyaPNR AND
					bm2.pkId = tblPassengerBookDetailsbook.fkBookMaster
					FOR XML PATH ('')) , 1, 1, '')) AS PaxAmendmentID
		     FROM tblPassengerBookDetails 
		     LEFT JOIN tblBookMaster  ON tblBookMaster.pkId = tblPassengerBookDetails.fkBookMaster
		     LEFT JOIN B2BMakepaymentCommission  ON B2BMakepaymentCommission.FkBookId = tblBookMaster.pkId
		     LEFT JOIN Paymentmaster  ON Paymentmaster.order_id = tblBookMaster.orderId
		     LEFT JOIN tblBookItenary BookItenaryPassenger ON  BookItenaryPassenger.fkBookMaster = tblBookMaster.pkId
		     WHERE tblBookMaster.riyaPNR = @RiyaPNR
			 --tblBookMaster.orderId = @OrderID or tblBookMaster.ParentOrderId =@OrderID
			 and tblPassengerBookDetails.fkBookMaster =BookMasterItenary.pkId
			-- and BookItenaryPassenger.pkId =tblBookItenary.pkId
			 and  tblBookItenary.pkId = BookItenaryPassenger.pkId 
		     FOR JSON PATH) AS OnwardReturnPaxDetails
			 ,tblBookItenary.isReturnJourney AS IsReturnJourney
			FROM tblBookItenary 		
			INNER JOIN tblBookMaster BookMasterItenary ON BookMasterItenary.pkId = tblBookItenary.fkBookMaster
			INNER JOIN mCountryCurrency  ON mCountryCurrency.CountryCode= BookMasterItenary.Country     
			LEFT JOIN B2BMakepaymentCommission B2BMakepaymentCommissionI  ON B2BMakepaymentCommissionI.FkBookId = BookMasterItenary.pkId
			WHERE  BookMasterItenary.riyapnr = @RiyaPNR and BookMasterItenary.BookingStatus != 20
			--tblBookItenary.orderId = @OrderID  or tblBookItenary.ParentOrderId =@OrderID
			ORDER BY  BookMasterItenary.returnFlag ASC   
		FOR JSON PATH) AS OnwardReturnFlightDetails
	-- END ONWARD/RETURN FLIGHT DETAIL

	-- START SSR Details
	, (SELECT fkBookMaster AS BookingID
		, fkPassengerid AS PassengerBookIDF
		, fkItenary AS BookItenaryIDF
		, ISNULL(SSR_Type,'') AS SSRType
		, ISNULL(SSR_Name,'') AS SSRName
		, ISNULL(SSR_Code,'') AS SSRCode
		--,ISNULL(SSR_Amount, 0) AS SSRAmount
		,(CASE 
        WHEN ISNULL(tblSSRDetails.ROE,0) = 0 
        THEN 
            CASE WHEN mCountryCurrency.CurrencyCode != @Currency
            THEN  CAST(ISNULL(tblSSRDetails.SSR_Amount,0) * tblBookMaster.AgentROE * tblBookMaster.ROE AS decimal(10,2))
            ELSE  CAST(ISNULL(tblSSRDetails.SSR_Amount,0) * tblBookMaster.ROE AS decimal(10,2))
            END
        ELSE 
            ISNULL(tblSSRDetails.SSR_Amount, 0) * tblSSRDetails.ROE
       END) AS SSRAmount
	FROM tblSSRDetails
	INNER JOIN tblBookMaster ON tblSSRDetails.fkBookMaster = tblBookMaster.pkId
	INNER JOIN mCountryCurrency  ON mCountryCurrency.CountryCode= tblBookMaster.Country       
	WHERE (tblBookMaster.orderId = @OrderID  or tblBookMaster.ParentOrderId =@OrderID)
	AND SSR_Code IS NOT NULL AND SSR_Status =1 
	FOR JSON PATH) AS SSRDetailNew
	-- END SSR Details

	-- START PAYMENT DETAIL
	, (SELECT TOP 1 Paymentmaster.PKID AS PaymentID
		,ISNULL(payment_mode, '') AS PaymentMode
		,CASE WHEN tblBookMaster.AgentROE <> 1 THEN (ISNULL(amount, 0)*ISNULL(tblBookMaster.AgentROE,1))
				ELSE ISNULL(amount, 0)
						END AS PaymenttAmount
		--,ISNULL(amount, 0) AS PaymenttAmount
		,FORMAT(inserteddt, 'dd-MMM-yyyy HH:mm', 'en-US') AS PaymentDate
		,ISNULL(bank_ref_no,'') AS PaymentReceipt
		,ISNULL(order_status,'') AS PaymentStatus
		FROM Paymentmaster
		INNER JOIN tblBookMaster ON tblBookMaster.orderid = Paymentmaster.order_id
		LEFT JOIN agentLogin al ON cast(al.UserID as nvarchar(30))=cast(tblBookMaster.AgentID as nvarchar(30))
		LEFT JOIN mcommon MC WITH(NOLOCK) ON al.NewCurrency = MC.ID  
		WHERE Paymentmaster.order_id = @OrderID
		FOR JSON PATH) AS PaymentDetails
	-- END PAYMENT DETAIL

	
	-- START AMENDMENT PAYMENT DETAIL
	, (SELECT  Paymentmaster.PKID AS PaymentID
		,ISNULL(Paymentmaster.payment_mode, '') AS PaymentMode
		--,ISNULL(Paymentmaster.amount, '') AS PaymenttAmount
		,CASE WHEN tblBookMaster.AgentROE <> 1 THEN (CAST(ISNULL(Paymentmaster.amount, 0) AS DECIMAL(10, 2)) *ISNULL(tblBookMaster.AgentROE,1))
				ELSE ISNULL(Paymentmaster.amount, 0)
						END AS PaymenttAmount
		,FORMAT(inserteddt, 'dd-MMM-yyyy HH:mm', 'en-US') AS PaymentDate
		,ISNULL(Paymentmaster.bank_ref_no,'') AS PaymentReceipt
		,ISNULL(Paymentmaster.order_status,'') AS PaymentStatus
		,ISNULL(Paymentmaster.AmendmentRefNo,'') AS AmendmentRefNo
		,ISNULL(Source,'') AS Source
		,ISNULL(Paymentmaster.order_id,'') AS OrderId
		,ISNULL(Paymentmaster.ParentOrderId,'') AS ParentOrderId
		,ISNULL(tblagentbalance.TransactionType,'') AS TransactionType
		FROM Paymentmaster
		LEFT JOIN tblagentbalance ON tblagentbalance.bookingref =  Paymentmaster.order_id 
		INNER JOIN tblBookMaster ON tblBookMaster.orderid = Paymentmaster.ParentOrderId
		WHERE    
		Paymentmaster.ParentOrderId LIKE @OrderID + '%'  and tblBookMaster.returnflag=0
		
		FOR JSON PATH) AS AmendmentPaymentDetails
	-- END AMENDMENT PAYMENT DETAIL

	
	-- START AMENDMENT REQUEST DETAIL
	, (
    SELECT  AmendmentRef, Type, RequestBy, Inserteddate, RiyaPNR, Status, AbortedDate, AbortedBy, RescheduleDate,IsBooked,Cabin,PassengerId,AmendmentID
    FROM (
        SELECT 
		    ID As AmendmentID,
            AmendmentRef,
            ISNULL(Type, '') AS Type,
            dbo.GetUserName_Amendment(RequestBy) AS RequestBy,
			FORMAT(Inserteddate, 'dd-MMM-yyyy HH:mm', 'en-US') AS Inserteddate,
            RiyaPNR,
            ISNULL(Status, 0) AS Status,
			FORMAT(AbortedDate, 'dd-MMM-yyyy HH:mm', 'en-US') AS AbortedDate,
            dbo.GetUserName_Amendment(AbortedBy) AS AbortedBy,
			FORMAT(RescheduleDate, 'dd-MMM-yyyy', 'en-US') AS RescheduleDate,
			ISNULL(IsBooked,0) AS IsBooked,
			ISNULL(Cabin,'') AS Cabin,
			 (SELECT STUFF((SELECT DISTINCT  ',' + CAST(PassengerId AS VARCHAR)
					FROM tbl_AmendmentRequest am WITH(NOLOCK)
					where innerTbl.AmendmentRef = am.AmendmentRef and riyaPNR = @RiyaPNR	
					FOR XML PATH ('')) , 1, 1, '')) AS PassengerId ,
            ROW_NUMBER() OVER (
            PARTITION BY AmendmentRef
            ORDER BY 
                CASE 
                    WHEN RescheduleDate = '1900-01-01' THEN 1 ELSE 0 
                END,  -- prefer valid date
                ID ASC
        ) AS rn
        FROM tbl_AmendmentRequest innerTbl WITH(NOLOCK)
        WHERE RiyaPNR = @RiyaPNR
    ) AS Ranked
    WHERE rn = 1
	ORDER BY AmendmentID ASC
    FOR JSON PATH
   ) AS AmendmentRequest

	-- END AMENDMENT REQUEST DETAIL

	-- START Cancellation DETAIL
	,(SELECT DISTINCT ISNULL(t1.paxFName + ' ' + ISNULL(t1.paxLName,''), '') AS FullName
		, CASE 
              WHEN t1.paxType = 'LBR' OR t1.paxType = 'IIT' THEN 'ADULT'
              ELSE ISNULL(t1.paxType, '')
              END AS PassengerType
		, t2.frmSector AS FromSector
		, t2.toSector AS ToSector
		,(CASE WHEN mCountryCurrency.CurrencyCode != @Currency 
					THEN CAST((ISNULL(t1.CancellationPenalty,0) * t2.AgentROE * t2.ROE)  AS DECIMAL(10, 2))
					ELSE CAST((ISNULL(t1.CancellationPenalty,0) * t2.ROE) AS DECIMAL(10, 2))
				END) AS CancellationPenalty
		--, ISNULL(t1.CancellationPenalty,0.0) AS CancellationPenalty
		, (ISNULL(t1.CancellationMarkup, 0) + ISNULL(t1.MarkupOnTaxFare, 0) + ISNULL(t1.MarkuponPenalty, 0)) AS CancellationMarkup
		, t1.RemarkCancellation2 AS CancellationRemark
		, FORMAT(CAST(t1.CancelledDate AS DateTime),'dd-MMM-yyyy HH:mm','en-us') AS CancellationDate
		, ISNULL(u.UserName, br.AgencyName) AS UserName
		, t1.pid AS PassengerBookDetailIDP
	FROM tblPassengerBookDetails t1
	LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
	LEFT JOIN [mUser] u ON u.id=t1.CancelByBackendUser1
	LEFT JOIN B2BRegistration br ON br.FKUserID=t1.CancelByAgency1
	INNER JOIN mCountryCurrency  ON mCountryCurrency.CountryCode= tblBookMaster.Country 
	WHERE t2.riyaPNR = @RiyaPNR 
	AND t1.RemarkCancellation2 IS NOT NULL 
	ORDER BY pid ASC
	 FOR JSON PATH
   ) AS CancellationDetails
   -- END Cancellation DETAIL

	FROM tblBookMaster
	LEFT JOIN AgentLogin ON AgentLogin.UserID = tblBookMaster.AgentID
	LEFT JOIN mUser  ON mUser.id = tblBookMaster.BookedBy and tblBookMaster.MainAgentId > 0
	LEFT JOIN B2BRegistration ON B2BRegistration.FKUserID = tblBookMaster.AgentID OR B2BRegistration.FKUserID = AgentLogin.ParentAgentID
    WHERE tblBookMaster.riyaPNR = @RiyaPNR
	FOR JSON PATH ,ROOT('B2BBookingClass')

END