

----GetAirlinePNRWiseSalesReport_V2 '2024-11-11 00:00:00','2024-11-15 23:59:59','','','SA','','','','','','',1,50,1,NULL
CREATE PROCEDURE [dbo].[GetAirlinePNRWiseSalesReport_V2] 
	@FromDate Date=NULL 
	, @ToDate Date=NULL
	, @AirlineCategory varchar(10)=NULL
	, @AirlineCode varchar(10)=NULL
	, @Country varchar(40)=NULL
	, @BranchCode varchar(40)=NULL
	, @AgentType varchar(50)=NULL
	, @ClassType varchar(10)=NULL
	, @RiyaPNR varchar(50)=NULL
	, @AgentId int=NULL
	--@AccountType varchar(20)=NULL, 
	, @BookingStatus varchar(20)=NULL --Jitendra Nakum 08/09/2022
	, @Start int=NULL
	, @Pagesize int=NULL
	, @IsPaging bit=NULL
	, @RecordCount INT OUTPUT
AS 
BEGIN 
	SET @RecordCount=0

	IF OBJECT_ID ( 'tempdb..#tempTableAirlinePNR') IS NOT NULL
		DROP TABLE #tempTableAirlinePNR
	SELECT * INTO #tempTableAirlinePNR FROM (
		SELECT --b.inserteddate AS 'Ticket Booked Date', 
		CONVERT(VARCHAR(10),(CASE WHEN coun.CountryCode='IN' THEN (DATEADD(SECOND, 0,CONVERT(varchar(10),b.issuedate,120))) 
			WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16,CONVERT(varchar(10),b.issuedate,120))) 
			WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16,CONVERT(varchar(10),b.issuedate,120))) 
			WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND,-1 * 60 * 60 - 29 * 60 - 13,CONVERT(varchar(10),b.issuedate,120)))
			WHEN coun.CountryCode='SA' THEN (DATEADD(SECOND,-1 * 60 * 60 - 29 * 60 - 13,CONVERT(varchar(10),b.issuedate,120))) 
		END),103) AS 'Ticket Booked Date'
		,case when isnull(r.AgencyName ,'')= '' then 
b2b1.AgencyName
else
r.AgencyName
end  AS 'Agency Name',
		--, AgencyName AS 'Agency Name'
	'''' + 	case when isnull(r.Icast ,'')= '' then 
b2b1.Icast
else
r.Icast
end AS 'Cust ID'
		--,'''' + r.Icast AS 'Cust ID'
		,(CASE WHEN @AgentType='Holiday'
		THEN (Select top 1 (CASE WHEN (BookingCountry='IN' OR BookingCountry='US') AND mc.Value='IN' THEN 'RTTICU'
								WHEN (BookingCountry='IN' OR BookingCountry='US') AND mc.Value='US' THEN 'RTTINC'
								WHEN (BookingCountry='IN' OR BookingCountry='US') AND mc.Value='CA' THEN 'RTTCAN'
								WHEN (BookingCountry='IN' OR BookingCountry='US') AND mc.Value='AE' THEN 'RTTDXB'
								ELSE '' END)
				from agentLogin WITH(NOLOCK)
						INNER JOIN mVendorCredential mc WITH(NOLOCK) ON mc.OfficeId=b.OfficeID AND FieldName='ERP Country'
						WHERE UserID=b.AgentID AND userTypeID=4
						)
				ELSE (Select top 1 wy.[RH Ledgers] from tblInterBranchWinyatra wy WITH(NOLOCK)
					INNER JOIN B2BRegistration r1 WITH(NOLOCK)ON wy.Icust=r1.Icast AND CAST(r1.FKUserID AS VARCHAR(50))=b.AgentID			
					INNER JOIN mVendorCredential mc WITH(NOLOCK) ON mc.OfficeId=b.OfficeID AND FieldName='ERP Country'  AND wy.Country=b.Country
					)
				END
		) AS [RH Ledgers]
		--,(CASE WHEN @AgentType='Holiday' AND @Country='IN' THEN 'RTTICU' WHEN @AgentType='Holiday' AND @Country='US' THEN 'RTTINC' ELSE
		--	(Select top 1 wy.[RH Ledgers] from tblInterBranchWinyatra wy 
		--	INNER JOIN B2BRegistration r1 WITH(NOLOCK)ON wy.Icust=r1.Icast AND CAST(r1.FKUserID AS VARCHAR(50))=b.AgentID			
		--	INNER JOIN mVendorCredential mc WITH(NOLOCK) ON mc.OfficeId=b.OfficeID AND FieldName='ERP Country'  AND wy.Country=mc.Value
		--	)
		--	END) AS [RH Ledgers]
		, ac.type AS 'Airline Category'
		, B.riyaPNR AS 'booking Id'
		, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS 'Airlines PNR'
		, B.GDSPNR AS 'CRS PNR'
		--, (CASE WHEN CHARINDEX('/',pb.ticketNum)>0 THEN SUBSTRING(SUBSTRING(pb.ticketNum, CHARINDEX(' ', pb.ticketNum)+1,LEN(pb.ticketNum)),0,CHARINDEX('/',(SUBSTRING(pb.ticketNum, CHARINDEX(' ', pb.ticketNum)+1,LEN(pb.ticketNum))),0)) ELSE pb.ticketNum END) AS 'Ticket No'
		, (CASE WHEN CHARINDEX('/',pb.ticketNum)>0 THEN SUBSTRING(SUBSTRING(SUBSTRING(pb.ticketNum, CHARINDEX(' ', pb.ticketNum)+1,LEN(pb.ticketNum)),0,CHARINDEX('/',(SUBSTRING(pb.ticketNum, CHARINDEX(' ', pb.ticketNum)+1,LEN(pb.ticketNum))),0)),0,4) ELSE '' END ) AS 'Supplier Code'
		,ISNULL(pb.TicketNumber,'') AS 'Ticket No'
		, 'Confirmed' AS 'Booking Status'
		, pb.paxType AS 'Pax Type'
		, ISNULL(pb.paxFName,'')+' '+ISNULL(pb.paxLName,'') AS 'Pax Name'
		--, pb.paxLName AS 'Last Name'
		, (CASE WHEN b.isReturnJourney=0 THEN 'OneWay' ELSE 'RoundTrip' END) AS 'Trip Type'
		, (CASE WHEN b.CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS 'Travel Type'
		, pm.payment_mode AS 'Payment Mode'
		,ISNULL(BP.ModeOfPayment,'') AS ModeOfPayment
		,ISNULL((Select top 1 FullName+'('+EmployeeNo+')' from mUser WHERE id=b.BookedBy),
		(Select top 1 AgencyName from B2BRegistration WHERE FKUserID=b.BookedBy))AS 'BookedBy'
		, coun.Currency AS 'Currency'
		, STUFF((SELECT '/' + substring(s.cabin, 1, CASE WHEN CHARINDEX('-', s.cabin ) = 0 THEN CHARINDEX('-', s.cabin) 
				ELSE CHARINDEX('-', s.cabin) -1 END) FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS Class
		, STUFF((SELECT '/' + s.frmSector+'-'+s.toSector FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS Sector --+' '+convert (varchar,s.depDate,105)
		, STUFF((SELECT '/' + s.airName FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Airline Name'
		, STUFF((SELECT '/' + s.airCode FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Airline Code'
		, STUFF((SELECT '/' + s.flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Flight No'
		--, convert (varchar,b.depDate,103) AS 'Date of Travel'
		, convert (varchar,b.depDate,103) AS 'Onward Travel Date'
		, convert (varchar,b.arrivalDate,103) AS 'Return Travel Date'
		, CONVERT(decimal(18,2),(pb.basicFare + isnull(pb.LonServiceFee,0))*b.ROE) AS 'Basic Fare'
		, CONVERT(decimal(18,2),pb.YQ*b.ROE) AS 'YQ Fare'
		, CONVERT(decimal(18,2),(pb.totalTax-pb.YQ)*b.ROE) AS 'Other Taxes'
		--,CONVERT(decimal(18,2),pb.FMCommission*b.ROE) AS 'Commission', 
		--CONVERT(decimal(18,2),pb.IATACommission*b.ROE) AS 'IATA',CONVERT(decimal(18,2),pb.PLBCommission*b.ROE) AS 'PLB',CONVERT(decimal(18,2),pb.DropnetCommission*b.ROE) AS 'DROPNET','0' AS 'TDS Amount',CONVERT(decimal(18,2),pb.Markup*b.ROE) AS 'Service Charges', 
		, CONVERT(decimal(18,2),pb.FMCommission) AS 'Commission'
		, CONVERT(decimal(18,2),pb.IATACommission) AS 'IATA'
		, CONVERT(decimal(18,2),ISNULL(pb.TDSonIATA,0)) AS 'TDS on IATA'
		, CONVERT(decimal(18,2),pb.PLBCommission) AS 'PLB'
		, CONVERT(decimal(18,2),ISNULL(pb.GSTonPLB,0)) AS 'GST on PLB'
		, CONVERT(decimal(18,2),ISNULL(pb.TDSonPLB,0)) AS 'TDS on PLB'
		, CONVERT(decimal(18,2),pb.DropnetCommission) AS 'DROPNET'
		, '0' AS 'TDS Amount'
		, CONVERT(decimal(18,2),pb.Markup) AS 'Service Charges'
		, '0' AS 'Agency Markup'
		, '0' AS 'Cancellation Penalty'
		, '0' AS 'Cancellation Markup'
		--CONVERT(DECIMAL(18,2),(ISNULL(Pb.BFC,0)+ISNULL(pb.B2BMarkup,0))*b.ROE) AS 'Markup',
		--CONVERT(DECIMAL(18,2),ISNULL(Pb.ServiceFee,0)*b.ROE) AS 'Service Fee'
		--, CONVERT(DECIMAL(18,2),(ISNULL(Pb.BFC,0)+ISNULL(pb.B2BMarkup,0))) AS 'Markup'
		, CONVERT(DECIMAL(18,2),(ISNULL(pb.B2BMarkup,0))) AS 'Hidden Markup'
		,(CASE WHEN (pb.MarkOn IS NULL OR pb.MarkOn='Markup on Base') THEN ISNULL(pb.BFC,0) ELSE 0 End) AS 'Markup on fare'
		,(CASE WHEN pb.MarkOn='Markup on Tax' THEN ISNULL(pb.BFC,0) ELSE 0 End) AS 'Markup on tax'
		, CONVERT(DECIMAL(18,2),ISNULL(Pb.ServiceFee,0)) AS 'Service Fee'
		, CONVERT(DECIMAL(18,2),ISNULL(pb.GST,0)) AS GST
		,CAST((dbo.Get_SSR_Amount_By_SSR_Type (b.riyaPNR,'Baggage',pb.totalFare,pb.paxType,pb.paxFName,paxLName,TicketNumber))
						* (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId) as decimal(18,2)) AS 'Baggage Amount'
		,CAST((dbo.Get_SSR_Amount_By_SSR_Type (b.riyaPNR,'Seat',pb.totalFare,pb.paxType,pb.paxFName,paxLName,TicketNumber))
						* (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId) as decimal(18,2)) AS 'Seat Amount'
		,CAST((dbo.Get_SSR_Amount_By_SSR_Type (b.riyaPNR,'Meals',pb.totalFare,pb.paxType,pb.paxFName,paxLName,TicketNumber))
						* (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId) as decimal(18,2)) AS 'Meals Amount'
		--, CONVERT(DECIMAL(18,2),ISNULL(ssr_baggage.SSR_Amount,0)*b.ROE) AS 'Baggage Amount'
		--, CONVERT(DECIMAL(18,2),ISNULL(ssr_seat.SSR_Amount,0)*b.ROE) AS 'Seat Amount'
		--, CONVERT(DECIMAL(18,2),ISNULL(ssr_meals.SSR_Amount,0)*b.ROE) AS 'Meals Amount'
		, '0.00' AS 'Other SSR Amount'
		,ISNULL(BP.ConvenienFeeInPercent,0) AS 'PG Charges In Percent'
		,CONVERT(decimal(18,2),(ISNULL(BP.TotalCommission,0)/ isnull((select count(*) from tblpassengerbookdetails pb where pb.fkBookMaster=b.pkId ),1))) AS 'Payment Gateway Charges'
		,(ISNULL(pb.VendorServiceFee,0) * b.ROE) AS 'Vendor Service Fee'
		, CONVERT(DECIMAL(18,2),(((pb.totalFare+ isnull(pb.LonServiceFee,0)) * b.ROE)+ isnull(pb.Markup,0) + isnull(pb.BFC,0) + isnull(pb.ServiceFee,0) + isnull(pb.GST,0) +
		ISNULL(((dbo.Get_SSR_Amount_By_SSR_Type (b.riyaPNR,'Baggage',pb.totalFare,pb.paxType,pb.paxFName,paxLName,TicketNumber))
						* (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId)),0)
		+ ISNULL(((dbo.Get_SSR_Amount_By_SSR_Type (b.riyaPNR,'Seat',pb.totalFare,pb.paxType,pb.paxFName,paxLName,TicketNumber))
						* (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId)),0)
		+ ISNULL(((dbo.Get_SSR_Amount_By_SSR_Type (b.riyaPNR,'Meals',pb.totalFare,pb.paxType,pb.paxFName,paxLName,TicketNumber))
						* (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId)),0) +
		ISNULL(pb.VendorServiceFee,0) * b.ROE +
		(ISNULL(pb.B2BMarkup,0)) -
		(isnull(pb.IATACommission,0) + isnull(pb.PLBCommission,0) + isnull(pb.DropnetCommission,0)) + CONVERT(decimal(18,2),(ISNULL(BP.TotalCommission,0)/ isnull((select count(*) from tblpassengerbookdetails pb where pb.fkBookMaster=b.pkId ),1))))) AS 'Net Amount'
		 --,CONVERT(DECIMAL(18,2),(pb.totalFare+pb.Markup + b.BFC + b.ServiceFee + b.GST+
		 --isnull(CASE SSR_Type WHEN 'Baggage' THEN SSR_Amount END,0)+
		 --isnull(CASE SSR_Type WHEN 'Seat' THEN SSR_Amount END,0)+
		--isnull(CASE SSR_Type WHEN 'Meals' THEN SSR_Amount END,0)+
		--+(ISNULL(Pb.BFC,0)+ISNULL(pb.B2BMarkup,0)) -(isnull(pb.IATACommission,0)+isnull(pb.PLBCommission,0)+isnull(pb.DropnetCommission,0)))*b.ROE) AS 'Net Amount', 
		, '0' AS 'Reschedule Charges'
		, '0' AS 'SC Tax'
		, '' AS 'Mo Number'
		, '' AS 'UATP Status'
		, '0' AS 'SF'
		, '' AS 'Previous Riya PNR'
		, '' AS 'Reschedule Markup'
		, '' AS 'Reschedule Date'
		, '' AS 'Cancellation Date' 
		--added by asmita 
		--,ISNULL( (Select top 1 SSR_Amount FROM tblSSRDetails AS ssr Where ssr.SSR_Type='Meals' AND ssr.fkBookMaster IN (Select pkid From tblBookMaster where GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR) AND ssr.fkPassengerid IN (Select fkPassengerid From tblBookMaster where fkPassengerid=ssr.fkPassengerid)),0) AS 'Meal Amount' 
		--,ISNULL( (Select top 1 SSR_Amount FROM tblSSRDetails AS ssr Where ssr.SSR_Type='Baggage' AND ssr.fkBookMaster IN (Select pkid From tblBookMaster where GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR) AND ssr.fkPassengerid IN (Select fkPassengerid From tblBookMaster where fkPassengerid=ssr.fkPassengerid)),0) AS 'Baggage Amount' 
		--,ISNULL( (Select top 1 SSR_Amount FROM tblSSRDetails AS ssr Where ssr.SSR_Type='Seat' AND ssr.fkBookMaster IN (Select pkid From tblBookMaster where GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR) AND ssr.fkPassengerid IN (Select fkPassengerid From tblBookMaster where fkPassengerid=ssr.fkPassengerid)),0) AS 'Seat Amount' 
		, R.CustomerType AS AccountType
		,pb.PanNumber AS 'PanCardno'
		--(Select top 1 ISNULL(PanCardno,'') from mAttrributesDetails Where fkPassengerid=pb.pid) AS 'PanCardno'
		,ISNULL(pb.PanCardValidation,'') AS 'Pan Card Remarks'
		,pb.passportNum AS 'Passport No'
		,FORMAT(pb.passexp, 'dd-MMM-yyyy') AS 'Passport Expiration Date'
		,pb.passportIssueCountry AS 'Passport Issue Country'
		,pb.nationality AS 'Passenger Nationality'
		,pb.dateOfBirth AS 'DOB'
		,pb.FrequentFlyNo AS 'Frequent Fly No'
		, (Select top 1 ISNULL(ma.OBTCno,'') AS OBTCno from mAttrributesDetails ma Where ma.OrderID=b.orderId AND ISNULL(ma.OBTCno,'')!='') AS 'OBT NO'
		, b.ROE AS ROE
		, b.VendorName as 'CRS'
		, b.OfficeID as 'Ticketing Suppier'
		, (CASE WHEN b.MainAgentId > 0 AND b.BookingSource='Web' THEN 'Internal Booking (Web)'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Retrive PNR' THEN 'Internal Booking (Retrive PNR)'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Retrive PNR - MultiTST' THEN 'Internal Booking Retrive PNR - MultiTST)'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Cryptic' THEN 'Internal Booking (Cryptic)'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Retrive PNR Accounting' THEN 'Internal Booking Accounting(Retrive PNR Accounting)'
				WHEN b.MainAgentId = 0 AND b.BookingSource='Web' THEN 'Agent Booking (Web)'
				WHEN b.MainAgentId = 0 AND b.BookingSource='Retrive PNR' THEN 'Agent Booking (Retrive PNR)' 
				WHEN b.MainAgentId = 0 AND b.BookingSource='Retrive PNR - MultiTST' THEN 'Agent Booking (Retrive PNR - MultiTST)' 
				WHEN b.MainAgentId > 0 AND b.BookingSource='ManualTicketing' THEN 'ManualTicketing'
				WHEN b.MainAgentId = 0 AND b.BookingSource='Cryptic' THEN 'Agent Booking (Cryptic)'
				WHEN b.BookingSource = 'GDS' THEN 'TJQ'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Retrive PNR Accounting-TicketNumber' THEN 'Internal Booking (PNR Accounting)'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Retrieve PNR accounting - MultiTST' THEN 'Internal Booking Retrive PNR accounting - MultiTST'
			END
			) AS 'Booking Mode'
			
		--, b.TCSTaxAmount AS [TCS TAX Amount]
		--, pb.NameAsOnPAN AS [Name As Per PAN Card]
		--, pb.PanNumber AS [PAN Card Number]
		--, 'E:\\Domains\\B2C New\\CacheLog\\LOGData\\TCSPanData\\' + PANDocuments AS [Undertaking Attachment]
		---END 
		FROM tblBookMaster b WITH(NOLOCK) 
		LEFT JOIN B2BRegistration r WITH(NOLOCK)ON CAST(r.FKUserID AS VARCHAR(50))=b.AgentID 
		INNER JOIN tblPassengerBookDetails pb WITH(NOLOCK) on pb.fkBookMaster=b.pkId AND pb.totalFare>0 
		LEFT JOIN agentLogin al WITH(NOLOCK) ON CAST(al.UserID AS VARCHAR(50))=b.AgentID 
		left join agentlogin al1 on al1.userid=al.ParentAgentID
		left join b2bregistration b2b1 on al.ParentAgentID = b2b1.FKUserID
		INNER JOIN Paymentmaster pm WITH(NOLOCK) ON pm.order_id=b.orderId 
		INNER JOIN AirlineCode_Console ac WITH(NOLOCK) ON ac.AirlineCode=B.airCode 
		INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=b.Country 
		LEFT JOIN B2BMakepaymentCommission BP WITH(NOLOCK) ON BP.FkBookId=b.pkId
		--LEFT JOIN tblSSRDetails ssr on ssr.fkBookMaster=b.pkId 
		--LEFT JOIN tblSSRDetails ssr on pb.pid =ssr.fkPassengerid 
		--LEFT JOIN tblSSRDetails ssr_seat WITH(NOLOCK) on pb.pid =ssr_seat.fkPassengerid AND ssr_seat.SSR_Type='Seat'
		--LEFT JOIN tblSSRDetails ssr_baggage WITH(NOLOCK) on pb.pid =ssr_baggage.fkPassengerid AND ssr_baggage.SSR_Type='Baggage'
		--LEFT JOIN tblSSRDetails ssr_meals WITH(NOLOCK) on pb.pid =ssr_meals.fkPassengerid AND ssr_meals.SSR_Type='Meals'
		--LEFT JOIN mAttrributesDetails ma WITH(NOLOCK) on ma.OrderID=b.orderId 
		WHERE ((@FROMDate = '') OR (CONVERT(date,B.inserteddate) >= CONVERT(date,@FROMDate))) 
 		AND ((@ToDate = '') OR (CONVERT(date,B.inserteddate) <= CONVERT(date, @ToDate))) 
		AND ((@AirlineCategory = '') OR (ac.type = @AirlineCategory)) 
		AND ((@AirlineCode = '') OR (b.airCode = @AirlineCode)) 
		-- AND ((@Country = '') OR (al.BookingCountry = @Country)) 
		AND ((@Country = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@Country, ',')))) 
		AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode)) 
		-- AND ((@AgentType='') OR ( @AgentType='B2C' AND b.AgentID='B2C') OR (al.UserTypeID = (SELECT ID FROM mCommon where Value=@AgentType))) 
		AND ((@AgentType='') OR ( @AgentType='B2C' AND b.AgentID='B2C') OR (al.UserTypeID in (SELECT ID FROM mCommon WITH(NOLOCK) where Value in (SELECT Data FROM sample_split(@AgentType, ','))))) 
		--AND ((@ClassType='') OR (substring(bi.cabin, CHARINDEX('-',bi.cabin)+1, LEN(bi.cabin))= @ClassType)) 
		AND ((@RiyaPNR = '') OR (b.riyaPNR = @RiyaPNR)) 
		AND ((@AgentId = '') OR (b.AgentID =CAST(@AgentId AS varchar(50)))) 
		--AND ((@AccountType = '') OR ( R.CustomerType = @AccountType)) 
		AND IsBooked=1 AND b.totalFare>0 AND pb.totalFare>0 
		AND ((@BookingStatus='') OR (@BookingStatus='Confirmed'))
 
		UNION 

		SELECT 
		CONVERT(varchar(10),pb.CancelledDate,103) AS 'Ticket Booked Date'
		,case when isnull(r.AgencyName ,'')= '' then 
b2b1.AgencyName
else
r.AgencyName
end AS 'Agency Name',
case when isnull(r.Icast ,'')= '' then 
b2b1.Icast
else
r.Icast
end AS 'Cust ID'
		--, AgencyName AS 'Agency Name'
		--, r.Icast AS 'Cust ID'
		,(CASE WHEN @AgentType='Holiday'
		THEN (Select top 1 (CASE WHEN (BookingCountry='IN' OR BookingCountry='US') AND mc.Value='IN' THEN 'RTTICU'
								WHEN (BookingCountry='IN' OR BookingCountry='US') AND mc.Value='US' THEN 'RTTINC'
								WHEN (BookingCountry='IN' OR BookingCountry='US') AND mc.Value='CA' THEN 'RTTCAN'
								WHEN (BookingCountry='IN' OR BookingCountry='US') AND mc.Value='AE' THEN 'RTTDXB'
								ELSE '' END)
				from agentLogin WITH(NOLOCK)
						INNER JOIN mVendorCredential mc WITH(NOLOCK) ON mc.OfficeId=b.OfficeID AND FieldName='ERP Country'
						WHERE UserID=b.AgentID AND userTypeID=4
						)
				ELSE (Select top 1 wy.[RH Ledgers] from tblInterBranchWinyatra wy WITH(NOLOCK)
					INNER JOIN B2BRegistration r1 WITH(NOLOCK)ON wy.Icust=r1.Icast AND CAST(r1.FKUserID AS VARCHAR(50))=b.AgentID			
					INNER JOIN mVendorCredential mc WITH(NOLOCK) ON mc.OfficeId=b.OfficeID AND FieldName='ERP Country'  AND wy.Country=b.Country
					)
				END
		) AS [RH Ledgers]
		--,(CASE WHEN @AgentType='Holiday' AND @Country='IN' THEN 'RTTICU' WHEN @AgentType='Holiday' AND @Country='US' THEN 'RTTINC' ELSE
		--	(Select top 1 wy.[RH Ledgers] from tblInterBranchWinyatra wy 
		--	INNER JOIN B2BRegistration r1 WITH(NOLOCK)ON wy.Icust=r1.Icast AND CAST(r1.FKUserID AS VARCHAR(50))=b.AgentID
		--	INNER JOIN mVendorCredential mc WITH(NOLOCK) ON mc.OfficeId=b.OfficeID AND FieldName='ERP Country'  AND wy.Country=mc.Value
		--	)
		--	END) AS [RH Ledgers]
		, ac.type AS 'Airline Category'
		, B.riyaPNR AS 'booking Id'
		, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS 'Airlines PNR'
		, B.GDSPNR AS 'CRS PNR'
		--, (CASE WHEN CHARINDEX('/',pb.ticketNum)>0 THEN SUBSTRING(SUBSTRING(pb.ticketNum, CHARINDEX(' ', pb.ticketNum)+1,LEN(pb.ticketNum)),0,CHARINDEX('/',(SUBSTRING(pb.ticketNum, CHARINDEX(' ', pb.ticketNum)+1,LEN(pb.ticketNum))),0)) ELSE pb.ticketNum END ) AS 'Ticket No'
		, (CASE WHEN CHARINDEX('/',pb.ticketNum)>0 THEN SUBSTRING(SUBSTRING(SUBSTRING(pb.ticketNum, CHARINDEX(' ', pb.ticketNum)+1,LEN(pb.ticketNum)),0,CHARINDEX('/',(SUBSTRING(pb.ticketNum, CHARINDEX(' ', pb.ticketNum)+1,LEN(pb.ticketNum))),0)),0,4) ELSE '' END ) AS 'Supplier Code'
		,ISNULL(pb.TicketNumber,'') AS 'Ticket No'
		, 'Cancelled' AS 'Booking Status'
		, pb.paxType AS 'Pax Type'
		, ISNULL(pb.paxFName,'')+' '+ISNULL(pb.paxLName,'') AS 'Pax Name'
		--, pb.paxLName AS 'Last Name'
		, (CASE WHEN b.isReturnJourney=0 THEN 'OneWay' ELSE 'RoundTrip' END) AS 'Trip Type'
		, (CASE WHEN b.CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS 'Travel Type'
		, pm.payment_mode AS 'Payment Mode'
		,ISNULL(BP.ModeOfPayment,'') AS ModeOfPayment
		,ISNULL((Select top 1 FullName+'('+EmployeeNo+')' from mUser WHERE id=b.BookedBy),
		(Select top 1 AgencyName from B2BRegistration WHERE FKUserID=b.BookedBy))AS 'BookedBy'
		, coun.Currency AS 'Currency'
		, STUFF((SELECT '/' + substring(s.cabin, 1, CASE WHEN CHARINDEX('-', s.cabin ) = 0 THEN CHARINDEX('-', s.cabin) 
				ELSE CHARINDEX('-', s.cabin) -1 END) FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS Class
		, STUFF((SELECT '/' + s.frmSector+'-'+s.toSector FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS Sector --+' '+convert (varchar,s.depDate,105)
		, STUFF((SELECT '/' + s.airName FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Airline Name'
		, STUFF((SELECT '/' + s.airCode FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Airline Code'
		, STUFF((SELECT '/' + s.flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Flight No'
		--, convert (varchar,b.depDate,103) AS 'Date of Travel'
		, convert (varchar,b.depDate,103) AS 'Onward Travel Date'
		, convert (varchar,b.arrivalDate,103) AS 'Return Travel Date'
		, -CONVERT(decimal(18,2),pb.basicFare*b.ROE) AS 'Basic Fare' 
		, -CAST(pb.YQ*b.ROE AS decimal(18,2)) AS 'YQ Fare'
		, -CONVERT(DECIMAL(18,2),(pb.totalTax-pb.YQ)*b.ROE) AS 'Other Taxes'
		--,-CONVERT(DECIMAL(18,2),(pb.FMCommission*b.ROE)) AS 'Commission', 
		---CONVERT(DECIMAL(18,2),pb.IATACommission*b.ROE) AS 'IATA',
		---CONVERT(DECIMAL(18,2),pb.PLBCommission*b.ROE) AS 'PLB',
		---CONVERT(DECIMAL(18,2),pb.DropnetCommission*b.ROE) AS 'DROPNET','0' AS 'TDS Amount'
		--,-CONVERT(DECIMAL(18,2),pb.Markup*b.ROE) AS 'Service Charges', 
		--'0' AS 'Agency Markup',CONVERT(DECIMAL(18,2),pb.CancellationPenalty*b.ROE) AS 'Cancellation Penalty'
		--,CONVERT(DECIMAL(18,2),pb.CancellationMarkup*b.ROE) AS 'Cancellation Markup',
		, -CONVERT(DECIMAL(18,2),(pb.FMCommission)) AS 'Commission'
		, -CONVERT(DECIMAL(18,2),pb.IATACommission) AS 'IATA'
		, CONVERT(decimal(18,2),ISNULL(pb.TDSonIATA,0)) AS 'TDS on IATA'
		, CONVERT(decimal(18,2),pb.PLBCommission) AS 'PLB'
		, CONVERT(decimal(18,2),ISNULL(pb.GSTonPLB,0)) AS 'GST on PLB'
		, CONVERT(decimal(18,2),ISNULL(pb.TDSonPLB,0)) AS 'TDS on PLB'
		, -CONVERT(DECIMAL(18,2),pb.DropnetCommission) AS 'DROPNET'
		, '0' AS 'TDS Amount'
		, -CONVERT(DECIMAL(18,2),pb.Markup) AS 'Service Charges'
		, '0' AS 'Agency Markup'
		, CONVERT(DECIMAL(18,2),pb.CancellationPenalty) AS 'Cancellation Penalty'
		, CONVERT(DECIMAL(18,2),pb.CancellationMarkup) AS 'Cancellation Markup'
		--CONVERT(DECIMAL(18,2),(ISNULL(Pb.BFC,0)+ISNULL(pb.B2BMarkup,0))*b.ROE) AS 'Markup',
		--CONVERT(DECIMAL(18,2),ISNULL(Pb.ServiceFee,0)*b.ROE) AS 'Service Fee',
		--, CONVERT(DECIMAL(18,2),(ISNULL(Pb.BFC,0)+ISNULL(pb.B2BMarkup,0))) AS 'Markup'
		, CONVERT(DECIMAL(18,2),(ISNULL(pb.B2BMarkup,0))) AS 'Hidden Markup'
		,(CASE WHEN (pb.MarkOn IS NULL OR pb.MarkOn='Markup on Base') THEN ISNULL(pb.BFC,0) ELSE 0 End) AS 'Markup on fare'
		,(CASE WHEN pb.MarkOn='Markup on Tax' THEN ISNULL(pb.BFC,0) ELSE 0 End) AS 'Markup on tax'
		, CONVERT(DECIMAL(18,2),ISNULL(Pb.ServiceFee,0)) AS 'Service Fee'
		, CONVERT(DECIMAL(18,2),ISNULL(pb.GST,0)) AS GST
		,CAST((dbo.Get_SSR_Amount_By_SSR_Type (b.riyaPNR,'Baggage',pb.totalFare,pb.paxType,pb.paxFName,paxLName,TicketNumber))
						* (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId) as decimal(18,2)) AS 'Baggage Amount'
		,CAST((dbo.Get_SSR_Amount_By_SSR_Type (b.riyaPNR,'Seat',pb.totalFare,pb.paxType,pb.paxFName,paxLName,TicketNumber))
						* (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId) as decimal(18,2)) AS 'Seat Amount'
		,CAST((dbo.Get_SSR_Amount_By_SSR_Type (b.riyaPNR,'Meals',pb.totalFare,pb.paxType,pb.paxFName,paxLName,TicketNumber))
						* (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId) as decimal(18,2)) AS 'Meals Amount'
		--, CONVERT(DECIMAL(18,2),ISNULL(ssr_baggage.SSR_Amount,0)*b.ROE) AS 'Baggage Amount'
		--, CONVERT(DECIMAL(18,2),ISNULL(ssr_seat.SSR_Amount,0)*b.ROE) AS 'Seat Amount'
		--, CONVERT(DECIMAL(18,2),ISNULL(ssr_meals.SSR_Amount,0)*b.ROE) AS 'Meals Amount'
		, '0.00' AS 'Other SSR Amount'
		,ISNULL(BP.ConvenienFeeInPercent,0) AS 'PG Charges In Percent',
		CONVERT(decimal(18,2),(ISNULL(BP.TotalCommission,0)/ isnull((select count(*) from tblpassengerbookdetails pb where pb.fkBookMaster=b.pkId ),1))) AS 'Payment Gateway Charges'
		--,ISNULL(BP.TotalCommission,0) AS 'Payment Gateway Charges'
		,(ISNULL(pb.VendorServiceFee,0) * b.ROE) AS 'Vendor Service Fee',
		-- -CONVERT(decimal(18,2), (((pb.totalFare * b.ROE) + pb.Markup + pb.BFC + pb.ServiceFee + pb.GST +
		--ISNULL(((dbo.Get_SSR_Amount_By_SSR_Type (b.riyaPNR,'Baggage',pb.totalFare,pb.paxType,pb.paxFName,paxLName,TicketNumber))
		--				* (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId)),0)
		--+ ISNULL(((dbo.Get_SSR_Amount_By_SSR_Type (b.riyaPNR,'Seat',pb.totalFare,pb.paxType,pb.paxFName,paxLName,TicketNumber))
		--				* (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId)),0)
		--+ ISNULL(((dbo.Get_SSR_Amount_By_SSR_Type (b.riyaPNR,'Meals',pb.totalFare,pb.paxType,pb.paxFName,paxLName,TicketNumber))
		--				* (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId)),0) 
		--+ ISNULL(pb.VendorServiceFee,0) * b.ROE
		--+ CONVERT(decimal(18,2),(ISNULL(BP.TotalCommission,0)/ isnull((select count(*) from tblpassengerbookdetails pb where pb.fkBookMaster=b.pkId ),1))) + ISNULL(pb.B2BMarkup,0) - (ISNULL(pb.IATACommission,0)  + ISNULL(pb.PLBCommission,0)
		--+ ISNULL(pb.DropnetCommission,0))) - (ISNULL(pb.CancellationPenalty,0) + ISNULL(pb.CancellationMarkup,0)))
		--	) AS 'Net Amount'
		    CONVERT(decimal(18,2), 
       pb.totalFare - (
            ISNULL(CancellationPenalty, 0)
            + ISNULL(pb.PLBCommission, 0)
            + ISNULL(pb.ServiceFee, 0)
            + ISNULL(pb.GST, 0)
            + ISNULL(pb.GSTonPLB, 0)
            + ISNULL(pb.TDSonPLB, 0)
        )
    ) AS 'Net Amount'
		, '0' AS 'Reschedule Charges'
		, '0' AS 'SC Tax'
		, '' AS 'Mo Number'
		, '' AS 'UATP Status'
		, '0' AS 'SF'
		, '' AS 'Previous Riya PNR'
		, '' AS 'Reschedule Markup'
		, '' AS 'Reschedule Date'
		, '' AS 'Cancellation Date' 
		--added by asmita 
		--,ISNULL( (Select top 1 SSR_Amount FROM tblSSRDetails AS ssr Where ssr.SSR_Type='Meals' AND ssr.fkBookMaster IN (Select pkid From tblBookMaster where GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR) AND ssr.fkPassengerid IN (Select fkPassengerid From tblBookMaster where fkPassengerid=ssr.fkPassengerid)),0) AS 'Meal Amount' 
		-- ,ISNULL( (Select top 1 SSR_Amount FROM tblSSRDetails AS ssr Where ssr.SSR_Type='Baggage' AND ssr.fkBookMaster IN (Select pkid From tblBookMaster where GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR) AND ssr.fkPassengerid IN (Select fkPassengerid From tblBookMaster where fkPassengerid=ssr.fkPassengerid)),0) AS 'Baggage Amount' 
		--,ISNULL( (Select top 1 SSR_Amount FROM tblSSRDetails AS ssr Where ssr.SSR_Type='Seat' AND ssr.fkBookMaster IN (Select pkid From tblBookMaster where GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR) AND ssr.fkPassengerid IN (Select fkPassengerid From tblBookMaster where fkPassengerid=ssr.fkPassengerid)),0) AS 'Seat Amount' 
		, R.CustomerType AS AccountType
		,pb.PanNumber AS 'PanCardno'
		--,(Select top 1 ISNULL(PanCardno,'') from mAttrributesDetails Where fkPassengerid=pb.pid) AS 'PanCardno'
		,ISNULL(pb.PanCardValidation,'') AS 'Pan Card Remarks'
		,pb.passportNum AS 'Passport No'
		,FORMAT(pb.passexp, 'dd-MMM-yyyy') AS 'Passport Expiration Date'
		,pb.passportIssueCountry AS 'Passport Issue Country'
		,pb.nationality AS 'Passenger Nationality'
		,pb.dateOfBirth AS 'DOB'
		,pb.FrequentFlyNo AS 'Frequent Fly No'
		, (Select top 1 ISNULL(ma.OBTCno,'') AS OBTCno from mAttrributesDetails ma Where ma.OrderID=b.orderId AND ISNULL(ma.OBTCno,'')!='') AS 'OBT NO'
		, b.ROE AS ROE
		, b.VendorName as 'CRS'
		, b.OfficeID as 'Ticketing Suppier'
		, (CASE WHEN b.MainAgentId > 0 AND b.BookingSource='Web' THEN 'Internal Booking (Web)'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Retrive PNR' THEN 'Internal Booking (Retrive PNR)'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Retrive PNR - MultiTST' THEN 'Internal Booking Retrive PNR - MultiTST)'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Cryptic' THEN 'Internal Booking (Cryptic)'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Retrive PNR Accounting' THEN 'Internal Booking Accounting(Retrive PNR Accounting)'
				WHEN b.MainAgentId = 0 AND b.BookingSource='Web' THEN 'Agent Booking (Web)'
				WHEN b.MainAgentId = 0 AND b.BookingSource='Retrive PNR' THEN 'Agent Booking (Retrive PNR)' 
				WHEN b.MainAgentId = 0 AND b.BookingSource='Retrive PNR - MultiTST' THEN 'Agent Booking (Retrive PNR - MultiTST)' 
				WHEN b.MainAgentId > 0 AND b.BookingSource='ManualTicketing' THEN 'ManualTicketing'
				WHEN b.MainAgentId = 0 AND b.BookingSource='Cryptic' THEN 'Agent Booking (Cryptic)'
				WHEN b.BookingSource = 'GDS' THEN 'TJQ'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Retrive PNR Accounting-TicketNumber' THEN 'Internal Booking (PNR Accounting)'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Retrieve PNR accounting - MultiTST' THEN 'Internal Booking Retrive PNR accounting - MultiTST'
			END
			) AS 'Booking Mode'
		--, b.TCSTaxAmount AS [TCS TAX Amount]
		--, pb.NameAsOnPAN AS [Name As Per PAN Card]
		--, pb.PanNumber AS [PAN Card Number]
		--, 'E:\\Domains\\B2C New\\CacheLog\\LOGData\\TCSPanData\\' + PANDocuments AS [Undertaking Attachment]
		---END 
		FROM tblBookMaster b WITH(NOLOCK) 
		LEFT JOIN B2BRegistration r WITH(NOLOCK) ON CAST(r.FKUserID AS VARCHAR(50))=b.AgentID 
		INNER JOIN tblPassengerBookDetails pb WITH(NOLOCK) on pb.fkBookMaster=b.pkId 
				AND pb.totalFare>0 
		LEFT JOIN agentLogin al WITH(NOLOCK) ON CAST(al.UserID AS VARCHAR(50))=b.AgentID 
		left join agentlogin al1 on al1.userid=al.ParentAgentID
		left join b2bregistration b2b1 on al.ParentAgentID = b2b1.FKUserID
		INNER JOIN Paymentmaster pm WITH(NOLOCK) ON pm.order_id=b.orderId 
		INNER JOIN AirlineCode_Console ac WITH(NOLOCK) ON ac.AirlineCode=B.airCode 
		INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=b.Country 
		LEFT JOIN B2BMakepaymentCommission BP WITH(NOLOCK) ON BP.FkBookId=b.pkId
		--LEFT JOIN tblSSRDetails ssr_seat WITH(NOLOCK) on pb.pid =ssr_seat.fkPassengerid AND ssr_seat.SSR_Type='Seat'
		--LEFT JOIN tblSSRDetails ssr_baggage WITH(NOLOCK) on pb.pid =ssr_baggage.fkPassengerid AND ssr_baggage.SSR_Type='Baggage'
		--LEFT JOIN tblSSRDetails ssr_meals WITH(NOLOCK) on pb.pid =ssr_meals.fkPassengerid AND ssr_meals.SSR_Type='Meals'
		--LEFT JOIN mAttrributesDetails ma WITH(NOLOCK) on ma.OrderID=b.orderId --dev 
		WHERE ((@FROMDate = '') OR (CONVERT(date,pb.CancelledDate) >= CONVERT(date,@FROMDate))) 
 		AND ((@ToDate = '') OR (CONVERT(date,pb.CancelledDate) <= CONVERT(date, @ToDate))) 
		AND ((@AirlineCategory = '') OR (ac.type = @AirlineCategory)) 
		AND ((@AirlineCode = '') OR (b.airCode = @AirlineCode)) 
		-- AND ((@Country = '') OR (al.BookingCountry = @Country)) 
		AND ((@Country = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@Country, ',')))) 
		AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode)) 
		-- AND ((@AgentType='') OR ( @AgentType='B2C' AND b.AgentID='B2C') OR (al.UserTypeID = (SELECT ID FROM mCommon where Value=@AgentType))) 
		AND ((@AgentType='') OR ( @AgentType='B2C' AND b.AgentID='B2C') OR (al.UserTypeID in (SELECT ID FROM mCommon WITH(NOLOCK) where Value in (SELECT Data FROM sample_split(@AgentType, ','))))) 
		--AND ((@ClassType='') OR (substring(bi.cabin, CHARINDEX('-',bi.cabin)+1, LEN(bi.cabin))= @ClassType)) 
		AND ((@RiyaPNR = '') OR (b.riyaPNR = @RiyaPNR)) 
		AND ((@AgentId = '') OR (b.AgentID =CAST(@AgentId AS varchar(50)))) 
		-- AND ((@AccountType = '') OR ( R.CustomerType = @AccountType)) 
		AND IsBooked=1 AND b.totalFare>0 AND pb.totalFare>0 
		AND ((@BookingStatus='') OR (@BookingStatus='Cancelled'))
	) p 

	SELECT @RecordCount = @@ROWCOUNT
	Print @RecordCount
	IF(@IsPaging=1)
	BEGIN
		SELECT * FROM #tempTableAirlinePNR		
		ORDER BY convert(date,[Ticket Booked Date],105) desc
		OFFSET @Start * @Pagesize ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	END
	ELSE
	BEGIN
		SELECT * FROM #tempTableAirlinePNR
		ORDER BY convert(date,[Ticket Booked Date],105) desc
	END
 END