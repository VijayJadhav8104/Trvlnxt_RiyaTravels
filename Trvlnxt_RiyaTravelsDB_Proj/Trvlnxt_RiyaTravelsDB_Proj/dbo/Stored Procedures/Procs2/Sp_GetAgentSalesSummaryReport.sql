
CREATE PROCEDURE [dbo].[Sp_GetAgentSalesSummaryReport] --[Sp_GetAgentSalesSummaryReport] '22-apr-2021','22-apr-2021','','','','','','',''
	@FromDate Date=null
	, @ToDate Date=null
	, @BranchCode varchar(40)=null
	, @PaymentType varchar(50)=null
	, @BookingType varchar(50)=null
	, @UserType varchar(100)=null
	, @AgentId int=null
	, @Country varchar(10)=null
	, @ProductType varchar(20)
AS
BEGIN
	IF(@BookingType='Booking')
	BEGIN
		SELECT --b.inserteddate AS 'Transaction Date',
		--CASE WHEN coun.CountryCode='IN' THEN (DATEADD(SECOND, 0,CONVERT(varchar(20),b.inserteddate,120)))
		--		WHEN coun.CountryCode='US' THEN (DATEADD(SECOND,-9*60*60 -29*60 -16,CONVERT(varchar(20),b.inserteddate,120)))
		--		WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND,-9*60*60 -29*60 -16,CONVERT(varchar(20),b.inserteddate,120)))
		--		WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),b.inserteddate,120)))
		--		end AS 'Transaction Date'
		CASE 
    WHEN coun.CountryCode = 'IN' THEN 
        FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, b.inserteddate)), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'US' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, b.inserteddate)), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'CA' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, b.inserteddate)), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'AE' THEN 
        FORMAT(DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13, CONVERT(DATETIME, b.inserteddate)), 'dd-MMM-yyyy')
END AS 'Transaction Date'
		, ISNULL(r.Icast,r1.icast) AS 'Cust ID'
		, 'Airline' AS'Product Type'
		, 'Booking' AS 'Booking Status'
		, B.riyaPNR AS 'Riya PNR'
		, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS 'Airlines PNR'
		, B.GDSPNR AS 'CRS PNR'
		, (CASE WHEN CHARINDEX('/',ticketNum) > 0 THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX('-', ticketNum) + 1,
				LEN(ticketNum)),0,CHARINDEX('/',(SUBSTRING(ticketNum, CHARINDEX('-',ticketNum) + 1,
				LEN(ticketNum))),0)) ELSE ticketNum END ) AS 'Ticket No'
		, STUFF((SELECT '/' + s.airCode  FROM tblBookMaster s WITH(NOLOCK) WHERE s.orderId = b.orderId 
				FOR XML PATH('')),1,1,'') AS 'Airline Code'
		, STUFF((SELECT '/' + B.airName + '(' + B.frmSector + '-' + B.toSector + ')' FROM tblBookMaster s WITH(NOLOCK)
				WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Description'
		, (CASE WHEN b.CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS 'Sector'
		, (pb.paxFName+' '+pb.paxLName) AS 'Passenger Name'
		, coun.Currency AS 'Currency'
		, CAST((pb.basicFare * b.ROE) AS decimal(18,2)) AS 'Base Amount'
		, CAST((pb.YQ * b.ROE) AS decimal(18,2)) AS 'YQ Tax'
		, CAST(((pb.totalTax-pb.YQ) * b.ROE) AS decimal(18,2)) AS 'Taxes Charges'
		, CAST((pb.INTax * b.ROE) AS decimal(18,2)) AS 'K3(GST) Tax'
		, '' AS 'SSR Amount'
		, ISNULL(b.ServiceFee,0) AS 'Service Fee - SF'
		, ISNULL(b.GST,0) AS 'GST on SF'
		, CAST((pb.totalFare * b.ROE) AS decimal(18,2)) AS 'Gross Amount'
		, pb.FMCommission AS 'Commission'
		, pb.IATACommission AS 'IATA'
		, pb.PLBCommission AS 'PLB'
		, pb.DropnetCommission AS 'DROPNET'
		, '' AS 'TDS'
		, b.MCOAmount AS 'MCO Amount'
		, '' AS 'Cancellation Charges'
		, (CAST((pb.totalFare * b.ROE) AS decimal(18,2)) + pb.Markup + b.BFC + b.ServiceFee + b.GST - 
				(pb.IATACommission+pb.PLBCommission+ISNULL(pb.DropnetCommission,0))) AS 'Net Amount'
		, '' AS 'Handling'
		, '' AS 'PG Charges'
		, '' AS 'PG GST'
		, al.AgentBalance AS 'Ledger Balance'
		, pm.payment_mode AS 'Payment Mode'
		, al.UserName
		, '' AS 'Agency Markup'
		, CONVERT(DECIMAL(18,2),(ISNULL(pb.B2BMarkup,0))) AS 'Hidden Markup'
		,(CASE WHEN (pb.MarkOn IS NULL OR pb.MarkOn='Markup on Base') THEN ISNULL(pb.BFC,0) ELSE 0 End) AS 'Markup on fare'
		,(CASE WHEN pb.MarkOn='Markup on Tax' THEN ISNULL(pb.BFC,0) ELSE 0 End) AS 'Markup on tax'
		, '' AS 'Remarks'
		, '' AS 'MO Number'
		, b.RegistrationNumber AS 'GST Number'
		, b.CompanyName AS 'Company Name'
		, (b.CAddress + ' ' + b.CState) AS 'Address'
		, b.emailId AS 'Email ID'
		, b.mobileNo AS 'Mobile No'
		, (CASE WHEN b.isReturnJourney=0 THEN 'One Way' ELSE 'Round Trip' END) AS 'Trip Type'
		FROM tblBookMaster b WITH(NOLOCK)
		INNER JOIN agentLogin al WITH(NOLOCK) ON CAST(al.UserID AS VARCHAR(50))=b.AgentID
		LEFT JOIN B2BRegistration r WITH(NOLOCK) ON CAST(r.FKUserID AS VARCHAR(50))=b.AgentID
		LEFT JOIN B2BRegistration r1 WITH(NOLOCK) ON CAST(r1.FKUserID AS VARCHAR(50))=al.ParentAgentID
		INNER JOIN tblPassengerBookDetails pb WITH(NOLOCK) on pb.fkBookMaster=b.pkId
		INNER JOIN Paymentmaster pm WITH(NOLOCK) ON pm.order_id=b.orderId
		INNER JOIN mCommon c WITH(NOLOCK) on c.ID=al.UserTypeID
		INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=b.Country
		WHERE ((@FROMDate = '') OR (CONVERT(date,B.inserteddate) >= CONVERT(date,@FROMDate)))
 		AND ((@ToDate = '') OR (CONVERT(date,B.inserteddate) <= CONVERT(date, @ToDate)))
		--AND ((@Country = '') OR (al.BookingCountry = @Country))
		AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))
		AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))
 		AND ((@PaymentType = '') OR (@PaymentType='Wallet' and pm.payment_mode IN ('Check' ,'Credit')) OR (pm.payment_mode=@PaymentType))
		AND ((@AgentId = '') OR  (b.AgentID =CAST(@AgentId AS varchar(50))))
		AND ((@ProductType = '') OR ( @ProductType = 'Airline'))
		--AND ((@UserType='') OR ( al.UserTypeID =@UserType))		 
		AND ((@UserType='') OR ( al.UserTypeID IN (SELECT CAST(Data AS varchar) FROM sample_split(@UserType, ','))))
		AND IsBooked=1 and b.totalFare>0	
	END	
	ELSE IF(@BookingType='Topup')
	BEGIN
		SELECT --ab.CreatedOn AS 'Transaction Date',
		--CASE WHEN coun.CountryCode='IN' THEN (DATEADD(SECOND, 0,CONVERT(varchar(20),ab.CreatedOn,120)))
		--		WHEN coun.CountryCode='US' THEN (DATEADD(SECOND,-9*60*60 -29*60 -16,CONVERT(varchar(20),ab.CreatedOn,120)))
		--		WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND,-9*60*60 -29*60 -16,CONVERT(varchar(20),ab.CreatedOn,120)))
		--		WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND,-1*60*60 -29*60 -13,CONVERT(varchar(20),ab.CreatedOn,120)))
		--		end AS 'Transaction Date'
		CASE 
    WHEN coun.CountryCode = 'IN' THEN 
        FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, ab.CreatedOn)), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'US' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ab.CreatedOn)), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'CA' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ab.CreatedOn)), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'AE' THEN 
        FORMAT(DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13, CONVERT(DATETIME, ab.CreatedOn)), 'dd-MMM-yyyy')
END AS 'Transaction Date'

		, r.Icast AS 'Cust ID'
		, 'Opening' AS'Product Type'
		, 'BALANCE B/F' AS Description
		, '' AS 'Booking Status'
		, '' AS 'Riya PNR'
		, '' AS  'Airlines PNR'
		, '' AS 'CRS PNR'
		, '' AS 'Ticket No'
		, '' AS 'Airline Code'
		, 'Topup Opening Balance' AS 'Sector'
		, '' AS 'Passenger Name'
		, coun.Currency AS 'Currency'
		, '0' AS 'Base Amount'
		, '0' AS 'YQ Tax'
		, '0' AS 'Taxes Charges'
		, '0' AS 'K3(GST) Tax'
		, '0' AS 'SSR Amount'
		, '0' AS 'Service Fee - SF'
		, '0' AS 'GST on SF'
		, '0' AS 'Gross Amount'
		, '0' AS 'Commission'
		, '0' AS 'IATA'
		, '0' AS 'PLB'
		, '0' AS 'DROPNET'
		, '' AS 'TDS'
		, '0' AS 'MCO Amount'
		, '0' AS 'Cancellation Charges'
		, '0' AS 'Net Amount'
		, '0' AS 'Handling'
		, '0' AS 'PG Charges'
		, '0' AS 'PG GST'
		, ab.TranscationAmount AS 'Ledger Balance'
		, 'Topup Account' AS 'Payment Mode'
		, al.UserName
		, '0' AS 'Agency Markup'
		,'0' AS 'Hidden Markup'
		,'0' AS 'Markup on fare'
		,'0' AS 'Markup on tax'
		, '' AS 'Remarks'
		, '' AS 'MO Number'
		, '' AS 'GST Number'
		, '' AS 'Company Name'
		, '' AS 'Address'
		, '' AS 'Email ID'
		, al.MobileNumber AS 'Mobile No'
		, '' AS 'Trip Type'
		FROM tblAgentBalance ab WITH(NOLOCK)
		INNER JOIN AgentLogin al WITH(NOLOCK) on al.UserID=ab.AgentNo
		INNER JOIN B2BRegistration r WITH(NOLOCK) ON CAST(r.FKUserID AS VARCHAR(50))=ab.AgentNo
		INNER JOIN mCommon c WITH(NOLOCK) on c.ID=al.UserTypeID
		INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=al.BookingCountry
		WHERE ((@FROMDate = '') OR (CONVERT(date,ab.CreatedOn) >= CONVERT(date,@FROMDate)))
 		AND ((@ToDate = '') OR (CONVERT(date,ab.CreatedOn) <= CONVERT(date, @ToDate)))
		--AND ((@Country = '') OR (al.BookingCountry = @Country))
		AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))
		AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))
 		AND ((@PaymentType = '') OR (@PaymentType='Wallet' ))
		AND ((@AgentId = '') OR  (ab.AgentNo =CAST(@AgentId AS varchar(50))))
		AND ((@ProductType = '') OR ( @ProductType = 'Airline'))
		--AND ((@UserType='') OR ( al.UserTypeID = @UserType))	
		AND ((@UserType='') OR ( al.UserTypeID IN (SELECT CAST(Data AS INT) FROM sample_split(@UserType, ','))))	
	END
	IF(@BookingType='Cancellation')
	BEGIN
		SELECT
		--pb.CancelledDate AS 'Transaction Date',
		--CASE WHEN coun.CountryCode='IN' THEN (DATEADD(SECOND, 0,CONVERT(varchar(20),pb.CancelledDate,120)))
		--		WHEN coun.CountryCode='US' THEN (DATEADD(SECOND,-9*60*60 -29*60 -16,CONVERT(varchar(20),pb.CancelledDate,120)))
		--		WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND,-9*60*60 -29*60 -16,CONVERT(varchar(20),pb.CancelledDate,120)))
		--		WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND,-9*60*60 -29*60 -13,CONVERT(varchar(20),pb.CancelledDate,120)))
		--		end AS 'Transaction Date'
		CASE 
    WHEN coun.CountryCode = 'IN' THEN 
        FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, pb.CancelledDate)), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'US' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, pb.CancelledDate)), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'CA' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, pb.CancelledDate)), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'AE' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 13, CONVERT(DATETIME, pb.CancelledDate)), 'dd-MMM-yyyy')
END AS 'Transaction Date'

		, r.Icast AS 'Cust ID'
		, 'Airline' AS'Product Type'
		, 'Cancellation' AS 'Booking Status'
		, B.riyaPNR AS 'Riya PNR'
		, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS 'Airlines PNR'
		, B.GDSPNR AS 'CRS PNR'
		, (CASE WHEN CHARINDEX('/',ticketNum) > 0 THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX('-', ticketNum) + 1,
				LEN(ticketNum)),0,CHARINDEX('/',(SUBSTRING(ticketNum, CHARINDEX('-', ticketNum) + 1,
				LEN(ticketNum))),0)) ELSE ticketNum END) AS 'Ticket No'
		, STUFF((SELECT '/' + s.airCode  FROM tblBookMaster s WITH(NOLOCK) WHERE s.orderId = b.orderId
				FOR XML PATH('')),1,1,'') AS 'Airline Code'
		, STUFF((SELECT '/' + B.airName + '(' + B.frmSector + '-' + B.toSector + ')'
				FROM tblBookMaster s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Description'
		, (CASE WHEN b.CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS 'Sector'
		, (pb.paxFName+' '+pb.paxLName) AS 'Passenger Name'
		, coun.Currency AS 'Currency'
		, -CAST((pb.basicFare * b.ROE) AS decimal(18,2)) AS 'Base Amount'
		, -CAST((pb.YQ * b.ROE) AS decimal(18,2)) AS 'YQ Tax'
		, -CAST(((pb.totalTax-pb.YQ) * b.ROE) AS decimal(18,2)) AS 'Taxes Charges'
		, -CAST((pb.INTax * b.ROE) AS decimal(18,2)) AS 'K3(GST) Tax'
		, '' AS 'SSR Amount'
		, -ISNULL(b.ServiceFee,0) AS 'Service Fee - SF'
		, -ISNULL(b.GST,0) AS 'GST on SF'
		, -CAST((pb.totalFare * b.ROE) AS decimal(18,2)) AS 'Gross Amount'
		, -pb.FMCommission AS 'Commission'
		, -pb.IATACommission AS 'IATA'
		, -pb.PLBCommission AS 'PLB'
		, -pb.DropnetCommission AS 'DROPNET'
		, '' AS 'TDS'
		, -b.MCOAmount AS 'MCO Amount'
		, CAST((pb.CancellationMarkup + pb.CancellationPenalty) AS varchar(50)) AS 'Cancellation Charges'
		, -(CAST((pb.totalFare * b.ROE) AS decimal(18,2))+pb.Markup + b.BFC + b.ServiceFee + b.GST - 
				(pb.IATACommission + pb.PLBCommission + ISNULL(pb.DropnetCommission,0))) + 
				(pb.CancellationPenalty + pb.CancellationMarkup) AS 'Net Amount'
		, '' AS 'Handling'
		, '' AS 'PG Charges'
		, '' AS 'PG GST'
		, al.AgentBalance AS 'Ledger Balance'
		, pm.payment_mode AS 'Payment Mode'
		, al.UserName
		, '' AS 'Agency Markup'
		, CONVERT(DECIMAL(18,2),(ISNULL(pb.B2BMarkup,0))) AS 'Hidden Markup'
		,(CASE WHEN (pb.MarkOn IS NULL OR pb.MarkOn='Markup on Base') THEN ISNULL(pb.BFC,0) ELSE 0 End) AS 'Markup on fare'
		,(CASE WHEN pb.MarkOn='Markup on Tax' THEN ISNULL(pb.BFC,0) ELSE 0 End) AS 'Markup on tax'
		, '' AS 'Remarks'
		, '' AS 'MO Number'
		, b.RegistrationNumber AS 'GST Number'
		, b.CompanyName AS 'Company Name'
		, (b.CAddress+' '+b.CState) AS 'Address'
		, b.emailId AS 'Email ID'
		, b.mobileNo AS 'Mobile No'
		, (CASE WHEN b.isReturnJourney=0 THEN 'One Way' ELSE 'Round Trip' END) AS 'Trip Type'
		FROM tblBookMaster b WITH(NOLOCK)
		INNER JOIN B2BRegistration r WITH(NOLOCK) ON CAST(r.FKUserID AS VARCHAR(50))=b.AgentID
		--INNER JOIN tblBookItenary bi  ON bi.fkBookMaster=B.pkId
		INNER JOIN tblPassengerBookDetails pb WITH(NOLOCK) on pb.fkBookMaster=b.pkId 
		INNER JOIN agentLogin al WITH(NOLOCK) ON CAST(al.UserID AS VARCHAR(50))=b.AgentID
		INNER JOIN Paymentmaster pm WITH(NOLOCK) ON pm.order_id=b.orderId
		INNER JOIN mCommon c WITH(NOLOCK) on c.ID=al.UserTypeID
		INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=b.Country
		WHERE ((@FROMDate = '') OR (CONVERT(date,pb.CancelledDate) >= CONVERT(date,@FROMDate)))
 		AND ((@ToDate = '') OR (CONVERT(date,pb.CancelledDate) <= CONVERT(date, @ToDate)))
		--AND ((@Country = '') OR (al.BookingCountry =@Country))
		AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))
		AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))
 		AND ((@PaymentType = '') OR (@PaymentType='Wallet' and pm.payment_mode IN ('Check' ,'Credit')) OR (pm.payment_mode=@PaymentType))
		AND ((@AgentId = '') OR  (b.AgentID =CAST(@AgentId AS varchar(50))))
		AND ((@ProductType = '') OR ( @ProductType = 'Airline'))
		-- AND ((@UserType='') OR ( al.UserTypeID = @UserType))
		AND ((@UserType='') OR ( al.UserTypeID IN (SELECT CAST(Data AS INT) FROM sample_split(@UserType, ','))))
		AND IsBooked=1 and b.totalFare >0	
	END
	ELSE IF(@BookingType='')
	BEGIN
		SELECT 
		-- b.inserteddate AS 'Transaction Date',
		--CASE WHEN coun.CountryCode='IN' THEN (DATEADD(SECOND, 0,CONVERT(varchar(20),b.inserteddate,120)))
		--		WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, -9*60*60 -29*60 -16,CONVERT(varchar(20),b.inserteddate,120)))
		--		WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, -9*60*60 -29*60 -16,CONVERT(varchar(20),b.inserteddate,120)))
		--		WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, - 1*60*60 -29*60 -13,CONVERT(varchar(20),b.inserteddate,120)))
		--		end AS 'Transaction Date'
		CASE 
    WHEN coun.CountryCode = 'IN' THEN 
        FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, b.inserteddate)), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'US' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, b.inserteddate)), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'CA' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, b.inserteddate)), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'AE' THEN 
        FORMAT(DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13, CONVERT(DATETIME, b.inserteddate)), 'dd-MMM-yyyy')
END AS 'Transaction Date'

		, ISNULL(r.Icast,r1.Icast) AS 'Cust ID'
		, 'Airline' AS 'Product Type'
		, 'Booking' AS 'Booking Status'
		, B.riyaPNR AS 'Riya PNR'
		, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS 'Airlines PNR'
		, B.GDSPNR AS 'CRS PNR'
		, (CASE WHEN CHARINDEX('/',ticketNum)>0 THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX('-', ticketNum)+1,
				LEN(ticketNum)),0,CHARINDEX('/',(SUBSTRING(ticketNum, CHARINDEX('-', ticketNum)+1,
				LEN(ticketNum))),0)) ELSE ticketNum END) AS 'Ticket No'
		, STUFF((SELECT '/' + s.airCode  FROM tblBookMaster s WITH(NOLOCK) WHERE s.orderId = b.orderId
				FOR XML PATH('')),1,1,'') AS 'Airline Code'
		, STUFF((SELECT '/' + B.airName + '(' + B.frmSector + '-' + B.toSector + ')' FROM tblBookMaster s WITH(NOLOCK)
				WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Description'
		, (CASE WHEN b.CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS 'Sector'
		, (pb.paxFName+' '+pb.paxLName) AS 'Passenger Name'
		, coun.Currency AS 'Currency'
		, CAST((pb.basicFare * b.ROE) AS decimal(18,2)) AS 'Base Amount'
		, CAST((pb.YQ * b.ROE) AS decimal(18,2)) AS 'YQ Tax'
		, CAST(((pb.totalTax-pb.YQ) * b.ROE) AS decimal(18,2)) AS 'Taxes Charges'
		, CAST((pb.INTax * b.ROE) AS decimal(18,2)) AS 'K3(GST) Tax'
		, '' AS 'SSR Amount'
		, ISNULL(b.ServiceFee,0) AS 'Service Fee - SF'
		, ISNULL(b.GST,0)  AS 'GST on SF'
		, CAST((pb.totalFare * b.ROE) AS decimal(18,2)) AS 'Gross Amount'
		, pb.FMCommission AS 'Commission'
		, pb.IATACommission AS 'IATA'
		, pb.PLBCommission AS 'PLB'
		, pb.DropnetCommission AS 'DROPNET'
		, '' AS 'TDS'
		, b.MCOAmount AS 'MCO Amount'
		, '' AS 'Cancellation Charges'
		, (CAST((pb.totalFare * b.ROE) AS decimal(18,2)) + pb.Markup + b.BFC + b.ServiceFee + b.GST -
				(pb.IATACommission+pb.PLBCommission + ISNULL(pb.DropnetCommission,0))) AS 'Net Amount'
		, '' AS 'Handling'
		, '' AS 'PG Charges'
		, '' AS 'PG GST'
		, al.AgentBalance AS 'Ledger Balance'
		, pm.payment_mode AS 'Payment Mode'
		, al.UserName
		, '' AS 'Agency Markup'
		, CONVERT(DECIMAL(18,2),(ISNULL(pb.B2BMarkup,0))) AS 'Hidden Markup'
		,(CASE WHEN (pb.MarkOn IS NULL OR pb.MarkOn='Markup on Base') THEN ISNULL(pb.BFC,0) ELSE 0 End) AS 'Markup on fare'
		,(CASE WHEN pb.MarkOn='Markup on Tax' THEN ISNULL(pb.BFC,0) ELSE 0 End) AS 'Markup on tax'
		, '' AS 'Remarks'
		, '' AS 'MO Number'
		, b.RegistrationNumber AS 'GST Number'
		, b.CompanyName AS 'Company Name'
		, (b.CAddress+' '+b.CState) AS 'Address'
		, b.emailId AS 'Email ID'
		, b.mobileNo AS 'Mobile No'
		, (CASE WHEN b.isReturnJourney=0 THEN 'One Way' ELSE 'Round Trip' END) AS 'Trip Type'
		FROM tblBookMaster b WITH(NOLOCK)
		INNER JOIN agentLogin al WITH(NOLOCK) ON CAST(al.UserID AS VARCHAR(50))=b.AgentID
		LEFT JOIN B2BRegistration r WITH(NOLOCK) ON CAST(r.FKUserID AS VARCHAR(50))=b.AgentID
		LEFT JOIN B2BRegistration r1 WITH(NOLOCK) ON CAST(r1.FKUserID AS VARCHAR(50))=al.ParentAgentID
		INNER JOIN tblPassengerBookDetails pb WITH(NOLOCK) on pb.fkBookMaster=b.pkId 
		INNER JOIN Paymentmaster pm WITH(NOLOCK) ON pm.order_id=b.orderId
		INNER JOIN mCommon c WITH(NOLOCK) on c.ID=al.UserTypeID
		INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=b.Country
		WHERE ((@FROMDate = '') OR (CONVERT(date,B.inserteddate) >= CONVERT(date,@FROMDate)))
 		AND ((@ToDate = '') OR (CONVERT(date,B.inserteddate) <= CONVERT(date, @ToDate)))
		--AND ((@Country = '') OR (al.BookingCountry = @Country))
		AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))
		AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))
 		AND ((@PaymentType = '') OR (@PaymentType='Wallet' and pm.payment_mode IN ('Check' ,'Credit')) OR (pm.payment_mode=@PaymentType))
		AND ((@AgentId = '') OR  (b.AgentID =CAST(@AgentId AS varchar(50))))
		AND ((@ProductType = '') OR ( @ProductType = 'Airline'))
		-- AND ((@UserType='') OR ( al.UserTypeID = @UserType))
		AND ((@UserType='') OR ( al.UserTypeID IN (SELECT CAST(Data AS INT) FROM sample_split(@UserType, ','))))
		AND  IsBooked=1 and b.totalFare > 0

		union

		SELECT 
		--pb.CancelledDate AS 'Transaction Date',
		--CASE WHEN coun.CountryCode='IN' THEN (DATEADD(SECOND, 0,CONVERT(varchar(20),pb.CancelledDate,120)))
		--		WHEN coun.CountryCode='US' THEN (DATEADD(SECOND,-9*60*60 -29*60 -16,CONVERT(varchar(20),pb.CancelledDate,120)))
		--		WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND,-9*60*60 -29*60 -16,CONVERT(varchar(20),pb.CancelledDate,120)))
		--		WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND,-9*60*60 -29*60 -13,CONVERT(varchar(20),pb.CancelledDate,120)))
		--		end AS 'Transaction Date'
		CASE 
    WHEN coun.CountryCode = 'IN' THEN 
        FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, pb.CancelledDate)), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'US' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, pb.CancelledDate)), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'CA' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, pb.CancelledDate)), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'AE' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 13, CONVERT(DATETIME, pb.CancelledDate)), 'dd-MMM-yyyy')
END AS 'Transaction Date'

		, ISNULL(r.Icast,r1.Icast) AS 'Cust ID'
		, 'Airline' AS 'Product Type'
		, 'Cancellation' AS 'Booking Status'
		, B.riyaPNR AS 'Riya PNR'
		, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS 'Airlines PNR'
		, B.GDSPNR AS 'CRS PNR'
		, (CASE WHEN CHARINDEX('/',ticketNum)>0 THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX('-', ticketNum) + 1,
				LEN(ticketNum)),0,CHARINDEX('/',(SUBSTRING(ticketNum, CHARINDEX('-', ticketNum)+1,
				LEN(ticketNum))),0)) ELSE ticketNum END ) AS 'Ticket No'
		, STUFF((SELECT '/' + s.airCode  FROM tblBookMaster s WITH(NOLOCK) WHERE s.orderId = b.orderId
				FOR XML PATH('')),1,1,'') AS 'Airline Code'
		, STUFF((SELECT '/' + B.airName + '(' + B.frmSector + '-' + B.toSector + ')' 
				FROM tblBookMaster s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Description'
		, (CASE WHEN b.CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS 'Sector'
		, (pb.paxFName+' '+pb.paxLName) AS 'Passenger Name'
		, coun.Currency AS 'Currency'
		, -CAST((pb.basicFare * b.ROE) AS decimal(18,2)) AS 'Base Amount'
		, -CAST((pb.YQ * b.ROE) AS decimal(18,2)) AS 'YQ Tax'
		, -CAST(((pb.totalTax-pb.YQ) * b.ROE) AS decimal(18,2)) AS 'Taxes Charges'
		, -CAST((pb.INTax * b.ROE) AS decimal(18,2)) AS 'K3(GST) Tax'
		, '' AS 'SSR Amount'
		, -ISNULL(b.ServiceFee,0) AS 'Service Fee - SF'
		, -ISNULL(b.GST,0)  AS 'GST on SF'
		, -CAST((pb.totalFare * b.ROE) AS decimal(18,2)) AS 'Gross Amount'
		, -pb.FMCommission AS 'Commission'
		, -pb.IATACommission AS 'IATA'
		, -pb.PLBCommission AS 'PLB'
		, -pb.DropnetCommission AS 'DROPNET'
		, '' AS 'TDS'
		, -b.MCOAmount AS 'MCO Amount'
		, CAST((pb.CancellationMarkup + pb.CancellationPenalty) AS varchar(50)) AS 'Cancellation Charges'
		, -(CAST((pb.totalFare * b.ROE) AS decimal(18,2))+pb.Markup + b.BFC + b.ServiceFee + b.GST - 
				(pb.IATACommission+pb.PLBCommission+ISNULL(pb.DropnetCommission,0)))+
				(pb.CancellationPenalty + pb.CancellationMarkup) AS 'Net Amount'
		, '' AS 'Handling'
		, '' AS 'PG Charges'
		, '' AS 'PG GST'
		, al.AgentBalance AS 'Ledger Balance'
		, pm.payment_mode AS 'Payment Mode'
		, al.UserName
		, '' AS 'Agency Markup'
		, CONVERT(DECIMAL(18,2),(ISNULL(pb.B2BMarkup,0))) AS 'Hidden Markup'
		,(CASE WHEN (pb.MarkOn IS NULL OR pb.MarkOn='Markup on Base') THEN ISNULL(pb.BFC,0) ELSE 0 End) AS 'Markup on fare'
		,(CASE WHEN pb.MarkOn='Markup on Tax' THEN ISNULL(pb.BFC,0) ELSE 0 End) AS 'Markup on tax'
		, '' AS 'Remarks'
		, '' AS 'MO Number'
		, b.RegistrationNumber AS 'GST Number'
		, b.CompanyName AS 'Company Name'
		, (b.CAddress+' '+b.CState) AS 'Address'
		, b.emailId AS 'Email ID'
		, b.mobileNo AS 'Mobile No'
		, (CASE WHEN b.isReturnJourney=0 THEN 'One Way' ELSE 'Round Trip' END) AS 'Trip Type'
		FROM tblBookMaster b WITH(NOLOCK)
		INNER JOIN agentLogin al WITH(NOLOCK) ON CAST(al.UserID AS VARCHAR(50))=b.AgentID
		LEFT JOIN B2BRegistration r WITH(NOLOCK) ON CAST(r.FKUserID AS VARCHAR(50))=b.AgentID
		LEFT JOIN B2BRegistration r1 WITH(NOLOCK) ON CAST(r1.FKUserID AS VARCHAR(50))=al.ParentAgentID
		INNER JOIN tblPassengerBookDetails pb WITH(NOLOCK) on pb.fkBookMaster=b.pkId 
		INNER JOIN Paymentmaster pm WITH(NOLOCK) ON pm.order_id=b.orderId
		INNER JOIN mCommon c WITH(NOLOCK) on c.ID=al.UserTypeID
		INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=b.Country
		WHERE ((@FROMDate = '') OR (CONVERT(date,pb.CancelledDate) >= CONVERT(date,@FROMDate)))
 		AND ((@ToDate = '') OR (CONVERT(date,pb.CancelledDate) <= CONVERT(date, @ToDate)))
		--AND ((@Country = '') OR (al.BookingCountry = @Country))
		AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))
		AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))
 		AND ((@PaymentType = '') OR (@PaymentType='Wallet' and pm.payment_mode IN ('Check' ,'Credit')) OR (pm.payment_mode=@PaymentType))
		AND ((@AgentId = '') OR  (b.AgentID =CAST(@AgentId AS varchar(50))))
		AND ((@ProductType = '') OR ( @ProductType = 'Airline'))
		-- AND ((@UserType='') OR ( al.UserTypeID = @UserType))
		AND ((@UserType='') OR ( al.UserTypeID IN (SELECT CAST(Data AS INT) FROM sample_split(@UserType, ','))))
		AND IsBooked=1 and b.totalFare >0

		UNION

		SELECT --ab.CreatedOn AS 'Transaction Date',
CASE 
    WHEN coun.CountryCode = 'IN' THEN 
        FORMAT(DATEADD(SECOND, 0, ab.CreatedOn), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'US' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, ab.CreatedOn), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'CA' THEN 
        FORMAT(DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, ab.CreatedOn), 'dd-MMM-yyyy')

    WHEN coun.CountryCode = 'AE' THEN 
        FORMAT(DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13, ab.CreatedOn), 'dd-MMM-yyyy')
END AS 'Transaction Date'
		, r.Icast AS 'Cust ID'
		, 'Opening' AS'Product Type'
		, 'BALANCE B/F' AS Description
		, '' AS 'Booking Status'
		, '' AS 'Riya PNR'
		, '' AS  'Airlines PNR'
		, '' AS 'CRS PNR'
		, '' AS 'Ticket No'
		, '' AS 'Airline Code'
		, 'Topup Opening Balance' AS 'Sector'
		, '' AS 'Passenger Name'
		, coun.Currency AS 'Currency'
		, '0' AS 'Base Amount'
		, '0' AS 'YQ Tax'
		, '0' AS 'Taxes Charges'
		, '0'  as 'K3(GST) Tax'
		, '0' AS 'SSR Amount'
		, '0' AS 'Service Fee - SF'
		, '0' AS 'GST on SF'
		, '0' AS 'Gross Amount'
		, '0' AS 'Commission'
		, '0' AS 'IATA'
		, '0' AS 'PLB'
		, '0' AS 'DROPNET'
		, '' AS 'TDS'
		, '0' AS 'MCO Amount'
		, '0' AS 'Cancellation Charges'
		, '0' AS 'Net Amount'
		, '0' AS 'Handling'
		, '0' AS 'PG Charges'
		, '0' AS 'PG GST'
		, ab.TranscationAmount AS 'Ledger Balance'
		, 'Topup Account' AS 'Payment Mode'
		, al.UserName
		, '0' AS 'Agency Markup'
		,'0' AS 'Hidden Markup'
		,'0' AS 'Markup on fare'
		,'0' AS 'Markup on tax'
		, '' AS 'Remarks'
		, '' AS 'MO Number'
		, '' AS 'GST Number'
		, '' AS 'Company Name'
		, '' AS 'Address'
		, '' AS 'Email ID'
		, al.MobileNumber AS 'Mobile No'
		, '' AS 'Trip Type'
		FROM tblAgentBalance ab WITH(NOLOCK)
		INNER JOIN AgentLogin al WITH(NOLOCK) on al.UserID=ab.AgentNo
		INNER JOIN B2BRegistration r WITH(NOLOCK) ON CAST(r.FKUserID AS VARCHAR(50))=ab.AgentNo
		INNER JOIN mCommon c WITH(NOLOCK) on c.ID=al.UserTypeID
		INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=al.BookingCountry
		WHERE ((@FROMDate = '') OR (CONVERT(date,ab.CreatedOn) >= CONVERT(date,@FROMDate)))
 		AND ((@ToDate = '') OR (CONVERT(date,ab.CreatedOn) <= CONVERT(date, @ToDate)))
		--AND ((@Country = '') OR (al.BookingCountry = @Country))
		AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))
		AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))
 		AND ((@PaymentType = '') OR (@PaymentType='Wallet' ))
		AND ((@AgentId = '') OR  (ab.AgentNo =CAST(@AgentId AS varchar(50))))
		AND ((@ProductType = '') OR ( @ProductType = 'Airline'))
		-- AND ((@UserType='') OR ( al.UserTypeID = @UserType))
		AND ((@UserType='') OR ( al.UserTypeID IN (SELECT CAST(Data AS INT) FROM sample_split(@UserType, ','))))
	END
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAgentSalesSummaryReport] TO [rt_read]
    AS [dbo];

