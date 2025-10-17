
--exec [dbo].[GetAirlinePNRWiseSalesReport] '2023-06-01','2023-06-26','','','IN,US,CA,AE,UK','','B2B,B2C,Holiday,Marine,RBT','','','','' 
CREATE PROCEDURE [dbo].[GetAirlinePNRWiseSalesReport]   
	@FromDate Date=null
	, @ToDate Date=null
	, @AirlineCategory varchar(10)=null
	, @AirlineCode varchar(10)=null
	, @Country varchar(40)=null
	, @BranchCode varchar(40)=null
	, @AgentType varchar(50)=null
	, @ClassType varchar(10)=null
	, @RiyaPNR varchar(50)=null
	, @AgentId int=null
	--@AccountType  varchar(20)=null, 
	, @BookingStatus varchar(20)=null  --Jitendra Nakum 08/09/2022
AS  
BEGIN  
	SELECT  --b.inserteddate AS 'Ticket Booked Date',  
	CASE WHEN coun.CountryCode='IN' THEN (DATEADD(SECOND, 0,CONVERT(varchar(20),b.inserteddate,120)))  
		WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, -9*60*60 -29*60 -16,CONVERT(varchar(20),b.inserteddate,120)))  
		WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, -9*60*60 -29*60 -16,CONVERT(varchar(20),b.inserteddate,120)))
		WHEN coun.CountryCode='GB' THEN (DATEADD(SECOND, -5*60*60 + 30*60,CONVERT(varchar(20),b.inserteddate,120)))
		--WHEN 'UK' THEN (DATEADD(SECOND, - 5*60*60 + 30*60, CONVERT(varchar(20), CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)), 120)))
		WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND,-1*60*60 -29*60 -13,CONVERT(varchar(20),b.inserteddate,120)))  
		END AS 'Ticket Booked Date'
	, AgencyName AS 'Agency Name'
	, r.Icast AS 'Cust ID'
	, ac.type AS 'Airline Category'
	, B.riyaPNR AS 'booking Id'
	, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS 'Airlines PNR'
	, B.GDSPNR AS 'CRS PNR'
	, (CASE WHEN CHARINDEX('/',pb.ticketNum)>0 
			THEN SUBSTRING(SUBSTRING(pb.ticketNum, CHARINDEX(' ', pb.ticketNum)+1,LEN(pb.ticketNum))
			,0,CHARINDEX('/',(SUBSTRING(pb.ticketNum, CHARINDEX(' ', pb.ticketNum)+1,LEN(pb.ticketNum))),0))
			ELSE pb.ticketNum END) AS 'Ticket No'
	, 'Confirmed' AS 'Booking Status'
	, pb.paxType AS 'Pax Type'
	, pb.paxFName AS 'First Name'
	, pb.paxLName AS 'Last Name'
	, (CASE WHEN b.isReturnJourney=0 THEN 'OneWay' ELSE 'RoundTrip' END) AS 'Trip Type'
	, (CASE WHEN b.CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS 'Travel Type'
	, pm.payment_mode AS 'Payment Mode'
	, coun.Currency AS 'Currency'
	, STUFF((SELECT '/' + substring(s.cabin, 1, CASE WHEN CHARINDEX('-', s.cabin ) = 0 THEN CHARINDEX('-', s.cabin)  
			ELSE CHARINDEX('-', s.cabin) -1 END) FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS Class
	, STUFF((SELECT '/' + s.frmSector+'-'+s.toSector+' '+convert (varchar,s.depDate,105) FROM tblBookItenary s WITH(NOLOCK) 
			WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS Sector
	, STUFF((SELECT '/' + s.airName  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Airline Name'
	, STUFF((SELECT '/' + s.airCode  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Airline Code'
	, STUFF((SELECT '/' + s.flightNo  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Flight No'
	, convert (varchar,b.depDate,103) AS 'Date of Travel'
	, CONVERT(decimal(18,2),pb.basicFare*b.ROE) AS 'Basic Fare'  
	, CONVERT(decimal(18,2),pb.YQ*b.ROE) AS 'YQ Fare'
	, CONVERT(decimal(18,2),(pb.totalTax-pb.YQ)*b.ROE) AS 'Other Taxes'
	--,CONVERT(decimal(18,2),pb.FMCommission*b.ROE) AS 'Commission',  
	--CONVERT(decimal(18,2),pb.IATACommission*b.ROE) AS 'IATA',CONVERT(decimal(18,2),pb.PLBCommission*b.ROE) AS 'PLB'
	--,CONVERT(decimal(18,2),pb.DropnetCommission*b.ROE) AS 'DROPNET','0' AS 'TDS Amount'
	--,CONVERT(decimal(18,2),pb.Markup*b.ROE) AS 'Service Charges',  
	, CONVERT(decimal(18,2),pb.FMCommission) AS 'Commission'
	, CONVERT(decimal(18,2),pb.IATACommission) AS 'IATA'
	, CONVERT(decimal(18,2),pb.PLBCommission) AS 'PLB'
	, CONVERT(decimal(18,2),pb.DropnetCommission) AS 'DROPNET'
	, '0' AS 'TDS Amount'
	, CONVERT(decimal(18,2),pb.Markup) AS 'Service Charges'
	, '0' AS 'Agency Markup'
	, '0' AS 'Cancellation Penalty'
	, '0' AS 'Cancellation Markup'
	--CONVERT(DECIMAL(18,2),(ISNULL(Pb.BFC,0)+ISNULL(pb.B2BMarkup,0))*b.ROE) AS 'Markup',
	--CONVERT(DECIMAL(18,2),ISNULL(Pb.ServiceFee,0)*b.ROE) AS 'Service Fee',
	, CONVERT(DECIMAL(18,2),(ISNULL(Pb.BFC,0)+ISNULL(pb.B2BMarkup,0))) AS 'Markup'
	, CONVERT(DECIMAL(18,2),ISNULL(Pb.ServiceFee,0)) AS 'Service Fee'
	, CONVERT(DECIMAL(18,2),ISNULL(pb.GST,0)) AS GST
	, CONVERT(DECIMAL(18,2),ISNULL(ssr_baggage.SSR_Amount,0)*b.ROE) AS 'Baggage Amount'
	, CONVERT(DECIMAL(18,2),ISNULL(ssr_seat.SSR_Amount,0)*b.ROE) AS 'Seat Amount'
	, CONVERT(DECIMAL(18,2),ISNULL(ssr_meals.SSR_Amount,0)*b.ROE) AS 'Meals Amount'
	--,CONVERT(DECIMAL(18,2),ISNULL(CASE SSR_Type WHEN 'Baggage' THEN SSR_Amount END,0)*b.ROE)  AS 'Baggage Amount',  
	--CONVERT(DECIMAL(18,2),ISNULL(CASE SSR_Type WHEN 'Seat' THEN SSR_Amount END,0)*b.ROE) AS 'Seat Amount',  
	--CONVERT(DECIMAL(18,2),ISNULL(CASE SSR_Type WHEN 'Meals' THEN SSR_Amount END,0)*b.ROE) AS 'Meals Amount'  
	, '0.00' AS 'Other SSR Amount'
	, CONVERT(DECIMAL(18,2),((pb.totalFare * b.ROE)+ pb.Markup + pb.BFC + pb.ServiceFee + pb.GST +
		(ISNULL(ssr_baggage.SSR_Amount,0)*b.ROE) + (ISNULL(ssr_seat.SSR_Amount,0)*b.ROE) + (ISNULL(ssr_meals.SSR_Amount,0)*b.ROE) +
		(ISNULL(pb.B2BMarkup,0)) -
		(isnull(pb.IATACommission,0) + isnull(pb.PLBCommission,0) + isnull(pb.DropnetCommission,0)))) AS 'Net Amount'
	--, CONVERT(DECIMAL(18,2),(pb.totalFare + pb.Markup + b.BFC + b.ServiceFee + b.GST +
	----isnull(CASE SSR_Type WHEN 'Baggage' THEN SSR_Amount END,0)+
	----isnull(CASE SSR_Type WHEN 'Seat' THEN SSR_Amount END,0)+
	----isnull(CASE SSR_Type WHEN 'Meals' THEN SSR_Amount END,0)+
	--		ISNULL(ssr_baggage.SSR_Amount,0) + ISNULL(ssr_seat.SSR_Amount,0) + ISNULL(ssr_meals.SSR_Amount,0) +
	--		(ISNULL(Pb.BFC,0)+ISNULL(pb.B2BMarkup,0)) -
	--		(isnull(pb.IATACommission,0) + isnull(pb.PLBCommission,0) + isnull(pb.DropnetCommission,0))) * b.ROE) AS 'Net Amount'
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
	, ma.OBTCNo AS 'OBT NO'
	, b.ROE AS ROE
	, b.VendorName as 'CRS'
	, b.OfficeID as 'Ticketing Suppier'
	, (case when b.MainAgentId > 0 AND b.BookingSource='Web' then 'Internal Booking (Web)'
				when b.MainAgentId > 0 AND b.BookingSource='Retrive PNR' then 'Internal Booking (Retrive PNR)'
				when b.MainAgentId > 0 AND b.BookingSource='Retrive PNR - MultiTST' then 'Internal Booking Retrive PNR - MultiTST)'
				when b.MainAgentId > 0 AND b.BookingSource='Cryptic' then 'Internal Booking (Cryptic)'
				when b.MainAgentId > 0 AND b.BookingSource='Retrive PNR Accounting' then 'Internal Booking Accounting(Retrive PNR Accounting)'
				when b.MainAgentId = 0 AND b.BookingSource='Web' then 'Agent Booking (Web)'
				when b.MainAgentId = 0 AND b.BookingSource='Retrive PNR' then 'Agent Booking (Retrive PNR)' 
				when b.MainAgentId = 0 AND b.BookingSource='Retrive PNR - MultiTST' then 'Agent Booking (Retrive PNR - MultiTST)' 
				when b.MainAgentId > 0 AND b.BookingSource='ManualTicketing' then 'ManualTicketing'
				when b.MainAgentId = 0 AND b.BookingSource='Cryptic' then 'Agent Booking (Cryptic)'
				when  b.BookingSource = 'GDS' then 'TJQ'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Retrive PNR Accounting-TicketNumber' THEN 'Internal Booking (PNR Accounting)'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Retrieve PNR accounting - MultiTST' THEN 'Internal Booking Retrive PNR accounting - MultiTST'
			end
			) as 'Booking Mode'
	FROM tblBookMaster b WITH(NOLOCK)  
	LEFT JOIN B2BRegistration r WITH(NOLOCK) ON CAST(r.FKUserID AS VARCHAR(50))=b.AgentID  
	INNER JOIN tblPassengerBookDetails pb WITH(NOLOCK) ON pb.fkBookMaster=b.pkId  AND pb.totalFare>0  
	LEFT JOIN agentLogin al WITH(NOLOCK) ON cast(al.UserID AS VARCHAR(50))=b.AgentID  
	INNER JOIN Paymentmaster pm WITH(NOLOCK) ON pm.order_id=b.orderId  
	INNER JOIN AirlineCode_Console ac WITH(NOLOCK) ON ac.AirlineCode=B.airCode  
	INNER JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode=b.Country  
	--LEFT JOIN tblSSRDetails ssr ON ssr.fkBookMaster=b.pkId  
	--LEFT JOIN tblSSRDetails ssr ON pb.pid =ssr.fkPassengerid   
	LEFT JOIN tblSSRDetails ssr_seat WITH(NOLOCK) ON pb.pid =ssr_seat.fkPassengerid  AND ssr_seat.SSR_Type='Seat'
	LEFT JOIN tblSSRDetails ssr_baggage WITH(NOLOCK) ON pb.pid =ssr_baggage.fkPassengerid  AND ssr_baggage.SSR_Type='Baggage'
	LEFT JOIN tblSSRDetails ssr_meals WITH(NOLOCK) ON pb.pid =ssr_meals.fkPassengerid  AND ssr_meals.SSR_Type='Meals'
	LEFT JOIN mAttrributesDetails ma WITH(NOLOCK) ON ma.OrderID=b.orderId    
	WHERE ((@FROMDate = '') OR (CONVERT(date,B.inserteddate) >= CONVERT(date,@FROMDate)))  
 	AND ((@ToDate = '') OR (CONVERT(date,B.inserteddate) <= CONVERT(date, @ToDate)))  
	AND ((@AirlineCategory = '') OR (ac.type = @AirlineCategory))  
	AND ((@AirlineCode = '') OR (b.airCode = @AirlineCode))  
	-- AND ((@Country = '') OR (al.BookingCountry = @Country))  
	AND ((@Country = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@Country, ','))))  
	AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))  
	-- AND ((@AgentType='') OR ( @AgentType='B2C' AND b.AgentID='B2C') OR (al.UserTypeID = (SELECT ID FROM mCommon where Value=@AgentType)))  
	AND ((@AgentType='') OR ( @AgentType='B2C' AND b.AgentID='B2C') OR (al.UserTypeID in (SELECT ID FROM mCommon where Value in  (SELECT Data FROM sample_split(@AgentType, ',')))))  
	--AND ((@ClassType='') OR (substring(bi.cabin, CHARINDEX('-',bi.cabin)+1, LEN(bi.cabin))= @ClassType))  
	AND ((@RiyaPNR = '') OR (b.riyaPNR = @RiyaPNR))  
	AND ((@AgentId = '') OR  (b.AgentID =cast(@AgentId AS varchar(50))))  
	--AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))  
	AND IsBooked=1 AND b.totalFare>0 AND pb.totalFare>0  
	AND ((@BookingStatus='') OR (@BookingStatus='Confirmed'))
  
	UNION  
  
	SELECT  
	pb.CancelledDate AS 'Ticket Booked Date'
	, AgencyName AS 'Agen cy Name'
	, r.Icast AS 'Cust ID'
	, ac.type AS 'Airline Category'
	, B.riyaPNR AS 'booking Id'
	, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS 'Airlines PNR'
	, B.GDSPNR AS 'CRS PNR'
	, (CASE WHEN CHARINDEX('/',pb.ticketNum)>0 THEN SUBSTRING(SUBSTRING(pb.ticketNum, CHARINDEX(' ', pb.ticketNum)+1,LEN(pb.ticketNum)),0,CHARINDEX('/',(SUBSTRING(pb.ticketNum, CHARINDEX(' ', pb.ticketNum)+1,LEN(pb.ticketNum))),0)) ELSE pb.ticketNum END) AS 'Ticket No'
	, 'Cancelled' AS 'Booking Status'
	, pb.paxType AS 'Pax Type'
	, pb.paxFName AS 'First Name'
	, pb.paxLName AS 'Last Name'
	, (CASE WHEN b.isReturnJourney=0 THEN 'OneWay' ELSE 'RoundTrip' END) AS 'Trip Type'
	, (CASE WHEN b.CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS 'Travel Type'
	, pm.payment_mode AS 'Payment Mode'
	, coun.Currency AS 'Currency'
	, STUFF((SELECT '/' + substring(s.cabin, 1, CASE WHEN  CHARINDEX('-', s.cabin ) = 0 THEN CHARINDEX('-', s.cabin)  
			ELSE CHARINDEX('-', s.cabin) -1 END) FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS Class
	, STUFF((SELECT '/' + s.frmSector+'-'+s.toSector+' '+convert (varchar,s.depDate,105) FROM tblBookItenary s WITH(NOLOCK) 
			WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS Sector
	, STUFF((SELECT '/' + s.airName  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Airline Name'
	, STUFF((SELECT '/' + s.airCode  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Airline Code'
	, STUFF((SELECT '/' + s.flightNo  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Flight No'
	, convert (varchar,b.depDate,103) AS 'Date of Travel'
	, -CONVERT(decimal(18,2),pb.basicFare*b.ROE) AS 'Basic Fare'  
	, -cast(pb.YQ*b.ROE AS decimal(18,2)) AS 'YQ Fare'
	, -CONVERT(DECIMAL(18,2),(pb.totalTax-pb.YQ)*b.ROE) AS 'Other Taxes'
	--,-CONVERT(DECIMAL(18,2),(pb.FMCommission*b.ROE)) AS 'Commission',  
	---CONVERT(DECIMAL(18,2),pb.IATACommission*b.ROE) AS 'IATA',-CONVERT(DECIMAL(18,2),pb.PLBCommission*b.ROE) AS 'PLB'
	--,-CONVERT(DECIMAL(18,2),pb.DropnetCommission*b.ROE) AS 'DROPNET','0' AS 'TDS Amount'
	--,-CONVERT(DECIMAL(18,2),pb.Markup*b.ROE) AS 'Service Charges',  
	--'0' AS 'Agency Markup',CONVERT(DECIMAL(18,2),pb.CancellationPenalty*b.ROE) AS 'Cancellation Penalty',
	--CONVERT(DECIMAL(18,2),pb.CancellationMarkup*b.ROE) AS 'Cancellation Markup',  
	, -CONVERT(DECIMAL(18,2),(pb.FMCommission)) AS 'Commission'
	, -CONVERT(DECIMAL(18,2),pb.IATACommission) AS 'IATA'
	, -CONVERT(DECIMAL(18,2),pb.PLBCommission) AS 'PLB'
    , -CONVERT(DECIMAL(18,2),pb.DropnetCommission) AS 'DROPNET'
	, '0' AS 'TDS Amount'
	, -CONVERT(DECIMAL(18,2),pb.Markup) AS 'Service Charges'
	, '0' AS 'Agency Markup'
	, CONVERT(DECIMAL(18,2),pb.CancellationPenalty) AS 'Cancellation Penalty'
	, CONVERT(DECIMAL(18,2),pb.CancellationMarkup) AS 'Cancellation Markup'
	--CONVERT(DECIMAL(18,2),(ISNULL(Pb.BFC,0)+ISNULL(pb.B2BMarkup,0))*b.ROE) AS 'Markup',
	--CONVERT(DECIMAL(18,2),ISNULL(Pb.ServiceFee,0)*b.ROE) AS 'Service Fee', 
	, CONVERT(DECIMAL(18,2),(ISNULL(Pb.BFC,0)+ISNULL(pb.B2BMarkup,0))) AS 'Markup'
	, CONVERT(DECIMAL(18,2),ISNULL(Pb.ServiceFee,0)) AS 'Service Fee'
	, CONVERT(DECIMAL(18,2),ISNULL(pb.GST,0)) AS GST
	, CONVERT(DECIMAL(18,2),ISNULL(ssr_baggage.SSR_Amount,0)*b.ROE) AS 'Baggage Amount'
	, CONVERT(DECIMAL(18,2),ISNULL(ssr_seat.SSR_Amount,0)*b.ROE) AS 'Seat Amount'
	, CONVERT(DECIMAL(18,2),ISNULL(ssr_meals.SSR_Amount,0)*b.ROE) AS 'Meals Amount'
	--CONVERT(DECIMAL(18,2),ISNULL(CASE SSR_Type WHEN 'Baggage' THEN SSR_Amount END,0)*b.ROE) AS 'Baggage Amount', 
	--CONVERT(DECIMAL(18,2),ISNULL(CASE SSR_Type WHEN 'Seat' THEN SSR_Amount END,0)*b.ROE) AS 'Seat Amount',  
	--CONVERT(DECIMAL(18,2),ISNULL(CASE SSR_Type WHEN 'Meals' THEN SSR_Amount END,0)*b.ROE) AS 'Meals Amount'
	, '0.00' AS 'Other SSR Amount'
	, -CONVERT(decimal(18,2), (((pb.totalFare * b.ROE) + pb.Markup + pb.BFC + pb.ServiceFee + pb.GST +
		(ISNULL(ssr_baggage.SSR_Amount,0)*b.ROE) + (ISNULL(ssr_seat.SSR_Amount,0)*b.ROE) + (ISNULL(ssr_meals.SSR_Amount,0)*b.ROE) +
		+ ISNULL(pb.B2BMarkup,0) - (ISNULL(pb.IATACommission,0) + ISNULL(pb.PLBCommission,0)
		+ ISNULL(pb.DropnetCommission,0))) - (ISNULL(pb.CancellationPenalty,0) + ISNULL(pb.CancellationMarkup,0)))
		) AS 'Net Amount'
	--, -CONVERT(decimal(18,2), ((pb.totalFare + pb.Markup + b.BFC + b.ServiceFee + b.GST +
	----ISNULL(CASE SSR_Type WHEN 'Baggage' THEN SSR_Amount END,0)+
	----ISNULL(CASE SSR_Type WHEN 'Seat' THEN SSR_Amount END,0)+
	----ISNULL(CASE SSR_Type WHEN 'Meals' THEN SSR_Amount END,0)+
	--	ISNULL(ssr_baggage.SSR_Amount,0) + ISNULL(ssr_seat.SSR_Amount,0) + ISNULL(ssr_meals.SSR_Amount,0) +
	--	+ (ISNULL(Pb.BFC,0) + ISNULL(pb.B2BMarkup,0)) - (ISNULL(pb.IATACommission,0) + ISNULL(pb.PLBCommission,0)
	--	+ ISNULL(pb.DropnetCommission,0))) - (ISNULL(pb.CancellationPenalty,0) + ISNULL(pb.CancellationMarkup,0)))
	--	* b.ROE) AS 'Net Amount'
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
	--   ,ISNULL( (Select top 1 SSR_Amount FROM tblSSRDetails AS ssr Where ssr.SSR_Type='Baggage' AND ssr.fkBookMaster IN (Select pkid From tblBookMaster where GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR) AND ssr.fkPassengerid IN (Select fkPassengerid From tblBookMaster where fkPassengerid=ssr.fkPassengerid)),0) AS 'Baggage Amount'  
	--,ISNULL( (Select top 1 SSR_Amount FROM tblSSRDetails AS ssr Where ssr.SSR_Type='Seat' AND ssr.fkBookMaster IN (Select pkid From tblBookMaster where GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR) AND ssr.fkPassengerid IN (Select fkPassengerid From tblBookMaster where fkPassengerid=ssr.fkPassengerid)),0) AS 'Seat Amount'  
	, R.CustomerType AS AccountType
	, ma.OBTCNo AS 'OBT NO'
	, b.ROE AS ROE
	, b.VendorName as 'CRS'
	, b.OfficeID as 'Ticketing Suppier'
	, (case when b.MainAgentId > 0 AND b.BookingSource='Web' then 'Internal Booking (Web)'
				when b.MainAgentId > 0 AND b.BookingSource='Retrive PNR' then 'Internal Booking (Retrive PNR)'
				when b.MainAgentId > 0 AND b.BookingSource='Retrive PNR - MultiTST' then 'Internal Booking Retrive PNR - MultiTST)'
				when b.MainAgentId > 0 AND b.BookingSource='Cryptic' then 'Internal Booking (Cryptic)'
				when b.MainAgentId > 0 AND b.BookingSource='Retrive PNR Accounting' then 'Internal Booking Accounting(Retrive PNR Accounting)'
				when b.MainAgentId = 0 AND b.BookingSource='Web' then 'Agent Booking (Web)'
				when b.MainAgentId = 0 AND b.BookingSource='Retrive PNR' then 'Agent Booking (Retrive PNR)' 
				when b.MainAgentId = 0 AND b.BookingSource='Retrive PNR - MultiTST' then 'Agent Booking (Retrive PNR - MultiTST)' 
				when b.MainAgentId > 0 AND b.BookingSource='ManualTicketing' then 'ManualTicketing'
				when b.MainAgentId = 0 AND b.BookingSource='Cryptic' then 'Agent Booking (Cryptic)'
				when  b.BookingSource = 'GDS' then 'TJQ'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Retrive PNR Accounting-TicketNumber' THEN 'Internal Booking (PNR Accounting)'
				WHEN b.MainAgentId > 0 AND b.BookingSource='Retrieve PNR accounting - MultiTST' THEN 'Internal Booking Retrive PNR accounting - MultiTST'
			end
			) as 'Booking Mode'
	---END  
	FROM tblBookMaster b WITH(NOLOCK)  
	LEFT JOIN B2BRegistration r WITH(NOLOCK) ON CAST(r.FKUserID AS VARCHAR(50))=b.AgentID  
	INNER JOIN tblPassengerBookDetails pb WITH(NOLOCK) ON pb.fkBookMaster=b.pkId  AND pb.totalFare>0  
	LEFT JOIN agentLogin al WITH(NOLOCK) ON cast(al.UserID AS VARCHAR(50))=b.AgentID  
	INNER JOIN Paymentmaster pm WITH(NOLOCK) ON pm.order_id=b.orderId  
	INNER JOIN AirlineCode_Console ac WITH(NOLOCK) ON ac.AirlineCode=B.airCode  
	INNER JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode=b.Country  
	--LEFT JOIN tblSSRDetails ssr ON pb.pid =ssr.fkPassengerid  
	LEFT JOIN tblSSRDetails ssr_seat WITH(NOLOCK) ON pb.pid =ssr_seat.fkPassengerid  AND ssr_seat.SSR_Type='Seat'
	LEFT JOIN tblSSRDetails ssr_baggage WITH(NOLOCK) ON pb.pid =ssr_baggage.fkPassengerid  AND ssr_baggage.SSR_Type='Baggage'
	LEFT JOIN tblSSRDetails ssr_meals WITH(NOLOCK) ON pb.pid =ssr_meals.fkPassengerid  AND ssr_meals.SSR_Type='Meals'
	LEFT JOIN mAttrributesDetails ma WITH(NOLOCK) ON ma.OrderID=b.orderId --dev 
	WHERE ((@FROMDate = '') OR (CONVERT(date,pb.CancelledDate) >= CONVERT(date,@FROMDate)))  
    AND ((@ToDate = '') OR (CONVERT(date,pb.CancelledDate) <= CONVERT(date, @ToDate)))  
	AND ((@AirlineCategory = '') OR (ac.type = @AirlineCategory))  
	AND ((@AirlineCode = '') OR (b.airCode = @AirlineCode))  
	-- AND ((@Country = '') OR (al.BookingCountry = @Country))  
	AND ((@Country = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@Country, ','))))  
	AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))  
	-- AND ((@AgentType='') OR ( @AgentType='B2C' AND b.AgentID='B2C') OR (al.UserTypeID = (SELECT ID FROM mCommon where Value=@AgentType)))  
	AND ((@AgentType='') OR ( @AgentType='B2C' AND b.AgentID='B2C') OR (al.UserTypeID in (SELECT ID FROM mCommon where Value in  (SELECT Data FROM sample_split(@AgentType, ',')))))  
	--AND ((@ClassType='') OR (substring(bi.cabin, CHARINDEX('-',bi.cabin)+1, LEN(bi.cabin))= @ClassType))  
	AND ((@RiyaPNR = '') OR (b.riyaPNR = @RiyaPNR))  
	AND ((@AgentId = '') OR  (b.AgentID =cast(@AgentId AS varchar(50))))  
	-- AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))  
	AND IsBooked=1 AND b.totalFare>0 AND pb.totalFare>0  
	AND ((@BookingStatus='') OR (@BookingStatus='Cancelled'))
END  

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAirlinePNRWiseSalesReport] TO [rt_read]
    AS [dbo];

