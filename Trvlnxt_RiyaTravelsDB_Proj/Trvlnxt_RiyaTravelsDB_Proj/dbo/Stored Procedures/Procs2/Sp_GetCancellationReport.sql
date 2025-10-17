-- =============================================
-- Author:		Bhavika kawa
-- Description:	To get cancellation report data Sp_GetCancellationReport '28-Jan-2022','20-Jan-2022','','','2,1,4,3,5','','IN,US,CA,AE','','','All','All'
-- =============================================
CREATE PROCEDURE [dbo].[Sp_GetCancellationReport] --Sp_GetCancellationReport '17-Jan-2022','17-Jan-2022','','','2','','AE','',''
	@FromDate Date 
	, @ToDate Date
	, @BranchCode varchar(40)
	, @PaymentType varchar(50)
	, @AgentTypeId varchar(100)
	, @AgentId varchar(100)
	, @Country varchar(50)
	, @AirlineCategory varchar(10)
	, @AirlineCode varchar(10)
	, @AgentType varchar(50)
	, @CountryType varchar(50)
AS
BEGIN
	IF(@CountryType='All' AND @AgentType='All')
	BEGIN
		SELECT 
		-- isnull(B.canceledDate,p.TobecancellationDate) AS [Request Date Time],
		--------------
		--CASE WHEN country.CountryCode='AE' THEN (DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.TobecancellationDate)),120))) -- 1 hour, 29 minutes AND 13 seconds
  -- 				WHEN country.CountryCode='US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.TobecancellationDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
  -- 				WHEN country.CountryCode='CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.TobecancellationDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
  -- 				WHEN country.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),CONVERT(DATETIME, isnull(B.canceledDate,P.TobecancellationDate)),120))   -- 0 hour, 0 minutes AND 0 seconds   
 	--			END AS 'Request Date Time'
----------------------------
CASE 
    WHEN country.CountryCode = 'AE' THEN FORMAT(DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13, ISNULL(b.canceledDate, P.TobecancellationDate)), 'dd-MMM-yyyy')
    WHEN country.CountryCode = 'US' THEN FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, ISNULL(b.canceledDate, P.TobecancellationDate)), 'dd-MMM-yyyy')
    WHEN country.CountryCode = 'CA' THEN FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, ISNULL(b.canceledDate, P.TobecancellationDate)), 'dd-MMM-yyyy')
    WHEN country.CountryCode = 'IN' THEN FORMAT(ISNULL(b.canceledDate, P.TobecancellationDate), 'dd-MMM-yyyy')
END AS [Request Date Time]
		-- isnull(B.canceledDate,p.CancelledDate) AS [Cancellation Date Time],
		--------------------
		--, CASE WHEN country.CountryCode='AE' THEN (DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 -13,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.CancelledDate)),120))) -- 1 hour, 29 minutes AND 13 seconds
  -- 				WHEN country.CountryCode='US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.CancelledDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
  -- 				WHEN country.CountryCode='CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.CancelledDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
  -- 				WHEN country.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),CONVERT(DATETIME, isnull(B.canceledDate,P.CancelledDate)),120))   -- 0 hour, 0 minutes AND 0 seconds   
 	--			END AS 'Cancellation Date Time'
---------------------------------
, CASE 
    WHEN country.CountryCode = 'AE' THEN 
        FORMAT(DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13, ISNULL(b.canceledDate, P.CancelledDate)), 'dd-MMM-yyyy')
    WHEN country.CountryCode = 'US' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, ISNULL(b.canceledDate, P.CancelledDate)), 'dd-MMM-yyyy')
    WHEN country.CountryCode = 'CA' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, ISNULL(b.canceledDate, P.CancelledDate)), 'dd-MMM-yyyy')
    WHEN country.CountryCode = 'IN' THEN 
        FORMAT(ISNULL(b.canceledDate, P.CancelledDate), 'dd-MMM-yyyy')
END AS [Cancellation Date Time]
		, ISNULL(R.AgencyName,'B2CINDIA') AS [Agency Name]
		, ISNULL(R.Icast,'ICUST35086') AS 'Agent ID'
		, (CASE B.CounterCloseTime WHEN 1 THEN 'Domestic' ELSE 'International' END) AS [Airline Type]
		, B.airName AS [Airline Name]
		, CASE WHEN B.VendorName ='Amadeus' AND B.airCode='FZ' THEN 'FSC' ELSE A.type END AS [Airline Category]
		, B.riyaPNR AS [Riya PNR]
		, (SELECT top 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS [Airline PNR]
		, (SELECT top 1 farebasis FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS  [Fare Basis]
		, B.GDSPNR  AS [CRS PNR]
		, P.TicketNumber AS [Ticket No]
		, B.IATA AS [IATA No]
		, 'FullyCancelled' AS [Booking Type]
		, P.paxType AS [Pax Type]
		, P.paxFName AS [First name]
		, P.paxLName AS [Last Name]
		, (B.frmSector + '-'  + B.toSector + ' ' + Convert(varchar,B.depDate,103)) AS [Sector]
		, B.flightNo AS [Flight Number]
		, (SELECT (CASE WHEN COUNT(orderId)=1 THEN 'OneWay' ELSE 'RoundTrip' END) AS TRIPTYPE FROM tblBookMaster WITH(NOLOCK)
				WHERE orderId=B.orderId GROUP BY orderId) AS [Trip Type]
		, (CASE WHEN PM.payment_mode='Check' THEN 'Check' WHEN PM.payment_mode='Self Balance' THEN 'Self Balance' 
				WHEN  PM.payment_mode='passthrough' THEN 'PassThrough' ELSE 'Payment Gateway' END ) AS [Payment Mode]
		, p.basicFare AS [Basic Fare]
		, p.YQ AS [YQ]
		, p.totalTax AS [Tax Amount]
		, (P.IATACommission + P.PLBCommission) AS [Commission]
		, ISNULL(PN.ServiceFee,0) AS [Service Fee]
		, 0 AS [TDS Amount]
		, 0 AS [Incentive]
		--commented by asmi pm.mer_amount AS [Total Amount], 
		, p.totalFare AS [Total Amount]
		, ISNULL(C.Panelty,P.CancellationPenalty) AS [Penalty]
		, ISNULL(C.Markup,P.CancellationMarkup) AS [Cancellation Markup]
		, ISNULL(C.Remark,P.RemarkCancellation) AS [Remarks]
		, ISNULL((U.UserName + '-' + U.FullName),(AL.UserName + '-' +ISNULL(AL.FirstName,'') 
				+ ' ' + ISNULL(AL.LastName,''))) [Cancelled By]
		, B.airCode AS [Supplier Name]
		, (CASE WHEN (B.BookingStatus=11 AND P.BookingStatus=11) THEN 'Online Cancellation' WHEN 
				(B.BookingStatus=6 AND P.BookingStatus=6 OR B.BookingStatus=4 AND P.BookingStatus=4) 
				THEN 'Offline Cancellation' ELSE '' END ) AS Status
		--,AL.BookingCountry,AL.UserTypeID
		FROM tblBookMaster B WITH(NOLOCK)
		INNER JOIN tblPassengerBookDetails P WITH(NOLOCK) on p.fkBookMaster=b.pkId
		LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID
		INNER JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode=B.airCode
		INNER JOIN Paymentmaster PM WITH(NOLOCK) ON PM.order_id=B.orderId
		LEFT JOIN CancellationHistory C WITH(NOLOCK) ON C.OrderId=B.orderId AND C.FlagType=1 AND C.paxfname=P.paxFName
		LEFT JOIN mUser U WITH(NOLOCK) ON U.ID=P.CancelByBackendUser1
		LEFT JOIN agentLogin AL WITH(NOLOCK) ON AL.UserID=P.CancelByAgency1
		LEFT JOIN PNRRetriveDetails PN WITH(NOLOCK) ON PN.OrderID=B.orderId
		INNER JOIN mCountry country WITH(NOLOCK) on b.Country=country.CountryCode
		WHERE IsBooked=1 AND b.totalFare>0 AND P.BookingStatus IN (4,6,11) AND
	 	-- ((canceledDate is not null AND b.AgentID='B2C' ) OR ((p.BookingStatus=4 OR B.BookingStatus=11) AND b.AgentID!='B2C' ))AND
		((@FROMDate = '') OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) >= CONVERT(date,@FROMDate)) OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) >= CONVERT(date,@FROMDate)))
 		AND ((@ToDate = '') OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) <= CONVERT(date, @ToDate)) OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) <= CONVERT(date, @ToDate)))
		--((@FROMDate = '') OR (CONVERT(date,(B.canceledDate)) >= CONVERT(date,@FROMDate)) )
		-- 		 AND ((@ToDate = '') OR (CONVERT(date,(B.canceledDate)) <= CONVERT(date, @ToDate)))
 		AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode) OR (@BranchCode='BOMRC' AND R.LocationCode IS NULL))
		-- AND ((@AgentTypeId = '') OR ( AL.UserTypeID = @AgentTypeId) OR (@AgentTypeId=1 AND AL.userTypeID IS NULL))
		AND ((@AgentTypeId != '') OR  (AL.UserTypeID IN (SELECT cast(Data as int) FROM sample_split(@AgentTypeId, ','))) OR (@AgentTypeId='1' AND AL.userTypeID IS NULL))
 		AND ((@AgentId = '') OR  (b.AgentID =cast(@AgentId as varchar(50))))
	 --AND ((@Country = '') OR (al.BookingCountry = @Country) OR (@Country='IN' AND AL.BookingCountry IS NULL))
		AND ((@Country != '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))) OR (@Country='IN' AND AL.BookingCountry IS NULL))
		--asmi
		-- AND (@Country != '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))) 
		-- AND (@Country = '') OR (@Country='IN' AND AL.BookingCountry IS NULL)
		--END 
		AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))
		AND ((@AirlineCode = '') OR (B.airCode = @AirlineCode))
		-- AND ((@PaymentType='') OR (LOWER(@PaymentType)='payment gateway' ))
		AND ((@PaymentType='') OR (LOWER(@PaymentType)='payment gateway' AND PM.payment_mode NOT IN ('Credit','PassThrough','Hold','Check')) OR (PM.payment_mode=@PaymentType))
		ORDER BY B.inserteddate Desc
	END
	ELSE IF(@CountryType='All' AND @AgentType!='All')
	BEGIN
		SELECT 
		-- isnull(B.canceledDate,p.TobecancellationDate) AS [Request Date Time],
		CASE WHEN country.CountryCode='AE' THEN (DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 -13,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.TobecancellationDate)),120))) -- 1 hour, 29 minutes AND 13 seconds
   				WHEN country.CountryCode='US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.TobecancellationDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
   				WHEN country.CountryCode='CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.TobecancellationDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
   				WHEN country.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),CONVERT(DATETIME, isnull(B.canceledDate,P.TobecancellationDate)),120))   -- 0 hour, 0 minutes AND 0 seconds   
 				END AS 'Request Date Time'
		-- isnull(B.canceledDate,p.CancelledDate) AS [Cancellation Date Time],
		, CASE WHEN  country.CountryCode='AE' THEN (DATEADD(SECOND, -1 * 60 * 60 -29 * 60 -13,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.CancelledDate)),120))) -- 1 hour, 29 minutes AND 13 seconds
   				WHEN   country.CountryCode='US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.CancelledDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
   				WHEN  country.CountryCode='CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.CancelledDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
   				WHEN   country.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),CONVERT(DATETIME, isnull(B.canceledDate,P.CancelledDate)),120))   -- 0 hour, 0 minutes AND 0 seconds   
 				END   AS 'Cancellation Date Time'
		, ISNULL(R.AgencyName,'B2CINDIA') AS [Agency Name]
		, ISNULL(R.Icast,'ICUST35086') AS 'Agent ID'
		, (CASE B.CounterCloseTime WHEN 1 THEN 'Domestic' ELSE 'International' END) AS [Airline Type]
		, B.airName AS [Airline Name]
		, CASE WHEN B.VendorName ='Amadeus' AND B.airCode='FZ' THEN 'FSC' ELSE A.type END AS [Airline Category]
		, B.riyaPNR AS [Riya PNR]
		, (SELECT top 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS [Airline PNR]
		, (SELECT top 1 farebasis FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS [Fare Basis]
		, B.GDSPNR  AS [CRS PNR]
		, P.TicketNumber AS [Ticket No]
		, B.IATA AS [IATA No]
		, 'FullyCancelled' AS [Booking Type]
		, P.paxType AS [Pax Type]
		, P.paxFName AS [First name]
		, P.paxLName AS [Last Name]
		, (B.frmSector + '-'  + B.toSector + ' ' + Convert(varchar,B.depDate,103)) AS [Sector]
		, B.flightNo AS [Flight Number]
		, (SELECT (CASE WHEN COUNT(orderId)=1 THEN 'OneWay' ELSE 'RoundTrip' END) AS TRIPTYPE FROM tblBookMaster WITH(NOLOCK)
				WHERE orderId=B.orderId GROUP BY orderId) AS [Trip Type]
		, (CASE WHEN PM.payment_mode='Check' THEN 'Check' WHEN PM.payment_mode='Self Balance' 
				THEN 'Self Balance' WHEN  PM.payment_mode='passthrough' THEN 'PassThrough'
				ELSE 'Payment Gateway' END ) AS [Payment Mode]
		, p.basicFare AS [Basic Fare]
		, p.YQ AS [YQ]
		, p.totalTax AS [Tax Amount]
		, (P.IATACommission + P.PLBCommission) AS [Commission]
		, ISNULL(PN.ServiceFee,0) AS [Service Fee]
		, 0 AS [TDS Amount]
		, 0 AS [Incentive]
		, p.totalFare AS [Total Amount]
		, ISNULL(C.Panelty,P.CancellationPenalty) AS [Penalty]
		, ISNULL(C.Markup,P.CancellationMarkup) AS [Cancellation Markup]
		, ISNULL(C.Remark,P.RemarkCancellation) AS [Remarks]
		, ISNULL((U.UserName + '-' + U.FullName),(AL.UserName + '-' +ISNULL(AL.FirstName,'') + ' ' + 
				ISNULL(AL.LastName,''))) [Cancelled By]
		, B.airCode AS [Supplier Name]
		, (CASE WHEN (B.BookingStatus=11 AND P.BookingStatus=11) THEN 'Online Cancellation' 
				WHEN (B.BookingStatus=6 AND P.BookingStatus=6 OR B.BookingStatus=4 AND P.BookingStatus=4)
				THEN 'Offline Cancellation' ELSE '' END ) AS Status
		--,AL.BookingCountry,AL.UserTypeID
		FROM tblBookMaster B WITH(NOLOCK)
		INNER JOIN tblPassengerBookDetails P WITH(NOLOCK) on p.fkBookMaster=b.pkId 
		LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID
		INNER JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode=B.airCode
		INNER JOIN Paymentmaster PM WITH(NOLOCK) ON PM.order_id=B.orderId
		LEFT JOIN CancellationHistory C WITH(NOLOCK) ON C.OrderId=B.orderId AND C.FlagType=1 AND C.paxfname=P.paxFName
		LEFT JOIN mUser U WITH(NOLOCK) ON U.ID=P.CancelByBackendUser1
		LEFT JOIN agentLogin AL WITH(NOLOCK) ON AL.UserID=P.CancelByAgency1
		LEFT JOIN PNRRetriveDetails PN WITH(NOLOCK) ON PN.OrderID=B.orderId
		INNER JOIN mCountry country WITH(NOLOCK) ON b.Country=country.CountryCode
		WHERE IsBooked=1 AND b.totalFare>0 AND P.BookingStatus IN(4,6,11) AND
	 	-- ((canceledDate is not null AND b.AgentID='B2C' ) OR ((p.BookingStatus=4 OR B.BookingStatus=11) AND b.AgentID!='B2C' ))AND
		((@FROMDate = '') OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) >= CONVERT(date,@FROMDate)) OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) >= CONVERT(date,@FROMDate)))
 		AND ((@ToDate = '') OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) <= CONVERT(date, @ToDate)) OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) <= CONVERT(date, @ToDate)))
		--((@FROMDate = '') OR (CONVERT(date,(B.canceledDate)) >= CONVERT(date,@FROMDate)) )
		-- 		 AND ((@ToDate = '') OR (CONVERT(date,(B.canceledDate)) <= CONVERT(date, @ToDate)))
 		AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode) OR (@BranchCode='BOMRC' AND R.LocationCode IS NULL))
		-- AND ((@AgentTypeId = '') OR ( AL.UserTypeID = @AgentTypeId) OR (@AgentTypeId=1 AND AL.userTypeID IS NULL))
		AND ((@AgentTypeId = '') OR  (AL.UserTypeID IN (SELECT cast(Data as int) FROM sample_split(@AgentTypeId, ','))) OR (@AgentTypeId='1' AND AL.userTypeID IS NULL))
 		AND ((@AgentId = '') OR  (b.AgentID =cast(@AgentId as varchar(50))))
		--AND ((@Country = '') OR (al.BookingCountry = @Country) OR (@Country='IN' AND AL.BookingCountry IS NULL))
		AND ((@Country != '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))) OR (@Country='IN' AND AL.BookingCountry IS NULL))
		--asmi
		-- AND (@Country != '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))) 
		-- AND (@Country = '') OR (@Country='IN' AND AL.BookingCountry IS NULL)
		 --END 
		AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))
		AND ((@AirlineCode = '') OR (B.airCode = @AirlineCode))
		-- AND ((@PaymentType='') OR (LOWER(@PaymentType)='payment gateway' ))
		AND ((@PaymentType='') OR (LOWER(@PaymentType)='payment gateway' AND PM.payment_mode NOT IN ('Credit','PassThrough','Hold','Check')) OR (PM.payment_mode=@PaymentType))
		ORDER BY B.inserteddate Desc
	END
	ELSE IF(@CountryType!='All' AND @AgentType='All')
	BEGIN
		SELECT 
		-- isnull(B.canceledDate,p.TobecancellationDate) AS [Request Date Time],
		CASE WHEN  country.CountryCode='AE' THEN (DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 -13,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.TobecancellationDate)),120))) -- 1 hour, 29 minutes AND 13 seconds
   				WHEN   country.CountryCode='US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.TobecancellationDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
   				WHEN  country.CountryCode='CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.TobecancellationDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
   				WHEN   country.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),CONVERT(DATETIME, isnull(B.canceledDate,P.TobecancellationDate)),120))   -- 0 hour, 0 minutes AND 0 seconds   
 				END AS 'Request Date Time'
		-- isnull(B.canceledDate,p.CancelledDate) AS [Cancellation Date Time],
		, CASE WHEN country.CountryCode='AE' THEN (DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 -13,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.CancelledDate)),120))) -- 1 hour, 29 minutes AND 13 seconds
   				WHEN country.CountryCode='US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.CancelledDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
   				WHEN country.CountryCode='CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.CancelledDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
   				WHEN country.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),CONVERT(DATETIME, isnull(B.canceledDate,P.CancelledDate)),120))   -- 0 hour, 0 minutes AND 0 seconds   
 				END AS 'Cancellation Date Time'
		, ISNULL(R.AgencyName,'B2CINDIA') AS [Agency Name]
		, ISNULL(R.Icast,'ICUST35086') AS 'Agent ID'
		, (CASE B.CounterCloseTime WHEN 1 THEN 'Domestic' ELSE 'International' END) AS [Airline Type]
		, B.airName AS [Airline Name]
		, CASE WHEN B.VendorName ='Amadeus' AND B.airCode='FZ' THEN 'FSC' ELSE A.type END AS [Airline Category]
		, B.riyaPNR AS [Riya PNR]
		, (SELECT top 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS [Airline PNR]
		, (SELECT top 1 farebasis FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS  [Fare Basis]
		, B.GDSPNR  AS [CRS PNR]
		, P.TicketNumber AS [Ticket No]
		, B.IATA AS [IATA No]
		, 'FullyCancelled' AS [Booking Type]
		, P.paxType AS [Pax Type]
		, P.paxFName AS [First name]
		, P.paxLName AS [Last Name]
		, (B.frmSector + '-'  + B.toSector + ' ' + Convert(varchar,B.depDate,103)) AS [Sector]
		, B.flightNo AS [Flight Number]
		, (SELECT (CASE WHEN COUNT(orderId)=1 THEN 'OneWay' ELSE 'RoundTrip' END) AS TRIPTYPE 
				FROM tblBookMaster WITH(NOLOCK) WHERE orderId=B.orderId GROUP BY orderId) AS [Trip Type]
		, (CASE WHEN PM.payment_mode='Check' THEN 'Check' WHEN PM.payment_mode='Self Balance'
				THEN 'Self Balance' WHEN  PM.payment_mode='passthrough' THEN 'PassThrough'
				ELSE 'Payment Gateway' END ) AS [Payment Mode]
		, p.basicFare AS [Basic Fare]
		, p.YQ AS [YQ]
		, p.totalTax AS [Tax Amount]
		, (P.IATACommission + P.PLBCommission) AS [Commission]
		, ISNULL(PN.ServiceFee,0) AS [Service Fee]
		, 0 AS [TDS Amount]
		, 0 AS [Incentive]
		, p.totalFare AS [Total Amount]
		, ISNULL(C.Panelty,P.CancellationPenalty) AS [Penalty]
		, ISNULL(C.Markup,P.CancellationMarkup) AS [Cancellation Markup]
		, ISNULL(C.Remark,P.RemarkCancellation) AS [Remarks]
		, ISNULL((U.UserName + '-' + U.FullName),(AL.UserName + '-' +ISNULL(AL.FirstName,'') + ' ' +
				ISNULL(AL.LastName,''))) [Cancelled By]
		, B.airCode AS [Supplier Name]
		, (CASE WHEN (B.BookingStatus=11 AND P.BookingStatus=11) THEN 'Online Cancellation'
				WHEN (B.BookingStatus=6 AND P.BookingStatus=6 OR B.BookingStatus=4 AND P.BookingStatus=4)
				THEN 'Offline Cancellation' ELSE '' END ) AS Status
		--,AL.BookingCountry,AL.UserTypeID
		FROM tblBookMaster B WITH(NOLOCK)
		INNER JOIN tblPassengerBookDetails P WITH(NOLOCK) on p.fkBookMaster=b.pkId
		LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID
		INNER JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode=B.airCode
		INNER JOIN Paymentmaster PM WITH(NOLOCK) ON PM.order_id=B.orderId
		LEFT JOIN CancellationHistory C WITH(NOLOCK) ON C.OrderId=B.orderId AND C.FlagType=1 AND C.paxfname=P.paxFName
		LEFT JOIN mUser U WITH(NOLOCK) ON U.ID=P.CancelByBackendUser1
		LEFT JOIN agentLogin AL WITH(NOLOCK) ON AL.UserID=P.CancelByAgency1
		LEFT JOIN PNRRetriveDetails PN WITH(NOLOCK) ON PN.OrderID=B.orderId
		INNER JOIN mCountry country WITH(NOLOCK) ON b.Country=country.CountryCode
		WHERE IsBooked=1 AND b.totalFare>0 AND P.BookingStatus IN(4,6,11) AND
	 	-- ((canceledDate is not null AND b.AgentID='B2C' ) OR ((p.BookingStatus=4 OR B.BookingStatus=11) AND b.AgentID!='B2C' ))AND
		((@FROMDate = '') OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) >= CONVERT(date,@FROMDate)) OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) >= CONVERT(date,@FROMDate)))
 		AND ((@ToDate = '') OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) <= CONVERT(date, @ToDate)) OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) <= CONVERT(date, @ToDate)))
		--((@FROMDate = '') OR (CONVERT(date,(B.canceledDate)) >= CONVERT(date,@FROMDate)) )
		-- 		 AND ((@ToDate = '') OR (CONVERT(date,(B.canceledDate)) <= CONVERT(date, @ToDate)))
 		AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode) OR (@BranchCode='BOMRC' AND R.LocationCode IS NULL))
		-- AND ((@AgentTypeId = '') OR ( AL.UserTypeID = @AgentTypeId) OR (@AgentTypeId=1 AND AL.userTypeID IS NULL))
		AND ((@AgentTypeId != '') OR  (AL.UserTypeID IN (SELECT cast(Data as int) FROM sample_split(@AgentTypeId, ','))) OR (@AgentTypeId='1' AND AL.userTypeID IS NULL))
 		AND ((@AgentId = '') OR  (b.AgentID =cast(@AgentId as varchar(50))))
		--AND ((@Country = '') OR (al.BookingCountry = @Country) OR (@Country='IN' AND AL.BookingCountry IS NULL))
		AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))) OR (@Country='IN' AND AL.BookingCountry IS NULL))
		--asmi
		-- AND (@Country != '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))) 
		-- AND (@Country = '') OR (@Country='IN' AND AL.BookingCountry IS NULL)
		--END 
		AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))
		AND ((@AirlineCode = '') OR (B.airCode = @AirlineCode))
		-- AND ((@PaymentType='') OR (LOWER(@PaymentType)='payment gateway' ))
		AND ((@PaymentType='') OR (LOWER(@PaymentType)='payment gateway' AND PM.payment_mode NOT IN ('Credit','PassThrough','Hold','Check')) OR (PM.payment_mode=@PaymentType))
		ORDER BY B.inserteddate Desc
	END
	ELSE IF(@CountryType!='All' AND @AgentType!='All')
	BEGIN
		SELECT 
		-- isnull(B.canceledDate,p.TobecancellationDate) AS [Request Date Time],
		CASE WHEN country.CountryCode='AE' THEN (DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 -13,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.TobecancellationDate)),120))) -- 1 hour, 29 minutes AND 13 seconds
   				WHEN country.CountryCode='US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.TobecancellationDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
   				WHEN country.CountryCode='CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.TobecancellationDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
   				WHEN country.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),CONVERT(DATETIME, isnull(B.canceledDate,P.TobecancellationDate)),120))   -- 0 hour, 0 minutes AND 0 seconds   
 				END AS 'Request Date Time',
		-- isnull(B.canceledDate,p.CancelledDate) AS [Cancellation Date Time],
		CASE WHEN country.CountryCode='AE' THEN (DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 -13,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.CancelledDate)),120))) -- 1 hour, 29 minutes AND 13 seconds
   				WHEN country.CountryCode='US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.CancelledDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
   				WHEN country.CountryCode='CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.canceledDate,P.CancelledDate)),120))) -- 9 hour, 29 minutes AND 16 seconds
   				WHEN country.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),CONVERT(DATETIME, isnull(B.canceledDate,P.CancelledDate)),120))   -- 0 hour, 0 minutes AND 0 seconds   
 				END AS 'Cancellation Date Time'
		, ISNULL(R.AgencyName,'B2CINDIA') AS [Agency Name]
		, ISNULL(R.Icast,'ICUST35086') AS 'Agent ID'
		, (CASE B.CounterCloseTime WHEN 1 THEN 'Domestic' ELSE 'International' END) AS [Airline Type]
		, B.airName AS [Airline Name]
		, CASE WHEN B.VendorName ='Amadeus' AND B.airCode='FZ' THEN 'FSC'
				ELSE A.type END AS [Airline Category]
		,B.riyaPNR AS [Riya PNR]
		, (SELECT top 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS [Airline PNR]
		, (SELECT top 1 farebasis FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS [Fare Basis]
		, B.GDSPNR  AS [CRS PNR]
		, P.TicketNumber AS [Ticket No]
		, B.IATA AS [IATA No]
		, 'FullyCancelled' AS [Booking Type]
		, P.paxType AS [Pax Type]
		, P.paxFName AS [First name]
		, P.paxLName AS [Last Name]
		, (B.frmSector + '-'  + B.toSector + ' ' + Convert(varchar,B.depDate,103)) AS [Sector]
		, B.flightNo AS [Flight Number]
		, (SELECT (CASE WHEN COUNT(orderId)=1 THEN 'OneWay' ELSE 'RoundTrip' END) AS TRIPTYPE FROM tblBookMaster WITH(NOLOCK)
				WHERE orderId=B.orderId GROUP BY orderId) AS [Trip Type]
		, (CASE WHEN PM.payment_mode='Check' THEN 'Check' WHEN PM.payment_mode='Self Balance' 
				THEN 'Self Balance' WHEN  PM.payment_mode='passthrough' THEN 'PassThrough' 
				ELSE 'Payment Gateway' END ) AS [Payment Mode]
		, p.basicFare AS [Basic Fare]
		, p.YQ AS [YQ]
		, p.totalTax AS [Tax Amount]
		, (P.IATACommission + P.PLBCommission) AS [Commission]
		, ISNULL(PN.ServiceFee,0) AS [Service Fee]
		, 0 AS [TDS Amount]
		, 0 AS [Incentive]
		, p.totalFare AS [Total Amount]
		, ISNULL(C.Panelty,P.CancellationPenalty) AS [Penalty]
		, ISNULL(C.Markup,P.CancellationMarkup) AS [Cancellation Markup]
		, ISNULL(C.Remark,P.RemarkCancellation) AS [Remarks]
		, ISNULL((U.UserName + '-' + U.FullName),(AL.UserName + '-' +ISNULL(AL.FirstName,'') + ' ' +
				ISNULL(AL.LastName,''))) [Cancelled By]
		, B.airCode AS [Supplier Name]
		, (CASE WHEN (B.BookingStatus=11 AND P.BookingStatus=11) THEN 'Online Cancellation' 
				WHEN (B.BookingStatus=6 AND P.BookingStatus=6 OR B.BookingStatus=4 AND P.BookingStatus=4)
				THEN 'Offline Cancellation' ELSE '' END ) AS Status
		--,AL.BookingCountry,AL.UserTypeID
		FROM tblBookMaster B WITH(NOLOCK)
		INNER JOIN tblPassengerBookDetails P WITH(NOLOCK) on p.fkBookMaster=b.pkId 
		LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID
		INNER JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode=B.airCode
		INNER JOIN Paymentmaster PM WITH(NOLOCK) ON PM.order_id=B.orderId
		LEFT JOIN CancellationHistory C WITH(NOLOCK) ON C.OrderId=B.orderId AND C.FlagType=1 AND C.paxfname=P.paxFName
		LEFT JOIN mUser U WITH(NOLOCK) ON U.ID=P.CancelByBackendUser1
		LEFT JOIN agentLogin AL WITH(NOLOCK) ON AL.UserID=P.CancelByAgency1
		LEFT JOIN PNRRetriveDetails PN WITH(NOLOCK) ON PN.OrderID=B.orderId
		INNER JOIN mCountry country WITH(NOLOCK) on b.Country=country.CountryCode
		WHERE IsBooked=1 AND b.totalFare>0 AND P.BookingStatus IN(4,6,11) AND
	 	-- ((canceledDate is not null AND b.AgentID='B2C' ) OR ((p.BookingStatus=4 OR B.BookingStatus=11) AND b.AgentID!='B2C' ))AND
		((@FROMDate = '') OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) >= CONVERT(date,@FROMDate)) OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) >= CONVERT(date,@FROMDate)))
 		AND ((@ToDate = '') OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) <= CONVERT(date, @ToDate)) OR (CONVERT(date,isnull(B.canceledDate,p.TobecancellationDate)) <= CONVERT(date, @ToDate)))
		--((@FROMDate = '') OR (CONVERT(date,(B.canceledDate)) >= CONVERT(date,@FROMDate)) )
		-- 		 AND ((@ToDate = '') OR (CONVERT(date,(B.canceledDate)) <= CONVERT(date, @ToDate)))
 		AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode) OR (@BranchCode='BOMRC' AND R.LocationCode IS NULL))
		-- AND ((@AgentTypeId = '') OR ( AL.UserTypeID = @AgentTypeId) OR (@AgentTypeId=1 AND AL.userTypeID IS NULL))
		AND ((@AgentTypeId = '') OR  (AL.UserTypeID IN (SELECT cast(Data as int) FROM sample_split(@AgentTypeId, ','))) OR (@AgentTypeId='1' AND AL.userTypeID IS NULL))
 		AND ((@AgentId = '') OR  (b.AgentID =cast(@AgentId as varchar(50))))
		--AND ((@Country = '') OR (al.BookingCountry = @Country) OR (@Country='IN' AND AL.BookingCountry IS NULL))
		AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))) OR (@Country='IN' AND AL.BookingCountry IS NULL))
		--asmi
		-- AND (@Country != '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))) 
		-- AND (@Country = '') OR (@Country='IN' AND AL.BookingCountry IS NULL)
		--END 
		AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))
		AND ((@AirlineCode = '') OR (B.airCode = @AirlineCode))
		-- AND ((@PaymentType='') OR (LOWER(@PaymentType)='payment gateway' ))
		AND ((@PaymentType='') OR (LOWER(@PaymentType)='payment gateway' AND PM.payment_mode NOT IN ('Credit','PassThrough','Hold','Check')) OR (PM.payment_mode=@PaymentType))
		ORDER BY B.inserteddate DESC
	END
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetCancellationReport] TO [rt_read]
    AS [dbo];

