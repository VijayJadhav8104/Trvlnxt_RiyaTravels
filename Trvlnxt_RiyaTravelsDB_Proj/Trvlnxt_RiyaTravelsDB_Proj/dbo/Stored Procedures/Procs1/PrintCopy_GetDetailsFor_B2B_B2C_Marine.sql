-- =============================================
-- Author:		<JD>
-- Create date: <11.09.2023>
-- Description:	<Description,,>
-- =============================================
--PrintCopy_GetDetailsFor_B2B_B2C_Marine 'RT20230704101348095', '10HON4', 'DF', 'INR', NULL, ''
--PrintCopy_GetDetailsFor_B2B_B2C_Marine 'RT20230926132615291', 'PSL230', 'WM273X', 'AED', ''
CREATE PROCEDURE [dbo].[PrintCopy_GetDetailsFor_B2B_B2C_Marine]
	 @Orderid NVarchar(50) = NULL
	, @RiyaPNR Varchar(20) = NULL
	, @GDSPNR Varchar(20) = NULL
	, @Currency Varchar(10)
	, @SectorID Varchar(20) = NULL
AS
BEGIN
	DECLARE @NewOrderID Varchar(50) = NULL, @FromSector Varchar(5) = '',
	@ToSector Varchar(20) = '', @TotalBookMasterCount Int,
	@AgentLogo Varchar(20) = '', @AgentId varchar(20)=''
	
	SELECT TOP 1 @NewOrderID = orderId, @ToSector = toSector,@AgentId=AgentID
	FROM tblBookMaster 
	WHERE riyaPNR = @RiyaPNR and BookingStatus != 18
	ORDER BY pkId DESC

	SELECT TOP 1 @FromSector = frmSector 
	FROM tblBookMaster 
	WHERE riyaPNR = @RiyaPNR
	ORDER BY pkId ASC

	SELECT @TotalBookMasterCount = COUNT(pkId)
	FROM tblBookMaster WHERE riyaPNR = @RiyaPNR AND ISNULL(TripType, '') != 'M'

	IF EXISTS(SELECT orderId FROM tblBookItenary where orderId = @NewOrderID AND isReturnJourney = 1)
	BEGIN
		SELECT TOP 1 @ToSector = (frmSector + '-' + toSector)
		FROM tblBookItenary 
		WHERE orderId = @NewOrderID AND isReturnJourney = 1
		ORDER BY pkId DESC
	END

	SELECT TOP 1 @AgentLogo = AgentLogoNew 
	FROM  tblBookMaster tbm
	LEFT JOIN AgentLogin agl ON agl.UserID = TRY_CAST(tbm.AgentID AS bigint)
	WHERE riyaPNR = @RiyaPNR

	--Common details
	IF(@AgentLogo != '')
	BEGIN
	SELECT TOP 1 ISNULL(agl.AgentLogoNew, '') AS AgentLogo
		, ISNULL(b2br.AgencyName, '') AS AgencyName
		,'+' + b2br.AddrMobileNo
		+ CASE 
		 WHEN b2br.AddrLandlineNo IS NOT NULL 
			 AND b2br.AddrLandlineNo <> '' 
			 AND b2br.AddrLandlineNo <> b2br.AddrMobileNo
		 THEN '/' + b2br.AddrLandlineNo
		 ELSE '' END AS AgencyContact
		--, ISNULL(b2br.AddrLandlineNo, '') + '/' + ISNULL(b2br.AddrMobileNo, '') AS AgencyContact
		, CASE WHEN @Agentid='48777' THEN 'NA' ELSE ISNULL(b2br.AddrEmail, '') END AS AgencyEmail
		, ISNULL(b2br.CustomerCOde, '') AS ICUST
		, ISNULL(ISNULL(b2br.AddrAddressLocation, '') + ',' + ISNULL(b2br.AddrCity, '') + ',' +ISNULL(b2br.AddrState, '') + '-' + ISNULL(b2br.AddrZipOrPostCode, ''), '') AS AgencyAddress
		, tbm.riyaPNR AS RiyaPNR
		, ISNULL(UPPER(FORMAT(tbm.IssueDate, 'dd-MMM-yyyy')), UPPER(FORMAT(ISNULL(tbm.inserteddate_old, tbm.inserteddate), 'dd-MMM-yyyy'))) AS IssueDate -- need to confirm
		, tbm.mobileNo AS CustomerContactno
		, CASE WHEN @Agentid='48777' THEN 'NA' ELSE tbm.emailId END AS EmailId
		, (CASE WHEN tbm.airName like '%AIRASIA%' THEN 'NA' ELSE ISNULL(tbm.GDSPNR, 'NA') END) AS CRSpnr -- need to confirm
		, tbi.airlinePNR AS AirlinePNR
		, (SELECT STUFF((SELECT '/' + ISNULL(tblBookMaster.ValidatingCarrier, tblBookMaster.airCode) 
							FROM tblBookMaster 
							WHERE tblBookMaster.orderId = @orderid 
							AND (@SectorID IS NULL OR @SectorID = '' OR tblBookMaster.pkId = @SectorID)
							FOR XML PATH('')),1,1,'')) AS Issueby
		, (SELECT TOP 1 tblBookItenary.aircode
				FROM tblBookItenary
				LEFT JOIN tblBookMaster ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
				WHERE tblBookMaster.orderId = @orderid
				AND (@SectorID IS NULL OR @SectorID = '' OR tblBookMaster.pkId = @SectorID)) AS AirCode
		--, ISNULL(pm.currency, tbm.agentcurrency) AS Currency
		,CASE WHEN tbm.AgentROE <> 1 THEN MC.Value
				ELSE ISNULL(pm.currency, tbm.agentcurrency)
						END AS Currency	
		, ISNULL(agl.GroupId, 0) AS GroupId
		, ISNULL(tbm.HoldText, '') AS HoldText
		, (@FromSector + '-' + @ToSector) AS Sector
		,  ISNULL(BookingStatus, 0) AS BookingStatus
		, UPPER(FORMAT(CAST(CASE tbm.Country
                   			WHEN 'AE' THEN (DATEADD(SECOND, - 1 * 60 * 60 - 29 * 60 - 13, CONVERT(DATETIME, ISNULL(tbm.inserteddate_old, tbm.inserteddate)))) 
                   			WHEN 'US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ISNULL(tbm.inserteddate_old, tbm.inserteddate)))) 
                   			WHEN 'CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ISNULL(tbm.inserteddate_old, tbm.inserteddate))))
                            WHEN 'SA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ISNULL(tbm.inserteddate_old, tbm.inserteddate))))
                   			WHEN 'GB' THEN (DATEADD(SECOND, - 5 * 60 * 60 + 30 * 60, CONVERT(DATETIME, ISNULL(tbm.inserteddate_old, tbm.inserteddate))))
                   			WHEN 'IN' THEN DATEADD(SECOND, 0, CONVERT(DATETIME, ISNULL(tbm.inserteddate_old, tbm.inserteddate)))
                 		END AS DATETIME), 'dd-MMM-yyyy hh:mm:ss tt')) AS BookingDateCountryWise
		, ISNULL(pm.payment_mode, '') AS PaymentMode
		, ISNULL(pm2.payment_mode, '') AS PaymentMode2
       , (CASE WHEN u.EmployeeNo IS NOT NULL
					THEN ISNULL(u.FullName, b2br.Icast) + ' (' + u.EmployeeNo + ')'
				ELSE ISNULL(u.FullName, b2br.Icast)
			END) AS BookedBy
		, (CASE WHEN tbm.MainAgentId > 0 AND tbm.BookingSource = 'Web' THEN 'Internal Booking (Web)'
				WHEN tbm.MainAgentId > 0 AND tbm.BookingSource = 'Retrive PNR' THEN 'Internal Booking (Retrive PNR)'
				WHEN tbm.MainAgentId > 0 AND tbm.BookingSource = 'Manual Ticketing' THEN 'Manual Booking'
				WHEN tbm.MainAgentId = 0 AND tbm.BookingSource = 'Web' THEN 'Agent Booking (Web)'
				WHEN tbm.MainAgentId = 0 AND tbm.BookingSource = 'Retrive PNR' THEN 'Agent Booking (Retrive PNR)'
				WHEN tbm.MainAgentId > 0 AND tbm.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN 'Internal Booking (PNR Accounting)'
				WHEN tbm.MainAgentId > 0 AND tbm.BookingSource = 'Retrieve PNR accounting - MultiTST' THEN 'Internal Booking Retrive PNR accounting - MultiTST'
				WHEN tbm.MainAgentId > 0 AND (tbm.BookingSource = 'Retrive PNR Accounting' OR tbm.BookingSource = 'Retrieve PNR accounting') THEN 'Retrieve PNR Accounting'
				WHEN tbm.BookingSource='GDS' THEN 'TJQ'
				WHEN tbm.BookingSource = 'API' THEN 'API'
			END) AS BookingType
		, ISNULL(tbm.OfficeID, '') AS BookingTicketingSupplier
		, ISNULL(tbm.FareType, '') AS FareType
		, ISNULL(tbm.CompanyName, 'NA') AS CompanyCode
		, ISNULL(tbm.RegistrationNumber, 'NA') AS GST_No
		,tbm.VendorName
		,tbm.journey AS Journey
	FROM tblBookMaster tbm
	LEFT JOIN AgentLogin agl ON agl.UserID = tbm.AgentID
	LEFT JOIN B2BRegistration b2br ON (b2br.FKUserID = tbm.AgentID OR b2br.FKUserID=agl.ParentAgentID)
	LEFT JOIN tblBookItenary tbi ON tbi.orderid = tbm.orderid AND tbi.airlinePNR = ISNULL(tbi.airlinePNR, '')
	LEFT JOIN Paymentmaster pm ON pm.order_id = tbm.orderid
	LEFT JOIN Paymentmaster pm2 ON pm2.ParentOrderId = tbm.orderid
	LEFT JOIN mcommon MC WITH(NOLOCK) ON agl.NewCurrency = MC.ID
	LEFT JOIN [mUser] u ON u.id = tbm.BookedBy and tbm.MainAgentId > 0
	WHERE tbm.orderid = @NewOrderID 
	AND tbm.returnFlag = 0 
	AND tbm.AgentID != 'B2C'
	END
	ELSE
	BEGIN
	SELECT TOP 1 ISNULL(agp.AgentLogoNew, '') AS AgentLogo
		, ISNULL(b2br.AgencyName, '') AS AgencyName
		,'+' + b2br.AddrMobileNo
		+ CASE 
		 WHEN b2br.AddrLandlineNo IS NOT NULL 
			 AND b2br.AddrLandlineNo <> '' 
			 AND b2br.AddrLandlineNo <> b2br.AddrMobileNo
		 THEN '/' + b2br.AddrLandlineNo
		 ELSE '' END AS AgencyContact
		--, ISNULL(b2br.AddrLandlineNo, '') + '/' + ISNULL(b2br.AddrMobileNo, '') AS AgencyContact
		, CASE WHEN @Agentid='48777' THEN 'NA' ELSE ISNULL(b2br.AddrEmail, '') END AS AgencyEmail
		, ISNULL(b2br.CustomerCOde, '') AS ICUST
		, ISNULL(ISNULL(b2br.AddrAddressLocation, '') + ',' + ISNULL(b2br.AddrCity, '') + ',' +ISNULL(b2br.AddrState, '') + '-' + ISNULL(b2br.AddrZipOrPostCode, ''), '') AS AgencyAddress
		, tbm.riyaPNR AS RiyaPNR
		, ISNULL(UPPER(FORMAT(tbm.IssueDate, 'dd-MMM-yyyy')), UPPER(FORMAT(ISNULL(tbm.inserteddate_old, tbm.inserteddate), 'dd-MMM-yyyy'))) AS IssueDate -- need to confirm
		, tbm.mobileNo AS CustomerContactno
		, CASE WHEN @Agentid='48777' THEN 'NA' ELSE tbm.emailId END AS EmailId
		, (CASE WHEN tbm.airName like '%AIRASIA%' THEN 'NA' ELSE ISNULL(tbm.GDSPNR, 'NA') END) AS CRSpnr -- need to confirm
		, tbi.airlinePNR AS AirlinePNR
		, (SELECT STUFF((SELECT '/' + ISNULL(tblBookMaster.ValidatingCarrier, tblBookMaster.airCode) 
							FROM tblBookMaster 
							WHERE tblBookMaster.orderId = @orderid 
							AND (@SectorID IS NULL OR @SectorID = '' OR tblBookMaster.pkId = @SectorID)
							FOR XML PATH('')),1,1,'')) AS Issueby
		, (SELECT TOP 1 tblBookItenary.aircode
				FROM tblBookItenary
				LEFT JOIN tblBookMaster ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
				WHERE tblBookMaster.orderId = @orderid
				AND (@SectorID IS NULL OR @SectorID = '' OR tblBookMaster.pkId = @SectorID)) AS AirCode
	--	, ISNULL(pm.currency, tbm.agentcurrency) AS Currency
		,CASE WHEN tbm.AgentROE <> 1 THEN MC.Value
				ELSE ISNULL(pm.currency, tbm.agentcurrency)
						END AS Currency	
		, ISNULL(agl.GroupId, 0) AS GroupId
		, ISNULL(tbm.HoldText, '') AS HoldText
		, (@FromSector + '-' + @ToSector) AS Sector
		, ISNULL(BookingStatus, 0) AS BookingStatus
		, UPPER(FORMAT(CAST(CASE tbm.Country
                   			WHEN 'AE' THEN (DATEADD(SECOND, - 1 * 60 * 60 - 29 * 60 - 13, CONVERT(DATETIME, ISNULL(tbm.inserteddate_old, tbm.inserteddate)))) 
                   			WHEN 'US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ISNULL(tbm.inserteddate_old, tbm.inserteddate)))) 
                   			WHEN 'CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ISNULL(tbm.inserteddate_old, tbm.inserteddate))))
                            WHEN 'SA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ISNULL(tbm.inserteddate_old, tbm.inserteddate))))
                   			WHEN 'GB' THEN (DATEADD(SECOND, - 5 * 60 * 60 + 30 * 60, CONVERT(DATETIME, ISNULL(tbm.inserteddate_old, tbm.inserteddate))))
                   			WHEN 'IN' THEN DATEADD(SECOND, 0, CONVERT(DATETIME, ISNULL(tbm.inserteddate_old, tbm.inserteddate)))
                 		END AS DATETIME), 'dd-MMM-yyyy hh:mm:ss tt')) AS BookingDateCountryWise
		, ISNULL(pm.payment_mode, '') AS PaymentMode
		, ISNULL(pm2.payment_mode, '') AS PaymentMode2
		, (CASE WHEN u.EmployeeNo IS NOT NULL
					THEN ISNULL(u.FullName, b2br.Icast) + ' (' + u.EmployeeNo + ')'
				ELSE ISNULL(u.FullName, b2br.Icast)
			END) AS BookedBy
		, (CASE WHEN tbm.MainAgentId > 0 AND tbm.BookingSource = 'Web' THEN 'Internal Booking (Web)'
				WHEN tbm.MainAgentId > 0 AND tbm.BookingSource = 'Retrive PNR' THEN 'Internal Booking (Retrive PNR)'
				WHEN tbm.MainAgentId > 0 AND tbm.BookingSource = 'Manual Ticketing' THEN 'Manual Booking'
				WHEN tbm.MainAgentId = 0 AND tbm.BookingSource = 'Web' THEN 'Agent Booking (Web)'
				WHEN tbm.MainAgentId = 0 AND tbm.BookingSource = 'Retrive PNR' THEN 'Agent Booking (Retrive PNR)'
				WHEN tbm.MainAgentId > 0 AND tbm.BookingSource = 'Retrive PNR Accounting-TicketNumber' THEN 'Internal Booking (PNR Accounting)'
				WHEN tbm.MainAgentId > 0 AND tbm.BookingSource = 'Retrieve PNR accounting - MultiTST' THEN 'Internal Booking Retrive PNR accounting - MultiTST'
				WHEN tbm.MainAgentId > 0 AND (tbm.BookingSource = 'Retrive PNR Accounting' OR tbm.BookingSource = 'Retrieve PNR accounting') THEN 'Retrieve PNR Accounting'
				WHEN tbm.BookingSource='GDS' THEN 'TJQ'
				WHEN tbm.BookingSource = 'API' THEN 'API'
			END) AS BookingType
		, ISNULL(tbm.OfficeID, '') AS BookingTicketingSupplier
		, ISNULL(tbm.FareType, '') AS FareType
		, ISNULL(tbm.CompanyName, 'NA') AS CompanyCode
		, ISNULL(tbm.RegistrationNumber, 'NA') AS GST_No
		,tbm.VendorName
		,tbm.journey AS Journey
	FROM tblBookMaster tbm
	LEFT JOIN AgentLogin agl ON agl.UserID = tbm.AgentID
	LEFT JOIN AgentLogin agp ON agp.UserID = agl.ParentAgentID
	LEFT JOIN B2BRegistration b2br ON (b2br.FKUserID = tbm.AgentID OR b2br.FKUserID=agl.ParentAgentID)
	LEFT JOIN tblBookItenary tbi ON tbi.orderid = tbm.orderid AND tbi.airlinePNR = ISNULL(tbi.airlinePNR, '')
	LEFT JOIN Paymentmaster pm ON pm.order_id = tbm.orderid
	LEFT JOIN Paymentmaster pm2 ON pm2.ParentOrderId = tbm.orderid
	LEFT JOIN mcommon MC WITH(NOLOCK) ON agl.NewCurrency = MC.ID
	LEFT JOIN [mUser] u ON u.id = tbm.BookedBy and tbm.MainAgentId > 0
	WHERE tbm.orderid = @NewOrderID 
	AND tbm.returnFlag = 0 
	AND tbm.AgentID != 'B2C'
	END


	--FLIGHT DETAILS
	SELECT DISTINCT t.airName AS AirName
		, t.isReturnJourney AS IsReturn
		, ISNULL(tb.TripType, '') AS TripType
		, t.pkId AS BookItenaryIDP
		, tb.pkId AS BookingID
		, t.operatingCarrier AS OperatingCarrier
		, t.flightNo AS FlightNo
		, t.airCode AS AirCode
		, (CASE WHEN (tb.BookingSource = 'Manual Ticketing') 
					THEN ISNULL(t.TotalTime, '')
			ELSE ISNULL(t.TotalTimeStopOver, '') END) AS TotalTime
		--, (CASE WHEN (tb.BookingSource = 'Manual Ticketing') 
		--			THEN ISNULL(t.TotalTime, '')
		--	ELSE ISNULL(CONVERT(varchar(5), DATEADD(minute, DATEDIFF(minute, t.deptTime , t.arrivalTime), 0), 114), '') END) AS TotalTime
		, (CAST(DATENAME(WEEKDAY, t.depDate) AS Varchar(3)) + ', ' + convert(Varchar, UPPER(FORMAT(t.depDate, 'dd-MMM-yyyy')))) AS DepartDateDisplay	
		, t.cabin AS Cabin
		, t.farebasis AS FareBasis
		, t.frmSector AS FromSector
		, t.toSector AS ToSector
		,ISNULL(CONVERT(char(5), t.deptTime, 108),'') AS DepartTime
		, ISNULL(CONVERT(char(5), t.arrivalTime, 108),'') AS ArrivTime
		, (CAST(DATENAME(WEEKDAY, t.arrivalDate) AS Varchar(3)) + ', ' + convert(Varchar,UPPER(FORMAT(t.arrivalDate, 'dd-MMM-yyyy')))) AS ArrivalDateDisplay
		, t.fromAirport AS FromAirport
		, t.toAirport AS ToAirport
		, t.fromTerminal AS FromTerminal
		, t.toTerminal AS ToTerminal
		, t.depDate AS DepDate
		, t.arrivalDate AS ArrivalDate
		, ISNULL(t.deptTime,'') AS DeptTime
		, ISNULL('VIA : '+t.Via,'') AS Via
		, ISNULL(t.arrivalTime,'') AS ArrivalTime
		, @TotalBookMasterCount AS TotalBookMasterCount
	FROM tblBookItenary t
	INNER JOIN tblBookMaster tb ON tb.pkId=t.fkBookMaster
	WHERE tb.orderId = @NewOrderID 
	AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID)
	ORDER BY ISNULL(t.deptTime,'') ASC

	--Passenger all Details(Seat baggege, excess baggege, meals)
	SELECT ROW_NUMBER() OVER (ORDER BY t1.pid ASC) AS SrNo
			, t1.pid AS PassengerBookIDP
			, t2.pkId AS BookingID
			, (t1.paxFName + ' ' + ISNULL(t1.paxLName,'') + ' ') AS FullName
			, CASE 
              WHEN t1.paxType = 'LBR' OR t1.paxType = 'IIT' THEN 'ADULT'
              ELSE ISNULL(t1.paxType, '')
              END AS PaxType
			, (CASE WHEN (BarCode IS NULL OR BarCode = '')
						THEN ''
				ELSE (SELECT STUFF((SELECT '^' + BarCode 
									FROM tblPassengerBookDetails PB 
									LEFT JOIN tblBookMaster t2 ON t2.pkId=PB.fkBookMaster 
									WHERE t2.orderId = @NewOrderID 
										AND (PB.paxFName + ' ' + PB.paxLName) = (t1.paxFName + ' ' + t1.paxLName)
									FOR XML PATH('')), 1, 1, ''))
				END) AS BarCode
				, CASE WHEN t2.BookingStatus = 6 THEN ISNULL(t1.BookingStatus, 1)
                   WHEN t2.BookingStatus = 4 THEN ISNULL(t1.BookingStatus, 1)
                   WHEN t2.BookingStatus = 11 THEN 4
                   ELSE ISNULL(t2.BookingStatus, 0)
                 END AS BookingStatus
			
				--,ISNULL( (CASE t2.BookingStatus 
				  --   WHEN 4 THEN ISNULL(t1.BookingStatus, 1)
                    --    ELSE ISNULL((CASE t2.BookingStatus WHEN 11 THEN 4 ELSE t2.BookingStatus END), 0)END) , 0) AS BookingStatus
			--, ISNULL((CASE t2.BookingStatus WHEN 11 THEN 4 ELSE t2.BookingStatus END),0) AS BookingStatus
			, (CASE WHEN CHARINDEX('/',ticketNum) > 0
						THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum) + 1, LEN(ticketNum)), 0, CHARINDEX('/', SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)))) 
					ELSE ticketNum END) AS TicketNumber
			, ISNULL(t1.FrequentFlyNo, '') AS FrequentFlyNo
			, '' AS Seat
			, '' AS Meals
			, t1.baggage AS Baggage
			, '' AS ExcessBaggage
			,t1.paxFName AS FirstName
			,t1.paxLName  AS LastName
			,t1.paxLName AS MiddleName
		FROM tblPassengerBookDetails t1 
		LEFT JOIN tblBookMaster t2 ON t2.pkId = t1.fkBookMaster 
		WHERE t2.orderId = @NewOrderID 
			AND (@SectorID IS NULL OR @SectorID = '' OR t2.pkId = @SectorID)
			--AND (t1.isReturn = 0 OR (t1.isReturn=1 AND (SELECT COUNT(pkId) 
			--										FROM tblBookMaster 
			--										WHERE orderId = @NewOrderID
			--											AND (@SectorID IS NULL OR @SectorID = '' OR tblBookMaster.pkId = @SectorID)) = 1))
			--AND (t1.isReturn = 1 OR t1.totalFare > 0 OR (ISNULL(t2.PreviousRiyaPNR, '') != '') OR t1.paxType = 'Infant')
		ORDER BY t1.pid ASC
	
	--SSR Details
	SELECT fkBookMaster AS BookingID
		, fkPassengerid AS PassengerBookIDF
		, fkItenary AS BookItenaryIDF
		, SSR_Type AS SSRType
		, SSR_Name AS SSRName
		, SSR_Code AS SSRCode
		,ISNULL(SSR_Amount, 0) AS SSRAmount
		--, ISNULL(SSR.SSR_Name, '') AS Baggage
		--, (CASE WHEN SSR.SSR_Code IS NOT NULL
		--						THEN 'Meal- ' + SSR.SSR_Code
		--					ELSE ''
		--				END) AS Meals
		--, ISNULL(SSR.SSR_Name, '') AS Seat
	FROM tblSSRDetails AS SSR
	INNER JOIN tblBookMaster AS tb ON SSR.fkBookMaster = tb.pkId
	WHERE tb.orderId = @NewOrderID
	AND SSR.SSR_Status =1
	AND SSR.SSR_Code IS NOT NULL

	--Taxes and other chanrges
	SELECT (CASE WHEN c.CurrencyCode != @currency
					THEN SUM(CAST((ISNULL(tp.serviceCharge, 0) * tb.AgentROE * tb.ROE) AS DECIMAL(10,2)))
				ELSE SUM(CAST((ISNULL(tp.serviceCharge, 0) * tb.ROE) AS DECIMAL(10,2)))
			END) AS ServiceCharge
		, (CASE WHEN c.CurrencyCode != @currency
		 			THEN SUM(CAST((ISNULL(tp.YRTax, 0) * tb.AgentROE * tb.ROE) AS DECIMAL(10,2)))
		 		ELSE SUM(CAST((ISNULL(tp.YRTax, 0) * tb.ROE) AS DECIMAL(10,2)))
		 	END) AS YRTax
		, (CASE WHEN c.CurrencyCode != @Currency
		 			THEN SUM(CAST(((ISNULL(tp.ExtraTax, 0)
									+ ISNULL(tp.INTax, 0)
									+ ISNULL(tp.JNTax, 0)
									+ ISNULL(tp.OCTax, 0)
									+ ISNULL(tp.WOTax, 0)
									+ ISNULL(tp.VendorServiceFee, 0)
									+ ISNULL(tb.ServiceFeeMap, 0)
									+ ISNULL(tb.ServiceFeeAdditional, 0)
									+ ISNULL(tp.YMTax, 0)+ISNULL(tp.AirlineFee,0)) * tb.AgentROE * tb.ROE) + ISNULL(tp.RFTax, 0) AS DECIMAL(10,2)))
									
		 		ELSE SUM(CAST(((ISNULL(tp.ExtraTax ,0)
								+ ISNULL(tp.INTax, 0)
								+ ISNULL(tp.JNTax, 0)
								+ ISNULL(tp.OCTax, 0)
								+ ISNULL(tp.WOTax, 0)
								+ ISNULL(tp.VendorServiceFee, 0)
								+ ISNULL(tb.ServiceFeeMap, 0)
								+ ISNULL(tb.ServiceFeeAdditional, 0)
								+ ISNULL(tp.YMTax, 0)+ISNULL(tp.AirlineFee,0)) * tb.ROE) + ISNULL(tp.RFTax, 0) AS DECIMAL(10,2)))
								
		 	END) AS ExtraTax
		, (CASE WHEN c.CurrencyCode != @currency
		 			THEN SUM(CAST((ISNULL(tp.YQ, 0) * tb.AgentROE * tb.ROE) AS DECIMAL(10,2)))
		 		ELSE SUM(CAST((ISNULL(tp.YQ, 0) * tb.ROE) AS DECIMAL(10,2)))
		 	END) AS YQTax
		, (CASE WHEN c.CurrencyCode != @currency
					THEN SUM(CAST((ISNULL(tp.B2BMarkup, 0) * tb.AgentROE * tb.ROE) AS DECIMAL(10,2)))
				ELSE SUM(CAST((ISNULL(tp.B2BMarkup, 0)) AS DECIMAL(10,2)))
			END) AS SCTax
			
		, (CASE WHEN c.CurrencyCode != @currency
		 			THEN SUM(CAST((ISNULL(tp.K7Tax, 0) * tb.AgentROE * tb.ROE) AS DECIMAL(10,2)))
		 		ELSE SUM(CAST((ISNULL(tp.K7Tax, 0) * tb.ROE) AS DECIMAL(10,2)))
		 	END) AS K7Tax
		, SUM(CAST(ISNULL(tp.MCOAmount,0) AS DECIMAL(10,2))) MCOAmount
		, ISNULL(tb.BFC, 0) AS BFC
		, ISNULL(tb.ServiceFee, 0) AS ServiceFee
		, ISNULL(tb.GST, 0) AS GST
	FROM tblBookMaster tb
	LEFT JOIN tblPassengerBookDetails tp ON tp.fkBookMaster=tb.pkId
	LEFT JOIN mCountryCurrency c ON c.CountryCode=tb.Country 
	WHERE tb.orderId = @NewOrderID 
		AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID)
		--AND (tb.totalFare>0 or (ISNULL(tb.PreviousRiyaPNR, '') != ''))
	GROUP BY c.CurrencyCode, tp.ServiceCharge, tb.AgentROE, tb.ROE, tp.YRTax, tp.INTax, tp.JNTax, tp.OCTax, tp.OCTax,tp.K7Tax
			, tp.ExtraTax, tp.YQ, tp.WOTax, tp.B2BMarkup, tp.MCOAmount, tp.BFC,tb.BFC, tb.ServiceFee, tb.GST, tb.pkId,tp.VendorServiceFee
	ORDER BY tb.pkId asc

	--Cancellation ticket Detail
	SELECT DISTINCT ISNULL(t1.paxFName + ' ' + t1.paxLName, '') AS FullName
		 , CASE 
              WHEN t1.paxType = 'LBR' OR t1.paxType = 'IIT' THEN 'ADULT'
              ELSE ISNULL(t1.paxType, '')
              END AS PassengerType
		, t2.frmSector AS FromSector
		, t2.toSector AS ToSector
		, ISNULL(t1.CancellationPenalty,0.0) AS CancellationPenalty
		, (ISNULL(t1.CancellationMarkup, 0) + ISNULL(t1.MarkupOnTaxFare, 0) + ISNULL(t1.MarkuponPenalty, 0)) AS CancellationMarkup
		, t1.RemarkCancellation2 AS CancellationRemark
		, FORMAT(CAST(t1.CancelledDate AS DateTime),'dd/MM/yyyy HH:mm:ss tt','en-us') AS CancellationDate
		, ISNULL(u.UserName, br.AgencyName) AS UserName
		, t1.pid AS PassengerBookDetailIDP
	FROM tblPassengerBookDetails t1
	LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
	LEFT JOIN [mUser] u ON u.id=t1.CancelByBackendUser1
	LEFT JOIN B2BRegistration br ON br.FKUserID=t1.CancelByAgency1
	WHERE t2.orderId = @NewOrderID 
	AND t1.RemarkCancellation2 IS NOT NULL 
	ORDER BY pid ASC

	DECLARE @Baggage_SSR_Amount Decimal(18, 2) = 0, @Meals_SSR_Amount Decimal(18, 2) = 0, @Seat_SSR_Amount Decimal(18, 2) = 0
	
	SELECT @Baggage_SSR_Amount = SUM(
    CASE 
        WHEN ISNULL(SSR.ROE,0) = 0 
        THEN 
            CASE WHEN c.CurrencyCode != @Currency
            THEN ISNULL(SSR.SSR_Amount, 0) * tb.AgentROE * tb.ROE
            ELSE ISNULL(SSR.SSR_Amount, 0) * tb.ROE
            END
        ELSE 
            ISNULL(SSR.SSR_Amount, 0) * SSR.ROE
    END)
	FROM tblBookMaster tb
	LEFT JOIN tblSSRDetails SSR ON SSR.fkBookMaster=TB.pkId
	LEFT JOIN mCountryCurrency c ON c.CountryCode=tb.Country
	WHERE orderId=@NewOrderID AND ssr.SSR_Type='Baggage'	
	AND SSR.SSR_Status =1
	GROUP BY c.CurrencyCode,tb.AgentROE,tb.ROE

	SELECT @Meals_SSR_Amount = SUM(
    CASE 
        WHEN ISNULL(SSR.ROE,0) = 0 
        THEN 
            CASE WHEN tb.BookingSource = 'Web' OR c.CurrencyCode != @Currency
            THEN  CAST(ISNULL(SSR.SSR_Amount,0) * tb.AgentROE * tb.ROE AS decimal(10,2))
            ELSE  CAST(ISNULL(SSR.SSR_Amount,0) * tb.ROE AS decimal(10,2))
            END
        ELSE 
            ISNULL(SSR.SSR_Amount, 0) * SSR.ROE
    END)
	FROM tblSSRDetails SSR		
	INNER JOIN tblBookMaster tb ON tb.pkid = SSR.fkBookMaster
	LEFT JOIN mCountryCurrency c ON c.CountryCode=tb.Country
	WHERE tb.orderId = @NewOrderID AND  (SSR_Type = 'Meals' or SSR_Type = 'Meal')
	AND SSR.SSR_Status =1
	GROUP BY TB.BookingSource, tb.AgentROE, tb.ROE, c.CurrencyCode

	SELECT @Seat_SSR_Amount = SUM(
    CASE 
        WHEN ISNULL(SSR.ROE,0) = 0 
        THEN 
            CASE WHEN c.CurrencyCode != @Currency
            THEN  CAST(ISNULL(SSR.SSR_Amount,0) * tb.AgentROE * tb.ROE AS decimal(10,2))
            ELSE  CAST(ISNULL(SSR.SSR_Amount,0) * tb.ROE AS decimal(10,2))
            END
        ELSE 
            ISNULL(SSR.SSR_Amount, 0) * SSR.ROE
    END)
	FROM tblPassengerBookDetails tp		
	INNER JOIN tblSSRDetails SSR ON SSR.fkpassengerid=tp.pid	
	INNER JOIN tblBookMaster tb ON tb.pkid=SSR.fkBookMaster
	LEFT JOIN mCountryCurrency c ON c.CountryCode=tb.Country
	WHERE tb.orderId=@NewOrderID AND SSR_Type='Seat'
	AND SSR.SSR_Status =1
	GROUp BY c.CurrencyCode, tb.AgentROE, tb.ROE


	--PAYMENT DETAILS
	DECLARE @BasicB2BMARKUP DECIMAL(18, 2)= 0, @TaxB2BMARKUP DECIMAL(18, 2)= 0

	IF EXISTS(SELECT TOP 1 pkId FROM tblBookMaster WHERE orderId= @NewOrderID AND B2bFareType= 1)
	BEGIN
		--SET @BasicB2BMARKUP= (SELECT TOP 1 tp.B2BMarkup FROM tblPassengerBookDetails tp INNER JOIN tblBookMaster tbm ON tp.fkBookMaster= tbm.pkId WHERE orderId= @NewOrderID)
		SET @BasicB2BMARKUP = (SELECT TOP 1 B2BMarkup FROM tblBookMaster WHERE orderId= @orderId)
	END
	ELSE IF EXISTS(SELECT TOP 1 pkId FROM tblBookMaster WHERE orderId= @NewOrderID AND (B2bFareType= 2 or B2bFareType= 3))
	BEGIN
		--SET @TaxB2BMARKUP= (SELECT TOP 1 tp.B2BMarkup FROM tblPassengerBookDetails tp INNER JOIN tblBookMaster tbm ON tp.fkBookMaster= tbm.pkId WHERE orderId= @NewOrderID)
		SET @TaxB2BMARKUP = (SELECT TOP 1 B2BMarkup FROM tblBookMaster WHERE orderId= @orderId)
	END

	--SELECT (CASE WHEN c.CurrencyCode != @Currency 
	--				THEN SUM(CAST((tP.basicFare * tb.AgentROE * tb.ROE) AS DECIMAL(10, 2)) + @BasicB2BMARKUP)
	--			ELSE SUM(CAST((tp.basicFare * tb.ROE) AS DECIMAL(10, 2)) + @BasicB2BMARKUP) END) AS BasicFare
	--		, (CASE WHEN c.CurrencyCode != @Currency 
	--				THEN SUM(CAST((tp.totalTax * tb.AgentROE * tb.ROE) + (@TaxB2BMARKUP
	--																		+ ISNULL(tp.HupAmount, 0)
	--																		+ ISNULL(tp.BFC, 0)) * tb.AgentROE AS DECIMAL(10, 2)))
	--			ELSE SUM(CAST((tp.totalTax * tb.ROE) + @TaxB2BMARKUP + ISNULL(tp.HupAmount, 0) + ISNULL(tp.BFC, 0) AS DECIMAL(10, 2))) END) AS TotalTax
	----, (CASE WHEN c.CurrencyCode != @Currency THEN SUM(CAST((tp.totalFare) * tb.AgentROE * tb.ROE AS DECIMAL(10, 2))) + ISNULL(tp.BFC, 0) + ISNULL(tb.B2BMarkup, 0) + ISNULL(tp.ServiceFee, 0) + ISNULL(tp.gst, 0) + ISNULL(tp.HupAmount, 0) - ISNULL(TB.TotalEarning, 0) ELSE SUM(CAST((tp.totalFare) * tb.ROE AS DECIMAL(10, 2))) + ISNULL(tp.HupAmount, 0) + ISNULL(tp.BFC, 0) + ISNULL(tb.B2BMarkup, 0) + ISNULL(tp.ServiceFee, 0) + ISNULL(tp.gst, 0) - ISNULL(TB.TotalEarning, 0) END) AS TotalFare
	--, 0 AS TotalFare
	--, (CASE WHEN c.CurrencyCode != @Currency THEN SUM(ISNULL(CAST((ISNULL(tp.RescheduleMarkup, 0) * tb.AgentROE * tb.ROE) + (ISNULL(tp.reScheduleCharge, 0) * tb.AgentROE * tb.ROE ) + (ISNULL(tp.SupplierPenalty, 0) * tb.AgentROE * tb.ROE) AS DECIMAL(10, 2)), 0)) ELSE SUM(ISNULL(CAST((ISNULL(tp.RescheduleMarkup, 0) * tb.ROE ) + (ISNULL(tp.reScheduleCharge, 0) * tb.ROE ) + (ISNULL(tp.SupplierPenalty, 0) * tb.ROE ) AS DECIMAL(10, 2)), 0)) END) AS ReschedulePenalty
	--, @Baggage_SSR_Amount AS SSR_Amount
	--, @Meals_SSR_Amount AS MealSSRAmount
	--, @Seat_SSR_Amount AS SeatSSRAmount
	--, (CASE WHEN c.CurrencyCode != @Currency 
	--			THEN CAST(((SUM(ISNULL(tb.basicFare, 0)
	--				 + ISNULL(tb.totalTax, 0)
	--				 + ISNULL(tb.B2BMarkup, 0)
	--				 + ISNULL(tb.AgentMarkup, 0)) * tb.AgentROE * tb.ROE)
	--				 + ISNULL(tb.BFC, 0)
	--				 + @Baggage_SSR_Amount
	--				 + @Meals_SSR_Amount
	--				 + @Seat_SSR_Amount
	--				 + ISNULL(tb.ServiceFee, 0)
	--				 + ISNULL(tb.GST, 0)) AS Numeric(18, 2))
	--			ELSE CAST(((SUM(ISNULL(tb.basicFare, 0)
	--				 + ISNULL(tb.totalTax, 0)
	--				 + ISNULL(tb.B2BMarkup, 0)
	--				 + ISNULL(tb.AgentMarkup, 0)) * tb.ROE)
	--				 + ISNULL(tb.BFC, 0)
	--				 + @Baggage_SSR_Amount
	--				 + @Meals_SSR_Amount
	--				 + @Seat_SSR_Amount
	--				 + ISNULL(tb.ServiceFee, 0)
	--				 + ISNULL(tb.GST, 0)) AS Numeric(18, 2))
	--		END) AS GrossAmount
	--, (CASE WHEN c.CurrencyCode != @Currency
	--			THEN CAST(((SUM(ISNULL(tb.basicFare, 0)
	--				 + ISNULL(tb.totalTax, 0)
	--				 + ISNULL(tb.B2BMarkup, 0)
	--				 + ISNULL(tb.AgentMarkup, 0)) * tb.AgentROE * tb.ROE)
	--				 + ISNULL(tb.BFC, 0)
	--				 + @Baggage_SSR_Amount
	--				 + @Meals_SSR_Amount
	--				 + @Seat_SSR_Amount
	--				 + ISNULL(tb.ServiceFee, 0)
	--				 + ISNULL(tb.GST, 0))
	--				 - (SUM(ISNULL(tb.TotalEarning, 0))) AS Numeric(18, 2))
	--			ELSE CAST(((SUM(ISNULL(tb.basicFare, 0)
	--				 + ISNULL(tb.totalTax, 0)
	--				 + ISNULL(tb.B2BMarkup, 0)
	--				 + ISNULL(tb.AgentMarkup, 0)) * tb.ROE)
	--				 + ISNULL(tb.BFC, 0)
	--				 + @Baggage_SSR_Amount
	--				 + @Meals_SSR_Amount
	--				 + @Seat_SSR_Amount
	--				 + ISNULL(tb.ServiceFee, 0)
	--				 + ISNULL(tb.GST, 0))
	--				 - (SUM(ISNULL(tb.TotalEarning, 0))) AS Numeric(18, 2))
	--		END) AS NetAmount
	--FROM tblBookMaster tb
	--INNER JOIN tblPassengerBookDetails tp ON tp.fkBookMaster= tb.pkId
	--INNER JOIN mCountryCurrency c ON c.CountryCode= tb.Country 
	--WHERE tb.orderId = @NewOrderID 
	--AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID)
	--AND (tb.totalFare>0 or (ISNULL(tb.PreviousRiyaPNR, '') != ''))
	--GROUP BY c.CurrencyCode, tb.AgentROE, tb.ROE, tb.ServiceFee, tb.GST, tb.BFC, tb.basicFare, tb.totalTax, tb.B2BMarkup, tb.AgentMarkup

	SELECT (CASE WHEN c.CurrencyCode != @Currency 
					THEN CAST((SUM(tp.basicFare) * tb.AgentROE * tb.ROE) AS DECIMAL(10, 2))
							+ (CASE WHEN tp.B2BMarkup > 0 THEN @BasicB2BMARKUP ELSE 0 END)
					ELSE CAST((SUM(tp.basicFare) * tb.ROE) AS DECIMAL(10, 2))
							+ (CASE WHEN tp.B2BMarkup > 0 THEN @BasicB2BMARKUP ELSE 0 END)
				END) AS BasicFare
			, (CASE WHEN c.CurrencyCode != @Currency 
					THEN CAST((SUM(tp.totalTax) * tb.AgentROE * tb.ROE) 
								+ (CASE WHEN tp.B2BMarkup > 0 THEN @TaxB2BMARKUP ELSE 0 END)
								+ ISNULL(tp.HupAmount, 0)
								+ ISNULL(tp.BFC, 0)
								+ ISNULL(tb.ServiceFee, 0) 
								+ ISNULL(tb.GST, 0) AS DECIMAL(10, 2))
				ELSE CAST((SUM(tp.totalTax) * tb.ROE)
								+ (CASE WHEN tp.B2BMarkup > 0 THEN @TaxB2BMARKUP ELSE 0 END)
								+ ISNULL(tp.HupAmount, 0)
								+ ISNULL(tp.BFC, 0)
								+ ISNULL(tb.ServiceFee, 0) 
								+ ISNULL(tb.GST, 0) AS DECIMAL(10, 2)) END) AS TotalTax
	, 0 AS TotalFare
	, (CASE WHEN c.CurrencyCode != @Currency
				THEN SUM(ISNULL(CAST((ISNULL(tp.RescheduleMarkup, 0) * tb.AgentROE * tb.ROE)
						+ (ISNULL(tp.reScheduleCharge, 0) * tb.AgentROE * tb.ROE )
						+ (ISNULL(tp.SupplierPenalty, 0) * tb.AgentROE * tb.ROE) AS DECIMAL(10, 2)), 0))
				ELSE SUM(ISNULL(CAST((ISNULL(tp.RescheduleMarkup, 0) * tb.ROE )
						+ (ISNULL(tp.reScheduleCharge, 0) * tb.ROE )
						+ (ISNULL(tp.SupplierPenalty, 0) * tb.ROE ) AS DECIMAL(10, 2)), 0))
		END) AS ReschedulePenalty
	, @Baggage_SSR_Amount AS SSR_Amount
	, @Meals_SSR_Amount AS MealSSRAmount
	, @Seat_SSR_Amount AS SeatSSRAmount
	, (CASE WHEN c.CurrencyCode != @Currency 
				THEN CAST((((ISNULL(tb.basicFare, 0)
					 + ISNULL(tb.totalTax, 0)) * tb.AgentROE * tb.ROE)
					 + ISNULL(tb.B2BMarkup, 0)
					 + ISNULL(tb.AgentMarkup, 0)
					 + ISNULL(tb.BFC, 0)
					 + ISNULL(tb.ServiceFee, 0)
					 + ISNULL(tb.GST, 0)) AS Numeric(18, 2))
				ELSE CAST((((ISNULL(tb.basicFare, 0)
					 + ISNULL(tb.totalTax, 0)) * tb.ROE)
					 + ISNULL(tb.B2BMarkup, 0)
					 + ISNULL(tb.AgentMarkup, 0)
					 + ISNULL(tb.BFC, 0)
					 + ISNULL(tb.ServiceFee, 0)
					 + ISNULL(tb.GST, 0)) AS Numeric(18, 2))
			END) AS GrossAmount
	, (CASE WHEN c.CurrencyCode != @Currency
				THEN CAST((((ISNULL(tb.basicFare, 0)
					 + ISNULL(tb.totalTax, 0)) * tb.AgentROE * tb.ROE)
					 + ISNULL(tb.B2BMarkup, 0)
					 + ISNULL(tb.AgentMarkup, 0)
					 + ISNULL(tb.BFC, 0)
					 + ISNULL(tb.ServiceFee, 0)
					 + ISNULL(tb.GST, 0))
					 - (ISNULL(tb.TotalEarning, 0)) AS Numeric(18, 2))
				ELSE CAST((((ISNULL(tb.basicFare, 0)
					 + ISNULL(tb.totalTax, 0)) * tb.ROE)
					 + ISNULL(tb.B2BMarkup, 0)
					 + ISNULL(tb.AgentMarkup, 0)
					 + ISNULL(tb.BFC, 0)
					 + ISNULL(tb.ServiceFee, 0)
					 + ISNULL(tb.GST, 0))
					 - (ISNULL(tb.TotalEarning, 0)) AS Numeric(18, 2))
			END) AS NetAmount
	INTO #mT FROM tblBookMaster tb
	INNER JOIN tblPassengerBookDetails tp ON tp.fkBookMaster= tb.pkId
	INNER JOIN mCountryCurrency c ON c.CountryCode= tb.Country 
	WHERE tb.orderId = @NewOrderID 
	AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID)
	--AND (tb.totalFare>0 or (ISNULL(tb.PreviousRiyaPNR, '') != ''))
	GROUP BY c.CurrencyCode, tb.AgentROE, tb.ROE, tb.BFC, tb.ServiceFee, tb.GST, tb.basicFare, tb.totalTax, tb.B2BMarkup, tb.AgentMarkup, tb.TotalEarning, tp.B2BMarkup
	, tp.HupAmount, tp.BFC

	SELECT SUM(BasicFare) AS BasicFare
	, SUM(TotalTax) AS TotalTax
	, SUM(TotalFare) AS TotalFare
	, SUM(ReschedulePenalty) AS ReschedulePenalty
	, SSR_Amount
	, MealSSRAmount
	, SeatSSRAmount
	, SUM(GrossAmount) AS GrossAmount
	, SUM(NetAmount) AS NetAmount
	FROM #mT
	GROUP BY SSR_Amount, MealSSRAmount, SeatSSRAmount

	DROP TABLE #mT

	--PaxType DISTINCT	
	SELECT DISTINCT	t1.paxType AS PaxType
	FROM tblPassengerBookDetails t1	
	LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster	
	LEFT JOIN AirlinesName a2 ON a2._CODE=t2.airCode	
	WHERE t2.orderId = @NewOrderID  
	ORDER BY paxType ASC

	SELECT ISNULL(c.CurrencyCode, '') AS CurrencyCode
			, ISNULL(tp.basicFare, 0) AS P_BasicFare
			, ISNULL(tb.AgentROE, 0) AS B_AgentROE
			, ISNULL(tb.ROE, 0) AS B_ROE
			, ISNULL(tp.B2BMarkup, 0) AS P_B2BMarkup
			, ISNULL(@BasicB2BMARKUP, 0) AS P_BasicB2BMARKUP
			, ISNULL(tp.totalTax, 0) +ISNULL(tp.AirlineFee,0) AS P_TotalTax
			, ISNULL(@TaxB2BMARKUP, 0) AS P_TaxB2BMARKUP
			, ISNULL(tp.HupAmount, 0) AS P_HupAmount
			, ISNULL(tp.BFC, 0) AS P_BFC
			, ISNULL(tb.ServiceFee, 0) AS B_ServiceFee
			, ISNULL(tb.GST, 0) AS B_GST
			, ISNULL(tp.RescheduleMarkup, 0) AS P_RescheduleMarkup
			, ISNULL(tp.reScheduleCharge, 0) AS P_reScheduleCharge
			, ISNULL(tp.SupplierPenalty, 0) AS P_SupplierPenalty
			, ISNULL(tb.basicFare, 0) AS B_BasicFare
			, ISNULL(tb.totalTax, 0) AS B_TotalTax
			, ISNULL(tb.B2BMarkup, 0) AS B_B2BMarkup
			, ISNULL(tb.AgentMarkup, 0) AS B_AGentMarkup
			, ISNULL(tb.BFC, 0) AS B_BFC
			, ISNULL(tb.ServiceFeeMap, 0) AS B_ServiceFeeMap
			, ISNULL(tb.ServiceFeeAdditional, 0) AS B_ServiceFeeAdditional
			, ISNULL(tb.TotalEarning, 0) AS B_TotalEarning
			, ISNULL(tb.BookingType, 0) AS B_BookingType
			, @Baggage_SSR_Amount AS BaggageAmount
			, @Meals_SSR_Amount AS MealAmount
			, @Seat_SSR_Amount AS SeatAmount
			, ISNULL(tb.isReturnJourney, 0) AS isReturnJourney
			, ISNULL(tp.IATACommission, 0) - ISNULL( tp.TDSonIATA,0) AS P_IATACommission
			, ISNULL(tp.PLBCommission , 0) - ISNULL( tp.TDSonPLB,0) AS P_PLBCommissions
			, ISNULL(tp.DropnetCommission, 0) AS P_DropnetCommission
			, ISNULL(tp.VendorServiceFee, 0) AS P_VendorServiceFee
			, (ISNULL(tp.LonServiceFee, 0)*tb.ROE) AS P_LonServiceFee
			, ISNULL(bm.TotalCommission, 0) AS TotalCommission
			,ISNULL(tp.MarkOn, '') AS P_MarkOn
	FROM tblBookMaster tb
	INNER JOIN tblPassengerBookDetails tp ON tp.fkBookMaster= tb.pkId
	INNER JOIN mCountryCurrency c ON c.CountryCode= tb.Country 
	LEFT JOIN B2BMakepaymentCommission bm ON bm.OrderId= tb.orderId 
	WHERE tb.orderId = @NewOrderID 
	AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID) order by tb.pkId
	--AND (tb.totalFare>0 or (ISNULL(tb.PreviousRiyaPNR, '') != ''))
END