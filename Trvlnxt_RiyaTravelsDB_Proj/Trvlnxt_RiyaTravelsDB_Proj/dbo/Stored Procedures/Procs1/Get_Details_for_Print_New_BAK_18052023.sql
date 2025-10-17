--Get_Details_for_Print_New_BAK_18052023 'RT20230725211222498', 'OXA136', 'NA', 'AED', NULL, ''
--Get_Details_for_Print_New_BAK_18052023 'RT20230821181603313', '6Y5OT5', 'UWOAFB', 'USD', NULL, NULL
CREATE Procedure [dbo].[Get_Details_for_Print_New_BAK_18052023]
	@orderid nvarchar(50) = null
	, @RiyaPNR varchar(20) = null
	, @GDSPNR varchar(20) = null
	, @Currency varchar(10)
	, @MainAgentId int = null
	, @SectorID Varchar(20) = NULL
AS
BEGIN
	DECLARE @NewOrderID varchar(50)=null,@Agentid varchar(20)=null
	
	SELECT TOP 1 @NewOrderID=orderId ,@Agentid=AgentID
	FROM tblBookMaster WITH(NOLOCK)
	WHERE riyaPNR=@RiyaPNR and BookingStatus != 18
	ORDER BY pkId desc;

	SELECT TOP 1 
				ISNULL(b.AgencyName,B1.AgencyName) AS AgencyName
				, ISNULL(ISNULL(B.AddrAddressLocation, B1.AddrAddressLocation) + ',' + ISNULL(B.AddrCity, B1.AddrCity) + ',' +ISNULL(B.AddrState, B1.AddrState) + '-' + ISNULL(B.AddrZipOrPostCode, B1.AddrZipOrPostCode), '') as AgencyAddressNW
				, (B.AddrAddressLocation + ',' + B.AddrCity + ',' +B.AddrZipOrPostCode) as Agencyaddress
				, ISNULL(B.AddrLandlineNo, B1.AddrLandlineNo) + '/' + ISNULL(B.AddrMobileNo,B1.AddrMobileNo) as AgencyContact
				, CASE WHEN @Agentid='48777' THEN 'NA' ELSE ISNULL(B.AddrEmail, B1.AddrEmail) end as AgencyEmail
				, t.riyaPNR
				, CONVERT(VARCHAR(20), UPPER(FORMAT(t.IssueDate, 'dd-MMM-yyyy'))) as IssueDt
				, t.mobileNo as CustomerContactno
				, CASE WHEN t.airName like '%AIRASIA%' THEN 'NA' ELSE ISNULL(t.GDSPNR,'NA') END CRSpnr
				, tbi.airlinePNR
				--, (CASE WHEN t.VendorName = 'Amadeus' THEN (CASE WHEN t.ValidatingCarrier IS NOT NULL
				--													THEN (SELECT STUFF((SELECT '/' + ISNULL(tblBookMaster.ValidatingCarrier, tblBookMaster.airCode) FROM tblBookMaster WHERE tblBookMaster.orderId = @orderid FOR XML PATH('')),1,1,'')) 
				--												ELSE '' END) 
				--	ELSE t.ValidatingCarrier END) AS Issueby
				--, t.ValidatingCarrier as Issueby
				--, tbi.aircode
				--, (CASE WHEN tbi.aircode IS NOT NULL
				--		THEN (SELECT STUFF((SELECT '/' + tblBookItenary.aircode FROM tblBookItenary WHERE tblBookItenary.orderId = @orderid FOR XML PATH('')),1,1,'')) 
				--		ELSE '' END) AS aircode
				--, (CASE WHEN t.VendorName = 'Amadeus' 
				--		THEN (CASE WHEN tbi.aircode IS NOT NULL
				--					THEN (SELECT STUFF((SELECT '/' + tblBookMaster.aircode FROM tblBookMaster WHERE tblBookMaster.orderId = @orderid FOR XML PATH('')),1,1,'')) 
				--				ELSE '' END) 
				--	ELSE tbi.aircode END) AS aircode
				, (SELECT STUFF((SELECT '/' + ISNULL(tblBookMaster.operatingCarrier, tblBookMaster.airName) 
									FROM tblBookMaster WITH(NOLOCK)
									--LEFT JOIN tblBookItenary on tblBookItenary.fkBookMaster = tblBookMaster.pkId -- Added BY JD 09.05.20236
									WHERE tblBookMaster.orderId = @orderid AND (@SectorID IS NULL OR @SectorID = '' OR tblBookMaster.pkId = @SectorID)
									FOR XML PATH('')),1,1,'')) AS Issueby
				, (SELECT TOP 1 tblBookItenary.aircode
									FROM tblBookItenary WITH(NOLOCK)
									LEFT JOIN tblBookMaster WITH(NOLOCK) on tblBookMaster.pkId = tblBookItenary.fkBookMaster
									WHERE tblBookMaster.orderId = @orderid AND (@SectorID IS NULL OR @SectorID = '' OR tblBookMaster.pkId = @SectorID)
									) AS aircode
				, CASE WHEN c.CurrencyCode != @Currency 
						THEN 'ServiceCharge: ' + convert(varchar(20), CAST((ServiceCharge *t.AgentROE * t.ROE ) as decimal(10,2))) 
							+ ';YRTax:' + convert(varchar(20), CAST((ISNULL(YRTax ,0)*t.AgentROE * t.ROE ) as decimal(10,2)))   
							+ ';INTax:' + convert(varchar(20), CAST((ISNULL(INTax ,0)*t.AgentROE * t.ROE ) as decimal(10,2))) + ';JNTax:' +  convert(varchar(20), CAST((ISNULL(JNTax ,0)*t.AgentROE * t.ROE ) as decimal(10)))
							+ ';OCTax :' +  convert(varchar(20), CAST((ISNULL(OCTax ,0)*t.AgentROE * t.ROE ) as decimal(10,2))) + ';ExtraTax:' + convert(varchar(20), CAST((ISNULL(ExtraTax ,0)*t.AgentROE * t.ROE +(ISNULL(t.TotalVendorServiceFee,0) * t.ROE) + ISNULL(RFTax,0)) as decimal(10,2))) 
							+ ';YQTax:' + convert(varchar(20), CAST((ISNULL(YQTax ,0)*t.AgentROE * t.ROE ) as decimal(10,2)))
							+ ';WOTax :' + convert(varchar(20), CAST((ISNULL(WOTax ,0)  ) as decimal(10,2)))
							+ ';SC :' + convert(varchar(20), CAST((ISNULL(B2BMarkup ,0)*t.AgentROE  ) as decimal(10,2))) 
							+  ISNULL(CASE WHEN MCOAmount>0 THEN ';MCO Amount :' + convert(varchar(20), CAST((ISNULL(MCOAmount ,0)*t.AgentROE  ) as decimal(10,2))) END,'')
							+  ISNULL(CASE WHEN ServiceFee>0 AND @MainAgentId=0 THEN ';Service Fee :' + convert(varchar(20), CAST((ISNULL(ServiceFee ,0)) as decimal(10,2))) END,'')
							+  ISNULL(CASE WHEN GST>0 AND @MainAgentId=0 THEN ';GST :' + convert(varchar(20), CAST((ISNULL(GST ,0)) as decimal(10,2))) END,'')
							+  ISNULL(CASE WHEN BFC>0 THEN ';BFC:' + convert(varchar(20), CAST((ISNULL(BFC ,0)*t.AgentROE  ) as decimal(10,2))) END,'')
					ELSE
						'ServiceCharge: ' + convert(varchar(20), CAST((ServiceCharge * t.ROE ) as decimal(10,2)))+ ';YRTax:' + convert(varchar(20), CAST((ISNULL(YRTax ,0) * t.ROE ) as decimal(10,2)))   
						+ ';INTax:' + convert(varchar(20), CAST((ISNULL(INTax ,0) * t.ROE ) as decimal(10,2))) + ';JNTax:' +  convert(varchar(20), CAST((ISNULL(JNTax ,0) * t.ROE ) as decimal(10)))
						+ ';OCTax :' +  convert(varchar(20), CAST((ISNULL(OCTax ,0) * t.ROE ) as decimal(10,2))) + ';ExtraTax:' + convert(varchar(20), CAST((ISNULL(ExtraTax ,0) * t.ROE +(ISNULL(t.TotalVendorServiceFee,0) * t.ROE) + ISNULL(RFTax,0)) as decimal(10,2))) 
						+ ';YQTax:' + convert(varchar(20), CAST((ISNULL(YQTax ,0) * t.ROE ) as decimal(10,2))) 
						+ ';WOTax :' + convert(varchar(20), CAST((ISNULL(WOTax ,0)  ) as decimal(10,2)))
						+ ';SC :' + convert(varchar(20), CAST((ISNULL(B2BMarkup ,0)  ) as decimal(10,2)))
						+  ISNULL(CASE WHEN MCOAmount>0 THEN ';MCO Amount :' + convert(varchar(20), CAST((ISNULL(MCOAmount ,0)  ) as decimal(10,2))) END,'')
						+  ISNULL(CASE WHEN ServiceFee>0 AND @MainAgentId=0 THEN ';Service Fee :' + convert(varchar(20), CAST((ISNULL(ServiceFee ,0)) as decimal(10,2))) END,'')
						+  ISNULL(CASE WHEN GST>0 AND  @MainAgentId=0 THEN ';GST :' + convert(varchar(20), CAST((ISNULL(GST ,0)  ) as decimal(10,2))) END,'')
						+  ISNULL(CASE WHEN BFC>0 THEN ';BFC:' + convert(varchar(20), CAST((ISNULL(BFC ,0)  ) as decimal(10,2))) END,'')
				END taxdesc
			, convert(varchar(20), ISNULL(t.inserteddate_old,t.inserteddate), 103) AS BookingDate
			-- Added by JD --confirm with manaswee madm --08.08.2023
			, UPPER(FORMAT(CAST(CASE t.Country
					WHEN 'AE' THEN (DATEADD(SECOND, - 1 * 60 * 60 - 29 * 60 - 13, CONVERT(DATETIME, ISNULL(t.inserteddate_old, t.inserteddate)))) 
   					WHEN 'US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ISNULL(t.inserteddate_old, t.inserteddate)))) 
   					WHEN 'CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ISNULL(t.inserteddate_old, t.inserteddate)))) 
					WHEN 'GB' THEN (DATEADD(SECOND, - 5 * 60 * 60 + 30 * 60, CONVERT(DATETIME, ISNULL(t.inserteddate_old, t.inserteddate))))
   					WHEN 'IN' THEN DATEADD(SECOND, 0, CONVERT(DATETIME, ISNULL(t.inserteddate_old, t.inserteddate)))
 				END AS DATETIME), 'dd-MMM-yyyy hh:mm:ss tt')) AS BookingDateCountryWise
			, pm.payment_mode
			, u.FullName as BookedBy
			, u.EmployeeNo as EmployeeCode
			, t.OfficeID as BookingTicketingSupplier
			, CASE WHEN t.MainAgentId>0 AND t.BookingSource='Web' THEN 'Internal Booking (Web)'
					WHEN t.MainAgentId>0 AND t.BookingSource='Retrive PNR' THEN 'Internal Booking (Retrive PNR)'
	      			WHEN t.MainAgentId>0 AND (t.BookingSource='ManualTicketing' OR t.BookingSource='Manual Ticketing') THEN 'Manual Booking'	
					WHEN t.MainAgentId=0 AND t.BookingSource='Web' THEN 'Agent Booking (Web)'
					WHEN t.MainAgentId=0 AND t.BookingSource='Retrive PNR' THEN 'Agent Booking (Retrive PNR)' 
					WHEN t.MainAgentId>0 AND t.BookingSource='Retrive PNR Accounting-TicketNumber' THEN 'Internal Booking (PNR Accounting)'
					WHEN t.MainAgentId>0 AND t.BookingSource='Retrieve PNR accounting - MultiTST' THEN 'Internal Booking Retrive PNR accounting - MultiTST'
					--Added by JD-15.06.2023 with manaswi madm
					--WHEN tb.MainAgentId=0 AND tb.BookingSource='GDS' THEN  'TJQ'
					WHEN t.BookingSource='GDS' THEN  'TJQ'
				END AS BookingType
			, ISNULL(t.isReturnJourney,0) AS Isreturn
			, t.FareType
			, t.Country as agencyCountry
			, ISNULL(pm.currency,t.agentcurrency) as currency
			, t.DiscountGstTDS
			, ISNULL(BFC,0) AS BFC
			, CAST(ISNULL(MCOAmount,0) as decimal(10,2)) MCOAmount
			, CASE WHEN c.CurrencyCode != @currency 
					THEN CAST((t.JNTax * t.AgentROE * t.ROE) AS Decimal(10,2)) 
					ELSE CAST((t.JNTax * t.ROE) AS Decimal(10,2)) 
				END JNTax
			, CASE WHEN c.CurrencyCode != @currency 
					THEN CAST((t.YQTax * t.AgentROE * t.ROE) AS Decimal(10,2))
				ELSE CAST((t.YQTax * t.ROE) as decimal(10,2)) END YQTax
			, CASE WHEN @Agentid='48777' THEN 'NA' ELSE t.emailId END AS emailId
			, BookingSource
			, ag.UserTypeID
			, t.ROE
			, t.AgentID
			, t.VendorName
			, t.CounterCloseTime 
			, tbi.cabin
			, tbi.farebasis
			, GDSPNR
			, t.Country
			, FORMAT(t.IssueDate,'dd/MM/yyyy hh:mm:ss tt')  MarineIssueDate
			--JD24.08.2022
			, ISNULL(Logo, '') AS Logo
			, ISNULL(AgentLogoNew, '') AS AgentLogoNew
			,ISNULL(t.IsBooked,0) AS IsBooked
			, ISNULL(ag.GroupId, 0) AS GroupId -- Added BY JD 22.11.2022
			, ISNULL(t.HoldText, '') AS HoldText -- Added by JD 15.12.2022
		FROM tblBookMaster t WITH(NOLOCK)
		LEFT JOIN [AirlineCode_Console] ac WITH(NOLOCK) on ac.AirlineCode=t.airCode
		--inner JOIN tblPassengerBookDetails t1 on t1.fkBookMaster =t.pkId
		LEFT JOIN B2BRegistration b WITH(NOLOCK) on b.FKUserID=t.AgentID
		LEFT JOIN mCountryCurrency c WITH(NOLOCK) on c.CountryCode=t.Country
		LEFT JOIN tblBookItenary tbi WITH(NOLOCK) on tbi.orderid=t.orderid AND tbi.airlinePNR = ISNULL(tbi.airlinePNR, '')
		LEFT JOIN [dbo].[Paymentmaster] pm WITH(NOLOCK) on pm.order_id=t.orderid
		LEFT JOIN [mUser] u WITH(NOLOCK) on u.id=t.BookedBy and t.MainAgentId > 0
		LEFT JOIN AgentLogin ag WITH(NOLOCK) on ag.UserID=t.AgentID
		LEFT JOIN B2BRegistration b1 WITH(NOLOCK) on b1.FKUserID=AG.ParentAgentID
		WHERE t.orderid=@NewOrderID 
		AND returnFlag = 0 
		AND t.AgentID != 'B2C'

	--passenger details
	SELECT t1.paxFName + ' ' + t1.paxLName + ' ' + '(' + paxType + ')' as FullName
		, CASE WHEN t1.isReturn=0 THEN 'Single' ELSE 'Return' END Journey
		, CASE WHEN t2.BookingStatus = 2 THEN 'Hold'  
				WHEN t1.BookingStatus = 6  THEN 'To Be Cancelled'   
				WHEN t2.BookingStatus = 14 THEN 'Open Ticket'
				WHEN t1.BookingStatus = 4  THEN 'Cancelled'   
				WHEN t2.BookingStatus = 0 THEN 'Failed'  
				--WHEN t1.BookingStatus IS NULL AND T2.IsBooked = 1 THEN 'Confirmed'  
				WHEN t2.BookingStatus = 1 AND T2.IsBooked=1 THEN  'Confirmed'  
				WHEN t2.BookingStatus = 2 THEN 'Hold'  
				WHEN t2.BookingStatus = 3 THEN 'Pending'  
				WHEN t2.BookingStatus = 4 THEN 'Cancelled'  
				WHEN t2.BookingStatus = 5 THEN 'Close'  
				WHEN t2.BookingStatus = 11 THEN 'Cancelled'  
				WHEN t2.BookingStatus = 12 THEN 'In-Process'  
				--WHEN t2.BookingStatus = 13 THEN 'TJQ Pending'
				WHEN t2.BookingStatus = 13 THEN 'Confirmed'
				WHEN t2.BookingStatus = 14 THEN 'Open Ticket'
				WHEN t2.BookingStatus = 15 THEN 'On Hold Canceled'
				--WHEN t1.BookingStatus IS NULL THEN 'Confirmed'  
			END Status
		, (CASE WHEN CHARINDEX('/',ticketNum) > 0
					THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum) + 1, LEN(ticketNum)), 0, CHARINDEX('/', SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum))))   
			ELSE ticketNum END) AS TicketNumber
		, (SELECT STUFF((SELECT '/' + tblPassengerBookDetails.baggage
									FROM tblPassengerBookDetails WITH(NOLOCK)
									LEFT JOIN tblBookMaster WITH(NOLOCK) on tblBookMaster.pkId = tblPassengerBookDetails.fkBookMaster
									WHERE tblBookMaster.orderId = @NewOrderID AND tblPassengerBookDetails.paxType = T1.paxType AND tblPassengerBookDetails.paxFName + ' ' + tblPassengerBookDetails.paxLName + ' ' + '(' + tblPassengerBookDetails.paxType + ')' = t1.paxFName + ' ' + t1.paxLName + ' ' + '(' + T1.paxType + ')'
									AND (@SectorID IS NULL OR @SectorID = '' OR tblBookMaster.pkId = @SectorID)
									FOR XML PATH('')),1,1,'')) AS baggage
		--, (CASE WHEN t2.isReturnJourney = 1 AND t1.paxType = 'ADULT' THEN t1.baggage + '/' + t1.baggage   
		--		WHEN t2.isReturnJourney=0 AND t1.paxType='ADULT' THEN t1.baggage
		--		WHEN t2.isReturnJourney=1 AND t1.paxType='CHILD' THEN t1.baggage + '/' + t1.baggage      
		--		WHEN t2.isReturnJourney=0 AND t1.paxType='CHILD' THEN t1.baggage
		--		WHEN t2.isReturnJourney=1 AND t1.paxType='INFANT' THEN t1.baggage + '/' + t1.baggage   
		--		WHEN t2.isReturnJourney=0 AND t1.paxType='INFANT' THEN t1.baggage 
		--	END) AS baggage
		, T1.isReturn
		, t1.paxType
		, pid
		, t1.paxFName
		, t1.paxLName
		, (CASE WHEN BarCode IS NULL THEN '' 
				WHEN BarCode = '' THEN ''
			ELSE (SELECT STUFF((SELECT '^' + BarCode 
									FROM tblPassengerBookDetails PB WITH(NOLOCK)
									LEFT JOIN tblBookMaster t2 WITH(NOLOCK) ON t2.pkId=PB.fkBookMaster 
									WHERE t2.orderId = @NewOrderID 
									AND (PB.paxFName + ' ' + PB.paxLName) = (t1.paxFName + ' ' + t1.paxLName)
							FOR XML PATH('')
							), 1, 1, '')) END) AS BarCode
		, ISNULL(PassengerID, '') AS PassengerID -- Added By JD 20.01.2022
		, t2.frmSector
		, t2.toSector
	FROM tblPassengerBookDetails t1 WITH(NOLOCK) 
	LEFT JOIN tblBookMaster t2 WITH(NOLOCK) on t2.pkId=t1.fkBookMaster  
	LEFT JOIN AirlinesName a2 WITH(NOLOCK) on a2._CODE=t2.airCode  
	WHERE t2.orderId = @NewOrderID AND (@SectorID IS NULL OR @SectorID = '' OR t2.pkId = @SectorID)
	AND (t1.isReturn = 0 OR (t1.isReturn=1 AND (SELECT count(pkId) FROM tblBookMaster WITH(NOLOCK) WHERE orderId = @NewOrderID AND (@SectorID IS NULL OR @SectorID = '' OR tblBookMaster.pkId = @SectorID)) =1))
--	AND (t1.isReturn = 1 OR t1.totalFare > 0 or (ISNULL(t2.PreviousRiyaPNR,'')!='') or t1.paxType='Infant')
	--AND (t1.isReturn = 1 OR t1.paxType='Infant')
	ORDER BY t1.paxType,FullName asc

	--flight details
	SELECT distinct 
			t.airCode
			, t.airName
			, t.flightNo
			, t.operatingCarrier
			, t.fromAirport
			, FORMAT(CAST(t.deptTime AS datetime), 'dd/MM/yyyy HH:mm:ss tt') deptTime
			, t.depDate
			, t.fromTerminal
			, t.toAirport
			, FORMAT(CAST(t.arrivalTime AS datetime), 'dd/MM/yyyy HH:mm:ss tt') arrivalTime
			, t.arrivalDate
			, t.toTerminal
			, t.farebasis
			--, t.insertedOn
			, CASE WHEN tb.airCode='IX' AND tb.bookingsource='Retrive PNR Accounting' THEN tb.FlightDuration
				ELSE CONVERT(varchar(5), DATEADD(minute, DATEDIFF(MINUTE, t.deptTime,t.arrivalTime), 0), 114) +' ' END Traveldifference
			, t.cabin
			, t.deptTime
			, tb.VendorName
			--, ISNULL(tb.TotalTime, '') AS TotalTime
			, (CASE  
					WHEN (tb.VendorName = 'Air Arabia 3L' OR tb.VendorName = 'Air Arabia')
						THEN ISNULL(tb.TotalTime, '')
					WHEN tb.VendorName = 'Amadeus' 
						THEN ISNULL(t.TotalTimeStopOver, '')
					ELSE (CASE 
							WHEN tb.airCode='IX' AND tb.bookingsource='Retrive PNR Accounting'
								THEN tb.FlightDuration
							ELSE CONVERT(varchar(5), DATEADD(minute, DATEDIFF(MINUTE, t.deptTime, t.arrivalTime), 0), 114) + ' ' END)
				END) AS TotalTime
			, t.airlinePNR
			, UPPER(FORMAT(CAST(t.depDate AS datetime), 'dd-MMM-yyyy')) DepartDate
			, CONVERT(char(5), t.deptTime, 108) as DepartTime
			, t.frmSector
			, t.toSector
			, UPPER(FORMAT(CAST(t.arrivalDate AS datetime), 'dd-MMM-yyyy')) ArrivDate
			, CONVERT(char(5), t.arrivalTime, 108) AS ArrivTime
			, SUBSTRING(t.fromAirport, 0, charindex('-', t.fromAirport, 0)) fromAirportNEW
			, SUBSTRING(t.toAirport, 0, charindex('-', t.toAirport, 0)) toAirportNEW
				, ISNULL('VIA : '+t.Via,'') AS Via
		,ISNULL(t.CarbonEmission,'') CarbonEmission
	FROM tblBookItenary t WITH(NOLOCK)
	--LEFT JOIN tblBookItenary tbi ON tbi.fkBookMaster=t.fkBookMaster
	inner JOIN tblBookMaster tb WITH(NOLOCK) ON tb.pkId=t.fkBookMaster
	WHERE tb.orderId=@NewOrderID AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID)
	ORDER BY t.deptTime ASC

	--GST details
	SELECT RegistrationNumber
			, CompanyName,CAddress+','+CState AS CAddress,CState,CContactNo, CEmailID
	FROM tblBookMaster t WITH(NOLOCK)
	WHERE (t.orderId=@NewOrderID OR t.riyaPNR = @RiyaPNR or t.GDSPNR = @GDSPNR) AND (@SectorID IS NULL OR @SectorID = '' OR t.pkId = @SectorID) 

	--Cancellation Remarks
	SELECT DISTINCT t1.RemarkCancellation2,ISNULL(t1.CancellationPenalty,0.0) CancellationPenalty
			, ISNULL(t1.CancellationMarkup,0.0) +ISNULL(t1.MarkupOnTaxFare,0.0) +ISNULL(t1.MarkuponPenalty,0.0)  AS CancellationMarkup
			, FORMAT(CAST(t1.CancelledDate as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us') CancelledDate
			, ISNULL(u.UserName,br.AgencyName) UserName
			, ISNULL(t1.paxFName +' '+t1.paxLName +' '+'('+paxType+')', '') as FullName
			, t2.frmSector
			, t2.toSector
			, pid
			, ISNULL(T1.CancellationServiceFee,0) CancellationServiceFee
	FROM tblPassengerBookDetails t1 WITH(NOLOCK)
	LEFT JOIN tblBookMaster t2 WITH(NOLOCK) ON t2.pkId=t1.fkBookMaster
	LEFT JOIN [mUser] u WITH(NOLOCK) ON u.id=t1.CancelByBackendUser1
	LEFT JOIN B2BRegistration br WITH(NOLOCK) ON br.FKUserID=t1.CancelByAgency1
	WHERE  t2.orderId=@NewOrderID AND t1.RemarkCancellation2 is not null  
	--AND t1.CancellationPenalty>0 AND t1.CancellationMarkup>0
	ORDER BY pid ASC


	--payment details
	declare @BasicB2BMARKUP decimal(18,2)=0
	declare @TaxB2BMARKUP decimal(18,2)=0
	IF exists(SELECT TOP 1 * FROM tblBookMaster WITH(NOLOCK) WHERE orderId=@NewOrderID AND B2bFareType=1)
	BEGIN
		SET @BasicB2BMARKUP=(SELECT TOP 1 tp.B2BMarkup FROM tblPassengerBookDetails tp WITH(NOLOCK) inner JOIN tblBookMaster tbm WITH(NOLOCK) ON tp.fkBookMaster=tbm.pkId WHERE orderId=@NewOrderID order by tp.pid)
	END
	ELSE IF exists(SELECT TOP 1 * FROM tblBookMaster WITH(NOLOCK) WHERE orderId=@NewOrderID AND (B2bFareType=2 or B2bFareType=3))
	BEGIN
		SET @TaxB2BMARKUP=(SELECT TOP 1 tp.B2BMarkup FROM tblPassengerBookDetails tp WITH(NOLOCK) inner JOIN tblBookMaster tbm WITH(NOLOCK) ON tp.fkBookMaster=tbm.pkId WHERE orderId=@NewOrderID order by tp.pid)
	END

	SELECT 
		tp.title +'.'+ +' '+tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' AS FullName,
		--distinct
		CASE WHEN c.CurrencyCode !=@Currency THEN
				SUM(CAST((tP.basicFare *tb.AgentROE* tb.ROE--+isnull(tp.Markup,0)
				) AS decimal(10,2)
				)+  CASE WHEN ISNULL(tP.basicFare, 0) != 0 THEN @BasicB2BMARKUP+ISNULL(tp.LonServiceFee,0) ELSE 0 END) 
				ELSE SUM(CAST((tp.basicFare * tb.ROE--+ isnull(tp.Markup,0)
				) AS decimal(10,2))
				+  CASE WHEN ISNULL(tP.basicFare, 0) != 0 THEN +@BasicB2BMARKUP+ISNULL(tp.LonServiceFee,0) ELSE 0 END) 
			END basicFare
		--,CASE WHEN c.CurrencyCode!=@Currency THEN
		--		SUM(CAST((tp.totalTax *tb.AgentROE * tb.ROE)+ (@TaxB2BMARKUP + ISNULL(tp.HupAmount,0) --+ ISNULL(tp.ServiceFee,0) + ISNULL(tp.gst,0)
		--		+ ISNULL(tp.BFC,0)) * tb.AgentROE  AS decimal(10,2))) ELSE SUM(CAST(tp.totalTax * tb.ROE + (@TaxB2BMARKUP + ISNULL(tp.HupAmount,0) --+ ISNULL(tp.ServiceFee,0) + ISNULL(tp.gst,0) 
		--		+ ISNULL(tp.BFC,0))  AS decimal(10,2))) 
		--	END totalTax

		--Added By JD 12.02.2023((CASE WHEN tp.B2BMarkup > 0 THEN @TaxB2BMARKUP ELSE 0 END)) Confirm with Dhanraj sir
		,CASE WHEN c.CurrencyCode!=@Currency THEN
				SUM(CAST(((tp.totalTax+ISNULL(tp.VendorServiceFee,0)+ISNULL(tp.AirlineFee,0)) *tb.AgentROE * tb.ROE)+
				  +  CASE WHEN ISNULL(tP.totalTax, 0) != 0 THEN (@TaxB2BMARKUP + ISNULL(tp.HupAmount,0) 
				+ ISNULL(tp.BFC,0)) ELSE 0 END * tb.AgentROE  AS decimal(10,2)))
				ELSE SUM(CAST((tp.totalTax+ISNULL(tp.VendorServiceFee,0) +ISNULL(tp.AirlineFee,0)) * tb.ROE
				+  CASE WHEN ISNULL(tP.totalTax, 0) != 0 THEN ((CASE WHEN tp.B2BMarkup > 0 THEN @TaxB2BMARKUP ELSE 0 END) + ISNULL(tp.HupAmount,0) --+ ISNULL(tp.ServiceFee,0) + ISNULL(tp.gst,0) 
				+ ISNULL(tp.BFC,0)) ELSE 0 END AS decimal(10,2))) 
			END totalTax
		,CASE WHEN c.CurrencyCode !=@Currency THEN
					SUM(CAST((tp.totalFare+ISNULL(tp.VendorServiceFee,0) +ISNULL(tp.AirlineFee,0)) * tb.AgentROE * tb.ROE AS decimal(10,2))) --+   ISNULL(tp.MCOAmount,0) +  ISNULL(tp.Markup,0)
					+CASE WHEN ISNULL(tP.totalFare, 0) != 0 THEN ISNULL(tp.BFC,0) +@TaxB2BMARKUP +@BasicB2BMARKUP +ISNULL(tp.LonServiceFee,0)
					+ ISNULL(tp.ServiceFee,0) + ISNULL(tp.gst,0) + ISNULL(tp.HupAmount,0)
					-(ISNULL(tp.PLBCommission,0)+ISNULL(tp.IATACommission,0)+ISNULL(tp.DropnetCommission,0))ELSE 0 END -- - (CASE WHEN ROW_NUMBER() OVER(ORDER BY tb.Pkid) = 1 THEN ISNULL(TB.TotalEarning, 0) ELSE 0 END) --ISNULL(TB.TotalEarning, 0) --+ ISNULL(tb.ServiceFee,0) + ISNULL(tb.GST,0) 
				ELSE SUM(CAST((tp.totalFare+ISNULL(tp.VendorServiceFee,0) +ISNULL(tp.AirlineFee,0)) * tb.ROE AS decimal(10,2))) --+   ISNULL(tp.MCOAmount,0) +  ISNULL(tp.Markup,0)
					+CASE WHEN ISNULL(tP.totalFare, 0) != 0 THEN ISNULL(tp.HupAmount,0)+ ISNULL(tp.BFC,0) +@TaxB2BMARKUP+@BasicB2BMARKUP+ISNULL(tp.LonServiceFee,0)
					+ ISNULL(tp.ServiceFee,0) + ISNULL(tp.gst,0)
					-(ISNULL(tp.PLBCommission,0)+ISNULL(tp.IATACommission,0)+ISNULL(tp.DropnetCommission,0)) ELSE 0 END-- - (CASE WHEN ROW_NUMBER() OVER(ORDER BY tb.Pkid) = 1 THEN ISNULL(TB.TotalEarning, 0) ELSE 0 END) --ISNULL(TB.TotalEarning, 0) --+ ISNULL(tb.ServiceFee,0) + ISNULL(tb.GST,0) 
			END totalFare
		,(CASE WHEN c.CurrencyCode != @Currency 
				THEN SUM(CAST(((tp.totalTax+ISNULL(tp.VendorServiceFee,0)+ISNULL(tp.AirlineFee,0)) *tb.AgentROE * tb.ROE)
				+ CASE WHEN ISNULL(tP.totalTax, 0) != 0 THEN (@TaxB2BMARKUP  + ISNULL(tp.HupAmount,0) + ISNULL(tp.BFC,0)) ELSE 0 END *tb.AgentROE  as decimal(10,2))) 
				ELSE SUM(CAST((tp.totalTax+ISNULL(tp.VendorServiceFee,0) +ISNULL(tp.AirlineFee,0)) * tb.ROE
				+ CASE WHEN ISNULL(tP.totalTax, 0) != 0 THEN (@TaxB2BMARKUP + ISNULL(tp.HupAmount,0)+ ISNULL(tp.BFC,0))ELSE 0 END  as decimal(10,2))) 
			END) AS TotalTaxWithoutServiceFee
		, (CASE WHEN c.CurrencyCode !=@Currency 
				THEN SUM(CAST((tp.totalFare+ISNULL(tp.VendorServiceFee,0) +ISNULL(tp.AirlineFee,0)) * tb.AgentROE * tb.ROE AS DECIMAL(10,2)))
				+ CASE WHEN ISNULL(tP.totalFare, 0) != 0 THEN ISNULL(tp.BFC,0) +@TaxB2BMARKUP +ISNULL(tp.LonServiceFee,0)+  ISNULL(tp.HupAmount,0)+@BasicB2BMARKUP -(ISNULL(tp.PLBCommission,0)+ISNULL(tp.IATACommission,0)+ISNULL(tp.DropnetCommission,0))ELSE 0 END
				ELSE SUM(CAST((tp.totalFare+ISNULL(tp.VendorServiceFee,0) +ISNULL(tp.AirlineFee,0)) * tb.ROE AS DECIMAL(10,2)))
				+ CASE WHEN ISNULL(tP.totalFare, 0) != 0 THEN ISNULL(tp.HupAmount,0)+ ISNULL(tp.BFC,0) + @TaxB2BMARKUP+@BasicB2BMARKUP +ISNULL(tp.LonServiceFee,0) -(ISNULL(tp.PLBCommission,0)+ISNULL(tp.IATACommission,0)+ISNULL(tp.DropnetCommission,0))ELSE 0 END
			END) AS TotalFareWithoutServiceFee 
		, CASE WHEN c.CurrencyCode !=@Currency 
				THEN SUM(ISNULL(CAST((ISNULL(tp.RescheduleMarkup,0)*tb.AgentROE* tb.ROE) +  (ISNULL(tp.reScheduleCharge,0)*tb.AgentROE* tb.ROE )+ (ISNULL(tp.SupplierPenalty,0)*tb.AgentROE* tb.ROE)  as decimal(10,2)),0))
				ELSE SUM(ISNULL(CAST((ISNULL(tp.RescheduleMarkup,0)* tb.ROE ) +  (ISNULL(tp.reScheduleCharge,0)* tb.ROE ) + (ISNULL(tp.SupplierPenalty,0)* tb.ROE )  as decimal(10,2)),0)) 
			END ReschedulePenalty
		, c.CurrencyCode
		, tp.isReturn
		, CASE WHEN c.CurrencyCode !=@currency 
				THEN CAST((tp.JNTax *tb.AgentROE* tb.ROE) as decimal(10,2)) ELSE CAST((tp.JNTax * tb.ROE) as decimal(10,2)) 
			END JNTax
		,ISNULL((CASE WHEN c.CurrencyCode !=@currency 
				THEN CAST((tp.YQ *tb.AgentROE* tb.ROE) as decimal(10,2)) ELSE CAST((tp.YQ * tb.ROE) as decimal(10,2)) 
			END),0) YQTax
		--bansi
		,ISNULL((CASE WHEN c.CurrencyCode !=@currency 
				THEN CAST((tp.ServiceCharge *tb.AgentROE* tb.ROE) as decimal(10,2)) ELSE CAST((tp.ServiceCharge * tb.ROE) as decimal(10,2))
			END),0) ServiceCharge
		,CASE WHEN c.CurrencyCode !=@currency 
				THEN CAST((tp.YRTax *tb.AgentROE* tb.ROE) as decimal(10,2)) ELSE CAST((tp.YRTax * tb.ROE) as decimal(10,2))
			END YRTax
		,CASE WHEN c.CurrencyCode !=@currency 
				THEN CAST((tp.INTax *tb.AgentROE* tb.ROE) as decimal(10,2)) ELSE CAST((tp.INTax * tb.ROE) as decimal(10,2)) 
			END INTax
		,CASE WHEN c.CurrencyCode !=@currency 
				THEN CAST((tp.OCTax *tb.AgentROE* tb.ROE) as decimal(10,2)) ELSE CAST((tp.OCTax * tb.ROE) as decimal(10,2)) 
			END OCTax
		--,CASE WHEN c.CurrencyCode !=@currency THEN 
		--CAST((tp.ExtraTax *tb.AgentROE* tb.ROE) as decimal(10,2)) ELSE CAST((tp.ExtraTax * tb.ROE) as decimal(10,2)) END ExtraTax
		,CASE WHEN c.CurrencyCode !=@Currency 
				THEN CAST((ISNULL(tp.ExtraTax ,0) *tb.AgentROE * tb.ROE) +(ISNULL(tp.AirlineFee ,0) *tb.AgentROE * tb.ROE) as decimal(10,2))
				ELSE CAST((ISNULL(tp.ExtraTax ,0) * tb.ROE )+(ISNULL(tp.AirlineFee ,0) * tb.ROE )   as decimal(10,2)) 
			END ExtraTax
		,ISNULL(CASE WHEN c.CurrencyCode !=@currency 
				THEN CAST((tp.WOTax) as decimal(10,2)) ELSE CAST((tp.WOTax) as decimal(10,2)) 
			END, 0) WOTax
		,ISNULL(CASE WHEN c.CurrencyCode !=@currency 
				THEN CAST((tp.B2BMarkup *tb.AgentROE) as decimal(10,2)) ELSE CAST((tp.B2BMarkup) as decimal(10,2)) 
			END, 0) AS SC
		,ISNULL(tp.RFTax, 0) AS RFTax
		,tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' as FName
	FROM tblBookMaster tb WITH(NOLOCK)
	LEFT JOIN tblPassengerBookDetails tp WITH(NOLOCK) on tp.fkBookMaster=tb.pkId
	LEFT JOIN mCountryCurrency c WITH(NOLOCK) on c.CountryCode=tb.Country 
	WHERE tb.orderId=@NewOrderID AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID)
	--AND (tb.totalFare>0 or (ISNULL(tb.PreviousRiyaPNR,'')!=''))
	GROUP BY c.CurrencyCode,tp.MCOAmount,tp.Markup,tb.ServiceFee,tb.GST,tp.BFC, tb.ReissueCharges,  tp.title, tp.paxFName , tp.paxLName , paxType,tp.BaggageFare, tp.isReturn,tp.B2BMarkup --,SSR.FKBOOKMASTER,SSR.SSR_Amount,riyaPNR
	,tp.ServiceFee, tp.GST,HupAmount,tp.JNTax,agentroe,roe,tp.YQ,tb.AgentROE,tb.ROE,
	tp.serviceCharge, tp.YRTax,tp.INTax,tp.OCTax,tp.ExtraTax,tp.WOTax,tp.B2BMarkup,tp.RFTax,tp.paxFName , tp.paxLName , paxType, TB.TotalEarning, tb.Pkid,tp.LonServiceFee,tp.VendorServiceFee
	,tp.PLBCommission,tp.IATACommission,tp.DropnetCommission,tp.AirlineFee,tp.totalFare
	
	--status cancellation
	Declare @TotalPasscount int
	Declare @CancelledPasscount int
	SET @TotalPasscount=(
		SELECT count(*) 
		FROM tblPassengerBookDetails t1 WITH(NOLOCK)
		LEFT JOIN tblBookMaster t2 WITH(NOLOCK) ON t2.pkId=t1.fkBookMaster
		WHERE t2.orderId=@NewOrderID)
	
	SET @CancelledPasscount=(
		SELECT count(*) 
		FROM tblPassengerBookDetails t1 WITH(NOLOCK)
		LEFT JOIN tblBookMaster t2 WITH(NOLOCK) ON t2.pkId=t1.fkBookMaster
		WHERE t2.orderId = @NewOrderID AND t1.BookingStatus = 4)
	
	IF(@TotalPasscount=@CancelledPasscount)
		BEGIN
			SELECT TOP 1 BookingStatus FROM tblBookMaster WITH(NOLOCK) WHERE orderId=@NewOrderID
		END
	ELSE
		BEGIN
			SELECT TOP 1 BookingStatus FROM tblBookMaster WITH(NOLOCK) WHERE orderId=@NewOrderID
		END
	
	--booking details
	SELECT TOP 1
	UPPER(Format(CAST(ISNULL(tb.inserteddate_old,tb.inserteddate) as datetime),'dd-MMM-yyyy HH:mm:ss tt','en-us'))  as BookingDate
	-- Added by JD --confirm with manaswee madm --08.08.2023
	, UPPER(FORMAT(CAST(CASE tb.Country
					WHEN 'AE' THEN (DATEADD(SECOND, - 1 * 60 * 60 - 29 * 60 - 13, CONVERT(DATETIME, ISNULL(tb.inserteddate_old, tb.inserteddate)))) 
   					WHEN 'US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ISNULL(tb.inserteddate_old, tb.inserteddate)))) 
   					WHEN 'CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ISNULL(tb.inserteddate_old, tb.inserteddate)))) 
					WHEN 'GB' THEN (DATEADD(SECOND, - 5 * 60 * 60 + 30 * 60, CONVERT(DATETIME, ISNULL(tb.inserteddate_old, tb.inserteddate))))
   					WHEN 'IN' THEN DATEADD(SECOND, 0, CONVERT(DATETIME, ISNULL(tb.inserteddate_old, tb.inserteddate)))
 				END AS DATETIME), 'dd-MMM-yyyy hh:mm:ss tt')) AS BookingDateCountryWise
	, pm.payment_mode
	, ISNULL(u.FullName,ag.UserName) FullName
	, CASE WHEN tb.MainAgentId>0 AND tb.BookingSource='Web' THEN 'Internal Booking (Web)'
			--afifa	
		     --WHEN tb.MainAgentId>0 AND tb.BookingSource='ManualTicketing' THEN 'Manual Booking'
			WHEN tb.MainAgentId>0 AND (tb.BookingSource='ManualTicketing' OR tb.BookingSource='Manual Ticketing') THEN 'Manual Booking'
			WHEN tb.MainAgentId>0 AND tb.BookingSource='Retrieve PNR accounting' THEN 'PNR accounting'	
			WHEN tb.MainAgentId>0 AND tb.BookingSource='Retrive PNR - MultiTST' THEN 'Retrive PNR - MultiTST'
			WHEN tb.MainAgentId>0 AND tb.BookingSource='Retrive PNR Accounting' THEN 'Internal Booking (Retrive PNR Accounting)'
			WHEN tb.MainAgentId>=0 AND tb.BookingSource='Retrive PNR' THEN 'Internal Booking (Retrive PNR)'
			WHEN tb.MainAgentId=0 AND tb.BookingSource='Web' THEN 'Agent Booking (Web)'
			WHEN tb.MainAgentId=0 AND tb.BookingSource='Retrive PNR' THEN 'Agent Booking (Retrive PNR)' 
			--WHEN tb.MainAgentId>0 AND tb.BookingSource='Retrieve PNR accounting - MultiTST' THEN 'Retrieve PNR accounting - MultiTST'	
			WHEN tb.MainAgentId=0 AND tb.BookingSource='Retrive PNR Accounting' THEN  'Agent Booking (Retrive PNR Accounting)'
			--Added by JD-15.06.2023 with manaswi madm
			--WHEN tb.MainAgentId=0 AND tb.BookingSource='GDS' THEN  'TJQ'
			WHEN tb.BookingSource='GDS' THEN  'TJQ'
			WHEN tb.MainAgentId>0 AND tb.BookingSource='Retrive PNR Accounting-TicketNumber' THEN 'Internal Booking (PNR Accounting)'
			WHEN tb.MainAgentId>0 AND tb.BookingSource='Retrieve PNR accounting - MultiTST' THEN 'Internal Booking Retrive PNR accounting - MultiTST'
		END  as BookingType 
	,CASE WHEN TicketingPCC!='' THEN TicketingPCC ELSE OfficeID END BookingTicketingSupplier
	,ISNULL(u.UserName,0) ID
	,ISNULL(U.ID,0) UserId
	,(SELECT TOP 1  
	   STUFF((SELECT '/' + bm.FareType 
				FROM tblBookMaster bm WITH(NOLOCK)
				WHERE bm.riyaPNR = b.riyaPNR AND (@SectorID IS NULL OR @SectorID = '' OR bm.pkId = @SectorID)  
				ORDER BY BM.pkId ASC
				FOR XML PATH('')), 1, 1, '') AS FareType
	FROM tblBookMaster b WITH(NOLOCK)
	WHERE orderId = @NewOrderID AND b.returnFlag=0
	GROUP BY b.riyaPNR,b.GDSPNR) FareType
	FROM tblBookMaster tb WITH(NOLOCK)
	LEFT JOIN [dbo].[Paymentmaster] pm WITH(NOLOCK) on pm.order_id=tb.orderid
	LEFT JOIN agentLogin ag WITH(NOLOCK) on ag.UserID=tb.AgentID
	LEFT JOIN [mUser] u WITH(NOLOCK) on u.id=tb.BookedBy and tb.MainAgentId > 0
	WHERE tb.orderId=@NewOrderID

	--pax type distinct	
	SELECT distinct	t1.paxType	--,'' as MarkupId	
	FROM tblPassengerBookDetails t1	WITH(NOLOCK)
	LEFT JOIN tblBookMaster t2 WITH(NOLOCK) ON t2.pkId=t1.fkBookMaster	
	LEFT JOIN AirlinesName a2 WITH(NOLOCK) ON a2._CODE=t2.airCode	
	WHERE  t2.orderId=@NewOrderID  order BY paxType asc	
	
	--BAGGEGE DETAILS FROM SSR TABLE
	SELECT
		tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName
		, SSR_Type
		, ISNULL(ssr.SSR_Name,'') SSR_Name
		,SUM(
         CASE 
         WHEN ISNULL(SSR.ROE,0) = 0 
         THEN 
            CASE WHEN c.CurrencyCode != @Currency
            THEN ISNULL(SSR.SSR_Amount, 0) * tb.AgentROE * tb.ROE
            ELSE ISNULL(SSR.SSR_Amount, 0) * tb.ROE
            END
          ELSE 
            ISNULL(SSR.SSR_Amount, 0) * SSR.ROE
         END) AS SSR_Amount
		 , tp.paxType
		, pid
	FROM tblPassengerBookDetails tp WITH(NOLOCK)
	inner JOIN tblSSRDetails SSR WITH(NOLOCK) ON SSR.fkpassengerid=tp.pid
	inner JOIN tblBookMaster tb  WITH(NOLOCK) ON tb.pkid=tp.fkBookMaster
	LEFT JOIN mCountryCurrency c WITH(NOLOCK) ON c.CountryCode=tb.Country
	WHERE  tb.orderId=@NewOrderID AND SSR_Type='Baggage' AND SSR.SSR_Status =1
	GROUP BY TP.paxFName,paxLName,paxType,SSR_Type,SSR_Name,CurrencyCode,tb.AgentROE,tb.ROE,pid
	ORDER BY tp.pid, tp.paxType
	
	--Reschedule passenger details List
	SELECT t1.paxFName +' '+t1.paxLName +' '+'('+paxType+')' as FullName,--'Confirmed' as Status,
	CASE
		WHEN r1.Status=7 THEN 'To Be Rescheduled' 
		WHEN r1.Status=8 THEN 'Rescheduled' 
		WHEN t1.BookingStatus is null  THEN 'Confirmed'
	END Status , t1.paxType
	FROM tblPassengerBookDetails t1 WITH(NOLOCK)
	LEFT JOIN tblBookMaster t2  WITH(NOLOCK) on t2.pkId=t1.fkBookMaster
	LEFT JOIN RescheduleData r1 WITH(NOLOCK) on r1.pid=t1.pid  
	WHERE  t2.orderId = @NewOrderID AND (@SectorID IS NULL OR @SectorID = '' OR t2.pkId = @SectorID)
	--AND r1.Status in(7,8)--AND t1.isReturn=0
	
	
	--Old PNR  payment details for Reschedule
	SELECT
		tp.isReturn,
		CASE WHEN c.CurrencyCode !=@Currency THEN
				--SUM
				(ISNULL(CAST((tP.basicFare *tb.AgentROE* tb.ROE+ISNULL(tp.Markup,0)) as decimal(10,2)),0)) ELSE --SUM
				(ISNULL(CAST((tp.basicFare * tb.ROE+ ISNULL(tp.Markup,0)) as decimal(10,2)),0)) 
			END basicFare
		, CASE WHEN c.CurrencyCode!=@Currency THEN
		 		--SUM
				(ISNULL(CAST(((tp.totalTax + ISNULL(tp.MCOAmount,0)) *tb.AgentROE * tb.ROE)+ (ISNULL(tb.B2BMarkup,0) + ISNULL(tb.ServiceFee,0) + ISNULL(tb.gst,0) + ISNULL(tb.BFC,0)) *tb.AgentROE  as decimal(10,2)),0)) ELSE --SUM
				(ISNULL(CAST((tp.totalTax + ISNULL(tp.MCOAmount,0)) * tb.ROE + (ISNULL(tp.B2BMarkup,0) + ISNULL(tb.ServiceFee,0) + ISNULL(tb.gst,0) + ISNULL(tb.BFC,0))  as decimal(10,2)),0))
			END  totalTax
		, CASE WHEN c.CurrencyCode !=@Currency THEN
				--SUM
				(ISNULL(CAST((tp.totalFare) * tb.AgentROE * tb.ROE  +   (ISNULL(tb.MCOAmount,0) +  ISNULL(tb.AgentMarkup,0)  + ISNULL(tb.ServiceFee,0) + ISNULL(tb.GST,0) + ISNULL(tb.BFC,0)  + ISNULL(tb.ReissueCharges,0)) as decimal(10,2)),0)) ELSE --SUM
				(ISNULL(CAST((tp.totalFare) * tb.ROE +   (ISNULL(tb.MCOAmount,0) +  ISNULL(tb.AgentMarkup,0) + ISNULL(tb.ServiceFee,0) + ISNULL(tb.GST,0) + ISNULL(tb.BFC,0)  + ISNULL(tb.ReissueCharges,0))  as decimal(10,2)),0))
			END totalFare
		, (CASE WHEN c.CurrencyCode != @Currency 
				THEN (ISNULL(CAST(((tp.totalTax + ISNULL(tp.MCOAmount,0)) * tb.AgentROE * tb.ROE) + (ISNULL(tb.B2BMarkup,0) + ISNULL(tb.BFC,0)) * tb.AgentROE  AS DECIMAL(10,2)),0)) 
				ELSE (ISNULL(CAST((tp.totalTax + ISNULL(tp.MCOAmount,0)) * tb.ROE + (ISNULL(tp.B2BMarkup,0) + ISNULL(tb.BFC,0))  AS DECIMAL(10,2)),0)) 
			END) AS TotalTaxWithoutServiceFee
		
		, (CASE WHEN c.CurrencyCode != @Currency 
				THEN (ISNULL(CAST((tp.totalFare) * tb.AgentROE * tb.ROE  +   (ISNULL(tb.MCOAmount,0) +  ISNULL(tb.AgentMarkup,0)  + ISNULL(tb.BFC,0)  + ISNULL(tb.ReissueCharges,0)) AS DECIMAL(10,2)),0))
				ELSE (ISNULL(CAST((tp.totalFare) * tb.ROE + (ISNULL(tb.MCOAmount,0) + ISNULL(tb.AgentMarkup,0) + ISNULL(tb.BFC,0)  + ISNULL(tb.ReissueCharges,0)) AS DECIMAL(10,2)),0))
			END) AS TotalFareWithoutServiceFee
		, CASE WHEN c.CurrencyCode!=@Currency THEN
				(ISNULL(CAST(  (ISNULL(tp.RescheduleMarkup,0)*tb.AgentROE* tb.ROE) +  (ISNULL(tp.reScheduleCharge,0)*tb.AgentROE* tb.ROE )+ (ISNULL(tp.SupplierPenalty,0)*tb.AgentROE* tb.ROE)  as decimal(10,2)),0))
			ELSE --SUM 
				(ISNULL(CAST(  (ISNULL(tp.RescheduleMarkup,0)* tb.ROE ) +  (ISNULL(tp.reScheduleCharge,0)* tb.ROE ) + (ISNULL(tp.SupplierPenalty,0)* tb.ROE )  as decimal(10,2)),0)) 
			END ReschedulePenalty
		,CASE WHEN c.CurrencyCode !=@Currency 
				THEN CAST((ISNULL(tp.YQ ,0)*tb.AgentROE * tb.ROE) as decimal(10,2))
				ELSE CAST((ISNULL(tp.YQ ,0) * tb.ROE ) as decimal(10,2))
			END YQ
		,CASE WHEN c.CurrencyCode !=@Currency 
				THEN CAST((ISNULL(tp.JNTax ,0)*tb.AgentROE * tb.ROE ) as decimal(10,2))
				ELSE CAST((ISNULL(tp.JNTax ,0) * tb.ROE ) as decimal(10,2)) 
			END JNTax
		,CASE WHEN c.CurrencyCode !=@Currency
			THEN CAST((ISNULL(tp.ExtraTax ,0)*tb.AgentROE * tb.ROE ) as decimal(10,2))
			ELSE CAST((ISNULL(tp.ExtraTax ,0) * tb.ROE ) as decimal(10,2))
			END ExtraTax
	FROM tblBookMaster tb WITH(NOLOCK)
	LEFT JOIN tblPassengerBookDetails tp WITH(NOLOCK) on tp.fkBookMaster=tb.pkId
	LEFT JOIN mCountryCurrency c WITH(NOLOCK) on c.CountryCode=tb.Country
	WHERE tb.riyaPNR= (SELECT TOP 1 PreviousRiyaPNR FROM tblBookMaster WITH(NOLOCK) WHERE orderId= @NewOrderID) 
	AND ISNULL(tp.reScheduleCharge,0) = 0-- AND tb.totalFare>0
	
	--MEAL DETAILS FROM SSR TABLE		 
	 SELECT tp.baggage
		, ssr.SSR_Type
		--, ISNULL('Meal-'+ SSR.SSR_Code +'/','') as SSR_Name
		, ISNULL(SSR.SSR_Code,'') as SSR_Name
		, tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName
		, SUM(
       CASE 
        WHEN ISNULL(SSR.ROE,0) = 0 
        THEN 
            CASE WHEN TB.BookingSource = 'Web' OR c.CurrencyCode != @Currency
            THEN  CAST(ISNULL(SSR.SSR_Amount,0) * tb.AgentROE * tb.ROE AS decimal(10,2))
            ELSE  CAST(ISNULL(SSR.SSR_Amount,0) * tb.ROE AS decimal(10,2))
            END
           ELSE 
            ISNULL(SSR.SSR_Amount, 0) * SSR.ROE
       END) AS SSR_Amount
	  , tp.paxType
		, tp.isReturn
	 FROM tblPassengerBookDetails tp WITH(NOLOCK)
	 INNER JOIN tblSSRDetails SSR WITH(NOLOCK) ON SSR.fkpassengerid=tp.pid	
	 INNER JOIN tblBookMaster tb  WITH(NOLOCK) on tb.pkid=SSR.fkBookMaster
	 LEFT JOIN mCountryCurrency c WITH(NOLOCK) on c.CountryCode=tb.Country
	 WHERE  tb.orderId=@NewOrderID AND SSR_Type='Meals' AND SSR.SSR_Status =1
	 GROUP BY tp.baggage, ssr.SSR_Type, SSR.SSR_Code, tp.paxFName, tp.paxLName, tp.paxType, TB.BookingSource, SSR.SSR_Amount, tb.AgentROE, tb.ROE, c.CurrencyCode, tp.isReturn
	
	--tblSSRDetails BAGAGE FARE 
	SELECT 
		CASE WHEN c.CurrencyCode!=@Currency THEN
			SUM(ISNULL(SSR.SSR_Amount,0)) *(tb.AgentROE * tb.ROE) 
			ELSE SUM(ISNULL(SSR.SSR_Amount,0)) *(tb.ROE)
		END SSR_Amount
	FROM tblBookMaster tb WITH(NOLOCK)
	LEFT JOIN tblSSRDetails SSR  WITH(NOLOCK) ON SSR.fkBookMaster=TB.pkId
	LEFT JOIN mCountryCurrency c WITH(NOLOCK) on c.CountryCode=tb.Country
	WHERE orderId=@NewOrderID AND ssr.SSR_Type='Baggage' AND SSR.SSR_Code !='TAX'
	GROUP BY c.CurrencyCode,tb.AgentROE,tb.ROE
	
	--Net fare calculation
	SELECT tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName
		,CASE WHEN c.CurrencyCode !=@Currency THEN
			SUM(CAST((tp.totalFare) * tb.AgentROE * tb.ROE as decimal(10,2))) +   ISNULL(tp.MCOAmount,0) +  ISNULL(tp.Markup,0)  + ISNULL(tp.BFC,0) +ISNULL(tp.B2BMarkup,0)
			ELSE SUM(CAST((tp.totalFare) * tb.ROE as decimal(10,2))) +   ISNULL(tp.MCOAmount,0) +  ISNULL(tp.Markup,0) + ISNULL(tp.BFC,0) +ISNULL(tp.B2BMarkup,0)
		END totalFare
		,SUM(ISNULL(tp.DiscountTDS,0)) DiscountTDS
		,SUM(ISNULL(tp.DiscountGST,0)) DiscountGST
		,SUM(ISNULL(TP.IATACommission,0) + ISNULL(TP.PLBCommission,0) + ISNULL(TP.DropnetCommission,0)) TotalCommission
		,ISNULL(tp.IATACommission,0) IATACommission
		,ISNULL(tp.PLBCommission,0) PLBCommission
		,ISNULL(tp.DropnetCommission,0) DropnetCommission
		,ISNULL(tp.ServiceFee,0) ServiceFee
		,ISNULL(tp.GST,0) GST
		,ISNULL(tp.HupAmount,0) HupAmount
	FROM tblPassengerBookDetails tp WITH(NOLOCK)
	LEFT JOIN tblBookMaster tb WITH(NOLOCK) ON tb.pkid=tp.fkBookMaster
	LEFT JOIN mCountryCurrency c WITH(NOLOCK) ON c.CountryCode=tb.Country
	WHERE orderId=@NewOrderID AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID) AND TP.totalFare > 0 --AND tp.isReturn = 0
	GROUP BY TP.paxFName,TP.paxLName,TP.paxType,C.CurrencyCode,TP.MCOAmount,TP.Markup,TB.BFC,TP.B2BMarkup,tp.IATACommission,tp.PLBCommission,tp.DropnetCommission,tP.ServiceFee,TP.GST, tp.BFC,HupAmount
	ORDER BY tP.paxType,FullName asc
	
	--TAX DESCRIPTION STRING
	SELECT 
		CASE WHEN c.CurrencyCode !=@Currency THEN
		'ServiceCharge: ' + convert(varchar(20), CAST((SUM(ServiceCharge) *t.AgentROE * t.ROE ) as decimal(10,2)))+ ';YRTax:' + convert(varchar(20), CAST((ISNULL(SUM(YRTax) ,0)*t.AgentROE * t.ROE ) as decimal(10,2)))   
			+  ';INTax:' + convert(varchar(20), CAST((ISNULL(SUM(INTax) ,0)*t.AgentROE * t.ROE ) as decimal(10,2))) + ';JNTax:' +  convert(varchar(20), CAST((ISNULL(SUM(JNTax) ,0)*t.AgentROE * t.ROE ) as decimal(10,2)))
			+  ';OCTax :' +  convert(varchar(20), CAST((ISNULL(SUM(OCTax) ,0)*t.AgentROE * t.ROE ) as decimal(10,2))) + ';ExtraTax:' + convert(varchar(20), CAST((ISNULL(SUM(ExtraTax) ,0)*t.AgentROE * t.ROE +(ISNULL(t.TotalVendorServiceFee,0) * t.ROE)+ ISNULL(RFTax,0)) as decimal(10,2))) 
			+   ';YQTax:' + convert(varchar(20), CAST((ISNULL(SUM(YQTax) ,0)*t.AgentROE * t.ROE ) as decimal(10,2)))
			+   ';WOTax :' + convert(varchar(20), CAST((ISNULL(SUM(WOTax) ,0)  ) as decimal(10,2)))
			+   ';SC :' + convert(varchar(20), CAST((ISNULL(SUM(B2BMarkup) ,0)*t.AgentROE  ) as decimal(10,2))) 
			+  ISNULL(CASE WHEN ServiceFee>0 AND @MainAgentId=0 THEN ';Service Fee :' + convert(varchar(20), CAST((ISNULL(ServiceFee ,0)) as decimal(10,2))) end,'')
			+  ISNULL(CASE WHEN GST>0 AND @MainAgentId=0 THEN ';GST :' + convert(varchar(20), CAST((ISNULL(GST ,0)) as decimal(10,2))) end,'')
			ELSE
			'ServiceCharge: ' + convert(varchar(20), CAST((SUM(ServiceCharge) * t.ROE ) as decimal(10,2)))+ ';YRTax:' + convert(varchar(20), CAST((ISNULL(SUM(YRTax) ,0) * t.ROE ) as decimal(10,2)))   
			+  ';INTax:' + convert(varchar(20), CAST((ISNULL(SUM(INTax) ,0) * t.ROE ) as decimal(10,2))) + ';JNTax:' +  convert(varchar(20), CAST((ISNULL(SUM(JNTax) ,0) * t.ROE ) as decimal(10,2)))
			+  ';OCTax :' +  convert(varchar(20), CAST((ISNULL(SUM(OCTax) ,0) * t.ROE ) as decimal(10,2))) + ';ExtraTax:' + convert(varchar(20), CAST((ISNULL(SUM(ExtraTax) ,0) * t.ROE +(ISNULL(t.TotalVendorServiceFee,0) * t.ROE) + ISNULL(RFTax,0)) as decimal(10,2))) 
			+   ';YQTax:' + convert(varchar(20), CAST((ISNULL(SUM(YQTax) ,0) * t.ROE ) as decimal(10,2))) 
			+   ';WOTax :' + convert(varchar(20), CAST((ISNULL(SUM(WOTax) ,0)  ) as decimal(10,2)))
			+   ';SC :' + convert(varchar(20), CAST((ISNULL(SUM(B2BMarkup) ,0)  ) as decimal(10,2)))	
				+  ISNULL(CASE WHEN ServiceFee>0 AND @MainAgentId=0 THEN ';Service Fee :' + convert(varchar(20), CAST((ISNULL(ServiceFee ,0)) as decimal(10,2))) end,'')
			+  ISNULL(CASE WHEN GST>0 AND  @MainAgentId=0 THEN ';GST :' + convert(varchar(20), CAST((ISNULL(GST ,0)  ) as decimal(10,2))) end,'')
		END taxdesc
	FROM tblBookMaster t WITH(NOLOCK)
	LEFT JOIN mCountryCurrency c WITH(NOLOCK) on c.CountryCode=t.Country
	WHERE t.orderId=@NewOrderID AND (@SectorID IS NULL OR @SectorID = '' OR t.pkId = @SectorID)
	GROUP BY CurrencyCode ,AgentROE,roe,ServiceFee,GST, RFTax,TotalVendorServiceFee
	
	
	--Passenger details for new print copy
	declare @BasicB2BMARKUP1 decimal(18,2)=0
	declare @TaxB2BMARKUP1 decimal(18,2)=0
	IF exists(SELECT TOP 1 * FROM tblBookMaster WITH(NOLOCK) WHERE orderId=@NewOrderID AND B2bFareType=1)
		BEGIN
			SET @BasicB2BMARKUP1=(SELECT TOP 1 tp.B2BMarkup FROM tblPassengerBookDetails tp WITH(NOLOCK) inner JOIN tblBookMaster tbm WITH(NOLOCK) ON tp.fkBookMaster=tbm.pkId WHERE orderId=@NewOrderID order by tp.pid)
		END
	ELSE if exists(SELECT TOP 1 * FROM tblBookMaster WITH(NOLOCK) WHERE orderId=@NewOrderID AND (B2bFareType=2 or B2bFareType=3))
		BEGIN
			SET @TaxB2BMARKUP1=(SELECT TOP 1 tp.B2BMarkup FROM tblPassengerBookDetails tp WITH(NOLOCK) inner JOIN tblBookMaster tbm WITH(NOLOCK) ON tp.fkBookMaster=tbm.pkId WHERE orderId=@NewOrderID order by tp.pid)
		END
	
	
	SELECT  
		t1.paxFName +' '+t1.paxLName +' '+'('+paxType+')' as FullName,
		CASE WHEN c.CurrencyCode !=@Currency THEN
			SUM(CAST((t1.basicFare *t2.AgentROE* t2.ROE+ISNULL(t1.Markup,0)) as decimal(10,2))+@BasicB2BMARKUP1+ISNULL(t1.LonServiceFee,0)) ELSE SUM(CAST((t1.basicFare * t2.ROE+ ISNULL(t1.Markup,0)) as decimal(10,2))+@BasicB2BMARKUP1+ISNULL(t1.LonServiceFee,0)) END basicFare
			, ISNULL(t1.GST, 0) AS GST
			, ISNULL(t1.ServiceFee, 0) AS ServiceFee
			,CASE WHEN c.CurrencyCode!=@Currency THEN
			SUM(CAST(((t1.totalTax+ISNULL(t1.VendorServiceFee,0) +ISNULL(t1.AirlineFee,0)) *t2.AgentROE * t2.ROE)+ (@TaxB2BMARKUP1 + ISNULL(t1.ServiceFee,0) + ISNULL(t1.gst,0) + ISNULL(t1.HupAmount,0) 
			+ ISNULL(t1.BFC,0)) *t2.AgentROE  as decimal(10,2))) ELSE SUM(CAST((t1.totalTax+ISNULL(t1.VendorServiceFee,0) +ISNULL(t1.AirlineFee,0)) * t2.ROE + (@TaxB2BMARKUP1 + ISNULL(t1.ServiceFee,0) + ISNULL(t1.HupAmount,0) + ISNULL(t1.gst,0) 
			+ ISNULL(t1.BFC,0))  as decimal(10,2)))
		END totalTax
		,CASE WHEN c.CurrencyCode !=@Currency THEN
			SUM(CAST((t1.totalFare+ISNULL(t1.VendorServiceFee,0) +ISNULL(t1.AirlineFee,0)) * t2.AgentROE * t2.ROE as decimal(10,2)))
			+  ISNULL(t1.Markup,0) + ISNULL(t1.BFC,0) +ISNULL(t1.LonServiceFee,0)
			+ ISNULL(t1.ServiceFee,0) + ISNULL(t1.gst,0) + ISNULL(t1.HupAmount,0)+@BasicB2BMARKUP1+@TaxB2BMARKUP1
			-(ISNULL(t1.PLBCommission,0)+ISNULL(t1.IATACommission,0)+ISNULL(t1.DropnetCommission,0))
			 ELSE SUM(CAST((t1.totalFare +ISNULL(t1.VendorServiceFee,0) +ISNULL(t1.AirlineFee,0)) * t2.ROE as decimal(10,2)))
			+  ISNULL(t1.Markup,0)  + ISNULL(t1.HupAmount,0)+ ISNULL(t1.BFC,0)+ISNULL(t1.LonServiceFee,0)
			+ ISNULL(t1.ServiceFee,0) + ISNULL(t1.gst,0)  +@BasicB2BMARKUP1+@TaxB2BMARKUP1
			-(ISNULL(t1.PLBCommission,0)+ISNULL(t1.IATACommission,0)+ISNULL(t1.DropnetCommission,0))
		END totalFare
		, (CASE WHEN c.CurrencyCode!=@Currency 
				THEN SUM(CAST(((t1.totalTax+ISNULL(t1.VendorServiceFee,0) +ISNULL(t1.AirlineFee,0)) * t2.AgentROE * t2.ROE)+ (@TaxB2BMARKUP1 + ISNULL(t1.ServiceFee,0) + ISNULL(t1.gst,0) + ISNULL(t1.HupAmount,0) + ISNULL(t1.BFC,0)) *t2.AgentROE  AS DECIMAL(10,2))) 
				ELSE SUM(CAST((t1.totalTax+ISNULL(t1.VendorServiceFee,0) +ISNULL(t1.AirlineFee,0)) * t2.ROE + (@TaxB2BMARKUP1 + ISNULL(t1.HupAmount,0) + ISNULL(t1.BFC,0)) AS DECIMAL(10,2))) 
			END) AS TotalTaxWithoutServiceFee
		, (CASE WHEN c.CurrencyCode != @Currency 
				THEN SUM(CAST((t1.totalFare+ISNULL(t1.VendorServiceFee,0) +ISNULL(t1.AirlineFee,0)) * t2.AgentROE * t2.ROE AS DECIMAL(10,2))) + ISNULL(t1.Markup,0) + ISNULL(t1.BFC,0)+@BasicB2BMARKUP1 +@TaxB2BMARKUP1+ ISNULL(t1.ServiceFee,0) + ISNULL(t1.gst,0) + ISNULL(t1.HupAmount,0)+ISNULL(t1.LonServiceFee,0)-(ISNULL(t1.PLBCommission,0)+ISNULL(t1.IATACommission,0)+ISNULL(t1.DropnetCommission,0))
				ELSE SUM(CAST((t1.totalFare+ISNULL(t1.VendorServiceFee,0) +ISNULL(t1.AirlineFee,0)) * t2.ROE AS DECIMAL(10,2))) + ISNULL(t1.Markup,0)  + ISNULL(t1.HupAmount,0)+ ISNULL(t1.BFC,0) +@BasicB2BMARKUP1 +@TaxB2BMARKUP1 + ISNULL(t1.ServiceFee,0) + ISNULL(t1.gst,0)+ISNULL(t1.LonServiceFee,0)-(ISNULL(t1.PLBCommission,0)+ISNULL(t1.IATACommission,0)+ISNULL(t1.DropnetCommission,0))
			END) AS TotalFareWithoutServiceFee
		,(CASE WHEN CHARINDEX('/',ticketNum)>0   
			THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)),0,CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum))))   
			ELSE ticketNum END )as 'TicketNumber', 
			CASE WHEN t1.isReturn=0 THEN 'Single' ELSE 'Return' end Journey,   
			CASE   
				WHEN t2.BookingStatus=2 THEN 'Hold'  
				WHEN t1.BookingStatus=6  THEN 'To Be Cancelled'   
				WHEN t1.BookingStatus=4  THEN 'Cancelled'   
				WHEN t2.BookingStatus=0 THEN 'Failed'
				--WHEN t1.BookingStatus is null AND T2.IsBooked=1 THEN 'Confirmed'  
				WHEN t2.BookingStatus=1 AND T2.IsBooked=1 THEN  'Confirmed'  
				WHEN t2.BookingStatus=2 THEN 'Hold'  
				WHEN t2.BookingStatus=3 THEN 'Pending'  
				WHEN t2.BookingStatus=4 THEN 'Cancelled'  
				WHEN t2.BookingStatus=5 THEN 'Close'  
				WHEN t2.BookingStatus=11 THEN 'Cancelled'  
				WHEN t2.BookingStatus=12 THEN 'In-Process' 
				--WHEN t2.BookingStatus = 13 THEN 'TJQ Pending'
				WHEN t2.BookingStatus = 13 THEN 'Confirmed'
				WHEN t2.BookingStatus = 14 THEN 'Open Ticket'
				WHEN t2.BookingStatus = 15 THEN 'On Hold Canceled'
				
				--WHEN t1.BookingStatus is null THEN 'Confirmed'  
			END Status
			, (SELECT STUFF((SELECT '/' + tblPassengerBookDetails.baggage
									FROM tblPassengerBookDetails WITH(NOLOCK)
									LEFT JOIN tblBookMaster WITH(NOLOCK) on tblBookMaster.pkId = tblPassengerBookDetails.fkBookMaster
									WHERE tblBookMaster.orderId = @NewOrderID AND tblPassengerBookDetails.paxType = T1.paxType AND tblPassengerBookDetails.paxFName + ' ' + tblPassengerBookDetails.paxLName + ' ' + '(' + tblPassengerBookDetails.paxType + ')' = t1.paxFName + ' ' + t1.paxLName + ' ' + '(' + T1.paxType + ')'
									AND (@SectorID IS NULL OR @SectorID = '' OR tblBookMaster.pkId = @SectorID)
									FOR XML PATH('')),1,1,'')) AS baggage
			--, CASE WHEN t2.isReturnJourney=1 AND t1.paxType= 'ADULT' THEN t1.baggage-- + '/'+t1.baggage   
			--	WHEN t2.isReturnJourney=1 AND t1.paxType = 'CHILD' THEN t1.baggage-- + '/'+t1.baggage   
			--	WHEN t2.isReturnJourney=1 AND t1.paxType = 'INFANT' THEN t1.baggage-- + '/'+t1.baggage   
			--	WHEN t2.isReturnJourney=0 AND t1.paxType = 'ADULT' THEN t1.baggage   
			--	WHEN t2.isReturnJourney=0 AND t1.paxType = 'CHILD' THEN t1.baggage   
			--	WHEN t1.paxType='INFANT' THEN CAST(dbo.udf_GetNumeric(ISNULL(t1.baggage,0)) as varchar(30)) +' Kg'
			--END baggage
			, T1.isReturn ,  
			t1.paxType,
			pid,
			CASE WHEN c.CurrencyCode !=@Currency THEN
				CAST((t1.JNTax *t2.AgentROE* t2.ROE) as decimal(10,2)) ELSE CAST((t1.JNTax * t2.ROE) as decimal(10,2)) 
			END JNTax,
			ISNULL((CASE WHEN c.CurrencyCode !=@Currency THEN
				CAST((t1.YQ *t2.AgentROE* t2.ROE) as decimal(10,2)) ELSE CAST((t1.YQ * t2.ROE) as decimal(10,2)) 
			END),0) YQTax,
			ISNULL(t1.FrequentFlyNo,'') FrequentFlyNo
			,paxFName
			,paxLName
			, CASE WHEN BarCode IS NULL THEN '' WHEN BarCode = '' THEN ''
					ELSE (SELECT STUFF((SELECT '^' + BarCode 
						  FROM tblPassengerBookDetails PB WITH(NOLOCK)
						  LEFT JOIN tblBookMaster t2 WITH(NOLOCK) ON t2.pkId=PB.fkBookMaster 
						  WHERE t2.orderId = @NewOrderID AND (PB.paxFName + ' ' + PB.paxLName) = (t1.paxFName + ' ' + t1.paxLName)
						  FOR XML PATH('')
							), 1, 1, ''))
		      END AS BarCode
			, ISNULL(PassengerID, '') AS PassengerID -- Added BY JD 20.01.2022
	 FROM tblPassengerBookDetails t1  WITH(NOLOCK)
	 LEFT JOIN tblBookMaster t2 WITH(NOLOCK) on t2.pkId=t1.fkBookMaster  
	 LEFT JOIN AirlinesName a2  WITH(NOLOCK) on a2._CODE=t2.airCode  
	 LEFT JOIN mCountryCurrency c WITH(NOLOCK) on c.CountryCode=t2.Country
	 WHERE  t2.orderId=@NewOrderID  AND (t1.isReturn=0 or (t1.isReturn=1 or (SELECT count(pkId) FROM tblBookMaster WITH(NOLOCK) WHERE orderId=@NewOrderID) =1))AND  
	--(t1.totalFare>0 or (ISNULL(t2.PreviousRiyaPNR,'')!=''))  AND
	 (@SectorID IS NULL OR @SectorID = '' OR t2.pkId = @SectorID) and t2.returnFlag=0
	--AND isReturnJourney=0
	GROUP BY title,paxFName,paxLName,paxType,ticketNum,isReturn,t2.BookingStatus,t1.BookingStatus,t2.IsBooked,c.CurrencyCode
	,t1.Markup,t1.bfc,t1.B2BMarkup,t1.GST,t1.ServiceFee,t1.HupAmount,t2.isReturnJourney,t1.baggage,t1.pid,t1.JNTax,t1.FrequentFlyNo
	,t2.AgentROE,t2.ROE,T1.YQ, t1.BarCode, PassengerID,t1.LonServiceFee,t1.VendorServiceFee,t1.PLBCommission,t1.IATACommission,t1.DropnetCommission
	ORDER BY t1.paxType, FullName, pid ASC
	
	--SSR Seats 
	SELECT ssr.SSR_Type,ssr.SSR_Name, tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName,
		
            (CASE 
                 WHEN ISNULL(SSR.ROE,0) = 0 
                  THEN 
                 CASE WHEN c.CurrencyCode != @Currency
                 THEN CAST(ISNULL(SSR.SSR_Amount, 0) * tb.AgentROE * tb.ROE AS Numeric(18, 2))
                 ELSE CAST(ISNULL(SSR.SSR_Amount, 0) * tb.ROE AS Numeric(18, 2))
                END
              ELSE 
              ISNULL(SSR.SSR_Amount, 0) * SSR.ROE
              END) AS SSR_Amount,
			  tp.paxType
	 FROM tblPassengerBookDetails tp WITH(NOLOCK)
	 INNER JOIN tblSSRDetails SSR WITH(NOLOCK) ON SSR.fkpassengerid=tp.pid	
	 INNER JOIN tblBookMaster tb  WITH(NOLOCK) on tb.pkid=SSR.fkBookMaster
	 LEFT JOIN mCountryCurrency c WITH(NOLOCK) on c.CountryCode=tb.Country
	 WHERE  tb.orderId=@NewOrderID AND SSR_Type='Seat' AND SSR.SSR_Status =1
	
	--Flight Details Marine ticket copy Viewpnr
	SELECT 
		tbi.flightNo
		,CONVERT(varchar(7), tbi.depDate, 106) depDateMarine
		,CONVERT(varchar(7), tbi.arrivalDate, 106) arrivalDateMarine
		,SUBSTRING(tbi.fromAirport, 0, charindex('[', tbi.fromAirport, 0)) fromAirportMarine
		,SUBSTRING(tbi.toAirport, 0, charindex('[', tbi.toAiRport, 0)) toAirportMarine
		,CONVERT(VARCHAR(5),tbi.deptTime,108) AS deptTimeMarine
		,CONVERT(VARCHAR(5),tbi.arrivalTime,108) AS arrivalTimeMarine
		,tbi.fromTerminal
		,tbi.toTerminal
		,tb.riyaPNR
		,tbi.airCode,
		tbi.airName, 
		upper(substring(DATENAME(weekday,tbi.deptTime),1,3)) +','+FORMAT(CAST(tbi.deptTime AS datetime), 'dd MMMM yyyy') WholeDateMarine,
		CASE WHEN tb.BookingStatus = 1 AND tb.IsBooked=1 THEN  'Confirmed'  
			 WHEN tb.BookingStatus = 2 THEN 'Hold'  
			 WHEN tb.BookingStatus = 3 THEN 'Pending'  
			 WHEN tb.BookingStatus = 4 THEN 'Cancelled'  
			 WHEN tb.BookingStatus = 5 THEN 'Close'  
			 WHEN tb.BookingStatus = 11 THEN 'Cancelled'  
			 WHEN tb.BookingStatus = 12 THEN 'In-Process' 
			 WHEN tb.BookingStatus = 0 THEN 'Failed'
		END Status
		,tbi.fromAirport
		,tbi.toAirport
		,tbi.cabin
		,tb.ROE, tb.AgentID, tb.VendorName, tb.CounterCloseTime 
		,CONVERT(varchar(5), DATEADD(minute, DATEDIFF(MINUTE, tbi.deptTime,tbi.arrivalTime), 0), 114) +' '+'Hrs.'  Traveldifference
		,CASE WHEN count(tb.pkid)=count(tbi.fkBookMaster) THEN 'Non-sTOP' END JourneyType
		,tbi.farebasis
		,faretype
		, tb.VendorName, tb.TotalTime
		,tbi.airlinepnr as AirlinePNR
		, ISNULL('VIA : '+tbi.Via,'') AS Via
	FROM tblBookItenary tbi WITH(NOLOCK)
	LEFT JOIN tblBookMaster tb WITH(NOLOCK) on tb.pkId=tbi.fkBookMaster
	WHERE tb.orderId=@NewOrderID AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID)
	GROUP BY tbi.flightNo,tbi.depDate,tbi.arrivalDate,tbi.fromAirport,tbi.toAirport,tbi.deptTime,tbi.arrivalTime,tbi.fromTerminal,tbi.toTerminal
	,tb.riyaPNR,tbi.airCode,tbi.airName,tb.BookingStatus,tb.IsBooked,tbi.cabin,tbi.farebasis,tbi.airlinePNR, tb.VendorName, tb.TotalTime
	,tb.ROE, tb.AgentID, tb.VendorName, tb.CounterCloseTime ,FareType,tbi.Via
	ORDER BY tbi.deptTime asc 
	
	--AIEXpress PNR Accounting Baggage/Meal desc with SSR	
	IF EXISTS(SELECT TOP 1 * from tblSSRDetails s1 WITH(NOLOCK) WHERE s1.fkpassengerid in(SELECT pid from tblPassengerBookDetails WITH(NOLOCK) WHERE fkBookMaster in(SELECT pkid from tblBookMaster WITH(NOLOCK) WHERE riyaPNR=@RiyaPNR)) )
	BEGIN
		SELECT tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName,
			tp.baggage,
			tp.paxType,
			SSR_Type,
			ISNULL(ssr.SSR_Name,tp.baggage) PassengerBaggageTotal
			,tp.isreturn, 0 as SSR_Amount
			,pid
			,'' as ExtenstionBaggage 
		FROM tblPassengerBookDetails tp WITH(NOLOCK)
		INNER JOIN tblSSRDetails SSR WITH(NOLOCK) ON SSR.fkpassengerid=tp.pid
		INNER JOIN tblBookMaster tb WITH(NOLOCK) ON tb.pkid=tp.fkBookMaster
		WHERE  tb.orderId=@NewOrderID AND bookingsource='Retrive PNR Accounting' AND airName='Air India Express' AND (SSR_Type='baggage') AND ssr.SSR_Amount>0 AND SSR.SSR_Status =1
		ORDER BY tp.paxType,FullName,pid
	END
	ELSE
	begin
		SELECT
			tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName,
			tp.baggage 
			,tp.paxType,
			'' as SSR_Type
			,CAST(dbo.udf_GetNumeric(ISNULL(REPLACE(tp.baggage,'1 Piece',''),0)) as int)  as PassengerBaggageTotal
			,tp.isreturn, 0 as SSR_Amount
			,LTRIM(RIGHT(tp.baggage, LEN(tp.baggage) - PATINDEX('%[0-9][^0-9]%', tp.baggage))) As ExtenstionBaggage
			,pid
			,isReturn
		FROM tblPassengerBookDetails tp WITH(NOLOCK)
		LEFT JOIN tblBookMaster tb WITH(NOLOCK) on tb.pkid=tp.fkBookMaster
		WHERE  tb.orderId=@NewOrderID AND bookingsource='Retrive PNR Accounting' AND airName='Air India Express'
		ORDER BY tp.paxType
	END
	
	--AIEXpress PNR Accounting Baggage/Meal desc withOUT SSR
	SELECT 1, tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' AS FullName,
		tp.baggage ,tp.paxType, tp.pid, tp.isReturn, tb.BookingSource
	FROM tblPassengerBookDetails tp WITH(NOLOCK)
	LEFT JOIN tblBookMaster tb WITH(NOLOCK) ON tb.pkId=tp.fkBookMaster
	WHERE  tb.orderId=@NewOrderID AND bookingsource='Retrive PNR Accounting' AND airName='Air India Express'  
	ORDER BY tp.paxType ,FullName ASC
END